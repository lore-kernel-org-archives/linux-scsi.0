Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFFF6C48BDF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 02:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96ED361357
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 02:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhFKC0o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 22:26:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23185 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbhFKC0o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 22:26:44 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210611022445epoutp04492e0a9370cc7a6a47ac43cc4b428c9c~HZfMwLO3J2777027770epoutp04Y
        for <linux-scsi@vger.kernel.org>; Fri, 11 Jun 2021 02:24:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210611022445epoutp04492e0a9370cc7a6a47ac43cc4b428c9c~HZfMwLO3J2777027770epoutp04Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1623378285;
        bh=mDjdAKSBgTj3iOY/FKLdno+bH8g0obADXYAyqRqQOqY=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=Gc6Eo/iWxV3NmoWO4NYvXC1k9ldAI3RpFnDffjf9688RG467uIbcfIFCkCrkstmDR
         rDAcub4+anwdLoCGIw4aWG5ndqxI0f/nqUMO/yFA3YGbgeDS2/JV4f6eOZhk6AVh3f
         1yDD4T+/P282wB9Z/VKpK0k66+XBcMmPyDdpfKBU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210611022444epcas2p24afe100eabdcaebcba3c4c46fc30dadd~HZfL1hpWr2090720907epcas2p2T;
        Fri, 11 Jun 2021 02:24:44 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.188]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4G1Pn65fnGz4x9QH; Fri, 11 Jun
        2021 02:24:42 +0000 (GMT)
X-AuditID: b6c32a47-f4bff700000024d9-06-60c2c96a6b5c
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        8B.4E.09433.A69C2C06; Fri, 11 Jun 2021 11:24:42 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v37 4/4] scsi: ufs: Add HPB 2.0 support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210611022142epcms2p374ea5b82cfe122de69a7fefe27edf856@epcms2p3>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210611022442epcms2p49f44cb8531f78be643e93b5768894f43@epcms2p4>
Date:   Fri, 11 Jun 2021 11:24:42 +0900
X-CMS-MailID: 20210611022442epcms2p49f44cb8531f78be643e93b5768894f43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJsWRmVeSWpSXmKPExsWy7bCmqW7WyUMJBjfWalk8mLeNzWJv2wl2
        i5c/r7JZTPvwk9ni0/plrBYvD2la7Dp4kM1i1YNwi+bF69ks5pxtYLLo7d/KZrH54AZmi8d3
        PrNbLLqxjcmi/187i8W2z4IWx0++Y7S4vGsOm0X39R1sFsuP/2OyWLr1JqNF5/Q1LA5iHpev
        eHtc7utl8tg56y67x4RFBxg99s9dw+7RcnI/i8fHp7dYPPq2rGL0+LxJzqP9QDdTAFdUjk1G
        amJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0JtKCmWJOaVA
        oYDE4mIlfTubovzSklSFjPziElul1IKUnAJDwwK94sTc4tK8dL3k/FwrQwMDI1OgyoScjLZj
        /AU/tjNVrNl6gbWB8dI/xi5GTg4JAROJxWufMXUxcnEICexglDjYvoK1i5GDg1dAUOLvDmGQ
        GmEBc4nH34+zgNhCAkoS6y/OYoeI60ncergGbA6bgI7E9BP32UHmiAi0skgsOrscbCizwHlm
        iT032qG28UrMaH/KAmFLS2xfvhUszingJ/Fg5hyoGg2JH8t6mSFsUYmbq9+yw9jvj82HqhGR
        aL13FqpGUOLBz91QcUmJY7s/MEHY9RJb7/xiBDlCQqCHUeLwzlusEAl9iWsdG1kgvvSVONWY
        AhJmEVCV+HhjH1hYQsBF4uylLJAws4C8xPa3c5hBwswCmhLrd+lDVChLHLnFAvNUw8bf7Ohs
        ZgE+iY7Df+HiO+Y9gTpMTWLdz/VMExiVZyECehaSXbMQdi1gZF7FKJZaUJybnlpsVGCMHLmb
        GMFJXst9B+OMtx/0DjEycTAeYpTgYFYS4d258lCCEG9KYmVValF+fFFpTmrxIUZToCcnMkuJ
        JucD80xeSbyhqZGZmYGlqYWpmZGFkjgvBztQk0B6YklqdmpqQWoRTB8TB6dUA5PBVe+AReZl
        l92OvjXjXCu3cvvXxrSLUx8UvGkJiLCdUbMkvPV8k+fkTSuO9Wyxj3y5yn+Lfe6VORPm35G5
        +rhxrtcD//xW8xvGwn+Nt7Jd1ZX6W9Oqudn21Set2guLhTS6leaec1RxFd6Q8k1YdoLdhdl/
        T8bcer9G47tvj2eHgjyLwqGFNztyZryOjuGc+emL/XzFxVMeyElKmxlzORv5eS4qf3xDd93e
        P+cvHzWeViL2Yspbp7iXHLWKp/4dehj16M071ZpVd28JHLrvrGIqsHvZ5Wj9VUl3vGpvXJmq
        2KwU7PZUM6WHX5xj5nkJ8ytaeh/aZjac6fk/4fO6z+l5sTpJd1XKjsiUbxFTfi+jxFKckWio
        xVxUnAgAl0kmZXsEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210611022142epcms2p374ea5b82cfe122de69a7fefe27edf856
References: <20210611022142epcms2p374ea5b82cfe122de69a7fefe27edf856@epcms2p3>
        <CGME20210611022142epcms2p374ea5b82cfe122de69a7fefe27edf856@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch supports the HPB 2.0.

The HPB 2.0 supports read of varying sizes from 4KB to 512KB.
In the case of Read (<= 32KB) is supported as single HPB read.
In the case of Read (36KB ~ 512KB) is supported by as a combination of
write buffer command and HPB read command to deliver more PPN.
The write buffer commands may not be issued immediately due to busy tags.
To use HPB read more aggressively, the driver can requeue the write buffer
command. The requeue threshold is implemented as timeout and can be
modified with requeue_timeout_ms entry in sysfs.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Tested-by: Can Guo <cang@codeaurora.org>
Tested-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs |  35 ++
 drivers/scsi/ufs/ufs-sysfs.c               |   4 +
 drivers/scsi/ufs/ufs.h                     |   3 +-
 drivers/scsi/ufs/ufshcd.c                  |  25 +-
 drivers/scsi/ufs/ufshcd.h                  |   7 +
 drivers/scsi/ufs/ufshpb.c                  | 615 +++++++++++++++++++--
 drivers/scsi/ufs/ufshpb.h                  |  67 ++-
 7 files changed, 682 insertions(+), 74 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index c3d80bd15f74..d001f008312b 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1425,3 +1425,38 @@ Description:	This entry shows the number of read buffer commands for
 		activating sub-regions recommended by response UPIUs.
 
 		The file is read only.
+
+What:		/sys/class/scsi_device/*/device/hpb_params/requeue_timeout_ms
+Date:		June 2021
+Contact:	Daejun Park <daejun7.park@samsung.com>
+Description:	This entry shows the requeue timeout threshold for write buffer
+		command in ms. This value can be changed by writing proper integer to
+		this entry.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/max_data_size_hpb_single_cmd
+Date:		June 2021
+Contact:	Daejun Park <daejun7.park@samsung.com>
+Description:	This entry shows the maximum HPB data size for using single HPB
+		command.
+
+		===  ========
+		00h  4KB
+		01h  8KB
+		02h  12KB
+		...
+		FFh  1024KB
+		===  ========
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/flags/wb_enable
+Date:		June 2021
+Contact:	Daejun Park <daejun7.park@samsung.com>
+Description:	This entry shows the status of HPB.
+
+		== ============================
+		0  HPB is not enabled.
+		1  HPB is enabled
+		== ============================
+
+		The file is read only.
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 639644817f36..08fe037069bc 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -1018,6 +1018,7 @@ UFS_FLAG(disable_fw_update, _PERMANENTLY_DISABLE_FW_UPDATE);
 UFS_FLAG(wb_enable, _WB_EN);
 UFS_FLAG(wb_flush_en, _WB_BUFF_FLUSH_EN);
 UFS_FLAG(wb_flush_during_h8, _WB_BUFF_FLUSH_DURING_HIBERN8);
+UFS_FLAG(hpb_enable, _HPB_EN);
 
 static struct attribute *ufs_sysfs_device_flags[] = {
 	&dev_attr_device_init.attr,
@@ -1031,6 +1032,7 @@ static struct attribute *ufs_sysfs_device_flags[] = {
 	&dev_attr_wb_enable.attr,
 	&dev_attr_wb_flush_en.attr,
 	&dev_attr_wb_flush_during_h8.attr,
+	&dev_attr_hpb_enable.attr,
 	NULL,
 };
 
@@ -1077,6 +1079,7 @@ out:									\
 static DEVICE_ATTR_RO(_name)
 
 UFS_ATTRIBUTE(boot_lun_enabled, _BOOT_LU_EN);
+UFS_ATTRIBUTE(max_data_size_hpb_single_cmd, _MAX_HPB_SINGLE_CMD);
 UFS_ATTRIBUTE(current_power_mode, _POWER_MODE);
 UFS_ATTRIBUTE(active_icc_level, _ACTIVE_ICC_LVL);
 UFS_ATTRIBUTE(ooo_data_enabled, _OOO_DATA_EN);
@@ -1100,6 +1103,7 @@ UFS_ATTRIBUTE(wb_cur_buf, _CURR_WB_BUFF_SIZE);
 
 static struct attribute *ufs_sysfs_attributes[] = {
 	&dev_attr_boot_lun_enabled.attr,
+	&dev_attr_max_data_size_hpb_single_cmd.attr,
 	&dev_attr_current_power_mode.attr,
 	&dev_attr_active_icc_level.attr,
 	&dev_attr_ooo_data_enabled.attr,
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index bfb84d2ba990..8c6b38b1b142 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -123,12 +123,13 @@ enum flag_idn {
 	QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN                 = 0x0F,
 	QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8     = 0x10,
 	QUERY_FLAG_IDN_HPB_RESET                        = 0x11,
+	QUERY_FLAG_IDN_HPB_EN				= 0x12,
 };
 
 /* Attribute idn for Query requests */
 enum attr_idn {
 	QUERY_ATTR_IDN_BOOT_LU_EN		= 0x00,
-	QUERY_ATTR_IDN_RESERVED			= 0x01,
+	QUERY_ATTR_IDN_MAX_HPB_SINGLE_CMD	= 0x01,
 	QUERY_ATTR_IDN_POWER_MODE		= 0x02,
 	QUERY_ATTR_IDN_ACTIVE_ICC_LVL		= 0x03,
 	QUERY_ATTR_IDN_OOO_DATA_EN		= 0x04,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index da96b7c6b108..6c4047fba3c7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2721,7 +2721,12 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	lrbp->req_abort_skip = false;
 
-	ufshpb_prep(hba, lrbp);
+	err = ufshpb_prep(hba, lrbp);
+	if (err == -EAGAIN) {
+		lrbp->cmd = NULL;
+		ufshcd_release(hba);
+		goto out;
+	}
 
 	ufshcd_comp_scsi_upiu(hba, lrbp);
 
@@ -3175,7 +3180,7 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
  *
  * Returns 0 for success, non-zero in case of failure
 */
-static int ufshcd_query_attr_retry(struct ufs_hba *hba,
+int ufshcd_query_attr_retry(struct ufs_hba *hba,
 	enum query_opcode opcode, enum attr_idn idn, u8 index, u8 selector,
 	u32 *attr_val)
 {
@@ -4970,7 +4975,8 @@ static int ufshcd_change_queue_depth(struct scsi_device *sdev, int depth)
 static void ufshcd_hpb_destroy(struct ufs_hba *hba, struct scsi_device *sdev)
 {
 	/* skip well-known LU */
-	if ((sdev->lun >= UFS_UPIU_MAX_UNIT_NUM_ID) || !ufshpb_is_allowed(hba))
+	if ((sdev->lun >= UFS_UPIU_MAX_UNIT_NUM_ID) ||
+	    !(hba->dev_info.hpb_enabled) || !ufshpb_is_allowed(hba))
 		return;
 
 	ufshpb_destroy_lu(hba, sdev);
@@ -7550,8 +7556,18 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 
 	if (dev_info->wspecversion >= UFS_DEV_HPB_SUPPORT_VERSION &&
 	    (b_ufs_feature_sup & UFS_DEV_HPB_SUPPORT)) {
-		dev_info->hpb_enabled = true;
+		bool hpb_en = false;
+
 		ufshpb_get_dev_info(hba, desc_buf);
+
+		if (!ufshpb_is_legacy(hba))
+			err = ufshcd_query_flag_retry(hba,
+						      UPIU_QUERY_OPCODE_READ_FLAG,
+						      QUERY_FLAG_IDN_HPB_EN, 0,
+						      &hpb_en);
+
+		if (ufshpb_is_legacy(hba) || (!err && hpb_en))
+			dev_info->hpb_enabled = true;
 	}
 
 	err = ufshcd_read_string_desc(hba, model_index,
@@ -8130,6 +8146,7 @@ static const struct attribute_group *ufshcd_driver_groups[] = {
 	&ufs_sysfs_lun_attributes_group,
 #ifdef CONFIG_SCSI_UFS_HPB
 	&ufs_sysfs_hpb_stat_group,
+	&ufs_sysfs_hpb_param_group,
 #endif
 	NULL,
 };
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index f99059b31e0a..d768f59900e0 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -652,6 +652,8 @@ struct ufs_hba_variant_params {
  * @srgn_size: device reported HPB sub-region size
  * @slave_conf_cnt: counter to check all lu finished initialization
  * @hpb_disabled: flag to check if HPB is disabled
+ * @max_hpb_single_cmd: device reported bMAX_DATA_SIZE_FOR_SINGLE_CMD value
+ * @is_legacy: flag to check HPB 1.0
  */
 struct ufshpb_dev_info {
 	int num_lu;
@@ -659,6 +661,8 @@ struct ufshpb_dev_info {
 	int srgn_size;
 	atomic_t slave_conf_cnt;
 	bool hpb_disabled;
+	u8 max_hpb_single_cmd;
+	bool is_legacy;
 };
 #endif
 
@@ -1120,6 +1124,9 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 			   u8 param_offset,
 			   u8 *param_read_buf,
 			   u8 param_size);
+int ufshcd_query_attr_retry(struct ufs_hba *hba, enum query_opcode opcode,
+			    enum attr_idn idn, u8 index, u8 selector,
+			    u32 *attr_val);
 int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 		      enum attr_idn idn, u8 index, u8 selector, u32 *attr_val);
 int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 878b34b02826..4e990f8ff1fa 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -31,6 +31,12 @@ bool ufshpb_is_allowed(struct ufs_hba *hba)
 	return !(hba->ufshpb_dev.hpb_disabled);
 }
 
+/* HPB version 1.0 is called as legacy version. */
+bool ufshpb_is_legacy(struct ufs_hba *hba)
+{
+	return hba->ufshpb_dev.is_legacy;
+}
+
 static struct ufshpb_lu *ufshpb_get_hpb_data(struct scsi_device *sdev)
 {
 	return sdev->hostdata;
@@ -64,9 +70,19 @@ static bool ufshpb_is_write_or_discard(struct scsi_cmnd *cmd)
 	       op_is_discard(req_op(cmd->request));
 }
 
-static bool ufshpb_is_supported_chunk(int transfer_len)
+static bool ufshpb_is_supported_chunk(struct ufshpb_lu *hpb, int transfer_len)
 {
-	return transfer_len <= HPB_MULTI_CHUNK_HIGH;
+	return transfer_len <= hpb->pre_req_max_tr_len;
+}
+
+/*
+ * In this driver, WRITE_BUFFER CMD support 36KB (len=9) ~ 1MB (len=256) as
+ * default. It is possible to change range of transfer_len through sysfs.
+ */
+static inline bool ufshpb_is_required_wb(struct ufshpb_lu *hpb, int len)
+{
+	return len > hpb->pre_req_min_tr_len &&
+	       len <= hpb->pre_req_max_tr_len;
 }
 
 static bool ufshpb_is_general_lun(int lun)
@@ -74,8 +90,7 @@ static bool ufshpb_is_general_lun(int lun)
 	return lun < UFS_UPIU_MAX_UNIT_NUM_ID;
 }
 
-static bool
-ufshpb_is_pinned_region(struct ufshpb_lu *hpb, int rgn_idx)
+static bool ufshpb_is_pinned_region(struct ufshpb_lu *hpb, int rgn_idx)
 {
 	if (hpb->lu_pinned_end != PINNED_NOT_SET &&
 	    rgn_idx >= hpb->lu_pinned_start &&
@@ -264,7 +279,7 @@ ufshpb_get_pos_from_lpn(struct ufshpb_lu *hpb, unsigned long lpn, int *rgn_idx,
 
 static void
 ufshpb_set_hpb_read_to_upiu(struct ufshpb_lu *hpb, struct ufshcd_lrb *lrbp,
-			    u32 lpn, __be64 ppn, u8 transfer_len)
+			    u32 lpn, __be64 ppn, u8 transfer_len, int read_id)
 {
 	unsigned char *cdb = lrbp->cmd->cmnd;
 
@@ -273,15 +288,260 @@ ufshpb_set_hpb_read_to_upiu(struct ufshpb_lu *hpb, struct ufshcd_lrb *lrbp,
 	/* ppn value is stored as big-endian in the host memory */
 	memcpy(&cdb[6], &ppn, sizeof(__be64));
 	cdb[14] = transfer_len;
+	cdb[15] = read_id;
 
 	lrbp->cmd->cmd_len = UFS_CDB_SIZE;
 }
 
+static inline void ufshpb_set_write_buf_cmd(unsigned char *cdb,
+					    unsigned long lpn, unsigned int len,
+					    int read_id)
+{
+	cdb[0] = UFSHPB_WRITE_BUFFER;
+	cdb[1] = UFSHPB_WRITE_BUFFER_PREFETCH_ID;
+
+	put_unaligned_be32(lpn, &cdb[2]);
+	cdb[6] = read_id;
+	put_unaligned_be16(len * HPB_ENTRY_SIZE, &cdb[7]);
+
+	cdb[9] = 0x00;	/* Control = 0x00 */
+}
+
+static struct ufshpb_req *ufshpb_get_pre_req(struct ufshpb_lu *hpb)
+{
+	struct ufshpb_req *pre_req;
+
+	if (hpb->num_inflight_pre_req >= hpb->throttle_pre_req) {
+		dev_info(&hpb->sdev_ufs_lu->sdev_dev,
+			 "pre_req throttle. inflight %d throttle %d",
+			 hpb->num_inflight_pre_req, hpb->throttle_pre_req);
+		return NULL;
+	}
+
+	pre_req = list_first_entry_or_null(&hpb->lh_pre_req_free,
+					   struct ufshpb_req, list_req);
+	if (!pre_req) {
+		dev_info(&hpb->sdev_ufs_lu->sdev_dev, "There is no pre_req");
+		return NULL;
+	}
+
+	list_del_init(&pre_req->list_req);
+	hpb->num_inflight_pre_req++;
+
+	return pre_req;
+}
+
+static inline void ufshpb_put_pre_req(struct ufshpb_lu *hpb,
+				      struct ufshpb_req *pre_req)
+{
+	pre_req->req = NULL;
+	bio_reset(pre_req->bio);
+	list_add_tail(&pre_req->list_req, &hpb->lh_pre_req_free);
+	hpb->num_inflight_pre_req--;
+}
+
+static void ufshpb_pre_req_compl_fn(struct request *req, blk_status_t error)
+{
+	struct ufshpb_req *pre_req = (struct ufshpb_req *)req->end_io_data;
+	struct ufshpb_lu *hpb = pre_req->hpb;
+	unsigned long flags;
+
+	if (error) {
+		struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
+		struct scsi_sense_hdr sshdr;
+
+		dev_err(&hpb->sdev_ufs_lu->sdev_dev, "block status %d", error);
+		scsi_command_normalize_sense(cmd, &sshdr);
+		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
+			"code %x sense_key %x asc %x ascq %x",
+			sshdr.response_code,
+			sshdr.sense_key, sshdr.asc, sshdr.ascq);
+		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
+			"byte4 %x byte5 %x byte6 %x additional_len %x",
+			sshdr.byte4, sshdr.byte5,
+			sshdr.byte6, sshdr.additional_length);
+	}
+
+	blk_mq_free_request(req);
+	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+	ufshpb_put_pre_req(pre_req->hpb, pre_req);
+	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+}
+
+static int ufshpb_prep_entry(struct ufshpb_req *pre_req, struct page *page)
+{
+	struct ufshpb_lu *hpb = pre_req->hpb;
+	struct ufshpb_region *rgn;
+	struct ufshpb_subregion *srgn;
+	__be64 *addr;
+	int offset = 0;
+	int copied;
+	unsigned long lpn = pre_req->wb.lpn;
+	int rgn_idx, srgn_idx, srgn_offset;
+	unsigned long flags;
+
+	addr = page_address(page);
+	ufshpb_get_pos_from_lpn(hpb, lpn, &rgn_idx, &srgn_idx, &srgn_offset);
+
+	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+
+next_offset:
+	rgn = hpb->rgn_tbl + rgn_idx;
+	srgn = rgn->srgn_tbl + srgn_idx;
+
+	if (!ufshpb_is_valid_srgn(rgn, srgn))
+		goto mctx_error;
+
+	if (!srgn->mctx)
+		goto mctx_error;
+
+	copied = ufshpb_fill_ppn_from_page(hpb, srgn->mctx, srgn_offset,
+					   pre_req->wb.len - offset,
+					   &addr[offset]);
+
+	if (copied < 0)
+		goto mctx_error;
+
+	offset += copied;
+	srgn_offset += copied;
+
+	if (srgn_offset == hpb->entries_per_srgn) {
+		srgn_offset = 0;
+
+		if (++srgn_idx == hpb->srgns_per_rgn) {
+			srgn_idx = 0;
+			rgn_idx++;
+		}
+	}
+
+	if (offset < pre_req->wb.len)
+		goto next_offset;
+
+	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+	return 0;
+mctx_error:
+	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+	return -ENOMEM;
+}
+
+static int ufshpb_pre_req_add_bio_page(struct ufshpb_lu *hpb,
+				       struct request_queue *q,
+				       struct ufshpb_req *pre_req)
+{
+	struct page *page = pre_req->wb.m_page;
+	struct bio *bio = pre_req->bio;
+	int entries_bytes, ret;
+
+	if (!page)
+		return -ENOMEM;
+
+	if (ufshpb_prep_entry(pre_req, page))
+		return -ENOMEM;
+
+	entries_bytes = pre_req->wb.len * sizeof(u64);
+
+	ret = bio_add_pc_page(q, bio, page, entries_bytes, 0);
+	if (ret != entries_bytes) {
+		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
+			"bio_add_pc_page fail: %d", ret);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static inline int ufshpb_get_read_id(struct ufshpb_lu *hpb)
+{
+	if (++hpb->cur_read_id >= MAX_HPB_READ_ID)
+		hpb->cur_read_id = 1;
+	return hpb->cur_read_id;
+}
+
+static int ufshpb_execute_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
+				  struct ufshpb_req *pre_req, int read_id)
+{
+	struct scsi_device *sdev = cmd->device;
+	struct request_queue *q = sdev->request_queue;
+	struct request *req;
+	struct scsi_request *rq;
+	struct bio *bio = pre_req->bio;
+
+	pre_req->hpb = hpb;
+	pre_req->wb.lpn = sectors_to_logical(cmd->device,
+					     blk_rq_pos(cmd->request));
+	pre_req->wb.len = sectors_to_logical(cmd->device,
+					     blk_rq_sectors(cmd->request));
+	if (ufshpb_pre_req_add_bio_page(hpb, q, pre_req))
+		return -ENOMEM;
+
+	req = pre_req->req;
+
+	/* 1. request setup */
+	blk_rq_append_bio(req, bio);
+	req->rq_disk = NULL;
+	req->end_io_data = (void *)pre_req;
+	req->end_io = ufshpb_pre_req_compl_fn;
+
+	/* 2. scsi_request setup */
+	rq = scsi_req(req);
+	rq->retries = 1;
+
+	ufshpb_set_write_buf_cmd(rq->cmd, pre_req->wb.lpn, pre_req->wb.len,
+				 read_id);
+	rq->cmd_len = scsi_command_size(rq->cmd);
+
+	if (blk_insert_cloned_request(q, req) != BLK_STS_OK)
+		return -EAGAIN;
+
+	hpb->stats.pre_req_cnt++;
+
+	return 0;
+}
+
+static int ufshpb_issue_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
+				int *read_id)
+{
+	struct ufshpb_req *pre_req;
+	struct request *req = NULL;
+	unsigned long flags;
+	int _read_id;
+	int ret = 0;
+
+	req = blk_get_request(cmd->device->request_queue,
+			      REQ_OP_SCSI_OUT | REQ_SYNC, BLK_MQ_REQ_NOWAIT);
+	if (IS_ERR(req))
+		return -EAGAIN;
+
+	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+	pre_req = ufshpb_get_pre_req(hpb);
+	if (!pre_req) {
+		ret = -EAGAIN;
+		goto unlock_out;
+	}
+	_read_id = ufshpb_get_read_id(hpb);
+	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+
+	pre_req->req = req;
+
+	ret = ufshpb_execute_pre_req(hpb, cmd, pre_req, _read_id);
+	if (ret)
+		goto free_pre_req;
+
+	*read_id = _read_id;
+
+	return ret;
+free_pre_req:
+	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+	ufshpb_put_pre_req(hpb, pre_req);
+unlock_out:
+	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+	blk_put_request(req);
+	return ret;
+}
+
 /*
  * This function will set up HPB read command using host-side L2P map data.
- * In HPB v1.0, maximum size of HPB read command is 4KB.
  */
-void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
 	struct ufshpb_lu *hpb;
 	struct ufshpb_region *rgn;
@@ -291,30 +551,31 @@ void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	__be64 ppn;
 	unsigned long flags;
 	int transfer_len, rgn_idx, srgn_idx, srgn_offset;
+	int read_id = 0;
 	int err = 0;
 
 	hpb = ufshpb_get_hpb_data(cmd->device);
 	if (!hpb)
-		return;
+		return -ENODEV;
 
 	if (ufshpb_get_state(hpb) == HPB_INIT)
-		return;
+		return -ENODEV;
 
 	if (ufshpb_get_state(hpb) != HPB_PRESENT) {
 		dev_notice(&hpb->sdev_ufs_lu->sdev_dev,
 			   "%s: ufshpb state is not PRESENT", __func__);
-		return;
+		return -ENODEV;
 	}
 
 	if (blk_rq_is_scsi(cmd->request) ||
 	    (!ufshpb_is_write_or_discard(cmd) &&
 	    !ufshpb_is_read_cmd(cmd)))
-		return;
+		return 0;
 
 	transfer_len = sectors_to_logical(cmd->device,
 					  blk_rq_sectors(cmd->request));
 	if (unlikely(!transfer_len))
-		return;
+		return 0;
 
 	lpn = sectors_to_logical(cmd->device, blk_rq_pos(cmd->request));
 	ufshpb_get_pos_from_lpn(hpb, lpn, &rgn_idx, &srgn_idx, &srgn_offset);
@@ -327,11 +588,11 @@ void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		ufshpb_set_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
 				 transfer_len);
 		spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
-		return;
+		return 0;
 	}
 
-	if (!ufshpb_is_supported_chunk(transfer_len))
-		return;
+	if (!ufshpb_is_supported_chunk(hpb, transfer_len))
+		return 0;
 
 	WARN_ON_ONCE(transfer_len > HPB_MULTI_CHUNK_HIGH);
 
@@ -340,7 +601,7 @@ void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 				   transfer_len)) {
 		hpb->stats.miss_cnt++;
 		spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
-		return;
+		return 0;
 	}
 
 	err = ufshpb_fill_ppn_from_page(hpb, srgn->mctx, srgn_offset, 1, &ppn);
@@ -353,28 +614,45 @@ void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		 * active state.
 		 */
 		dev_err(hba->dev, "get ppn failed. err %d\n", err);
-		return;
+		return err;
 	}
+	if (!ufshpb_is_legacy(hba) &&
+	    ufshpb_is_required_wb(hpb, transfer_len)) {
+		err = ufshpb_issue_pre_req(hpb, cmd, &read_id);
+		if (err) {
+			unsigned long timeout;
+
+			timeout = cmd->jiffies_at_alloc + msecs_to_jiffies(
+				  hpb->params.requeue_timeout_ms);
 
-	ufshpb_set_hpb_read_to_upiu(hpb, lrbp, lpn, ppn, transfer_len);
+			if (time_before(jiffies, timeout))
+				return -EAGAIN;
+
+			hpb->stats.miss_cnt++;
+			return 0;
+		}
+	}
+
+	ufshpb_set_hpb_read_to_upiu(hpb, lrbp, lpn, ppn, transfer_len, read_id);
 
 	hpb->stats.hit_cnt++;
+	return 0;
 }
-static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
-					     struct ufshpb_subregion *srgn)
+
+static struct ufshpb_req *ufshpb_get_req(struct ufshpb_lu *hpb,
+					 int rgn_idx, enum req_opf dir)
 {
-	struct ufshpb_req *map_req;
+	struct ufshpb_req *rq;
 	struct request *req;
-	struct bio *bio;
 	int retries = HPB_MAP_REQ_RETRIES;
 
-	map_req = kmem_cache_alloc(hpb->map_req_cache, GFP_KERNEL);
-	if (!map_req)
+	rq = kmem_cache_alloc(hpb->map_req_cache, GFP_KERNEL);
+	if (!rq)
 		return NULL;
 
 retry:
-	req = blk_get_request(hpb->sdev_ufs_lu->request_queue,
-			      REQ_OP_SCSI_IN, BLK_MQ_REQ_NOWAIT);
+	req = blk_get_request(hpb->sdev_ufs_lu->request_queue, dir,
+			      BLK_MQ_REQ_NOWAIT);
 
 	if ((PTR_ERR(req) == -EWOULDBLOCK) && (--retries > 0)) {
 		usleep_range(3000, 3100);
@@ -382,35 +660,54 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
 	}
 
 	if (IS_ERR(req))
-		goto free_map_req;
+		goto free_rq;
+
+	rq->hpb = hpb;
+	rq->req = req;
+	rq->rb.rgn_idx = rgn_idx;
+
+	return rq;
+
+free_rq:
+	kmem_cache_free(hpb->map_req_cache, rq);
+	return NULL;
+}
+
+static void ufshpb_put_req(struct ufshpb_lu *hpb, struct ufshpb_req *rq)
+{
+	blk_put_request(rq->req);
+	kmem_cache_free(hpb->map_req_cache, rq);
+}
+
+static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
+					     struct ufshpb_subregion *srgn)
+{
+	struct ufshpb_req *map_req;
+	struct bio *bio;
+
+	map_req = ufshpb_get_req(hpb, srgn->rgn_idx, REQ_OP_SCSI_IN);
+	if (!map_req)
+		return NULL;
 
 	bio = bio_alloc(GFP_KERNEL, hpb->pages_per_srgn);
 	if (!bio) {
-		blk_put_request(req);
-		goto free_map_req;
+		ufshpb_put_req(hpb, map_req);
+		return NULL;
 	}
 
-	map_req->hpb = hpb;
-	map_req->req = req;
 	map_req->bio = bio;
 
-	map_req->rgn_idx = srgn->rgn_idx;
-	map_req->srgn_idx = srgn->srgn_idx;
-	map_req->mctx = srgn->mctx;
+	map_req->rb.srgn_idx = srgn->srgn_idx;
+	map_req->rb.mctx = srgn->mctx;
 
 	return map_req;
-
-free_map_req:
-	kmem_cache_free(hpb->map_req_cache, map_req);
-	return NULL;
 }
 
 static void ufshpb_put_map_req(struct ufshpb_lu *hpb,
 			       struct ufshpb_req *map_req)
 {
 	bio_put(map_req->bio);
-	blk_put_request(map_req->req);
-	kmem_cache_free(hpb->map_req_cache, map_req);
+	ufshpb_put_req(hpb, map_req);
 }
 
 static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
@@ -493,6 +790,13 @@ static void ufshpb_activate_subregion(struct ufshpb_lu *hpb,
 	srgn->srgn_state = HPB_SRGN_VALID;
 }
 
+static void ufshpb_umap_req_compl_fn(struct request *req, blk_status_t error)
+{
+	struct ufshpb_req *umap_req = (struct ufshpb_req *)req->end_io_data;
+
+	ufshpb_put_req(umap_req->hpb, umap_req);
+}
+
 static void ufshpb_map_req_compl_fn(struct request *req, blk_status_t error)
 {
 	struct ufshpb_req *map_req = (struct ufshpb_req *) req->end_io_data;
@@ -500,8 +804,8 @@ static void ufshpb_map_req_compl_fn(struct request *req, blk_status_t error)
 	struct ufshpb_subregion *srgn;
 	unsigned long flags;
 
-	srgn = hpb->rgn_tbl[map_req->rgn_idx].srgn_tbl +
-		map_req->srgn_idx;
+	srgn = hpb->rgn_tbl[map_req->rb.rgn_idx].srgn_tbl +
+		map_req->rb.srgn_idx;
 
 	ufshpb_clear_dirty_bitmap(hpb, srgn);
 	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
@@ -511,6 +815,16 @@ static void ufshpb_map_req_compl_fn(struct request *req, blk_status_t error)
 	ufshpb_put_map_req(map_req->hpb, map_req);
 }
 
+static void ufshpb_set_unmap_cmd(unsigned char *cdb, struct ufshpb_region *rgn)
+{
+	cdb[0] = UFSHPB_WRITE_BUFFER;
+	cdb[1] = rgn ? UFSHPB_WRITE_BUFFER_INACT_SINGLE_ID :
+			  UFSHPB_WRITE_BUFFER_INACT_ALL_ID;
+	if (rgn)
+		put_unaligned_be16(rgn->rgn_idx, &cdb[2]);
+	cdb[9] = 0x00;
+}
+
 static void ufshpb_set_read_buf_cmd(unsigned char *cdb, int rgn_idx,
 				    int srgn_idx, int srgn_mem_size)
 {
@@ -524,6 +838,23 @@ static void ufshpb_set_read_buf_cmd(unsigned char *cdb, int rgn_idx,
 	cdb[9] = 0x00;
 }
 
+static void ufshpb_execute_umap_req(struct ufshpb_lu *hpb,
+				   struct ufshpb_req *umap_req,
+				   struct ufshpb_region *rgn)
+{
+	struct request *req;
+	struct scsi_request *rq;
+
+	req = umap_req->req;
+	req->timeout = 0;
+	req->end_io_data = (void *)umap_req;
+	rq = scsi_req(req);
+	ufshpb_set_unmap_cmd(rq->cmd, rgn);
+	rq->cmd_len = HPB_WRITE_BUFFER_CMD_LENGTH;
+
+	blk_execute_rq_nowait(NULL, req, 1, ufshpb_umap_req_compl_fn);
+}
+
 static int ufshpb_execute_map_req(struct ufshpb_lu *hpb,
 				  struct ufshpb_req *map_req, bool last)
 {
@@ -536,12 +867,12 @@ static int ufshpb_execute_map_req(struct ufshpb_lu *hpb,
 
 	q = hpb->sdev_ufs_lu->request_queue;
 	for (i = 0; i < hpb->pages_per_srgn; i++) {
-		ret = bio_add_pc_page(q, map_req->bio, map_req->mctx->m_page[i],
+		ret = bio_add_pc_page(q, map_req->bio, map_req->rb.mctx->m_page[i],
 				      PAGE_SIZE, 0);
 		if (ret != PAGE_SIZE) {
 			dev_err(&hpb->sdev_ufs_lu->sdev_dev,
 				   "bio_add_pc_page fail %d - %d\n",
-				   map_req->rgn_idx, map_req->srgn_idx);
+				   map_req->rb.rgn_idx, map_req->rb.srgn_idx);
 			return ret;
 		}
 	}
@@ -557,8 +888,8 @@ static int ufshpb_execute_map_req(struct ufshpb_lu *hpb,
 	if (unlikely(last))
 		mem_size = hpb->last_srgn_entries * HPB_ENTRY_SIZE;
 
-	ufshpb_set_read_buf_cmd(rq->cmd, map_req->rgn_idx,
-				map_req->srgn_idx, mem_size);
+	ufshpb_set_read_buf_cmd(rq->cmd, map_req->rb.rgn_idx,
+				map_req->rb.srgn_idx, mem_size);
 	rq->cmd_len = HPB_READ_BUFFER_CMD_LENGTH;
 
 	blk_execute_rq_nowait(NULL, req, 1, ufshpb_map_req_compl_fn);
@@ -690,6 +1021,26 @@ static void ufshpb_purge_active_subregion(struct ufshpb_lu *hpb,
 	}
 }
 
+static int ufshpb_issue_umap_req(struct ufshpb_lu *hpb,
+				 struct ufshpb_region *rgn)
+{
+	struct ufshpb_req *umap_req;
+	int rgn_idx = rgn ? rgn->rgn_idx : 0;
+
+	umap_req = ufshpb_get_req(hpb, rgn_idx, REQ_OP_SCSI_OUT);
+	if (!umap_req)
+		return -ENOMEM;
+
+	ufshpb_execute_umap_req(hpb, umap_req, rgn);
+
+	return 0;
+}
+
+static int ufshpb_issue_umap_all_req(struct ufshpb_lu *hpb)
+{
+	return ufshpb_issue_umap_req(hpb, NULL);
+}
+
 static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
 				  struct ufshpb_region *rgn)
 {
@@ -1212,6 +1563,16 @@ static void ufshpb_lu_parameter_init(struct ufs_hba *hba,
 	u32 entries_per_rgn;
 	u64 rgn_mem_size, tmp;
 
+	/* for pre_req */
+	hpb->pre_req_min_tr_len = hpb_dev_info->max_hpb_single_cmd + 1;
+
+	if (ufshpb_is_legacy(hba))
+		hpb->pre_req_max_tr_len = HPB_LEGACY_CHUNK_HIGH;
+	else
+		hpb->pre_req_max_tr_len = HPB_MULTI_CHUNK_HIGH;
+
+	hpb->cur_read_id = 0;
+
 	hpb->lu_pinned_start = hpb_lu_info->pinned_start;
 	hpb->lu_pinned_end = hpb_lu_info->num_pinned ?
 		(hpb_lu_info->pinned_start + hpb_lu_info->num_pinned - 1)
@@ -1358,7 +1719,7 @@ ufshpb_sysfs_attr_show_func(rb_active_cnt);
 ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
 ufshpb_sysfs_attr_show_func(map_req_cnt);
 
-static struct attribute *hpb_dev_attrs[] = {
+static struct attribute *hpb_dev_stat_attrs[] = {
 	&dev_attr_hit_cnt.attr,
 	&dev_attr_miss_cnt.attr,
 	&dev_attr_rb_noti_cnt.attr,
@@ -1370,9 +1731,118 @@ static struct attribute *hpb_dev_attrs[] = {
 
 struct attribute_group ufs_sysfs_hpb_stat_group = {
 	.name = "hpb_stats",
-	.attrs = hpb_dev_attrs,
+	.attrs = hpb_dev_stat_attrs,
+};
+
+/* SYSFS functions */
+#define ufshpb_sysfs_param_show_func(__name)				\
+static ssize_t __name##_show(struct device *dev,			\
+	struct device_attribute *attr, char *buf)			\
+{									\
+	struct scsi_device *sdev = to_scsi_device(dev);			\
+	struct ufshpb_lu *hpb = ufshpb_get_hpb_data(sdev);		\
+									\
+	if (!hpb)							\
+		return -ENODEV;						\
+									\
+	return sysfs_emit(buf, "%d\n", hpb->params.__name);		\
+}
+
+ufshpb_sysfs_param_show_func(requeue_timeout_ms);
+static ssize_t
+requeue_timeout_ms_store(struct device *dev, struct device_attribute *attr,
+			 const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct ufshpb_lu *hpb = ufshpb_get_hpb_data(sdev);
+	int val;
+
+	if (!hpb)
+		return -ENODEV;
+
+	if (kstrtouint(buf, 0, &val))
+		return -EINVAL;
+
+	if (val < 0)
+		return -EINVAL;
+
+	hpb->params.requeue_timeout_ms = val;
+
+	return count;
+}
+static DEVICE_ATTR_RW(requeue_timeout_ms);
+
+static struct attribute *hpb_dev_param_attrs[] = {
+	&dev_attr_requeue_timeout_ms.attr,
+	NULL,
 };
 
+struct attribute_group ufs_sysfs_hpb_param_group = {
+	.name = "hpb_params",
+	.attrs = hpb_dev_param_attrs,
+};
+
+static int ufshpb_pre_req_mempool_init(struct ufshpb_lu *hpb)
+{
+	struct ufshpb_req *pre_req = NULL, *t;
+	int qd = hpb->sdev_ufs_lu->queue_depth / 2;
+	int i;
+
+	INIT_LIST_HEAD(&hpb->lh_pre_req_free);
+
+	hpb->pre_req = kcalloc(qd, sizeof(struct ufshpb_req), GFP_KERNEL);
+	hpb->throttle_pre_req = qd;
+	hpb->num_inflight_pre_req = 0;
+
+	if (!hpb->pre_req)
+		goto release_mem;
+
+	for (i = 0; i < qd; i++) {
+		pre_req = hpb->pre_req + i;
+		INIT_LIST_HEAD(&pre_req->list_req);
+		pre_req->req = NULL;
+
+		pre_req->bio = bio_alloc(GFP_KERNEL, 1);
+		if (!pre_req->bio)
+			goto release_mem;
+
+		pre_req->wb.m_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!pre_req->wb.m_page) {
+			bio_put(pre_req->bio);
+			goto release_mem;
+		}
+
+		list_add_tail(&pre_req->list_req, &hpb->lh_pre_req_free);
+	}
+
+	return 0;
+release_mem:
+	list_for_each_entry_safe(pre_req, t, &hpb->lh_pre_req_free, list_req) {
+		list_del_init(&pre_req->list_req);
+		bio_put(pre_req->bio);
+		__free_page(pre_req->wb.m_page);
+	}
+
+	kfree(hpb->pre_req);
+	return -ENOMEM;
+}
+
+static void ufshpb_pre_req_mempool_destroy(struct ufshpb_lu *hpb)
+{
+	struct ufshpb_req *pre_req = NULL;
+	int i;
+
+	for (i = 0; i < hpb->throttle_pre_req; i++) {
+		pre_req = hpb->pre_req + i;
+		bio_put(hpb->pre_req[i].bio);
+		if (!pre_req->wb.m_page)
+			__free_page(hpb->pre_req[i].wb.m_page);
+		list_del_init(&pre_req->list_req);
+	}
+
+	kfree(hpb->pre_req);
+}
+
 static void ufshpb_stat_init(struct ufshpb_lu *hpb)
 {
 	hpb->stats.hit_cnt = 0;
@@ -1383,6 +1853,11 @@ static void ufshpb_stat_init(struct ufshpb_lu *hpb)
 	hpb->stats.map_req_cnt = 0;
 }
 
+static void ufshpb_param_init(struct ufshpb_lu *hpb)
+{
+	hpb->params.requeue_timeout_ms = HPB_REQUEUE_TIME_MS;
+}
+
 static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 {
 	int ret;
@@ -1415,14 +1890,24 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 		goto release_req_cache;
 	}
 
+	ret = ufshpb_pre_req_mempool_init(hpb);
+	if (ret) {
+		dev_err(hba->dev, "ufshpb(%d) pre_req_mempool init fail",
+			hpb->lun);
+		goto release_m_page_cache;
+	}
+
 	ret = ufshpb_alloc_region_tbl(hba, hpb);
 	if (ret)
-		goto release_m_page_cache;
+		goto release_pre_req_mempool;
 
 	ufshpb_stat_init(hpb);
+	ufshpb_param_init(hpb);
 
 	return 0;
 
+release_pre_req_mempool:
+	ufshpb_pre_req_mempool_destroy(hpb);
 release_m_page_cache:
 	kmem_cache_destroy(hpb->m_page_cache);
 release_req_cache:
@@ -1431,7 +1916,7 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 }
 
 static struct ufshpb_lu *
-ufshpb_alloc_hpb_lu(struct ufs_hba *hba, int lun,
+ufshpb_alloc_hpb_lu(struct ufs_hba *hba, struct scsi_device *sdev,
 		    struct ufshpb_dev_info *hpb_dev_info,
 		    struct ufshpb_lu_info *hpb_lu_info)
 {
@@ -1442,7 +1927,8 @@ ufshpb_alloc_hpb_lu(struct ufs_hba *hba, int lun,
 	if (!hpb)
 		return NULL;
 
-	hpb->lun = lun;
+	hpb->lun = sdev->lun;
+	hpb->sdev_ufs_lu = sdev;
 
 	ufshpb_lu_parameter_init(hba, hpb, hpb_dev_info, hpb_lu_info);
 
@@ -1452,6 +1938,7 @@ ufshpb_alloc_hpb_lu(struct ufs_hba *hba, int lun,
 		goto release_hpb;
 	}
 
+	sdev->hostdata = hpb;
 	return hpb;
 
 release_hpb:
@@ -1654,6 +2141,7 @@ void ufshpb_destroy_lu(struct ufs_hba *hba, struct scsi_device *sdev)
 
 	ufshpb_cancel_jobs(hpb);
 
+	ufshpb_pre_req_mempool_destroy(hpb);
 	ufshpb_destroy_region_tbl(hpb);
 
 	kmem_cache_destroy(hpb->map_req_cache);
@@ -1693,6 +2181,7 @@ static void ufshpb_hpb_lu_prepared(struct ufs_hba *hba)
 			ufshpb_set_state(hpb, HPB_PRESENT);
 			if ((hpb->lu_pinned_end - hpb->lu_pinned_start) > 0)
 				queue_work(ufshpb_wq, &hpb->map_work);
+			ufshpb_issue_umap_all_req(hpb);
 		} else {
 			dev_err(hba->dev, "destroy HPB lu %d\n", hpb->lun);
 			ufshpb_destroy_lu(hba, sdev);
@@ -1717,7 +2206,7 @@ void ufshpb_init_hpb_lu(struct ufs_hba *hba, struct scsi_device *sdev)
 	if (ret)
 		goto out;
 
-	hpb = ufshpb_alloc_hpb_lu(hba, lun, &hba->ufshpb_dev,
+	hpb = ufshpb_alloc_hpb_lu(hba, sdev, &hba->ufshpb_dev,
 				  &hpb_lu_info);
 	if (!hpb)
 		goto out;
@@ -1725,9 +2214,6 @@ void ufshpb_init_hpb_lu(struct ufs_hba *hba, struct scsi_device *sdev)
 	tot_active_srgn_pages += hpb_lu_info.max_active_rgns *
 			hpb->srgns_per_rgn * hpb->pages_per_srgn;
 
-	hpb->sdev_ufs_lu = sdev;
-	sdev->hostdata = hpb;
-
 out:
 	/* All LUs are initialized */
 	if (atomic_dec_and_test(&hba->ufshpb_dev.slave_conf_cnt))
@@ -1814,8 +2300,9 @@ void ufshpb_get_geo_info(struct ufs_hba *hba, u8 *geo_buf)
 void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 {
 	struct ufshpb_dev_info *hpb_dev_info = &hba->ufshpb_dev;
-	int version;
+	int version, ret;
 	u8 hpb_mode;
+	u32 max_hpb_single_cmd = HPB_MULTI_CHUNK_LOW;
 
 	hpb_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
 	if (hpb_mode == HPB_HOST_CONTROL) {
@@ -1826,13 +2313,27 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 	}
 
 	version = get_unaligned_be16(desc_buf + DEVICE_DESC_PARAM_HPB_VER);
-	if (version != HPB_SUPPORT_VERSION) {
+	if ((version != HPB_SUPPORT_VERSION) &&
+	    (version != HPB_SUPPORT_LEGACY_VERSION)) {
 		dev_err(hba->dev, "%s: HPB %x version is not supported.\n",
 			__func__, version);
 		hpb_dev_info->hpb_disabled = true;
 		return;
 	}
 
+	if (version == HPB_SUPPORT_LEGACY_VERSION)
+		hpb_dev_info->is_legacy = true;
+
+	pm_runtime_get_sync(hba->dev);
+	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+		QUERY_ATTR_IDN_MAX_HPB_SINGLE_CMD, 0, 0, &max_hpb_single_cmd);
+	pm_runtime_put_sync(hba->dev);
+
+	if (ret)
+		dev_err(hba->dev, "%s: idn: read max size of single hpb cmd query request failed",
+			__func__);
+	hpb_dev_info->max_hpb_single_cmd = max_hpb_single_cmd;
+
 	/*
 	 * Get the number of user logical unit to check whether all
 	 * scsi_device finish initialization
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 6e6a0252dc15..1e8d6e1d909e 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -30,19 +30,29 @@
 #define PINNED_NOT_SET				U32_MAX
 
 /* hpb support chunk size */
-#define HPB_MULTI_CHUNK_HIGH			1
+#define HPB_LEGACY_CHUNK_HIGH			1
+#define HPB_MULTI_CHUNK_LOW			7
+#define HPB_MULTI_CHUNK_HIGH			256
 
 /* hpb vender defined opcode */
 #define UFSHPB_READ				0xF8
 #define UFSHPB_READ_BUFFER			0xF9
 #define UFSHPB_READ_BUFFER_ID			0x01
+#define UFSHPB_WRITE_BUFFER			0xFA
+#define UFSHPB_WRITE_BUFFER_INACT_SINGLE_ID	0x01
+#define UFSHPB_WRITE_BUFFER_PREFETCH_ID		0x02
+#define UFSHPB_WRITE_BUFFER_INACT_ALL_ID	0x03
+#define HPB_WRITE_BUFFER_CMD_LENGTH		10
+#define MAX_HPB_READ_ID				0x7F
 #define HPB_READ_BUFFER_CMD_LENGTH		10
 #define LU_ENABLED_HPB_FUNC			0x02
 
 #define HPB_RESET_REQ_RETRIES			10
 #define HPB_MAP_REQ_RETRIES			5
+#define HPB_REQUEUE_TIME_MS			0
 
-#define HPB_SUPPORT_VERSION			0x100
+#define HPB_SUPPORT_VERSION			0x200
+#define HPB_SUPPORT_LEGACY_VERSION		0x100
 
 enum UFSHPB_MODE {
 	HPB_HOST_CONTROL,
@@ -119,23 +129,38 @@ struct ufshpb_region {
 	     (i)++)
 
 /**
- * struct ufshpb_req - UFSHPB READ BUFFER (for caching map) request structure
- * @req: block layer request for READ BUFFER
- * @bio: bio for holding map page
- * @hpb: ufshpb_lu structure that related to the L2P map
+ * struct ufshpb_req - HPB related request structure (write/read buffer)
+ * @req: block layer request structure
+ * @bio: bio for this request
+ * @hpb: ufshpb_lu structure that related to
+ * @list_req: ufshpb_req mempool list
+ * @sense: store its sense data
  * @mctx: L2P map information
  * @rgn_idx: target region index
  * @srgn_idx: target sub-region index
  * @lun: target logical unit number
+ * @m_page: L2P map information data for pre-request
+ * @len: length of host-side cached L2P map in m_page
+ * @lpn: start LPN of L2P map in m_page
  */
 struct ufshpb_req {
 	struct request *req;
 	struct bio *bio;
 	struct ufshpb_lu *hpb;
-	struct ufshpb_map_ctx *mctx;
-
-	unsigned int rgn_idx;
-	unsigned int srgn_idx;
+	struct list_head list_req;
+	union {
+		struct {
+			struct ufshpb_map_ctx *mctx;
+			unsigned int rgn_idx;
+			unsigned int srgn_idx;
+			unsigned int lun;
+		} rb;
+		struct {
+			struct page *m_page;
+			unsigned int len;
+			unsigned long lpn;
+		} wb;
+	};
 };
 
 struct victim_select_info {
@@ -144,6 +169,10 @@ struct victim_select_info {
 	atomic_t active_cnt;
 };
 
+struct ufshpb_params {
+	unsigned int requeue_timeout_ms;
+};
+
 struct ufshpb_stats {
 	u64 hit_cnt;
 	u64 miss_cnt;
@@ -151,6 +180,7 @@ struct ufshpb_stats {
 	u64 rb_active_cnt;
 	u64 rb_inactive_cnt;
 	u64 map_req_cnt;
+	u64 pre_req_cnt;
 };
 
 struct ufshpb_lu {
@@ -166,6 +196,15 @@ struct ufshpb_lu {
 	struct list_head lh_act_srgn; /* hold rsp_list_lock */
 	struct list_head lh_inact_rgn; /* hold rsp_list_lock */
 
+	/* pre request information */
+	struct ufshpb_req *pre_req;
+	int num_inflight_pre_req;
+	int throttle_pre_req;
+	struct list_head lh_pre_req_free;
+	int cur_read_id;
+	int pre_req_min_tr_len;
+	int pre_req_max_tr_len;
+
 	/* cached L2P map management worker */
 	struct work_struct map_work;
 
@@ -190,6 +229,7 @@ struct ufshpb_lu {
 	u32 pages_per_srgn;
 
 	struct ufshpb_stats stats;
+	struct ufshpb_params params;
 
 	struct kmem_cache *map_req_cache;
 	struct kmem_cache *m_page_cache;
@@ -201,7 +241,7 @@ struct ufs_hba;
 struct ufshcd_lrb;
 
 #ifndef CONFIG_SCSI_UFS_HPB
-static void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp) {}
+static int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp) { return 0; }
 static void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp) {}
 static void ufshpb_resume(struct ufs_hba *hba) {}
 static void ufshpb_suspend(struct ufs_hba *hba) {}
@@ -214,8 +254,9 @@ static void ufshpb_remove(struct ufs_hba *hba) {}
 static bool ufshpb_is_allowed(struct ufs_hba *hba) { return false; }
 static void ufshpb_get_geo_info(struct ufs_hba *hba, u8 *geo_buf) {}
 static void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf) {}
+static bool ufshpb_is_legacy(struct ufs_hba *hba) { return false; }
 #else
-void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
+int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
 void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
 void ufshpb_resume(struct ufs_hba *hba);
 void ufshpb_suspend(struct ufs_hba *hba);
@@ -228,7 +269,9 @@ void ufshpb_remove(struct ufs_hba *hba);
 bool ufshpb_is_allowed(struct ufs_hba *hba);
 void ufshpb_get_geo_info(struct ufs_hba *hba, u8 *geo_buf);
 void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf);
+bool ufshpb_is_legacy(struct ufs_hba *hba);
 extern struct attribute_group ufs_sysfs_hpb_stat_group;
+extern struct attribute_group ufs_sysfs_hpb_param_group;
 #endif
 
 #endif /* End of Header */
-- 
2.25.1

