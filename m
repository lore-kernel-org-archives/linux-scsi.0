Return-Path: <SRS0=Z0Y/=AH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B828C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Jun 2020 09:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73B7721531
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Jun 2020 09:52:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="wyN3pnp1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgFZJwC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Jun 2020 05:52:02 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:28828 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726856AbgFZJwB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Jun 2020 05:52:01 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05Q9jJHA027907
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2020 02:52:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=yxSRZMqMIsI5mZL/1KCgVW0tdAkNgjar2XrO0E1Vs6c=;
 b=wyN3pnp1Ax0rPHP2DuDxXuTbtsGMujLC6APDwx8VbIFCX3OOxTSzSuKLEoAM+HthcoFV
 imMfGHqKvTNaTJDncuyq1+6bu7A0SmJPu4tOlvGxCiceW4eaTmBuSobwSumQjIeXqMyv
 gi7+24gN1uLZpuqSvYUC9iQNeAOH2t+ZxR3OUoJzKol7RAbGwhGZkyCf7LNH9Sz8/c42
 BFMkCpa/R+sjYRBLHs06N+mFPE147lCkWiEYQrPmu+LSrm2ujCXzNHWp64+K0H02hyGm
 R3gmBRJqSP4WpBJLrFyw8lkecTY8icwZRB1JUBy9YZfO4G8pYOxq0XfOS+xgSW66CIA7 6A== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 31uuqh40aw-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2020 02:52:01 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Jun
 2020 02:50:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 26 Jun 2020 02:50:24 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id D0E443F703F;
        Fri, 26 Jun 2020 02:50:23 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 05Q9oN5g032252;
        Fri, 26 Jun 2020 02:50:23 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 05Q9oNO7032185;
        Fri, 26 Jun 2020 02:50:23 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH V2] scsi: libfc: Skip additional kref updating work event.
Date:   Fri, 26 Jun 2020 02:49:59 -0700
Message-ID: <20200626094959.32151-1-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_05:2020-06-26,2020-06-26 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

  When an rport event(RPORT_EV_READY) is updated without
  work being queued, avoid taking an additional reference.

  This issue was leading to memory leak.
  Below is the trace from KMEMLEAK tool.
  unreferenced object 0xffff8888259e8780 (size 512):
  comm "kworker/2:1", jiffies 4433237386 (age 113021.971s)
    hex dump (first 32 bytes):
	58 0a ec cf 83 88 ff ff 00 00 00 00 00 00 00 00
	01 00 00 00 08 00 00 00 13 7d f0 1e 0e 00 00 10
  backtrace:
  [<000000006b25760f>] fc_rport_recv_req+0x3c6/0x18f0 [libfc]
  [<00000000f208d994>] fc_lport_recv_els_req+0x120/0x8a0 [libfc]
  [<00000000a9c437b8>] fc_lport_recv+0xb9/0x130 [libfc]
  [<00000000a9c437b8>] fc_lport_recv+0xb9/0x130 [libfc]
  [<00000000ad5be37b>] qedf_ll2_process_skb+0x73d/0xad0 [qedf]
  [<00000000e0eb6893>] process_one_work+0x382/0x6c0
  [<000000002dfd9e21>] worker_thread+0x57/0x5c0
  [<00000000b648204f>] kthread+0x1a0/0x1c0
  [<0000000072f5ab20>] ret_from_fork+0x35/0x40
  [<000000001d5c05d8>] 0xffffffffffffffff

  Below is the logs sequence which leads to memory leak.
  Here we get the RPORT_EV_READY and RPORT_EV_STOP back to back,
  which lead to overwrite the event RPORT_EV_READY by event RPORT_EV_STOP.
  Because of this kref_count get incremented by 1.
  kernel: host0: rport fffce5: Received PLOGI request
  kernel: host0: rport fffce5: Received PLOGI in INIT state
  kernel: host0: rport fffce5: Port is Ready
  kernel: host0: rport fffce5: Received PRLI request while in state Ready
  kernel: host0: rport fffce5: PRLI rspp type 8 active 1 passive 0
  kernel: host0: rport fffce5: Received LOGO request while in state Ready
  kernel: host0: rport fffce5: Delete port
  kernel: host0: rport fffce5: Received PLOGI request
  kernel: host0: rport fffce5: Received PLOGI in state Delete - send busy
  kernel: host0: rport fffce5: work event 3
  kernel: host0: rport fffce5: lld callback ev 3
  kernel: host0: rport fffce5: work delete

  Reviewed-by: Girish Basrur <gbasrur@marvell.com>
  Reviewed-by: Saurav Kashyap <skashyap@marvell.com>
  Reviewed-by: Shyam Sundar <ssundar@marvell.com>
  Signed-off-by: Javed Hasan <jhasan@marvell.com>

Signed-off-by: Javed Hasan <jhasan@marvell.com>
---
Changes in v2:
 - Identation fix.
---
 drivers/scsi/libfc/fc_rport.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index ca39b4b..d84de3f 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -483,10 +483,11 @@ static void fc_rport_enter_delete(struct fc_rport_priv *rdata,
 
 	fc_rport_state_enter(rdata, RPORT_ST_DELETE);
 
-	kref_get(&rdata->kref);
-	if (rdata->event == RPORT_EV_NONE &&
-	    !queue_work(rport_event_queue, &rdata->event_work))
-		kref_put(&rdata->kref, fc_rport_destroy);
+	if (rdata->event == RPORT_EV_NONE) {
+		kref_get(&rdata->kref);
+		if(!queue_work(rport_event_queue, &rdata->event_work))
+			kref_put(&rdata->kref, fc_rport_destroy);
+	}
 
 	rdata->event = event;
 }
-- 
1.8.3.1

