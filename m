Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA026C6FD19
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Mar 2023 04:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjCMEhd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Mar 2023 00:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjCMEha (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2023 00:37:30 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8529741097
        for <linux-scsi@vger.kernel.org>; Sun, 12 Mar 2023 21:37:28 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32D33atr014804;
        Sun, 12 Mar 2023 21:37:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Wscj4EqM5TjIEO3Fj8PGE4V1ftjHtYrss+jKXtyxpq8=;
 b=TAVh0nv2XmuabuM6Vn+J0/FV8Mh1XknjXqx68WgpfLccUIukzJWC1NQkTUteUazj7wOS
 /Wuzck+mB7J/JzT0xYma4B9dfwjrzqN8BWG7f4ZSLKuaKqlv2wXygg6NLowTDk12DduX
 X5yyWr45O19pkpKrwg4MaOQ84w50o1q9n0SlvXrwS3em4IwyxRNWSAndiyWj9xVeJ8zQ
 oFfVTpw3kBMKJ+9sPwQzeULOeFRQST5P99hGip/E0zlqtaGW2sNgr/TIN8Dt6DA5WSN2
 Wn1ltrp8DNg1s96rWAg7QJofOEbEJRotCxXq8stMHW6leB7jQN22/GMj/d8NC4BTRCt6 ew== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3p8t1t46rp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 12 Mar 2023 21:37:26 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Sun, 12 Mar
 2023 21:37:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Sun, 12 Mar 2023 21:37:23 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 8C8925B693A;
        Sun, 12 Mar 2023 21:37:22 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>
Subject: [PATCH 2/2] qla2xxx: synchronize the iocb count to be in order
Date:   Sun, 12 Mar 2023 21:37:11 -0700
Message-ID: <20230313043711.13500-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20230313043711.13500-1-njavali@marvell.com>
References: <20230313043711.13500-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: o6U8s9rydpv_Raui_ChCeriPLlWIOKq_
X-Proofpoint-ORIG-GUID: o6U8s9rydpv_Raui_ChCeriPLlWIOKq_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-12_10,2023-03-10_01,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

The system hang observed with below call trace,

BUG: kernel NULL pointer dereference, address: 0000000000000000
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP NOPTI
CPU: 15 PID: 86747 Comm: nvme Kdump: loaded Not tainted 6.2.0+ #1
Hardware name: Dell Inc. PowerEdge R6515/04F3CJ, BIOS 2.7.3 03/31/2022
RIP: 0010:__wake_up_common+0x55/0x190
Code: 41 f6 01 04 0f 85 b2 00 00 00 48 8b 43 08 4c 8d
      40 e8 48 8d 43 08 48 89 04 24 48 89 c6\
      49 8d 40 18 48 39 c6 0f 84 e9 00 00 00 <49> 8b 40 18 89 6c 24 14 31
      ed 4c 8d 60 e8 41 8b 18 f6 c3 04 75 5d
RSP: 0018:ffffb05a82afbba0 EFLAGS: 00010082
RAX: 0000000000000000 RBX: ffff8f9b83a00018 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffff8f9b83a00020 RDI: ffff8f9b83a00018
RBP: 0000000000000001 R08: ffffffffffffffe8 R09: ffffb05a82afbbf8
R10: 70735f7472617473 R11: 5f30307832616c71 R12: 0000000000000001
R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f815cf4c740(0000) GS:ffff8f9eeed80000(0000)
	knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000010633a000 CR4: 0000000000350ee0
Call Trace:
    <TASK>
    __wake_up_common_lock+0x83/0xd0
    qla_nvme_ls_req+0x21b/0x2b0 [qla2xxx]
    __nvme_fc_send_ls_req+0x1b5/0x350 [nvme_fc]
    nvme_fc_xmt_disconnect_assoc+0xca/0x110 [nvme_fc]
    nvme_fc_delete_association+0x1bf/0x220 [nvme_fc]
    ? nvme_remove_namespaces+0x9f/0x140 [nvme_core]
    nvme_do_delete_ctrl+0x5b/0xa0 [nvme_core]
    nvme_sysfs_delete+0x5f/0x70 [nvme_core]
    kernfs_fop_write_iter+0x12b/0x1c0
    vfs_write+0x2a3/0x3b0
    ksys_write+0x5f/0xe0
    do_syscall_64+0x5c/0x90
    ? syscall_exit_work+0x103/0x130
    ? syscall_exit_to_user_mode+0x12/0x30
    ? do_syscall_64+0x69/0x90
    ? exit_to_user_mode_loop+0xd0/0x130
    ? exit_to_user_mode_prepare+0xec/0x100
    ? syscall_exit_to_user_mode+0x12/0x30
    ? do_syscall_64+0x69/0x90
    ? syscall_exit_to_user_mode+0x12/0x30
    ? do_syscall_64+0x69/0x90
    entry_SYSCALL_64_after_hwframe+0x72/0xdc
    RIP: 0033:0x7f815cd3eb97

The iocb counts are out of order that would block any commands from
going out and hang the system. Synchronize the iocb count to be in
correct order.

Fixes: 5f63a163ed2f ("scsi: qla2xxx: Fix exchange oversubscription for management commands")
Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 030625ebb4e6..71feda2cdb63 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1900,6 +1900,8 @@ qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
 	}
 
 	req->outstanding_cmds[index] = NULL;
+
+	qla_put_fw_resources(sp->qpair, &sp->iores);
 	return sp;
 }
 
@@ -3112,7 +3114,6 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *vha, void *pkt,
 	}
 	bsg_reply->reply_payload_rcv_len = 0;
 
-	qla_put_fw_resources(sp->qpair, &sp->iores);
 done:
 	/* Return the vendor specific reply to API */
 	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = rval;
-- 
2.19.0.rc0

