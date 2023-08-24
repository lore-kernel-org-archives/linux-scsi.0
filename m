Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 270DFC3DA6F
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Aug 2023 06:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240023AbjHXGSt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 02:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240021AbjHXGSs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 02:18:48 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F9B10F5
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2023 23:18:46 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37NJp4QN006914;
        Wed, 23 Aug 2023 23:18:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=hTYRBgsDffAmnYRkqfmPCWgZiOXeZl520gx9VDjhNPo=;
 b=SKCbqhXrBRz37rfLVa5FTLoRAhojmNCnWvTCT4WLcPnvxq4QpGMVFkns+/mtvmCZ+EzE
 cS05YomynPzM7xdOuGrVUWNoWX8r7n6fcys5QgeoHSybjdVMiM3xq2t+JELTKMR5qt7O
 wwi9Ih8CLMaVGTznMWZFqg9vBF2QztZwduLKoG3xAytWKrs/DtyXGMFNiMiBt/tJ84qg
 hGbGcyoxW7lrR9zLeiG6andA/dy8BLjDlzDXR0HqZyezKZC2muFur1yaEnAxtZsaGepe
 eHmM1JJXdtbhXFCCdMw6aO1WpsX1OecFgVyxGMPemHvYd4zUcgntaoCyQOs4F6i51NQT eg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3snrmcsjmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 23 Aug 2023 23:18:43 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 23 Aug
 2023 23:18:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 23 Aug 2023 23:18:41 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 0FD133F707D;
        Wed, 23 Aug 2023 23:18:39 -0700 (PDT)
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <jmeneghi@redhat.com>,
        Saurav Kashyap <skashyap@marvell.com>
Subject: [PATCH v2] bnx2fc: Remove dma_alloc_coherent to suppress the BUG_ON.
Date:   Thu, 24 Aug 2023 11:48:38 +0530
Message-ID: <20230824061838.13103-1-skashyap@marvell.com>
X-Mailer: git-send-email 2.23.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Proofpoint-GUID: IQh8Of9eiaJRJIZWY4CXBRao_DEqhEi8
X-Proofpoint-ORIG-GUID: IQh8Of9eiaJRJIZWY4CXBRao_DEqhEi8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-24_03,2023-08-22_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jerry Snitselaar <jsnitsel@redhat.com>

dma_free_coherent should not be called under spin_lock_bh,
this patch changed dma coherent calls to kzalloc and dma_map_single.

[  449.843143] ------------[ cut here ]------------
[  449.848302] kernel BUG at mm/vmalloc.c:2727!
[  449.853072] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[  449.858712] CPU: 5 PID: 1996 Comm: kworker/u24:2 Not tainted 5.14.0-118.=
el9.x86_64 #1
Rebooting.
[  449.867454] Hardware name: Dell Inc. PowerEdge R730/0WCJNT, BIOS 2.3.4 1=
1/08/2016
[  449.876966] Workqueue: fc_rport_eq fc_rport_work [libfc]
[  449.882910] RIP: 0010:vunmap+0x2e/0x30
[  449.887098] Code: 00 65 8b 05 14 a2 f0 4a a9 00 ff ff 00 75 1b 55 48 89 =
fd e8 34 36 79 00 48 85 ed 74 0b 48 89 ef 31 f6 5d e9 14 fc ff ff 5d c3 <0f=
> 0b 0f 1f 44 00 00 41 57 41 56 49 89 ce 41 55 49 89 fd 41 54 41
[  449.908054] RSP: 0018:ffffb83d878b3d68 EFLAGS: 00010206
[  449.913887] RAX: 0000000080000201 RBX: ffff8f4355133550 RCX: 000000000d4=
00005
[  449.921843] RDX: 0000000000000001 RSI: 0000000000001000 RDI: ffffb83da53=
f5000
[  449.929808] RBP: ffff8f4ac6675800 R08: ffffb83d878b3d30 R09: 00000000000=
efbdf
[  449.937774] R10: 0000000000000003 R11: ffff8f434573e000 R12: 00000000000=
01000
[  449.945736] R13: 0000000000001000 R14: ffffb83da53f5000 R15: ffff8f43d4e=
a3ae0
[  449.953701] FS:  0000000000000000(0000) GS:ffff8f529fc80000(0000) knlGS:=
0000000000000000
[  449.962732] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  449.969138] CR2: 00007f8cf993e150 CR3: 0000000efbe10003 CR4: 00000000003=
706e0
[  449.977102] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  449.985065] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[  449.993028] Call Trace:
[  449.995756]  __iommu_dma_free+0x96/0x100
[  450.000139]  bnx2fc_free_session_resc+0x67/0x240 [bnx2fc]
[  450.006171]  bnx2fc_upload_session+0xce/0x100 [bnx2fc]
[  450.011910]  bnx2fc_rport_event_handler+0x9f/0x240 [bnx2fc]
[  450.018136]  fc_rport_work+0x103/0x5b0 [libfc]
[  450.023103]  process_one_work+0x1e8/0x3c0
[  450.027581]  worker_thread+0x50/0x3b0
[  450.031669]  ? rescuer_thread+0x370/0x370
[  450.036143]  kthread+0x149/0x170
[  450.039744]  ? set_kthread_struct+0x40/0x40
[  450.044411]  ret_from_fork+0x22/0x30
[  450.048404] Modules linked in: vfat msdos fat xfs nfs_layout_nfsv41_file=
s rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver dm_service_time qedf qed c=
rc8 bnx2fc libfcoe libfc scsi_transport_fc intel_rapl_msr intel_rapl_common=
 x86_pkg_temp_thermal intel_powerclamp dcdbas rapl intel_cstate intel_uncor=
e mei_me pcspkr mei ipmi_ssif lpc_ich ipmi_si fuse zram ext4 mbcache jbd2 l=
oop nfsv3 nfs_acl nfs lockd grace fscache netfs irdma ice sd_mod t10_pi sg =
ib_uverbs ib_core 8021q garp mrp stp llc mgag200 i2c_algo_bit drm_kms_helpe=
r syscopyarea sysfillrect sysimgblt mxm_wmi fb_sys_fops cec crct10dif_pclmu=
l ahci crc32_pclmul bnx2x drm ghash_clmulni_intel libahci rfkill i40e libat=
a megaraid_sas mdio wmi sunrpc lrw dm_crypt dm_round_robin dm_multipath dm_=
snapshot dm_bufio dm_mirror dm_region_hash dm_log dm_zero dm_mod linear rai=
d10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx raid=
6_pq libcrc32c crc32c_intel raid1 raid0 iscsi_ibft squashfs be2iscsi bnx2i =
cnic uio cxgb4i cxgb4 tls
[  450.048497]  libcxgbi libcxgb qla4xxx iscsi_boot_sysfs iscsi_tcp libiscs=
i_tcp libiscsi scsi_transport_iscsi edd ipmi_devintf ipmi_msghandler
[  450.159753] ---[ end trace 712de2c57c64abc8 ]---

Reported-by: Guangwu Zhang <guazhang@redhat.com>
Tested-by: Ravi Adabala <radabala@marvell.com>
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
v1 -> v2
- Added patch description
- Corrected Jerry's name

 drivers/scsi/bnx2fc/bnx2fc_tgt.c | 228 ++++++++++++++++++++++---------
 1 file changed, 166 insertions(+), 62 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_=
tgt.c
index 2c246e80c1c4..03628f7760e7 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -671,12 +671,18 @@ static int bnx2fc_alloc_session_resc(struct bnx2fc_hb=
a *hba,
 	tgt->sq_mem_size =3D (tgt->sq_mem_size + (CNIC_PAGE_SIZE - 1)) &
 			   CNIC_PAGE_MASK;
=20
-	tgt->sq =3D dma_alloc_coherent(&hba->pcidev->dev, tgt->sq_mem_size,
-				     &tgt->sq_dma, GFP_KERNEL);
+	tgt->sq =3D kzalloc(tgt->sq_mem_size, GFP_KERNEL);
 	if (!tgt->sq) {
 		printk(KERN_ERR PFX "unable to allocate SQ memory %d\n",
 			tgt->sq_mem_size);
-		goto mem_alloc_failure;
+		goto sq_alloc_failure;
+	}
+
+	tgt->sq_dma =3D dma_map_single(&hba->pcidev->dev, tgt->sq,
+				     tgt->sq_mem_size, DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(&hba->pcidev->dev, tgt->sq_dma))) {
+		pr_err(PFX "unable to map SQ memory %d\n", tgt->sq_mem_size);
+		goto sq_map_failure;
 	}
=20
 	/* Allocate and map CQ */
@@ -684,12 +690,18 @@ static int bnx2fc_alloc_session_resc(struct bnx2fc_hb=
a *hba,
 	tgt->cq_mem_size =3D (tgt->cq_mem_size + (CNIC_PAGE_SIZE - 1)) &
 			   CNIC_PAGE_MASK;
=20
-	tgt->cq =3D dma_alloc_coherent(&hba->pcidev->dev, tgt->cq_mem_size,
-				     &tgt->cq_dma, GFP_KERNEL);
+	tgt->cq =3D kzalloc(tgt->cq_mem_size, GFP_KERNEL);
 	if (!tgt->cq) {
-		printk(KERN_ERR PFX "unable to allocate CQ memory %d\n",
-			tgt->cq_mem_size);
-		goto mem_alloc_failure;
+		pr_err(PFX "unable to allocate CQ memory %d\n",
+		       tgt->cq_mem_size);
+		goto cq_alloc_failure;
+	}
+
+	tgt->cq_dma =3D dma_map_single(&hba->pcidev->dev, tgt->cq,
+				     tgt->cq_mem_size, DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(&hba->pcidev->dev, tgt->cq_dma))) {
+		pr_err(PFX "unable to map CQ memory %d\n", tgt->cq_mem_size);
+		goto cq_map_failure;
 	}
=20
 	/* Allocate and map RQ and RQ PBL */
@@ -697,24 +709,36 @@ static int bnx2fc_alloc_session_resc(struct bnx2fc_hb=
a *hba,
 	tgt->rq_mem_size =3D (tgt->rq_mem_size + (CNIC_PAGE_SIZE - 1)) &
 			   CNIC_PAGE_MASK;
=20
-	tgt->rq =3D dma_alloc_coherent(&hba->pcidev->dev, tgt->rq_mem_size,
-				     &tgt->rq_dma, GFP_KERNEL);
+	tgt->rq =3D kzalloc(tgt->rq_mem_size, GFP_KERNEL);
 	if (!tgt->rq) {
-		printk(KERN_ERR PFX "unable to allocate RQ memory %d\n",
-			tgt->rq_mem_size);
-		goto mem_alloc_failure;
+		pr_err(PFX "unable to allocate RQ memory %d\n",
+		       tgt->rq_mem_size);
+		goto rq_alloc_failure;
+	}
+
+	tgt->rq_dma =3D dma_map_single(&hba->pcidev->dev, tgt->rq,
+				     tgt->rq_mem_size, DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(&hba->pcidev->dev, tgt->rq_dma))) {
+		pr_err(PFX "unable to map RQ memory %d\n", tgt->rq_mem_size);
+		goto rq_map_failure;
 	}
=20
 	tgt->rq_pbl_size =3D (tgt->rq_mem_size / CNIC_PAGE_SIZE) * sizeof(void *);
 	tgt->rq_pbl_size =3D (tgt->rq_pbl_size + (CNIC_PAGE_SIZE - 1)) &
 			   CNIC_PAGE_MASK;
=20
-	tgt->rq_pbl =3D dma_alloc_coherent(&hba->pcidev->dev, tgt->rq_pbl_size,
-					 &tgt->rq_pbl_dma, GFP_KERNEL);
+	tgt->rq_pbl =3D kzalloc(tgt->rq_pbl_size, GFP_KERNEL);
 	if (!tgt->rq_pbl) {
-		printk(KERN_ERR PFX "unable to allocate RQ PBL %d\n",
-			tgt->rq_pbl_size);
-		goto mem_alloc_failure;
+		pr_err(PFX "unable to allocate RQ PBL %d\n", tgt->rq_pbl_size);
+		goto rq_pbl_alloc_failure;
+	}
+
+	tgt->rq_pbl_dma =3D dma_map_single(&hba->pcidev->dev, tgt->rq_pbl,
+					 tgt->rq_pbl_size, DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(&hba->pcidev->dev, tgt->rq_pbl_dma))) {
+		pr_err(PFX "unable to map RQ PBL memory %d\n",
+		       tgt->rq_pbl_size);
+		goto rq_pbl_map_failure;
 	}
=20
 	num_pages =3D tgt->rq_mem_size / CNIC_PAGE_SIZE;
@@ -734,13 +758,19 @@ static int bnx2fc_alloc_session_resc(struct bnx2fc_hb=
a *hba,
 	tgt->xferq_mem_size =3D (tgt->xferq_mem_size + (CNIC_PAGE_SIZE - 1)) &
 			       CNIC_PAGE_MASK;
=20
-	tgt->xferq =3D dma_alloc_coherent(&hba->pcidev->dev,
-					tgt->xferq_mem_size, &tgt->xferq_dma,
-					GFP_KERNEL);
+	tgt->xferq =3D kzalloc(tgt->xferq_mem_size, GFP_KERNEL);
 	if (!tgt->xferq) {
 		printk(KERN_ERR PFX "unable to allocate XFERQ %d\n",
 			tgt->xferq_mem_size);
-		goto mem_alloc_failure;
+		goto xferq_alloc_failure;
+	}
+
+	tgt->xferq_dma =3D dma_map_single(&hba->pcidev->dev, tgt->xferq,
+					tgt->xferq_mem_size, DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(&hba->pcidev->dev, tgt->xferq_dma))) {
+		pr_err(PFX "unable to map XFERQ memory %d\n",
+		       tgt->xferq_mem_size);
+		goto xferq_map_failure;
 	}
=20
 	/* Allocate and map CONFQ & CONFQ PBL */
@@ -748,13 +778,19 @@ static int bnx2fc_alloc_session_resc(struct bnx2fc_hb=
a *hba,
 	tgt->confq_mem_size =3D (tgt->confq_mem_size + (CNIC_PAGE_SIZE - 1)) &
 			       CNIC_PAGE_MASK;
=20
-	tgt->confq =3D dma_alloc_coherent(&hba->pcidev->dev,
-					tgt->confq_mem_size, &tgt->confq_dma,
-					GFP_KERNEL);
+	tgt->confq =3D kzalloc(tgt->confq_mem_size, GFP_KERNEL);
 	if (!tgt->confq) {
-		printk(KERN_ERR PFX "unable to allocate CONFQ %d\n",
-			tgt->confq_mem_size);
-		goto mem_alloc_failure;
+		pr_err(PFX "unable to allocate CONFQ %d\n",
+		       tgt->confq_mem_size);
+		goto confq_alloc_failure;
+	}
+
+	tgt->confq_dma =3D dma_map_single(&hba->pcidev->dev, tgt->confq,
+					tgt->confq_mem_size, DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(&hba->pcidev->dev, tgt->confq_dma))) {
+		pr_err(PFX "unable to map CONFQ memory %d\n",
+		       tgt->confq_mem_size);
+		goto confq_map_failure;
 	}
=20
 	tgt->confq_pbl_size =3D
@@ -762,13 +798,19 @@ static int bnx2fc_alloc_session_resc(struct bnx2fc_hb=
a *hba,
 	tgt->confq_pbl_size =3D
 		(tgt->confq_pbl_size + (CNIC_PAGE_SIZE - 1)) & CNIC_PAGE_MASK;
=20
-	tgt->confq_pbl =3D dma_alloc_coherent(&hba->pcidev->dev,
-					    tgt->confq_pbl_size,
-					    &tgt->confq_pbl_dma, GFP_KERNEL);
+	tgt->confq_pbl =3D kzalloc(tgt->confq_pbl_size, GFP_KERNEL);
 	if (!tgt->confq_pbl) {
-		printk(KERN_ERR PFX "unable to allocate CONFQ PBL %d\n",
-			tgt->confq_pbl_size);
-		goto mem_alloc_failure;
+		pr_err(PFX "unable to allocate CONFQ PBL %d\n",
+		       tgt->confq_pbl_size);
+		goto confq_pbl_alloc_failure;
+	}
+
+	tgt->confq_pbl_dma =3D dma_map_single(&hba->pcidev->dev, tgt->confq_pbl,
+					    tgt->confq_pbl_size, DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(&hba->pcidev->dev, tgt->confq_pbl_dma))) {
+		pr_err(PFX "unable to map CONFQ PBL memory %d\n",
+		       tgt->confq_pbl_size);
+		goto confq_pbl_map_failure;
 	}
=20
 	num_pages =3D tgt->confq_mem_size / CNIC_PAGE_SIZE;
@@ -786,35 +828,88 @@ static int bnx2fc_alloc_session_resc(struct bnx2fc_hb=
a *hba,
 	/* Allocate and map ConnDB */
 	tgt->conn_db_mem_size =3D sizeof(struct fcoe_conn_db);
=20
-	tgt->conn_db =3D dma_alloc_coherent(&hba->pcidev->dev,
-					  tgt->conn_db_mem_size,
-					  &tgt->conn_db_dma, GFP_KERNEL);
+	tgt->conn_db =3D kzalloc(tgt->conn_db_mem_size, GFP_KERNEL);
 	if (!tgt->conn_db) {
 		printk(KERN_ERR PFX "unable to allocate conn_db %d\n",
-						tgt->conn_db_mem_size);
-		goto mem_alloc_failure;
+		       tgt->conn_db_mem_size);
+		goto conn_db_alloc_failure;
 	}
=20
+	tgt->conn_db_dma =3D dma_map_single(&hba->pcidev->dev, tgt->conn_db,
+					  tgt->conn_db_mem_size, DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(&hba->pcidev->dev, tgt->conn_db_dma))) {
+		pr_err(PFX "unable to map conn db memory %d\n",
+		       tgt->conn_db_mem_size);
+		goto conn_db_map_failure;
+	}
=20
 	/* Allocate and map LCQ */
 	tgt->lcq_mem_size =3D (tgt->max_sqes + 8) * BNX2FC_SQ_WQE_SIZE;
 	tgt->lcq_mem_size =3D (tgt->lcq_mem_size + (CNIC_PAGE_SIZE - 1)) &
 			     CNIC_PAGE_MASK;
=20
-	tgt->lcq =3D dma_alloc_coherent(&hba->pcidev->dev, tgt->lcq_mem_size,
-				      &tgt->lcq_dma, GFP_KERNEL);
-
+	tgt->lcq =3D kzalloc(tgt->lcq_mem_size, GFP_KERNEL);
 	if (!tgt->lcq) {
 		printk(KERN_ERR PFX "unable to allocate lcq %d\n",
 		       tgt->lcq_mem_size);
-		goto mem_alloc_failure;
+		goto lcq_alloc_failure;
+	}
+
+	tgt->lcq_dma =3D dma_map_single(&hba->pcidev->dev, tgt->lcq,
+				      tgt->lcq_mem_size, DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(&hba->pcidev->dev, tgt->lcq_dma))) {
+		pr_err(PFX "unable to map lcq memory %d\n",
+		       tgt->lcq_mem_size);
+		goto lcq_map_failure;
 	}
=20
 	tgt->conn_db->rq_prod =3D 0x8000;
=20
 	return 0;
=20
-mem_alloc_failure:
+lcq_map_failure:
+	kfree(tgt->lcq);
+lcq_alloc_failure:
+	dma_unmap_single(&hba->pcidev->dev, tgt->conn_db_dma,
+			 tgt->conn_db_mem_size, DMA_BIDIRECTIONAL);
+conn_db_map_failure:
+	kfree(tgt->conn_db);
+conn_db_alloc_failure:
+	dma_unmap_single(&hba->pcidev->dev, tgt->confq_pbl_dma,
+			 tgt->confq_pbl_size, DMA_BIDIRECTIONAL);
+confq_pbl_map_failure:
+	kfree(tgt->confq_pbl);
+confq_pbl_alloc_failure:
+	dma_unmap_single(&hba->pcidev->dev, tgt->confq_dma,
+			 tgt->confq_mem_size, DMA_BIDIRECTIONAL);
+confq_map_failure:
+	kfree(tgt->confq);
+confq_alloc_failure:
+	dma_unmap_single(&hba->pcidev->dev, tgt->xferq_dma,
+			 tgt->xferq_mem_size, DMA_BIDIRECTIONAL);
+xferq_map_failure:
+	kfree(tgt->xferq);
+xferq_alloc_failure:
+	dma_unmap_single(&hba->pcidev->dev, tgt->rq_pbl_dma,
+			 tgt->rq_pbl_size, DMA_BIDIRECTIONAL);
+rq_pbl_map_failure:
+	kfree(tgt->rq_pbl);
+rq_pbl_alloc_failure:
+	dma_unmap_single(&hba->pcidev->dev, tgt->rq_dma, tgt->rq_mem_size,
+			 DMA_BIDIRECTIONAL);
+rq_map_failure:
+	kfree(tgt->rq);
+rq_alloc_failure:
+	dma_unmap_single(&hba->pcidev->dev, tgt->cq_dma, tgt->cq_mem_size,
+			 DMA_BIDIRECTIONAL);
+cq_map_failure:
+	kfree(tgt->cq);
+cq_alloc_failure:
+	dma_unmap_single(&hba->pcidev->dev, tgt->sq_dma, tgt->sq_mem_size,
+			 DMA_BIDIRECTIONAL);
+sq_map_failure:
+	kfree(tgt->sq);
+sq_alloc_failure:
 	return -ENOMEM;
 }
=20
@@ -839,54 +934,63 @@ static void bnx2fc_free_session_resc(struct bnx2fc_hb=
a *hba,
=20
 	/* Free LCQ */
 	if (tgt->lcq) {
-		dma_free_coherent(&hba->pcidev->dev, tgt->lcq_mem_size,
-				    tgt->lcq, tgt->lcq_dma);
+		dma_unmap_single(&hba->pcidev->dev, tgt->lcq_dma,
+				 tgt->lcq_mem_size, DMA_BIDIRECTIONAL);
+		kfree(tgt->lcq);
 		tgt->lcq =3D NULL;
 	}
 	/* Free connDB */
 	if (tgt->conn_db) {
-		dma_free_coherent(&hba->pcidev->dev, tgt->conn_db_mem_size,
-				    tgt->conn_db, tgt->conn_db_dma);
+		dma_unmap_single(&hba->pcidev->dev, tgt->conn_db_dma,
+				 tgt->conn_db_mem_size, DMA_BIDIRECTIONAL);
+		kfree(tgt->conn_db);
 		tgt->conn_db =3D NULL;
 	}
 	/* Free confq  and confq pbl */
 	if (tgt->confq_pbl) {
-		dma_free_coherent(&hba->pcidev->dev, tgt->confq_pbl_size,
-				    tgt->confq_pbl, tgt->confq_pbl_dma);
+		dma_unmap_single(&hba->pcidev->dev, tgt->confq_pbl_dma,
+				 tgt->confq_pbl_size, DMA_BIDIRECTIONAL);
+		kfree(tgt->confq_pbl);
 		tgt->confq_pbl =3D NULL;
 	}
 	if (tgt->confq) {
-		dma_free_coherent(&hba->pcidev->dev, tgt->confq_mem_size,
-				    tgt->confq, tgt->confq_dma);
+		dma_unmap_single(&hba->pcidev->dev, tgt->confq_dma,
+				 tgt->confq_mem_size, DMA_BIDIRECTIONAL);
+		kfree(tgt->confq);
 		tgt->confq =3D NULL;
 	}
 	/* Free XFERQ */
 	if (tgt->xferq) {
-		dma_free_coherent(&hba->pcidev->dev, tgt->xferq_mem_size,
-				    tgt->xferq, tgt->xferq_dma);
+		dma_unmap_single(&hba->pcidev->dev, tgt->xferq_dma,
+				 tgt->xferq_mem_size, DMA_BIDIRECTIONAL);
+		kfree(tgt->xferq);
 		tgt->xferq =3D NULL;
 	}
 	/* Free RQ PBL and RQ */
 	if (tgt->rq_pbl) {
-		dma_free_coherent(&hba->pcidev->dev, tgt->rq_pbl_size,
-				    tgt->rq_pbl, tgt->rq_pbl_dma);
+		dma_unmap_single(&hba->pcidev->dev, tgt->rq_pbl_dma,
+				 tgt->rq_pbl_size, DMA_BIDIRECTIONAL);
+		kfree(tgt->rq_pbl);
 		tgt->rq_pbl =3D NULL;
 	}
 	if (tgt->rq) {
-		dma_free_coherent(&hba->pcidev->dev, tgt->rq_mem_size,
-				    tgt->rq, tgt->rq_dma);
+		dma_unmap_single(&hba->pcidev->dev, tgt->rq_dma,
+				 tgt->rq_mem_size, DMA_BIDIRECTIONAL);
+		kfree(tgt->rq);
 		tgt->rq =3D NULL;
 	}
 	/* Free CQ */
 	if (tgt->cq) {
-		dma_free_coherent(&hba->pcidev->dev, tgt->cq_mem_size,
-				    tgt->cq, tgt->cq_dma);
+		dma_unmap_single(&hba->pcidev->dev, tgt->cq_dma,
+				 tgt->cq_mem_size, DMA_BIDIRECTIONAL);
+		kfree(tgt->cq);
 		tgt->cq =3D NULL;
 	}
 	/* Free SQ */
 	if (tgt->sq) {
-		dma_free_coherent(&hba->pcidev->dev, tgt->sq_mem_size,
-				    tgt->sq, tgt->sq_dma);
+		dma_unmap_single(&hba->pcidev->dev, tgt->sq_dma,
+				 tgt->sq_mem_size, DMA_BIDIRECTIONAL);
+		kfree(tgt->sq);
 		tgt->sq =3D NULL;
 	}
 	spin_unlock_bh(&tgt->cq_lock);
--=20
2.23.1

