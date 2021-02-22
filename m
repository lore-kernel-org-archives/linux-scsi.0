Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF293C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 09:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9004864E2F
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 09:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbhBVJcy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 04:32:54 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:16025 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbhBVJck (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2021 04:32:40 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210222093154epoutp0122519564cdfa7ea1a54c3d7c34374074~mCABYhUBt1062110621epoutp01Z
        for <linux-scsi@vger.kernel.org>; Mon, 22 Feb 2021 09:31:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210222093154epoutp0122519564cdfa7ea1a54c3d7c34374074~mCABYhUBt1062110621epoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1613986314;
        bh=xP4ht97lN7oiMRHfLOYooTEdF7edMc+yU0qGX4Now5s=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=YfxexZbA63w0Bevt/09d2NSExmvXLRiiJ0T0cMOjeDpOVPoy+i1DIbkfDCqcgjYSz
         7AfbH1Vtdm009sRHVD2HxfpUySs/uzsIPhzEa76gw24vkF7iRL9d1bkhvFtLZdxP/2
         gqoBfurIT6xBPhQCJc9TQOS3VSh/IcqCrx3CJdCg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210222093152epcas2p47dd3ddf5b26d717992770756ecf1308c~mCAAUmTug1999119991epcas2p4R;
        Mon, 22 Feb 2021 09:31:52 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.188]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DkcQG6NWgz4x9Q7; Mon, 22 Feb
        2021 09:31:50 +0000 (GMT)
X-AuditID: b6c32a46-1d9ff7000000dbf8-a0-60337a060400
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        41.82.56312.60A73306; Mon, 22 Feb 2021 18:31:50 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v22 4/4] scsi: ufs: Add HPB 2.0 support
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
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210222092957epcms2p728b0c563f3cfbecbf8692d7e86f9afed@epcms2p7>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210222093150epcms2p155352e2255e6bfd8f8d71c737ed05e76@epcms2p1>
Date:   Mon, 22 Feb 2021 18:31:50 +0900
X-CMS-MailID: 20210222093150epcms2p155352e2255e6bfd8f8d71c737ed05e76
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJsWRmVeSWpSXmKPExsWy7bCmmS5blXGCwY032hYP5m1js9jbdoLd
        4uXPq2wWh2+/Y7eY9uEns8Wn9ctYLV4e0rRY9SDconnxejaLOWcbmCx6+7eyWTy+85ndYtGN
        bUwW/f/aWSwu75rDZtF9fQebxfLj/5gsbm/hsli69SajRef0NSwWixbuZnEQ9bh8xdvjcl8v
        k8fOWXfZPSYsOsDosX/uGnaPlpP7WTw+Pr3F4tG3ZRWjx+dNch7tB7qZAriicmwyUhNTUosU
        UvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgD5UUihLzCkFCgUkFhcr
        6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfmFpfmpesl5+daGRoYGJkCVSbkZHTdfctUMGkT
        U8WxZx+ZGhjf/2TsYuTkkBAwkdh/bgdzFyMXh5DADkaJAycaWbsYOTh4BQQl/u4QBjGFBcwl
        +m+HgJQLCShJrL84ix3EFhbQk7j1cA3YGDYBHYnpJ+6zg4wREdjEInFvQQcriMMs8ItJ4sTj
        D1DLeCVmtD9lgbClJbYv38oIsoBTwE/ixUopiLCGxI9lvcwQtqjEzdVv2WHs98fmQ40RkWi9
        dxaqRlDiwc/dUHFJiWO7PzBB2PUSW+/8YgS5QUKgh1Hi8M5brBAJfYlrHRvBbuAV8JW4t30Z
        WAOLgKpE975/ULe5SHQcnQq2gFlAXmL72znMIHcyC2hKrN+lD2JKCChLHLnFAvNVw8bf7Ohs
        ZgE+iY7Df+HiO+Y9gTpNTWLdz/VMExiVZyECehaSXbMQdi1gZF7FKJZaUJybnlpsVGCEHLub
        GMHJXcttB+OUtx/0DjEycTAeYpTgYFYS4WW7a5QgxJuSWFmVWpQfX1Sak1p8iNEU6MuJzFKi
        yfnA/JJXEm9oamRmZmBpamFqZmShJM5bbPAgXkggPbEkNTs1tSC1CKaPiYNTqoGptuxq8Mlw
        +Q3/LFpvRgmL5ujJTC1eL5w6qSOzceaLDy6CpZMtIx9UPN6hrJrcuqJFRyuQL9dmf9T8n997
        Xr6bclG0la9n1rU2/sqVfjve+apcPy0l3VNXcb32wnN11W8e+SzzDS71du7efj+zYoMDQ/Vh
        BqFTW+3Kzd9fPrixItU+pFc0Sv6ejxhP8bUcl6PzRALVloYrOEclV8y5/dXSXehN8HzOn1dK
        zjPP6ti+woiht8pky8Jwh+J1BTe078d8yJl5iclrcZP2ox+Nny80Ri94+VDDUfbS6ldfuEPi
        /6ouPm+3IKApqKUp5TNv3GbnwMw3s445u3b/zA1yqYjcLNB87pXywyUyH3IPWSixFGckGmox
        FxUnAgDPOHr5dwQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210222092907epcms2p307f3c4116349ebde6eed05c767287449
References: <20210222092957epcms2p728b0c563f3cfbecbf8692d7e86f9afed@epcms2p7>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p1>
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

Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs |  35 +-
 drivers/scsi/ufs/ufs-sysfs.c               |   2 +
 drivers/scsi/ufs/ufs.h                     |   3 +-
 drivers/scsi/ufs/ufshcd.c                  |  20 +-
 drivers/scsi/ufs/ufshcd.h                  |   5 +
 drivers/scsi/ufs/ufshpb.c                  | 603 +++++++++++++++++++--
 drivers/scsi/ufs/ufshpb.h                  |  64 ++-
 7 files changed, 653 insertions(+), 79 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index bf5cb8846de1..0017eaf89cbe 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1253,14 +1253,14 @@ Description:	This entry shows the number of HPB pinned regions assigned to
 
 		The file is read only.
 
-What:		/sys/class/scsi_device/*/device/hpb_sysfs/hit_cnt
+What:		/sys/class/scsi_device/*/device/hpb_stat_sysfs/hit_cnt
 Date:		February 2021
 Contact:	Daejun Park <daejun7.park@samsung.com>
 Description:	This entry shows the number of reads that changed to HPB read.
 
 		The file is read only.
 
-What:		/sys/class/scsi_device/*/device/hpb_sysfs/miss_cnt
+What:		/sys/class/scsi_device/*/device/hpb_stat_sysfs/miss_cnt
 Date:		February 2021
 Contact:	Daejun Park <daejun7.park@samsung.com>
 Description:	This entry shows the number of reads that cannot be changed to
@@ -1268,7 +1268,7 @@ Description:	This entry shows the number of reads that cannot be changed to
 
 		The file is read only.
 
-What:		/sys/class/scsi_device/*/device/hpb_sysfs/rb_noti_cnt
+What:		/sys/class/scsi_device/*/device/hpb_stat_sysfs/rb_noti_cnt
 Date:		February 2021
 Contact:	Daejun Park <daejun7.park@samsung.com>
 Description:	This entry shows the number of response UPIUs that has
@@ -1276,7 +1276,7 @@ Description:	This entry shows the number of response UPIUs that has
 
 		The file is read only.
 
-What:		/sys/class/scsi_device/*/device/hpb_sysfs/rb_active_cnt
+What:		/sys/class/scsi_device/*/device/hpb_stat_sysfs/rb_active_cnt
 Date:		February 2021
 Contact:	Daejun Park <daejun7.park@samsung.com>
 Description:	This entry shows the number of active sub-regions recommended by
@@ -1284,7 +1284,7 @@ Description:	This entry shows the number of active sub-regions recommended by
 
 		The file is read only.
 
-What:		/sys/class/scsi_device/*/device/hpb_sysfs/rb_inactive_cnt
+What:		/sys/class/scsi_device/*/device/hpb_stat_sysfs/rb_inactive_cnt
 Date:		February 2021
 Contact:	Daejun Park <daejun7.park@samsung.com>
 Description:	This entry shows the number of inactive regions recommended by
@@ -1292,10 +1292,33 @@ Description:	This entry shows the number of inactive regions recommended by
 
 		The file is read only.
 
-What:		/sys/class/scsi_device/*/device/hpb_sysfs/map_req_cnt
+What:		/sys/class/scsi_device/*/device/hpb_stat_sysfs/map_req_cnt
 Date:		February 2021
 Contact:	Daejun Park <daejun7.park@samsung.com>
 Description:	This entry shows the number of read buffer commands for
 		activating sub-regions recommended by response UPIUs.
 
 		The file is read only.
+
+What:		/sys/class/scsi_device/*/device/hpb_param_sysfs/requeue_timeout_ms
+Date:		February 2021
+Contact:	Daejun Park <daejun7.park@samsung.com>
+Description:	This entry shows the requeue timeout threshold for write buffer
+		command in ms. This value can be changed by writing proper integer to
+		this entry.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/max_data_size_hpb_single_cmd
+Date:		February 2021
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
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 2546e7a1ac4f..00fb519406cf 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -841,6 +841,7 @@ out:									\
 static DEVICE_ATTR_RO(_name)
 
 UFS_ATTRIBUTE(boot_lun_enabled, _BOOT_LU_EN);
+UFS_ATTRIBUTE(max_data_size_hpb_single_cmd, _MAX_HPB_SINGLE_CMD);
 UFS_ATTRIBUTE(current_power_mode, _POWER_MODE);
 UFS_ATTRIBUTE(active_icc_level, _ACTIVE_ICC_LVL);
 UFS_ATTRIBUTE(ooo_data_enabled, _OOO_DATA_EN);
@@ -864,6 +865,7 @@ UFS_ATTRIBUTE(wb_cur_buf, _CURR_WB_BUFF_SIZE);
 
 static struct attribute *ufs_sysfs_attributes[] = {
 	&dev_attr_boot_lun_enabled.attr,
+	&dev_attr_max_data_size_hpb_single_cmd.attr,
 	&dev_attr_current_power_mode.attr,
 	&dev_attr_active_icc_level.attr,
 	&dev_attr_ooo_data_enabled.attr,
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 957763db1006..e0b748777a1b 100644
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
index 851c01a26207..f18a0a32f014 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2656,7 +2656,12 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	lrbp->req_abort_skip = false;
 
-	ufshpb_prep(hba, lrbp);
+	err = ufshpb_prep(hba, lrbp);
+	if (err == -EAGAIN) {
+		lrbp->cmd = NULL;
+		ufshcd_release(hba);
+		goto out;
+	}
 
 	ufshcd_comp_scsi_upiu(hba, lrbp);
 
@@ -3110,7 +3115,7 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
  *
  * Returns 0 for success, non-zero in case of failure
 */
-static int ufshcd_query_attr_retry(struct ufs_hba *hba,
+int ufshcd_query_attr_retry(struct ufs_hba *hba,
 	enum query_opcode opcode, enum attr_idn idn, u8 index, u8 selector,
 	u32 *attr_val)
 {
@@ -7447,8 +7452,14 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 
 	if (dev_info->wspecversion >= UFS_DEV_HPB_SUPPORT_VERSION &&
 	    (b_ufs_feature_sup & UFS_DEV_HPB_SUPPORT)) {
-		dev_info->hpb_enabled = true;
-		ufshpb_get_dev_info(hba, desc_buf);
+		bool hpb_en = false;
+
+		err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
+					      QUERY_FLAG_IDN_HPB_EN, 0, &hpb_en);
+		if (!err && hpb_en) {
+			dev_info->hpb_enabled = true;
+			ufshpb_get_dev_info(hba, desc_buf);
+		}
 	}
 
 	err = ufshcd_read_string_desc(hba, model_index,
@@ -8019,6 +8030,7 @@ static const struct attribute_group *ufshcd_driver_groups[] = {
 	&ufs_sysfs_lun_attributes_group,
 #ifdef CONFIG_SCSI_UFS_HPB
 	&ufs_sysfs_hpb_stat_group,
+	&ufs_sysfs_hpb_param_group,
 #endif
 	NULL,
 };
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 961fc5b77943..49bfebf366c7 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -654,6 +654,7 @@ struct ufs_hba_variant_params {
  * @srgn_size: device reported HPB sub-region size
  * @slave_conf_cnt: counter to check all lu finished initialization
  * @hpb_disabled: flag to check if HPB is disabled
+ * @max_hpb_single_cmd: maximum size of single HPB command
  */
 struct ufshpb_dev_info {
 	int num_lu;
@@ -661,6 +662,7 @@ struct ufshpb_dev_info {
 	int srgn_size;
 	atomic_t slave_conf_cnt;
 	bool hpb_disabled;
+	int max_hpb_single_cmd;
 };
 #endif
 
@@ -1091,6 +1093,9 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
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
index 50749b1fff06..6887120c73df 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -64,9 +64,19 @@ static bool ufshpb_is_write_or_discard_cmd(struct scsi_cmnd *cmd)
 	       op_is_discard(req_op(cmd->request));
 }
 
-static bool ufshpb_is_support_chunk(int transfer_len)
+static bool ufshpb_is_support_chunk(struct ufshpb_lu *hpb, int transfer_len)
 {
-	return transfer_len <= HPB_MULTI_CHUNK_HIGH;
+	return transfer_len <= hpb->pre_req_max_tr_len;
+}
+
+/*
+ * WRITE_BUFFER CMD support 36K (len=9) ~ 512K (len=128) default.
+ * it is possible to change range of transfer_len through sysfs.
+ */
+static inline bool ufshpb_is_required_wb(struct ufshpb_lu *hpb, int len)
+{
+	return (len >= hpb->pre_req_min_tr_len &&
+		len <= hpb->pre_req_max_tr_len);
 }
 
 static bool ufshpb_is_general_lun(int lun)
@@ -74,8 +84,7 @@ static bool ufshpb_is_general_lun(int lun)
 	return lun < UFS_UPIU_MAX_UNIT_NUM_ID;
 }
 
-static bool
-ufshpb_is_pinned_region(struct ufshpb_lu *hpb, int rgn_idx)
+static bool ufshpb_is_pinned_region(struct ufshpb_lu *hpb, int rgn_idx)
 {
 	if (hpb->lu_pinned_end != PINNED_NOT_SET &&
 	    rgn_idx >= hpb->lu_pinned_start &&
@@ -255,7 +264,8 @@ ufshpb_get_pos_from_lpn(struct ufshpb_lu *hpb, unsigned long lpn, int *rgn_idx,
 
 static void
 ufshpb_set_hpb_read_to_upiu(struct ufshpb_lu *hpb, struct ufshcd_lrb *lrbp,
-			    u32 lpn, u64 ppn, unsigned int transfer_len)
+			    u32 lpn, u64 ppn, unsigned int transfer_len,
+			    int read_id)
 {
 	unsigned char *cdb = lrbp->cmd->cmnd;
 
@@ -264,15 +274,269 @@ ufshpb_set_hpb_read_to_upiu(struct ufshpb_lu *hpb, struct ufshcd_lrb *lrbp,
 	/* ppn value is stored as big-endian in the host memory */
 	memcpy(&cdb[6], &ppn, sizeof(u64));
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
+	pre_req->bio = NULL;
+	list_add_tail(&pre_req->list_req, &hpb->lh_pre_req_free);
+	hpb->num_inflight_pre_req--;
+}
+
+static void ufshpb_pre_req_compl_fn(struct request *req, blk_status_t error)
+{
+	struct ufshpb_req *pre_req = (struct ufshpb_req *)req->end_io_data;
+	struct ufshpb_lu *hpb = pre_req->hpb;
+	unsigned long flags;
+	struct scsi_sense_hdr sshdr;
+
+	if (error) {
+		dev_err(&hpb->sdev_ufs_lu->sdev_dev, "block status %d", error);
+		scsi_normalize_sense(pre_req->sense, SCSI_SENSE_BUFFERSIZE,
+				     &sshdr);
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
+	bio_put(pre_req->bio);
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
+	u64 *addr;
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
+	srgn_offset += offset;
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
+		hpb->cur_read_id = 0;
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
+	blk_rq_append_bio(req, &bio);
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
+	struct bio *bio = NULL;
+	unsigned long flags;
+	int _read_id;
+	int ret = 0;
+
+	req = blk_get_request(cmd->device->request_queue,
+			      REQ_OP_SCSI_OUT | REQ_SYNC, BLK_MQ_REQ_NOWAIT);
+	if (IS_ERR(req))
+		return -EAGAIN;
+
+	bio = bio_alloc(GFP_ATOMIC, 1);
+	if (!bio) {
+		blk_put_request(req);
+		return -EAGAIN;
+	}
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
+	pre_req->bio = bio;
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
+	bio_put(bio);
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
@@ -282,26 +546,27 @@ void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	u64 ppn;
 	unsigned long flags;
 	int transfer_len, rgn_idx, srgn_idx, srgn_offset;
+	int read_id = MAX_HPB_READ_ID;
 	int err = 0;
 
 	hpb = ufshpb_get_hpb_data(cmd->device);
 	if (!hpb)
-		return;
+		return -ENODEV;
 
 	if (ufshpb_get_state(hpb) != HPB_PRESENT) {
 		dev_notice(&hpb->sdev_ufs_lu->sdev_dev,
 			   "%s: ufshpb state is not PRESENT", __func__);
-		return;
+		return -ENODEV;
 	}
 
 	if (!ufshpb_is_write_or_discard_cmd(cmd) &&
 	    !ufshpb_is_read_cmd(cmd))
-		return;
+		return 0;
 
 	transfer_len = sectors_to_logical(cmd->device,
 					  blk_rq_sectors(cmd->request));
 	if (unlikely(!transfer_len))
-		return;
+		return 0;
 
 	lpn = sectors_to_logical(cmd->device, blk_rq_pos(cmd->request));
 	ufshpb_get_pos_from_lpn(hpb, lpn, &rgn_idx, &srgn_idx, &srgn_offset);
@@ -314,18 +579,18 @@ void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		ufshpb_set_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
 				 transfer_len);
 		spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
-		return;
+		return 0;
 	}
 
-	if (!ufshpb_is_support_chunk(transfer_len))
-		return;
+	if (!ufshpb_is_support_chunk(hpb, transfer_len))
+		return 0;
 
 	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
 	if (ufshpb_test_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
 				   transfer_len)) {
 		hpb->stats.miss_cnt++;
 		spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
-		return;
+		return 0;
 	}
 
 	err = ufshpb_fill_ppn_from_page(hpb, srgn->mctx, srgn_offset, 1, &ppn);
@@ -339,28 +604,45 @@ void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		 */
 		WARN_ON(true);
 		dev_err(hba->dev, "get ppn failed. err %d\n", err);
-		return;
+		return err;
 	}
 
-	ufshpb_set_hpb_read_to_upiu(hpb, lrbp, lpn, ppn, transfer_len);
+	if (ufshpb_is_required_wb(hpb, transfer_len)) {
+		err = ufshpb_issue_pre_req(hpb, cmd, &read_id);
+		if (err) {
+			unsigned long timeout;
+
+			timeout = cmd->jiffies_at_alloc + msecs_to_jiffies(
+				  hpb->params.requeue_timeout_ms);
+
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
@@ -368,35 +650,54 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
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
@@ -468,6 +769,13 @@ static void ufshpb_activate_subregion(struct ufshpb_lu *hpb,
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
@@ -475,8 +783,8 @@ static void ufshpb_map_req_compl_fn(struct request *req, blk_status_t error)
 	struct ufshpb_subregion *srgn;
 	unsigned long flags;
 
-	srgn = hpb->rgn_tbl[map_req->rgn_idx].srgn_tbl +
-		map_req->srgn_idx;
+	srgn = hpb->rgn_tbl[map_req->rb.rgn_idx].srgn_tbl +
+		map_req->rb.srgn_idx;
 
 	ufshpb_clear_dirty_bitmap(hpb, srgn);
 	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
@@ -486,6 +794,16 @@ static void ufshpb_map_req_compl_fn(struct request *req, blk_status_t error)
 	ufshpb_put_map_req(map_req->hpb, map_req);
 }
 
+static void ufshpb_set_unmap_cmd(unsigned char *cdb, int rgn_idx, bool single)
+{
+	cdb[0] = UFSHPB_WRITE_BUFFER;
+	cdb[1] = single ? UFSHPB_WRITE_BUFFER_INACT_SINGLE_ID :
+			  UFSHPB_WRITE_BUFFER_INACT_ALL_ID;
+	if (single)
+		put_unaligned_be16(rgn_idx, &cdb[2]);
+	cdb[9] = 0x00;
+}
+
 static void ufshpb_set_read_buf_cmd(unsigned char *cdb, int rgn_idx,
 				    int srgn_idx, int srgn_mem_size)
 {
@@ -499,6 +817,26 @@ static void ufshpb_set_read_buf_cmd(unsigned char *cdb, int rgn_idx,
 	cdb[9] = 0x00;
 }
 
+static int ufshpb_execute_umap_all_req(struct ufshpb_lu *hpb,
+				       struct ufshpb_req *umap_req)
+{
+	struct request_queue *q;
+	struct request *req;
+	struct scsi_request *rq;
+
+	q = hpb->sdev_ufs_lu->request_queue;
+	req = umap_req->req;
+	req->timeout = 0;
+	req->end_io_data = (void *)umap_req;
+	rq = scsi_req(req);
+	ufshpb_set_unmap_cmd(rq->cmd, 0, false);
+	rq->cmd_len = HPB_WRITE_BUFFER_CMD_LENGTH;
+
+	blk_execute_rq_nowait(q, NULL, req, 1, ufshpb_umap_req_compl_fn);
+
+	return 0;
+}
+
 static int ufshpb_execute_map_req(struct ufshpb_lu *hpb,
 				  struct ufshpb_req *map_req, bool last)
 {
@@ -511,12 +849,12 @@ static int ufshpb_execute_map_req(struct ufshpb_lu *hpb,
 
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
@@ -532,8 +870,8 @@ static int ufshpb_execute_map_req(struct ufshpb_lu *hpb,
 	if (unlikely(last))
 		mem_size = hpb->last_srgn_entries * HPB_ENTRY_SIZE;
 
-	ufshpb_set_read_buf_cmd(rq->cmd, map_req->rgn_idx,
-				map_req->srgn_idx, mem_size);
+	ufshpb_set_read_buf_cmd(rq->cmd, map_req->rb.rgn_idx,
+				map_req->rb.srgn_idx, hpb->srgn_mem_size);
 	rq->cmd_len = HPB_READ_BUFFER_CMD_LENGTH;
 
 	blk_execute_rq_nowait(q, NULL, req, 1, ufshpb_map_req_compl_fn);
@@ -660,6 +998,24 @@ static void ufshpb_purge_active_subregion(struct ufshpb_lu *hpb,
 	}
 }
 
+static int ufshpb_issue_umap_all_req(struct ufshpb_lu *hpb)
+{
+	struct ufshpb_req *umap_req;
+
+	umap_req = ufshpb_get_req(hpb, 0, REQ_OP_SCSI_OUT);
+	if (!umap_req)
+		return -ENOMEM;
+
+	if (ufshpb_execute_umap_all_req(hpb, umap_req))
+		goto free_umap_req;
+
+	return 0;
+
+free_umap_req:
+	ufshpb_put_req(hpb, umap_req);
+	return -EAGAIN;
+}
+
 static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
 				  struct ufshpb_region *rgn)
 {
@@ -1179,6 +1535,16 @@ static void ufshpb_lu_parameter_init(struct ufs_hba *hba,
 	u32 entries_per_rgn;
 	u64 rgn_mem_size, tmp;
 
+	/* for pre_req */
+	if (hpb_dev_info->max_hpb_single_cmd)
+		hpb->pre_req_min_tr_len = hpb_dev_info->max_hpb_single_cmd;
+	else
+		hpb->pre_req_min_tr_len = HPB_MULTI_CHUNK_LOW;
+	hpb->pre_req_max_tr_len = max(HPB_MULTI_CHUNK_HIGH,
+				      hpb->pre_req_min_tr_len);
+
+	hpb->cur_read_id = 0;
+
 	hpb->lu_pinned_start = hpb_lu_info->pinned_start;
 	hpb->lu_pinned_end = hpb_lu_info->num_pinned ?
 		(hpb_lu_info->pinned_start + hpb_lu_info->num_pinned - 1)
@@ -1326,7 +1692,7 @@ ufshpb_sysfs_attr_show_func(rb_active_cnt);
 ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
 ufshpb_sysfs_attr_show_func(map_req_cnt);
 
-static struct attribute *hpb_dev_attrs[] = {
+static struct attribute *hpb_dev_stat_attrs[] = {
 	&dev_attr_hit_cnt.attr,
 	&dev_attr_miss_cnt.attr,
 	&dev_attr_rb_noti_cnt.attr,
@@ -1337,10 +1703,108 @@ static struct attribute *hpb_dev_attrs[] = {
 };
 
 struct attribute_group ufs_sysfs_hpb_stat_group = {
-	.name = "hpb_sysfs",
-	.attrs = hpb_dev_attrs,
+	.name = "hpb_stat_sysfs",
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
+	if (val <= 0)
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
+};
+
+struct attribute_group ufs_sysfs_hpb_param_group = {
+	.name = "hpb_param_sysfs",
+	.attrs = hpb_dev_param_attrs,
 };
 
+static int ufshpb_pre_req_mempool_init(struct ufshpb_lu *hpb)
+{
+	struct ufshpb_req *pre_req = NULL;
+	int qd = hpb->sdev_ufs_lu->queue_depth;
+	int i, j;
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
+		pre_req->bio = NULL;
+
+		pre_req->wb.m_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!pre_req->wb.m_page) {
+			for (j = 0; j < i; j++)
+				__free_page(hpb->pre_req[j].wb.m_page);
+
+			goto release_mem;
+		}
+		list_add_tail(&pre_req->list_req, &hpb->lh_pre_req_free);
+	}
+
+	return 0;
+release_mem:
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
@@ -1351,6 +1815,11 @@ static void ufshpb_stat_init(struct ufshpb_lu *hpb)
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
@@ -1383,14 +1852,24 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
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
@@ -1399,7 +1878,7 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 }
 
 static struct ufshpb_lu *
-ufshpb_alloc_hpb_lu(struct ufs_hba *hba, int lun,
+ufshpb_alloc_hpb_lu(struct ufs_hba *hba, struct scsi_device *sdev,
 		    struct ufshpb_dev_info *hpb_dev_info,
 		    struct ufshpb_lu_info *hpb_lu_info)
 {
@@ -1410,7 +1889,8 @@ ufshpb_alloc_hpb_lu(struct ufs_hba *hba, int lun,
 	if (!hpb)
 		return NULL;
 
-	hpb->lun = lun;
+	hpb->lun = sdev->lun;
+	hpb->sdev_ufs_lu = sdev;
 
 	ufshpb_lu_parameter_init(hba, hpb, hpb_dev_info, hpb_lu_info);
 
@@ -1420,6 +1900,7 @@ ufshpb_alloc_hpb_lu(struct ufs_hba *hba, int lun,
 		goto release_hpb;
 	}
 
+	sdev->hostdata = hpb;
 	return hpb;
 
 release_hpb:
@@ -1622,6 +2103,7 @@ void ufshpb_destroy_lu(struct ufs_hba *hba, struct scsi_device *sdev)
 
 	ufshpb_cancel_jobs(hpb);
 
+	ufshpb_pre_req_mempool_destroy(hpb);
 	ufshpb_destroy_region_tbl(hpb);
 
 	kmem_cache_destroy(hpb->map_req_cache);
@@ -1661,6 +2143,7 @@ static void ufshpb_hpb_lu_prepared(struct ufs_hba *hba)
 			ufshpb_set_state(hpb, HPB_PRESENT);
 			if ((hpb->lu_pinned_end - hpb->lu_pinned_start) > 0)
 				queue_work(ufshpb_wq, &hpb->map_work);
+			ufshpb_issue_umap_all_req(hpb);
 		} else {
 			dev_err(hba->dev, "destroy HPB lu %d\n", hpb->lun);
 			ufshpb_destroy_lu(hba, sdev);
@@ -1685,7 +2168,7 @@ void ufshpb_init_hpb_lu(struct ufs_hba *hba, struct scsi_device *sdev)
 	if (ret)
 		goto out;
 
-	hpb = ufshpb_alloc_hpb_lu(hba, lun, &hba->ufshpb_dev,
+	hpb = ufshpb_alloc_hpb_lu(hba, sdev, &hba->ufshpb_dev,
 				  &hpb_lu_info);
 	if (!hpb)
 		goto out;
@@ -1693,9 +2176,6 @@ void ufshpb_init_hpb_lu(struct ufs_hba *hba, struct scsi_device *sdev)
 	tot_active_srgn_pages += hpb_lu_info.max_active_rgns *
 			hpb->srgns_per_rgn * hpb->pages_per_srgn;
 
-	hpb->sdev_ufs_lu = sdev;
-	sdev->hostdata = hpb;
-
 out:
 	/* All LUs are initialized */
 	if (atomic_dec_and_test(&hba->ufshpb_dev.slave_conf_cnt))
@@ -1782,8 +2262,9 @@ void ufshpb_get_geo_info(struct ufs_hba *hba, u8 *geo_buf)
 void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 {
 	struct ufshpb_dev_info *hpb_dev_info = &hba->ufshpb_dev;
-	int version;
+	int version, ret;
 	u8 hpb_mode;
+	u32 max_hpb_sigle_cmd = 0;
 
 	hpb_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
 	if (hpb_mode == HPB_HOST_CONTROL) {
@@ -1801,6 +2282,16 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 		return;
 	}
 
+	pm_runtime_get_sync(hba->dev);
+	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+		QUERY_ATTR_IDN_MAX_HPB_SINGLE_CMD, 0, 0, &max_hpb_sigle_cmd);
+	pm_runtime_put_sync(hba->dev);
+
+	if (ret)
+		dev_err(hba->dev, "%s: idn: read max size of single hpb cmd query request failed",
+			__func__);
+	hpb_dev_info->max_hpb_single_cmd = max_hpb_sigle_cmd;
+
 	/*
 	 * Get the number of user logical unit to check whether all
 	 * scsi_device finish initialization
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index c70e73546e35..a697d8cef52d 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -30,19 +30,27 @@
 #define PINNED_NOT_SET				U32_MAX
 
 /* hpb support chunk size */
-#define HPB_MULTI_CHUNK_HIGH			1
+#define HPB_MULTI_CHUNK_LOW			9
+#define HPB_MULTI_CHUNK_HIGH			128
 
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
+#define HPB_REQUEUE_TIME_MS			3
 
-#define HPB_SUPPORT_VERSION			0x100
+#define HPB_SUPPORT_VERSION			0x200
 
 enum UFSHPB_MODE {
 	HPB_HOST_CONTROL,
@@ -118,23 +126,39 @@ struct ufshpb_region {
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
+	char sense[SCSI_SENSE_BUFFERSIZE];
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
@@ -143,6 +167,10 @@ struct victim_select_info {
 	atomic_t active_cnt;
 };
 
+struct ufshpb_params {
+	unsigned int requeue_timeout_ms;
+};
+
 struct ufshpb_stats {
 	u64 hit_cnt;
 	u64 miss_cnt;
@@ -150,6 +178,7 @@ struct ufshpb_stats {
 	u64 rb_active_cnt;
 	u64 rb_inactive_cnt;
 	u64 map_req_cnt;
+	u64 pre_req_cnt;
 };
 
 struct ufshpb_lu {
@@ -165,6 +194,15 @@ struct ufshpb_lu {
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
 
@@ -189,6 +227,7 @@ struct ufshpb_lu {
 	u32 pages_per_srgn;
 
 	struct ufshpb_stats stats;
+	struct ufshpb_params params;
 
 	struct kmem_cache *map_req_cache;
 	struct kmem_cache *m_page_cache;
@@ -200,7 +239,7 @@ struct ufs_hba;
 struct ufshcd_lrb;
 
 #ifndef CONFIG_SCSI_UFS_HPB
-static void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp) {}
+static int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp) { return 0; }
 static void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp) {}
 static void ufshpb_resume(struct ufs_hba *hba) {}
 static void ufshpb_suspend(struct ufs_hba *hba) {}
@@ -214,7 +253,7 @@ static bool ufshpb_is_allowed(struct ufs_hba *hba) { return false; }
 static void ufshpb_get_geo_info(struct ufs_hba *hba, u8 *geo_buf) {}
 static void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf) {}
 #else
-void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
+int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
 void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
 void ufshpb_resume(struct ufs_hba *hba);
 void ufshpb_suspend(struct ufs_hba *hba);
@@ -228,6 +267,7 @@ bool ufshpb_is_allowed(struct ufs_hba *hba);
 void ufshpb_get_geo_info(struct ufs_hba *hba, u8 *geo_buf);
 void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf);
 extern struct attribute_group ufs_sysfs_hpb_stat_group;
+extern struct attribute_group ufs_sysfs_hpb_param_group;
 #endif
 
 #endif /* End of Header */
-- 
2.25.1

