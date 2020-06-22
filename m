Return-Path: <SRS0=lGnU=AD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 180B2C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 10:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3265206FA
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 10:13:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="jK/5+hkN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgFVKN0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Jun 2020 06:13:26 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27266 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726515AbgFVKN0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Jun 2020 06:13:26 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MAANwK021572
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2020 03:13:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=HPVWCMQqI+8I+FK4cDoDcBm3ztKVzpZomqe/jDWRVDA=;
 b=jK/5+hkNP723X6YkZcenctlorq/YNiFTuPY1UjRM6WW7kW1Q3jdvOdH9K8cqE2g6qB7P
 QZ4a1xVzYjd/yXfmmTVYv6n+SgAr8uX6Z6nTTWSNqUBqDODSIaryVGFscGflnmtFkf4y
 Y5nUURRhXu4y2fRgd/rcCBZwJG3g0iHyEsBL5O+GppG7FPjhoXwGqLyzCSyqidkc5vAm
 ebW0zH0DzkKCl/RLJ7AvgczG8BOO3aXsOZmSYLcHlx6qpctY6/8nFtL9tqZwUf3r4B/r
 S5du6lwRecdbZGjaRkaIzHnNJllKpyxVO4ERwxAufwnYg1HCl8T738tdK8C5ryKwRIBl wA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 31sftpfy8t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2020 03:13:25 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 03:13:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Jun 2020 03:13:24 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 9FDD63F703F;
        Mon, 22 Jun 2020 03:13:24 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 05MADOfh003981;
        Mon, 22 Jun 2020 03:13:24 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 05MADOBY003972;
        Mon, 22 Jun 2020 03:13:24 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 2/2] scsi: libfc: Skip additional kref updating work event.
Date:   Mon, 22 Jun 2020 03:12:12 -0700
Message-ID: <20200622101212.3922-3-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200622101212.3922-1-jhasan@marvell.com>
References: <20200622101212.3922-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_03:2020-06-22,2020-06-22 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

  When an rport event(RPORT_EV_READY) is updated without work being
  queued, avoid taking an additional reference.

  This issue was leading to memory leak. Below is the trace from
  KMEMLEAK tool.
  unreferenced object 0xffff8888259e8780 (size 512):
  comm "kworker/2:1", pid 182614, jiffies 4433237386 (age 113021.971s)
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
  Here we get the RPORT_EV_READY and RPORT_EV_STOP back to back, which lead to
  overwrite the event RPORT_EV_READY by event RPORT_EV_STOP. Because of this
  kref_count get incremented by 1.
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
---
 drivers/scsi/libfc/fc_rport.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index ca39b4b..830df32f 100644
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
+	    if(!queue_work(rport_event_queue, &rdata->event_work))
+			kref_put(&rdata->kref, fc_rport_destroy);
+	}
 
 	rdata->event = event;
 }
-- 
1.8.3.1

