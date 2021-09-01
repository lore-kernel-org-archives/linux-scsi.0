Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC0AAC4320A
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 12:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B36F36115C
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 12:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344023AbhIAMkz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Sep 2021 08:40:55 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:63997 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344573AbhIAMjk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Sep 2021 08:39:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630499924; x=1662035924;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Ovy15cfCLOVD1iYA9PGNZtmHCKvlbWrMM4AuvWkgx/c=;
  b=O9s2v7e5HpyRAS/Wo9+hO+OJ0yH9zi2dRg9c9/u/3EQLorbxeA1I6fMw
   WsJqnN5XCL4XS48cuvc0gfGb34ARusjPu22HH56dY4ongjP0uy4gP7x79
   7wDonc9dnAK2kTf5R9wR8mbZWTbunNzEQuXJnFU8UECk/weeDpjb6yZDG
   j2Zz5TPSlEsxFkeIGxNhr3jHYXzhVuWGqpFaVykazNlcgq5rlnUri4fOJ
   MQBt5LIJdDhqmXFUzUW6s2DpfeIuPKeFOfeoca2IM1gTKmtQgDSEDzJPs
   In2CpfBt5PKYNXAaUYTkIDBrKnWbaaMZibofbdCQrYP0I3x5nguJJ/AsQ
   w==;
X-IronPort-AV: E=Sophos;i="5.84,369,1620662400"; 
   d="scan'208";a="290548644"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 01 Sep 2021 20:38:44 +0800
IronPort-SDR: t6RfBioPj4CIb1HB2SeaJKItjHkVv267/HPNk9OKIiaCEETjCnWL0IZMKPRMiuZl7uqSP+nZ9Z
 00Wj2EFbWgt5lfWFLLrWZvvxwnXeWSQ2mSzjUQP0Ayua148yIR68vKmZkPEsH2gugwd2+w76oR
 7lHBRE1FfUC5cCwvynQjA+XmFA+vJIorbPqQHr5Pb7f6Jc+B1DayvGpDEZHpFEeHzFO3M6cU53
 NKEgpTRZCpOOTJtV8eqKMeZSCkaKT9LfqNNk+amzisjEPzA0YxLLU5ZyKHj6mZhizEggKB7ykS
 Kd7I7TJPq8b1VkwFxLubtZvj
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2021 05:13:49 -0700
IronPort-SDR: F2H452xKyaSNYsJ95UYRnySX6LfS+T/RQaeM81OwQywVrE/LHXTg/GzRQ4YHVU8IwDrJTXgccu
 p0NUZzkBDP8dpQSY0Lo5cyAuvVYPdcEnXG8aosl2tR+uYJqFUDY5KmtL+nhvgzd75CqKAeOWJq
 8v9M7PXM0x/fBAigQ5lpZnr4tkeXRYvxB/+LY6fjPTWJMSCbY8877p79h4/waF8I8W9TnpSM+4
 ydu4VaK95JGzDAPCVOWsQtWWjCimDGObNFzx2bqkOm9L61bsOhOPbKJ8Ofnm5AA6olwxcdEdu9
 S84=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com (HELO BXYGM33.ad.shared) ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 01 Sep 2021 05:38:41 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 3/3] scsi: ufs-sysfs: Add sysfs entries for temperature notification
Date:   Wed,  1 Sep 2021 15:37:07 +0300
Message-Id: <20210901123707.5014-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210901123707.5014-1-avri.altman@wdc.com>
References: <20210901123707.5014-1-avri.altman@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The temperature readings are in degrees Celsius, and to allow negative
temperature, need to subtract 80 from the reported value. Make sure to
enforce the legal range of those values, and properly document it as
well.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 38 ++++++++++
 drivers/scsi/ufs/ufs-sysfs.c               | 86 ++++++++++++++++++++++
 drivers/scsi/ufs/ufs.h                     |  3 +
 3 files changed, 127 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index ec3a7149ced5..ff2294971e44 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1534,3 +1534,41 @@ Contact:	Avri Altman <avri.altman@wdc.com>
 Description:	In host control mode the host is the originator of map requests.
 		To avoid flooding the device with map requests, use a simple throttling
 		mechanism that limits the number of inflight map requests.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/case_rough_temp
+Date:		September 2021
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:	The device case rough temperature (bDeviceCaseRoughTemperature
+		attribute). It is termed "rough" due to the inherent inaccuracy
+		of the temperature sensor inside a semiconductor device,
+		e.g. +- 10 degrees centigrade error range.
+		allowable range is [-79..170].
+		The temperature readings are in decimal degrees Celsius.
+
+		Please note that the Tcase validity depends on the state of the
+		wExceptionEventControl attribute: it is up to the user to
+		verify that the applicable mask (TOO_HIGH_TEMP_EN, and / or
+		TOO_LOW_TEMP_EN) is set for the exception handling control.
+		This can be either done by ufs-bsg or ufs-debugfs.
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/high_temp_bound
+Date:		September 2021
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:	The high temperature (bDeviceTooHighTempBoundary attribute)
+		from which TOO_HIGH_TEMP in wExceptionEventStatus is turned on.
+		The temperature readings are in decimal degrees Celsius.
+		allowable range is [20..170].
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/low_temp_bound
+Date:		September 2021
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:	The low temperature (bDeviceTooLowTempBoundary attribute)
+		from which TOO_LOW_TEMP in wExceptionEventStatus is turned on.
+		The temperature readings are in decimal degrees Celsius.
+		allowable range is [-79..0].
+
+		The file is read only.
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 5c405ff7b6ea..a9abe33c40e4 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -1047,6 +1047,86 @@ static inline bool ufshcd_is_wb_attrs(enum attr_idn idn)
 		idn <= QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE;
 }
 
+static inline bool ufshcd_is_temp_attrs(enum attr_idn idn)
+{
+	return idn >= QUERY_ATTR_IDN_CASE_ROUGH_TEMP &&
+	       idn <= QUERY_ATTR_IDN_LOW_TEMP_BOUND;
+}
+
+static bool ufshcd_case_temp_legal(struct ufs_hba *hba)
+{
+	u32 ee_mask;
+	int ret;
+
+	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+				QUERY_ATTR_IDN_EE_CONTROL, 0, 0, &ee_mask);
+	ufshcd_rpm_put_sync(hba);
+	if (ret)
+		return false;
+
+	return (ufshcd_is_high_temp_notif_allowed(hba) &&
+		(ee_mask & MASK_EE_TOO_HIGH_TEMP)) ||
+	       (ufshcd_is_low_temp_notif_allowed(hba) &&
+		(ee_mask & MASK_EE_TOO_HIGH_TEMP));
+}
+
+static bool ufshcd_temp_legal(struct ufs_hba *hba, enum attr_idn idn,
+			      u32 value)
+{
+	return (idn == QUERY_ATTR_IDN_CASE_ROUGH_TEMP && value >= 1 &&
+		value <= 250 && ufshcd_case_temp_legal(hba)) ||
+	       (idn == QUERY_ATTR_IDN_HIGH_TEMP_BOUND && value >= 100 &&
+		value <= 250) ||
+	       (idn == QUERY_ATTR_IDN_LOW_TEMP_BOUND && value >= 1 &&
+		value <= 80);
+}
+
+#define UFS_ATTRIBUTE_DEC(_name, _uname)				\
+static ssize_t _name##_show(struct device *dev,				\
+	struct device_attribute *attr, char *buf)			\
+{									\
+	struct ufs_hba *hba = dev_get_drvdata(dev);			\
+	u32 value;							\
+	int dec_value;							\
+	int ret;							\
+	u8 index = 0;							\
+									\
+	down(&hba->host_sem);						\
+	if (!ufshcd_is_user_access_allowed(hba)) {			\
+		up(&hba->host_sem);					\
+		return -EBUSY;						\
+	}								\
+	if (ufshcd_is_temp_attrs(QUERY_ATTR_IDN##_uname)) {		\
+		if (!ufshcd_is_temp_notif_allowed(hba)) {		\
+			up(&hba->host_sem);				\
+			return -EOPNOTSUPP;				\
+		}							\
+	}								\
+	ufshcd_rpm_get_sync(hba);					\
+	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,	\
+		QUERY_ATTR_IDN##_uname, index, 0, &value);		\
+	ufshcd_rpm_put_sync(hba);					\
+	if (ret) {							\
+		ret = -EINVAL;						\
+		goto out;						\
+	}								\
+	dec_value = value;						\
+	if (ufshcd_is_temp_attrs(QUERY_ATTR_IDN##_uname)) {		\
+		if (!ufshcd_temp_legal(hba, QUERY_ATTR_IDN##_uname,	\
+				       value)) {			\
+			ret = -EINVAL;					\
+			goto out;					\
+		}							\
+		dec_value -= 80;					\
+	}								\
+	ret = sysfs_emit(buf, "%d\n", dec_value);			\
+out:									\
+	up(&hba->host_sem);						\
+	return ret;							\
+}									\
+static DEVICE_ATTR_RO(_name)
+
 #define UFS_ATTRIBUTE(_name, _uname)					\
 static ssize_t _name##_show(struct device *dev,				\
 	struct device_attribute *attr, char *buf)			\
@@ -1100,6 +1180,9 @@ UFS_ATTRIBUTE(wb_avail_buf, _AVAIL_WB_BUFF_SIZE);
 UFS_ATTRIBUTE(wb_life_time_est, _WB_BUFF_LIFE_TIME_EST);
 UFS_ATTRIBUTE(wb_cur_buf, _CURR_WB_BUFF_SIZE);
 
+UFS_ATTRIBUTE_DEC(case_rough_temp, _CASE_ROUGH_TEMP);
+UFS_ATTRIBUTE_DEC(high_temp_bound, _HIGH_TEMP_BOUND);
+UFS_ATTRIBUTE_DEC(low_temp_bound, _LOW_TEMP_BOUND);
 
 static struct attribute *ufs_sysfs_attributes[] = {
 	&dev_attr_boot_lun_enabled.attr,
@@ -1119,6 +1202,9 @@ static struct attribute *ufs_sysfs_attributes[] = {
 	&dev_attr_ffu_status.attr,
 	&dev_attr_psa_state.attr,
 	&dev_attr_psa_data_size.attr,
+	&dev_attr_case_rough_temp.attr,
+	&dev_attr_high_temp_bound.attr,
+	&dev_attr_low_temp_bound.attr,
 	&dev_attr_wb_flush_status.attr,
 	&dev_attr_wb_avail_buf.attr,
 	&dev_attr_wb_life_time_est.attr,
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 4f2a2fe0c84a..03d08fc1bd68 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -152,6 +152,9 @@ enum attr_idn {
 	QUERY_ATTR_IDN_PSA_STATE		= 0x15,
 	QUERY_ATTR_IDN_PSA_DATA_SIZE		= 0x16,
 	QUERY_ATTR_IDN_REF_CLK_GATING_WAIT_TIME	= 0x17,
+	QUERY_ATTR_IDN_CASE_ROUGH_TEMP		= 0x18,
+	QUERY_ATTR_IDN_HIGH_TEMP_BOUND		= 0x19,
+	QUERY_ATTR_IDN_LOW_TEMP_BOUND		= 0x1A,
 	QUERY_ATTR_IDN_WB_FLUSH_STATUS	        = 0x1C,
 	QUERY_ATTR_IDN_AVAIL_WB_BUFF_SIZE       = 0x1D,
 	QUERY_ATTR_IDN_WB_BUFF_LIFE_TIME_EST    = 0x1E,
-- 
2.17.1

