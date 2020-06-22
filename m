Return-Path: <SRS0=lGnU=AD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03C7EC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 10:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1236206FA
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 10:13:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="irEv2MH0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgFVKNC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Jun 2020 06:13:02 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50396 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726515AbgFVKNC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Jun 2020 06:13:02 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MAAPvx021659
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2020 03:13:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=SPsDHKHNFjosHxarujGuW4srn7YYfmDZ11czon22waA=;
 b=irEv2MH0tv2Zquv6WXamankO6Gd8y5ZPYNZDe14rE3YDQwUu8oC1sQtpHA3pOpD9Lv3g
 nEh8orli9zgU0b9Lrkq5k4RwUo/VRSADYovJnXEofeO30m3VydWxj19bBBH9qZv8RFuC
 cLwVfG7idm5XfHxh1/hzZuy3WyX2MElsrQEpsOU2hENHpRHODoFfCtAMwZFBmZrV1Bz8
 eMYBbQabBOzRBRD7cyH+EoBax8W4tovTBOrL+fI4cXFbpLLpQrJV0uyJt0c+E4QwA9u+
 BUKhgEM66CAQOmXDEVEQN/Syobx+Ttgi1Db8QFA+ZQg+IZwU1mF7zof5arf+5A23QvoY TA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 31sftpfy7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2020 03:13:01 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 03:13:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Jun 2020 03:13:00 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 801913F7040;
        Mon, 22 Jun 2020 03:13:00 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 05MAD0hJ003969;
        Mon, 22 Jun 2020 03:13:00 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 05MAD0o1003968;
        Mon, 22 Jun 2020 03:13:00 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 1/2] scsi: libfc: Handling of extra kref.
Date:   Mon, 22 Jun 2020 03:12:11 -0700
Message-ID: <20200622101212.3922-2-jhasan@marvell.com>
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

  Handling of extra kref which is done by lookup table in
  case rdata is already present in list.

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
	[<00000000ad5be37b>] qedf_ll2_process_skb+0x73d/0xad0 [qedf]
	[<00000000e0eb6893>] process_one_work+0x382/0x6c0
	[<000000002dfd9e21>] worker_thread+0x57/0x5c0
	[<00000000b648204f>] kthread+0x1a0/0x1c0
	[<0000000072f5ab20>] ret_from_fork+0x35/0x40
	[<000000001d5c05d8>] 0xffffffffffffffff

 Below is the logs sequence which leads to memory leak.
 Here we get the nested "Received PLOGI request" for same port
 and this request leads to call the fc_rport_create() twice for the same rport.
	kernel: host1: rport fffce5: Received PLOGI request
	kernel: host1: rport fffce5: Received PLOGI in INIT state
	kernel: host1: rport fffce5: Port is Ready
	kernel: host1: rport fffce5: Received PRLI request while in state Ready
	kernel: host1: rport fffce5: PRLI rspp type 8 active 1 passive 0
	kernel: host1: rport fffce5: Received LOGO request while in state Ready
	kernel: host1: rport fffce5: Delete port
	kernel: host1: rport fffce5: Received PLOGI request
	kernel: host1: rport fffce5: Received PLOGI in state Delete - send busy

Reviewed-by: Girish Basrur <gbasrur@marvell.com>
Reviewed-by: Saurav Kashyap <skashyap@marvell.com>
Reviewed-by: Shyam Sundar <ssundar@marvell.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
---
 drivers/scsi/libfc/fc_rport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 83636ef..ca39b4b 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -133,8 +133,10 @@ struct fc_rport_priv *fc_rport_create(struct fc_lport *lport, u32 port_id)
 	lockdep_assert_held(&lport->disc.disc_mutex);
 
 	rdata = fc_rport_lookup(lport, port_id);
-	if (rdata)
+	if (rdata) {
+		kref_put(&rdata->kref, fc_rport_destroy);
 		return rdata;
+	}
 
 	if (lport->rport_priv_size > 0)
 		rport_priv_size = lport->rport_priv_size;
-- 
1.8.3.1

