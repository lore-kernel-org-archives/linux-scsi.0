Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EBEBC6FD19
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Mar 2023 04:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjCMEha (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Mar 2023 00:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjCMEh3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2023 00:37:29 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42ED841094
        for <linux-scsi@vger.kernel.org>; Sun, 12 Mar 2023 21:37:28 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32D33atq014804;
        Sun, 12 Mar 2023 21:37:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=nQvjs9KuJaL7kjzmhIMzC+PcmtrmMt6vg0Q3LzKln54=;
 b=iOLVt5DJL4H0Db4a8F1u+YFeqsy5NHDJFW6MQ3pCkeUnav10osdHLnw3pa1oojB4ATWt
 v7IvIMs1bbT5Y4vLhT9cyrMDuMHQ4AdIWH0eRiQwRKCVtAQX7LfEID5rC8yeX1HC2ZG+
 iHWlgnCrry2ciGeyBwITVG7S3QwNggBAqenJuFs+gK+IXJnulZZK8r/uZdbNnz22YDpv
 87s8VwwRhlIrybdUDV82yXZIvHfiHzTpGhQg60eyugEUDI/az1IU8f2znJusDAxkpwbV
 jcdNhxIm/hK58te/QVUi8HPzbKCnapH+jboMVs7nNlCEeX2aEBGnrB0FxqZeh1DV60f0 Sw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3p8t1t46rp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 12 Mar 2023 21:37:26 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Sun, 12 Mar
 2023 21:37:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Sun, 12 Mar 2023 21:37:23 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 770435B692C;
        Sun, 12 Mar 2023 21:37:22 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>
Subject: [PATCH 1/2] qla2xxx: perform lockless command completion in abort path
Date:   Sun, 12 Mar 2023 21:37:10 -0700
Message-ID: <20230313043711.13500-2-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20230313043711.13500-1-njavali@marvell.com>
References: <20230313043711.13500-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 3K0TcWKdLenZFmAz3vza8yNEhgQbsrLw
X-Proofpoint-ORIG-GUID: 3K0TcWKdLenZFmAz3vza8yNEhgQbsrLw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-12_10,2023-03-10_01,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

While adding and removing the controller, call trace was observed,

WARNING: CPU: 3 PID: 623596 at kernel/dma/mapping.c:532 dma_free_attrs+0x33/0x50
CPU: 3 PID: 623596 Comm: sh Kdump: loaded Not tainted 5.14.0-96.el9.x86_64 #1
RIP: 0010:dma_free_attrs+0x33/0x50

Call Trace:
   qla2x00_async_sns_sp_done+0x107/0x1b0 [qla2xxx]
   qla2x00_abort_srb+0x8e/0x250 [qla2xxx]
   ? ql_dbg+0x70/0x100 [qla2xxx]
   __qla2x00_abort_all_cmds+0x108/0x190 [qla2xxx]
   qla2x00_abort_all_cmds+0x24/0x70 [qla2xxx]
   qla2x00_abort_isp_cleanup+0x305/0x3e0 [qla2xxx]
   qla2x00_remove_one+0x364/0x400 [qla2xxx]
   pci_device_remove+0x36/0xa0
   __device_release_driver+0x17a/0x230
   device_release_driver+0x24/0x30
   pci_stop_bus_device+0x68/0x90
   pci_stop_and_remove_bus_device_locked+0x16/0x30
   remove_store+0x75/0x90
   kernfs_fop_write_iter+0x11c/0x1b0
   new_sync_write+0x11f/0x1b0
   vfs_write+0x1eb/0x280
   ksys_write+0x5f/0xe0
   do_syscall_64+0x5c/0x80
   ? do_user_addr_fault+0x1d8/0x680
   ? do_syscall_64+0x69/0x80
   ? exc_page_fault+0x62/0x140
   ? asm_exc_page_fault+0x8/0x30
   entry_SYSCALL_64_after_hwframe+0x44/0xae

The command was completed in abort path during driver unload
with a lock held causing the warning in abort path.
Hence complete the command without any lock held.

Reported-by: Lin Li <lilin@redhat.com>
Tested-by: Lin Li <lilin@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 545167627e48..d2f6c0546587 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1858,6 +1858,17 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 	for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
 		sp = req->outstanding_cmds[cnt];
 		if (sp) {
+			/*
+			 * perform lockless completion while driver unload
+			 */
+			if (qla2x00_chip_is_down(vha)) {
+				req->outstanding_cmds[cnt] = NULL;
+				spin_unlock_irqrestore(qp->qp_lock_ptr, flags);
+				sp->done(sp, res);
+				spin_lock_irqsave(qp->qp_lock_ptr, flags);
+				continue;
+			}
+
 			switch (sp->cmd_type) {
 			case TYPE_SRB:
 				qla2x00_abort_srb(qp, sp, res, &flags);
-- 
2.19.0.rc0

