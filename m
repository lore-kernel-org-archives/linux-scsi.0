Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F07CDB465
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 10:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbjJPKSp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 06:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbjJPKSV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 06:18:21 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FAC10F
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 03:18:18 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39FMqvx3002312
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 03:18:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=pTyBfo9TvWgifbULpHS4ipyzvQKLwGs+dRbYP3GFhAs=;
 b=BtQCHjclGJlUTbMpYiwvNw8pNVkv64/FiA8UMMROS3txi8FV7H7x2PLEpSSveTmP6RWv
 th5dXQeHAGS2ZScCZCcmTCtfRXt+jnFKzbY1tXxfGynpx2IXuyq1wL87TQt6cQaa18ww
 XyfUZSwYrGekwo0ZrMMt/dun3racM4yvVidgqLkeI9zlXu8bqkHlzVNblWJcsRz/1fl3
 9Hh1f9CbAurbd2DG8Ur5EIHmByiS0ZBIYyo908hFR2y77r2g8ZCkxxUQsSjISaMVlpi/
 GShEM6BdmJWA3eG63OKnKu6j0Ffqa7hTX/KBp9EJu1bSVnDx3Ao5l1Wi6JZMFThkt7Eo yg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3tqtgkmu7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 03:18:12 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 16 Oct
 2023 03:18:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Mon, 16 Oct 2023 03:18:07 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id A9D3D3F7068;
        Mon, 16 Oct 2023 03:18:05 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH] qla2xxx: Fix double free of dsd_list during driver load.
Date:   Mon, 16 Oct 2023 15:47:49 +0530
Message-ID: <20231016101749.5059-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: UeLoKNWJkKYbbcaMwq9w9f_8fM1pm4e8
X-Proofpoint-ORIG-GUID: UeLoKNWJkKYbbcaMwq9w9f_8fM1pm4e8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_03,2023-10-12_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

On driver load, scsi_add_host can fail. This trigger the free path
to call qla2x00_mem_free() multiple times. This cause Null pointer
access of ha->base_qpair. Add check before access to free.

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
 IP: [<ffffffffc118f73c>] qla2x00_mem_free+0x51c/0xcb0 [qla2xxx]
 PGD 8000001fcfe4a067 PUD 1fc8f0a067 PMD 0
 Oops: 0000 [#1] SMP
 RIP: 0010:[<ffffffffc118f73c>]  [<ffffffffc118f73c>] qla2x00_mem_free+0x51c/0xcb0 [qla2xxx]
 RSP: 0018:ffff8ace97a93a30  EFLAGS: 00010246
 RAX: 0000000000000000 RBX: ffff8ace8efd0000 RCX: 000000000000488f
 RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
 RBP: ffff8ace97a93a60 R08: 000000000001f040 R09: ffffffff8678209b
 R10: ffff8acf7d6df040 R11: ffffc591c0fcc980 R12: ffffffff87034800
 R13: ffff8acf0e3cc740 R14: ffff8ace8efd0000 R15: 00000000fffffff4
 FS:  00007f4cf5449740(0000) GS:ffff8acf7d6c0000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000030 CR3: 0000001fc2f6c000 CR4: 00000000007607e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  [<ffffffff86781f18>] ? kobject_put+0x28/0x60
  [<ffffffffc119a59c>] qla2x00_probe_one+0x19fc/0x3040 [qla2xxx]

Fixes: efeda3bf912f ("scsi: qla2xxx: Move resource to allow code reuse")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 50db08265c51..dcae09a37d49 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4953,7 +4953,7 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 	ha->gid_list = NULL;
 	ha->gid_list_dma = 0;
 
-	if (!list_empty(&ha->base_qpair->dsd_list)) {
+	if (ha->base_qpair && !list_empty(&ha->base_qpair->dsd_list)) {
 		struct dsd_dma *dsd_ptr, *tdsd_ptr;
 
 		/* clean up allocated prev pool */
-- 
2.23.1

