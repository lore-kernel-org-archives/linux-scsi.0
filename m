Return-Path: <SRS0=Y1+o=5Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 777C3C2D0EA
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 06:43:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D0902074F
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 06:43:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="xeg2VIUV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgDHGnz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 02:43:55 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36546 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726477AbgDHGny (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2020 02:43:54 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0386f8nF031052;
        Tue, 7 Apr 2020 23:43:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=siZ+YXG2BvIdHnWnBV8TZ5AQYZIvgXt1c0Eer5ft7XU=;
 b=xeg2VIUVTk5ShxM4/C3TpGJSgh3OVpeCRu8wDDDmQAFpxtkL+7zxteB6SIBJJUMLjNWo
 92Mlz5faohdhGlE0If8TwGKEXeBn2zalNmqnpGbCKtwvnlv4v6MUweUQ3GC7G0k928f7
 YpVxQUsvJHjKEVz/XcgXww5uEErV+ekuhWimgSrPYp8bWJBWoAy4kMIGIu4WvF8P3F2g
 SiqxWxk7ICn4anj/Db36ejA3ktQklxzUmgHXPD/nu4cYI5sVppDRePeSgSm5Q3eCg0Dq
 SsDnwQwGgSOzUKWAE0C9JeBBgHVnlSvvRX3F2socdcC581YXrA91IRDfyK7U3bt8DQSw Dg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 3091jwa0r7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 23:43:47 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 7 Apr
 2020 23:43:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 7 Apr 2020 23:43:46 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 178853F703F;
        Tue,  7 Apr 2020 23:43:46 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0386hjVJ019428;
        Tue, 7 Apr 2020 23:43:45 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0386hjLX019427;
        Tue, 7 Apr 2020 23:43:45 -0700
From:   Manish Rangankar <mrangankar@marvell.com>
To:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 4/6] qedi: Do not flush offload work if ARP not resolved.
Date:   Tue, 7 Apr 2020 23:43:30 -0700
Message-ID: <20200408064332.19377-5-mrangankar@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200408064332.19377-1-mrangankar@marvell.com>
References: <20200408064332.19377-1-mrangankar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_10:2020-04-07,2020-04-07 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Nilesh Javali <njavali@marvell.com>

For non-reachable target offload_work is not initialized,
and endpoint state is set to OFLD_NONE. This result into
the WARN_ON due to check of work function field set to zero.

------------[ cut here ]------------
WARNING: CPU: 24 PID: 18587 at ../kernel/workqueue.c:3037 __flush_work+0x1c1/0x1d0
:
Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380 Gen10, BIOS U30 02/01/2020
RIP: 0010:__flush_work+0x1c1/0x1d0
Code: ba 6d 00 03 80 c9 f0 eb b6 48 c7 c7 20 ee 6c a4 e8 52 d3 04 00 0f 0b 31 c0 e9 d1 fe ff
ff 48 c7 c7 20 ee 6c a4 e8 3d d3 04 00 <0f> 0b 31 c0 e9 bc fe ff ff e8 11 f3 f
 00 31 f6
RSP: 0018:ffffac5a8cd47a80 EFLAGS: 00010282
RAX: 0000000000000024 RBX: ffff98d68c1fcaf0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff98ce9fd99898 RDI: ffff98ce9fd99898
RBP: ffff98d68c1fcbc0 R08: 00000000000006fa R09: 0000000000000001
R10: ffffac5a8cd47b50 R11: 0000000000000001 R12: 0000000000000000
R13: 000000000000489b R14: ffff98d68c1fc800 R15: ffff98d692132c00
FS:  00007f65f7f62280(0000) GS:ffff98ce9fd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd2435e880 CR3: 0000000809334003 CR4: 00000000007606e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 ? class_create_release+0x40/0x40
 ? klist_put+0x2c/0x80
 qedi_ep_disconnect+0xdd/0x400 [qedi]
 iscsi_if_ep_disconnect.isra.20+0x59/0x70 [scsi_transport_iscsi]
 iscsi_if_rx+0x129b/0x1670 [scsi_transport_iscsi]
 ? __netlink_lookup+0xe7/0x160
 netlink_unicast+0x21d/0x300
 netlink_sendmsg+0x30f/0x430
 sock_sendmsg+0x5b/0x60
 ____sys_sendmsg+0x1e2/0x240
 ? copy_msghdr_from_user+0xd9/0x160
 ___sys_sendmsg+0x88/0xd0
 ? ___sys_recvmsg+0xa2/0xe0
 ? hrtimer_try_to_cancel+0x25/0x100
 ? do_nanosleep+0x9c/0x170
 ? __sys_sendmsg+0x5e/0xa0
 __sys_sendmsg+0x5e/0xa0
 do_syscall_64+0x60/0x1f0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f65f6f16107
Code: 64 89 02 48 c7 c0 ff ff ff ff eb b9 0f 1f 80 00 00 00 00 8b 05 aa d2 2b 00 48 63 d2 48
63 ff 85 c0 75 18 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 59 f3 c3 0f 1f 8
    0 00 00 00 00 53 48 89 f3 48
 RSP: 002b:00007ffd24367ca8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
 RAX: ffffffffffffffda RBX: 000055a7aeaaf110 RCX: 00007f65f6f16107
 RDX: 0000000000000000 RSI: 00007ffd24367cc0 RDI: 0000000000000003
 RBP: 0000000000000070 R08: 0000000000000000 R09: 0000000000000000
 R10: 000000000000075c R11: 0000000000000246 R12: 00007ffd24367cc0
 R13: 000055a7ae560008 R14: 00007ffd24367db0 R15: 0000000000000000
 ---[ end trace 54f499c05d41f8bb ]---

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_iscsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 26b1151..80c724b 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1000,7 +1000,8 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 	if (qedi_ep->state == EP_STATE_OFLDCONN_START)
 		goto ep_exit_recover;
 
-	flush_work(&qedi_ep->offload_work);
+	if (qedi_ep->state != EP_STATE_OFLDCONN_NONE)
+		flush_work(&qedi_ep->offload_work);
 
 	if (qedi_ep->conn) {
 		qedi_conn = qedi_ep->conn;
-- 
1.8.3.1

