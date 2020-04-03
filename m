Return-Path: <SRS0=YASp=5T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B45C2BA12
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 18:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEF5820B1F
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 18:00:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Q3fC9aUu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbgDCSAl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Apr 2020 14:00:41 -0400
Received: from mout.gmx.net ([212.227.15.19]:37839 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727989AbgDCSAl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Apr 2020 14:00:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1585936813;
        bh=Qh1WoO+bnQ7lf0YM3L8zg/8Ho61UP33iXUhGywCH7is=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=Q3fC9aUuWkTXSTGWM/UUG/kB4UkBTqmKhxGZJwfTIwjaZCbPBcdUXujlHxe3gATvA
         GtgklUucqYiNqCn8i6x+Z6aJ9B6IpsDpHwy5rwcoavTwe+vLpegP/pt1z/xttaOZe/
         92ctiNvIACD/PJ6zTXXfLE1nLD94Xgrvdfqb5FXQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([82.19.195.159]) by mail.gmx.com
 (mrgmx005 [212.227.17.184]) with ESMTPSA (Nemesis) id
 1MJE2D-1jdKH13eW3-00Kh4u; Fri, 03 Apr 2020 20:00:13 +0200
From:   Alex Dewar <alex.dewar@gmx.co.uk>
To:     alex.dewar@gmx.co.uk
Cc:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>, hmadhani@marvell.com,
        Richard Fontana <rfontana@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH] scsi: Remove unnecessary calls to memset after dma_alloc_coherent
Date:   Fri,  3 Apr 2020 18:58:31 +0100
Message-Id: <20200403175833.75531-1-alex.dewar@gmx.co.uk>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:4e0hss2WvUtGvqI6hihTHQD31nPnYyhd89b8wK7pKoryL/adcEt
 6pdz8+sBlgHz9nSKLFo0Ab0ta5asxTfZOS9bWSi3Az4mFykjCHOp+CaIBCYAvi/LV041ebg
 AtXqqLoNevsfl1b+Ij/Nk8mc744/EaKXE1qgxyksZ92gvlOYLNnhIjOKx5Eky0w67C7sq7a
 DP/CA4gD+ZgdjSuY+pCLg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:TLR6dvnJRsE=:lH4axejOc/j/AftKiGcj2t
 OMVwogUgzlkx3fy5cFFgqt6hMWaeqIZquYz4Nnac9baA+f8ILi4piZf9h+lbloReG0sGMXgk0
 mVoQydCpt8OD1eZibURPufYdKF7e2fbepOF0wpkZvV0cb3mc1zx7qPONnLIaU36wJyIvHdIXD
 WEWbGG3lJtEZoljI7ImnYj43pbQYAJZzvSNao378kHYsfp+I4ST2qb29o3O9s++CzOPSmOU/y
 Q1rflX6iAwpLI/RDlTmY7LdBz8Xtc0suyrKlnfLu5u07bTdyIzPPJqLhN9lb7fuGeMidDvXeg
 +NkdTRYIaQWJIAuZEd4eZlLvs4N4Tp/I64ptTKBP//HGCa/ud3ncDm/EFCc4IiErarV2kG+wj
 Am9zNQiexMTbxQIFPJhP3DHBrsK6j8o363AqZj5lV7nO3cNChgYtc3okTnTgJTJ46//Xs1E/+
 vM3RMALBXjq2phSyX+bg46V68UVpirTm0Yf5/W7NJloaniSBM5YVmMMCcgdV0XzkS1ELXhp23
 liyr7mcYnH4KJ6qT1yccUUbjOjNkOFvkbCB4n1DMYj3OD8k9MsuWAaBDHWlPHJ/dUUQQnWVIS
 /oTCceqFwkuglS2Apzz9brTLli+pWmC8tzPxApJ44U6XPYJJsIzR3XVfQzjsAdMt4eGgNOAxR
 /wqAnYSLiM9D0kitvd6VGAwSdzoiGY3kD0YsOZFE/pNTThI9rfsoifz7piDIxas3rxaWZHMwU
 NFH8C+XQADr6W+JA/bI9PfPXbydLOJ70j6gL9/F9qfST4G22f/sWrcYweQg9TDpq3St3ChiKu
 0KXH9Is9EbYOPjhSll6XstSm/9wSHSBT5CZCmc72H1BRainYxhYVQyVKfJAJIc1SpvfvcqrRG
 Gn2dM7F7AzeXhw46qp0gMtppPFhPh87tjJioaw+Zc0EiOlwmj56hhT1h1tJM4o3tiZ+cDUuh6
 gsBfXcCgRy/aKV4+vArvUgfWniUEEmu+MAuDyNkcXYXwqRO+7np0XLcU0HTt0Q1MRdV7upZNI
 9yP7OzSTVWT6ifKoB+YJ/MkUqI7IeTIWQpMniPj5yJPdYs6UiuTPLWBUL4Ydyr03Ih/vYEGhj
 gN4THGGksOi/KcH48Xi7ixzRvZ7WDTpbtSriCkL8mFly+E7G1sBqtyUHZKPpoBKqyz1JWPrzP
 ZL4qlKL6SijbQeKLPNIlX9SXFR6gz4kRD9SlUkmmQSa5GNSs8PzQI01UGvNbuT3KFiGQ408GA
 mSE8KLAtVHYmGsoOJ
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

dma_alloc_coherent() now zeroes memory after allocation, so additional
calls to memset() afterwards are unnecessary. Remove them.

Issue identified with Coccinelle.

Signed-off-by: Alex Dewar <alex.dewar@gmx.co.uk>
=2D--
 drivers/scsi/dpt_i2o.c              | 8 ++------
 drivers/scsi/mpt3sas/mpt3sas_base.c | 3 +--
 drivers/scsi/mvsas/mv_init.c        | 8 +-------
 drivers/scsi/pmcraid.c              | 1 -
 drivers/scsi/qla2xxx/qla_isr.c      | 3 +--
 drivers/scsi/qla2xxx/qla_mbx.c      | 4 +---
 6 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 02dff3a684e0..3daf274f85c3 100644
=2D-- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -1331,7 +1331,6 @@ static s32 adpt_i2o_reset_hba(adpt_hba* pHba)
 		printk(KERN_ERR"IOP reset failed - no free memory.\n");
 		return -ENOMEM;
 	}
-	memset(status,0,4);

 	msg[0]=3DEIGHT_WORD_MSG_SIZE|SGL_OFFSET_0;
 	msg[1]=3DI2O_CMD_ADAPTER_RESET<<24|HOST_TID<<12|ADAPTER_TID;
@@ -2784,7 +2783,6 @@ static s32 adpt_i2o_init_outbound_q(adpt_hba* pHba)
 			pHba->name);
 		return -ENOMEM;
 	}
-	memset(status, 0, 4);

 	writel(EIGHT_WORD_MSG_SIZE| SGL_OFFSET_6, &msg[0]);
 	writel(I2O_CMD_OUTBOUND_INIT<<24 | HOST_TID<<12 | ADAPTER_TID, &msg[1]);
@@ -2838,7 +2836,6 @@ static s32 adpt_i2o_init_outbound_q(adpt_hba* pHba)
 		printk(KERN_ERR "%s: Could not allocate reply pool\n", pHba->name);
 		return -ENOMEM;
 	}
-	memset(pHba->reply_pool, 0 , pHba->reply_fifo_size * REPLY_FRAME_SIZE * =
4);

 	for(i =3D 0; i < pHba->reply_fifo_size; i++) {
 		writel(pHba->reply_pool_pa + (i * REPLY_FRAME_SIZE * 4),
@@ -3067,13 +3064,12 @@ static int adpt_i2o_build_sys_table(void)
 	sys_tbl_len =3D sizeof(struct i2o_sys_tbl) +	// Header + IOPs
 				(hba_count) * sizeof(struct i2o_sys_tbl_entry);

-	sys_tbl =3D dma_alloc_coherent(&pHba->pDev->dev,
-				sys_tbl_len, &sys_tbl_pa, GFP_KERNEL);
+	sys_tbl =3D dma_alloc_coherent(&pHba->pDev->dev, sys_tbl_len,
+				     &sys_tbl_pa, GFP_KERNEL);
 	if (!sys_tbl) {
 		printk(KERN_WARNING "SysTab Set failed. Out of memory.\n");
 		return -ENOMEM;
 	}
-	memset(sys_tbl, 0, sys_tbl_len);

 	sys_tbl->num_entries =3D hba_count;
 	sys_tbl->version =3D I2OVERSION;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mp=
t3sas_base.c
index 663782bb790d..6144c0910b90 100644
=2D-- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5203,7 +5203,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *=
ioc)

 	ioc->request_dma_sz =3D sz;
 	ioc->request =3D dma_alloc_coherent(&ioc->pdev->dev, sz,
-			&ioc->request_dma, GFP_KERNEL);
+					  &ioc->request_dma, GFP_KERNEL);
 	if (!ioc->request) {
 		ioc_err(ioc, "request pool: dma_alloc_coherent failed: hba_depth(%d), c=
hains_per_io(%d), frame_sz(%d), total(%d kB)\n",
 			ioc->hba_queue_depth, ioc->chains_needed_per_io,
@@ -5215,7 +5215,6 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *=
ioc)
 		_base_release_memory_pools(ioc);
 		goto retry_allocation;
 	}
-	memset(ioc->request, 0, sz);

 	if (retry_sz)
 		ioc_err(ioc, "request pool: dma_alloc_coherent succeed: hba_depth(%d), =
chains_per_io(%d), frame_sz(%d), total(%d kb)\n",
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 7af9173c4925..75c9fc37a388 100644
=2D-- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -244,28 +244,22 @@ static int mvs_alloc(struct mvs_info *mvi, struct Sc=
si_Host *shost)
 				     &mvi->tx_dma, GFP_KERNEL);
 	if (!mvi->tx)
 		goto err_out;
-	memset(mvi->tx, 0, sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ);
 	mvi->rx_fis =3D dma_alloc_coherent(mvi->dev, MVS_RX_FISL_SZ,
 					 &mvi->rx_fis_dma, GFP_KERNEL);
 	if (!mvi->rx_fis)
 		goto err_out;
-	memset(mvi->rx_fis, 0, MVS_RX_FISL_SZ);
-
 	mvi->rx =3D dma_alloc_coherent(mvi->dev,
 				     sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1),
 				     &mvi->rx_dma, GFP_KERNEL);
 	if (!mvi->rx)
 		goto err_out;
-	memset(mvi->rx, 0, sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1));
 	mvi->rx[0] =3D cpu_to_le32(0xfff);
 	mvi->rx_cons =3D 0xfff;

-	mvi->slot =3D dma_alloc_coherent(mvi->dev,
-				       sizeof(*mvi->slot) * slot_nr,
+	mvi->slot =3D dma_alloc_coherent(mvi->dev, sizeof(*mvi->slot) * slot_nr,
 				       &mvi->slot_dma, GFP_KERNEL);
 	if (!mvi->slot)
 		goto err_out;
-	memset(mvi->slot, 0, sizeof(*mvi->slot) * slot_nr);

 	mvi->bulk_buffer =3D dma_alloc_coherent(mvi->dev,
 				       TRASH_BUCKET_SIZE,
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 7eb88fe1eb0b..6976013cf4c7 100644
=2D-- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4718,7 +4718,6 @@ static int pmcraid_allocate_host_rrqs(struct pmcraid=
_instance *pinstance)
 			return -ENOMEM;
 		}

-		memset(pinstance->hrrq_start[i], 0, buffer_size);
 		pinstance->hrrq_curr[i] =3D pinstance->hrrq_start[i];
 		pinstance->hrrq_end[i] =3D
 			pinstance->hrrq_start[i] + PMCRAID_MAX_CMD - 1;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr=
.c
index 8d7a905f6247..632fd56cb626 100644
=2D-- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -79,7 +79,7 @@ qla24xx_process_abts(struct scsi_qla_host *vha, void *pk=
t)
 	    (uint8_t *)abts, sizeof(*abts));

 	rsp_els =3D dma_alloc_coherent(&ha->pdev->dev, sizeof(*rsp_els), &dma,
-	    GFP_KERNEL);
+				     GFP_KERNEL);
 	if (!rsp_els) {
 		ql_log(ql_log_warn, vha, 0x0287,
 		    "Failed allocate dma buffer ABTS/ELS RSP.\n");
@@ -87,7 +87,6 @@ qla24xx_process_abts(struct scsi_qla_host *vha, void *pk=
t)
 	}

 	/* terminate exchange */
-	memset(rsp_els, 0, sizeof(*rsp_els));
 	rsp_els->entry_type =3D ELS_IOCB_TYPE;
 	rsp_els->entry_count =3D 1;
 	rsp_els->nport_handle =3D ~0;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx=
.c
index 9fd83d1bffe0..6d8573b870bc 100644
=2D-- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4887,15 +4887,13 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *vh=
a)
 	    "Entered %s.\n", __func__);

 	els_cmd_map =3D dma_alloc_coherent(&ha->pdev->dev, ELS_CMD_MAP_SIZE,
-	    &els_cmd_map_dma, GFP_KERNEL);
+					 &els_cmd_map_dma, GFP_KERNEL);
 	if (!els_cmd_map) {
 		ql_log(ql_log_warn, vha, 0x7101,
 		    "Failed to allocate RDP els command param.\n");
 		return QLA_MEMORY_ALLOC_FAILED;
 	}

-	memset(els_cmd_map, 0, ELS_CMD_MAP_SIZE);
-
 	els_cmd_map[index] |=3D 1 << bit;

 	mcp->mb[0] =3D MBC_SET_RNID_PARAMS;
=2D-
2.26.0

