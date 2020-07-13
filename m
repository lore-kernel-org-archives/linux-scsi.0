Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E77C433E4
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 10:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26CD820758
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 10:50:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Dvf24ZD3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729424AbgGMKuI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 06:50:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36988 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729191AbgGMKuH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 06:50:07 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200713105002epoutp0346304129ac6ba899e62b0dd42c6cf647~hSkTEiUVu0947309473epoutp03T
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 10:50:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200713105002epoutp0346304129ac6ba899e62b0dd42c6cf647~hSkTEiUVu0947309473epoutp03T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594637402;
        bh=n6OwJXD4e+r8+Gfsq7aGFUJzvBb2DqAwqgmP/cYN2Bg=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=Dvf24ZD34sAF+uY1S626k2NHss2ppIaFP8cIgRC+8kVL3UfFAx46EY8D1BGrP/XpT
         hWiVzKkqih9vVLdSyssyoM7rO1s+yEvxYiTRX1tq+P8scAbrJJ9T3o19IyQ8s6ghU8
         EvxXgztZ7trmuO9y6xhkqeBY+zLuxUwi2ZZNglc8=
Received: from epcpadp1 (unknown [182.195.40.11]) by epcas1p1.samsung.com
        (KnoxPortal) with ESMTP id
        20200713105001epcas1p1be289603d505a7758fcf648cc6715f08~hSkSjEUj41265212652epcas1p1i;
        Mon, 13 Jul 2020 10:50:01 +0000 (GMT)
Mime-Version: 1.0
Subject: [PATCH v6 2/5] scsi: ufs: Add UFS-feature layer
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Daejun Park <daejun7.park@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <231786897.01594636801601.JavaMail.epsvc@epcpadp1>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <231786897.01594637401708.JavaMail.epsvc@epcpadp1>
Date:   Mon, 13 Jul 2020 19:40:40 +0900
X-CMS-MailID: 20200713104040epcms2p4b21deebc0eb2678c4d873d641103c705
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8
References: <231786897.01594636801601.JavaMail.epsvc@epcpadp1>
        <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
        <CGME20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8@epcms2p4>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch is adding UFS feature layer to UFS core driver.

UFS Driver data structure (struct ufs_hba)
=09=E2=94=82
=E2=94=8C--------------=E2=94=90
=E2=94=82 UFS feature  =E2=94=82 <-- HPB module
=E2=94=82    layer     =E2=94=82 <-- other extended feature module
=E2=94=94--------------=E2=94=98
Each extended UFS-Feature module has a bus of ufs-ext feature type.
The UFS feature layer manages common APIs used by each extended feature
module. The APIs are set of UFS Query requests and UFS Vendor commands
related to each extended feature module.

Other extended features can also be implemented using the proposed APIs.
For example, in Write Booster, "prep_fn" can be used to guarantee the
lifetime of UFS by updating the amount of write IO.
And reset/reset_host/suspend/resume can be used to manage the kernel task
for checking lifetime of UFS.

The following 6 callback functions have been added to "ufshcd.c".
prep_fn: called after construct upiu structure
reset: called after proving hba
reset_host: called before ufshcd_host_reset_and_restore
suspend: called before ufshcd_suspend
resume: called after ufshcd_resume
rsp_upiu: called in ufshcd_transfer_rsp_status with SAM_STAT_GOOD state

Tested-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/Makefile     |   2 +-
 drivers/scsi/ufs/ufsfeature.c | 148 ++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufsfeature.h |  69 ++++++++++++++++
 drivers/scsi/ufs/ufshcd.c     |  17 ++++
 drivers/scsi/ufs/ufshcd.h     |   2 +
 5 files changed, 237 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/ufs/ufsfeature.c
 create mode 100644 drivers/scsi/ufs/ufsfeature.h

diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 9810963bc049..1e4967e076b5 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -6,7 +6,7 @@ obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) +=3D cdns-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_QCOM) +=3D ufs-qcom.o
 obj-$(CONFIG_SCSI_UFS_EXYNOS) +=3D ufs-exynos.o
 obj-$(CONFIG_SCSI_UFSHCD) +=3D ufshcd-core.o
-ufshcd-core-y=09=09=09=09+=3D ufshcd.o ufs-sysfs.o
+ufshcd-core-y=09=09=09=09+=3D ufshcd.o ufs-sysfs.o ufsfeature.o
 ufshcd-core-$(CONFIG_SCSI_UFS_BSG)=09+=3D ufs_bsg.o
 ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO) +=3D ufshcd-crypto.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) +=3D ufshcd-pci.o
diff --git a/drivers/scsi/ufs/ufsfeature.c b/drivers/scsi/ufs/ufsfeature.c
new file mode 100644
index 000000000000..94c6be6babd3
--- /dev/null
+++ b/drivers/scsi/ufs/ufsfeature.c
@@ -0,0 +1,148 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Universal Flash Storage Feature Support
+ *
+ * Copyright (C) 2017-2018 Samsung Electronics Co., Ltd.
+ *
+ * Authors:
+ *=09Yongmyung Lee <ymhungry.lee@samsung.com>
+ *=09Jinyoung Choi <j-young.choi@samsung.com>
+ */
+
+#include "ufshcd.h"
+#include "ufsfeature.h"
+
+inline void ufsf_slave_configure(struct ufs_hba *hba,
+=09=09=09=09 struct scsi_device *sdev)
+{
+=09/* skip well-known LU */
+=09if (sdev->lun >=3D UFS_UPIU_MAX_UNIT_NUM_ID)
+=09=09return;
+
+=09if (!(hba->dev_info.b_ufs_feature_sup & UFS_DEV_HPB_SUPPORT))
+=09=09return;
+
+=09atomic_inc(&hba->ufsf.slave_conf_cnt);
+
+=09wake_up(&hba->ufsf.sdev_wait);
+}
+
+inline void ufsf_ops_prep_fn(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+{
+=09struct ufshpb_driver *ufshpb_drv;
+
+=09ufshpb_drv =3D dev_get_drvdata(&hba->ufsf.hpb_dev);
+
+=09if (ufshpb_drv && ufshpb_drv->ufshpb_ops.prep_fn)
+=09=09ufshpb_drv->ufshpb_ops.prep_fn(hba, lrbp);
+}
+
+inline void ufsf_ops_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp=
)
+{
+=09struct ufshpb_driver *ufshpb_drv;
+
+=09ufshpb_drv =3D dev_get_drvdata(&hba->ufsf.hpb_dev);
+
+=09if (ufshpb_drv && ufshpb_drv->ufshpb_ops.rsp_upiu)
+=09=09ufshpb_drv->ufshpb_ops.rsp_upiu(hba, lrbp);
+}
+
+inline void ufsf_ops_reset_host(struct ufs_hba *hba)
+{
+=09struct ufshpb_driver *ufshpb_drv;
+
+=09ufshpb_drv =3D dev_get_drvdata(&hba->ufsf.hpb_dev);
+
+=09if (ufshpb_drv && ufshpb_drv->ufshpb_ops.reset_host)
+=09=09ufshpb_drv->ufshpb_ops.reset_host(hba);
+}
+
+inline void ufsf_ops_reset(struct ufs_hba *hba)
+{
+=09struct ufshpb_driver *ufshpb_drv;
+
+=09ufshpb_drv =3D dev_get_drvdata(&hba->ufsf.hpb_dev);
+
+=09if (ufshpb_drv && ufshpb_drv->ufshpb_ops.reset)
+=09=09ufshpb_drv->ufshpb_ops.reset(hba);
+}
+
+inline void ufsf_ops_suspend(struct ufs_hba *hba)
+{
+=09struct ufshpb_driver *ufshpb_drv;
+
+=09ufshpb_drv =3D dev_get_drvdata(&hba->ufsf.hpb_dev);
+
+=09if (ufshpb_drv && ufshpb_drv->ufshpb_ops.suspend)
+=09=09ufshpb_drv->ufshpb_ops.suspend(hba);
+}
+
+inline void ufsf_ops_resume(struct ufs_hba *hba)
+{
+=09struct ufshpb_driver *ufshpb_drv;
+
+=09ufshpb_drv =3D dev_get_drvdata(&hba->ufsf.hpb_dev);
+
+=09if (ufshpb_drv && ufshpb_drv->ufshpb_ops.resume)
+=09=09ufshpb_drv->ufshpb_ops.resume(hba);
+}
+
+struct device_type ufshpb_dev_type =3D {
+=09.name =3D "ufshpb_device"
+};
+EXPORT_SYMBOL(ufshpb_dev_type);
+
+static int ufsf_bus_match(struct device *dev,
+=09=09=09 struct device_driver *gendrv)
+{
+=09if (dev->type =3D=3D &ufshpb_dev_type)
+=09=09return 1;
+
+=09return 0;
+}
+
+struct bus_type ufsf_bus_type =3D {
+=09.name =3D "ufsf_bus",
+=09.match =3D ufsf_bus_match,
+};
+EXPORT_SYMBOL(ufsf_bus_type);
+
+static void ufsf_dev_release(struct device *dev)
+{
+=09put_device(dev->parent);
+}
+
+void ufsf_scan_features(struct ufs_hba *hba)
+{
+=09int ret;
+
+=09init_waitqueue_head(&hba->ufsf.sdev_wait);
+=09atomic_set(&hba->ufsf.slave_conf_cnt, 0);
+
+=09if (hba->dev_info.wspecversion >=3D HPB_SUPPORTED_VERSION &&
+=09    (hba->dev_info.b_ufs_feature_sup & UFS_DEV_HPB_SUPPORT)) {
+=09=09device_initialize(&hba->ufsf.hpb_dev);
+
+=09=09hba->ufsf.hpb_dev.bus =3D &ufsf_bus_type;
+=09=09hba->ufsf.hpb_dev.type =3D &ufshpb_dev_type;
+=09=09hba->ufsf.hpb_dev.parent =3D get_device(hba->dev);
+=09=09hba->ufsf.hpb_dev.release =3D ufsf_dev_release;
+
+=09=09dev_set_name(&hba->ufsf.hpb_dev, "ufshpb");
+=09=09ret =3D device_add(&hba->ufsf.hpb_dev);
+=09=09if (ret)
+=09=09=09dev_warn(hba->dev, "ufshpb: failed to add device\n");
+=09}
+}
+
+static int __init ufsf_init(void)
+{
+=09int ret;
+
+=09ret =3D bus_register(&ufsf_bus_type);
+=09if (ret)
+=09=09pr_err("%s bus_register failed\n", __func__);
+
+=09return ret;
+}
+device_initcall(ufsf_init);
diff --git a/drivers/scsi/ufs/ufsfeature.h b/drivers/scsi/ufs/ufsfeature.h
new file mode 100644
index 000000000000..1822d9d8e745
--- /dev/null
+++ b/drivers/scsi/ufs/ufsfeature.h
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Universal Flash Storage Feature Support
+ *
+ * Copyright (C) 2017-2018 Samsung Electronics Co., Ltd.
+ *
+ * Authors:
+ *=09Yongmyung Lee <ymhungry.lee@samsung.com>
+ *=09Jinyoung Choi <j-young.choi@samsung.com>
+ */
+
+#ifndef _UFSFEATURE_H_
+#define _UFSFEATURE_H_
+
+#define HPB_SUPPORTED_VERSION=09=09=090x0310
+
+struct ufs_hba;
+struct ufshcd_lrb;
+
+/**
+ * struct ufsf_operation - UFS feature specific callbacks
+ * @prep_fn: called after construct upiu structure. The prep_fn should wor=
k
+ *=09     properly even if it processes the same SCSI command multiple
+ *=09     times by requeuing.
+ * @reset: called after probing hba
+ * @reset_host: called before ufshcd_host_reset_and_restore
+ * @suspend: called before ufshcd_suspend
+ * @resume: called after ufshcd_resume
+ * @rsp_upiu: called in ufshcd_transfer_rsp_status with SAM_STAT_GOOD stat=
e
+ */
+struct ufsf_operation {
+=09void (*prep_fn)(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
+=09void (*reset)(struct ufs_hba *hba);
+=09void (*reset_host)(struct ufs_hba *hba);
+=09void (*suspend)(struct ufs_hba *hba);
+=09void (*resume)(struct ufs_hba *hba);
+=09void (*rsp_upiu)(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
+};
+
+struct ufshpb_driver {
+=09struct device_driver drv;
+=09struct list_head lh_hpb_lu;
+
+=09struct ufsf_operation ufshpb_ops;
+
+=09/* memory management */
+=09struct kmem_cache *ufshpb_mctx_cache;
+=09mempool_t *ufshpb_mctx_pool;
+=09mempool_t *ufshpb_page_pool;
+
+=09struct workqueue_struct *ufshpb_wq;
+};
+
+struct ufsf_feature_info {
+=09atomic_t slave_conf_cnt;
+=09wait_queue_head_t sdev_wait;
+=09struct device hpb_dev;
+};
+
+void ufsf_slave_configure(struct ufs_hba *hba, struct scsi_device *sdev);
+void ufsf_scan_features(struct ufs_hba *hba);
+void ufsf_ops_prep_fn(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
+void ufsf_ops_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
+void ufsf_ops_reset_host(struct ufs_hba *hba);
+void ufsf_ops_reset(struct ufs_hba *hba);
+void ufsf_ops_suspend(struct ufs_hba *hba);
+void ufsf_ops_resume(struct ufs_hba *hba);
+
+#endif /* End of Header */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index efc0a6cbfe22..3e652747e635 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2556,6 +2556,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host=
, struct scsi_cmnd *cmd)
=20
 =09ufshcd_comp_scsi_upiu(hba, lrbp);
=20
+=09ufsf_ops_prep_fn(hba, lrbp);
+
 =09err =3D ufshcd_map_sg(hba, lrbp);
 =09if (err) {
 =09=09lrbp->cmd =3D NULL;
@@ -4689,6 +4691,8 @@ static int ufshcd_slave_configure(struct scsi_device =
*sdev)
 =09struct ufs_hba *hba =3D shost_priv(sdev->host);
 =09struct request_queue *q =3D sdev->request_queue;
=20
+=09ufsf_slave_configure(hba, sdev);
+
 =09blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
=20
 =09if (ufshcd_is_rpm_autosuspend_allowed(hba))
@@ -4817,6 +4821,9 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struc=
t ufshcd_lrb *lrbp)
 =09=09=09=09 */
 =09=09=09=09pm_runtime_get_noresume(hba->dev);
 =09=09=09}
+
+=09=09=09if (scsi_status =3D=3D SAM_STAT_GOOD)
+=09=09=09=09ufsf_ops_rsp_upiu(hba, lrbp);
 =09=09=09break;
 =09=09case UPIU_TRANSACTION_REJECT_UPIU:
 =09=09=09/* TODO: handle Reject UPIU Response */
@@ -6569,6 +6576,8 @@ static int ufshcd_host_reset_and_restore(struct ufs_h=
ba *hba)
 =09 * Stop the host controller and complete the requests
 =09 * cleared by h/w
 =09 */
+=09ufsf_ops_reset_host(hba);
+
 =09ufshcd_hba_stop(hba);
=20
 =09spin_lock_irqsave(hba->host->host_lock, flags);
@@ -7003,6 +7012,7 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 =09/* getting Specification Version in big endian format */
 =09dev_info->wspecversion =3D desc_buf[DEVICE_DESC_PARAM_SPEC_VER] << 8 |
 =09=09=09=09      desc_buf[DEVICE_DESC_PARAM_SPEC_VER + 1];
+=09dev_info->b_ufs_feature_sup =3D desc_buf[DEVICE_DESC_PARAM_UFS_FEAT];
=20
 =09model_index =3D desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
=20
@@ -7373,6 +7383,7 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 =09}
=20
 =09ufs_bsg_probe(hba);
+=09ufsf_scan_features(hba);
 =09scsi_scan_host(hba->host);
 =09pm_runtime_put_sync(hba->dev);
=20
@@ -7461,6 +7472,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool=
 async)
 =09/* Enable Auto-Hibernate if configured */
 =09ufshcd_auto_hibern8_enable(hba);
=20
+=09ufsf_ops_reset(hba);
 out:
=20
 =09trace_ufshcd_init(dev_name(hba->dev), ret,
@@ -8218,6 +8230,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum u=
fs_pm_op pm_op)
 =09=09req_link_state =3D UIC_LINK_OFF_STATE;
 =09}
=20
+=09ufsf_ops_suspend(hba);
+
 =09/*
 =09 * If we can't transition into any of the low power modes
 =09 * just gate the clocks.
@@ -8339,6 +8353,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum u=
fs_pm_op pm_op)
 =09hba->clk_gating.is_suspended =3D false;
 =09hba->dev_info.b_rpm_dev_flush_capable =3D false;
 =09ufshcd_release(hba);
+=09ufsf_ops_resume(hba);
 out:
 =09if (hba->dev_info.b_rpm_dev_flush_capable) {
 =09=09schedule_delayed_work(&hba->rpm_dev_flush_recheck_work,
@@ -8435,6 +8450,8 @@ static int ufshcd_resume(struct ufs_hba *hba, enum uf=
s_pm_op pm_op)
 =09/* Enable Auto-Hibernate if configured */
 =09ufshcd_auto_hibern8_enable(hba);
=20
+=09ufsf_ops_resume(hba);
+
 =09if (hba->dev_info.b_rpm_dev_flush_capable) {
 =09=09hba->dev_info.b_rpm_dev_flush_capable =3D false;
 =09=09cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 656c0691c858..6d70d4678632 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -47,6 +47,7 @@
 #include "ufs.h"
 #include "ufs_quirks.h"
 #include "ufshci.h"
+#include "ufsfeature.h"
=20
 #define UFSHCD "ufshcd"
 #define UFSHCD_DRIVER_VERSION "0.2"
@@ -754,6 +755,7 @@ struct ufs_hba {
 =09bool wb_enabled;
 =09struct delayed_work rpm_dev_flush_recheck_work;
=20
+=09struct ufsf_feature_info ufsf;
 #ifdef CONFIG_SCSI_UFS_CRYPTO
 =09union ufs_crypto_capabilities crypto_capabilities;
 =09union ufs_crypto_cap_entry *crypto_cap_array;
--=20
2.17.1


