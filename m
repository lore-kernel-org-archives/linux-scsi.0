Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8540FC00144
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jul 2022 05:14:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbiG2FOI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jul 2022 01:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbiG2FOH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2022 01:14:07 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8467D7D1DA
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 22:14:04 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id v18so3619282plo.8
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 22:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pirU/tXY4eRWw+UKu3CN0oSf2FqguCC88BPI0NBg4zk=;
        b=FwrTInxlcrALW4e8uZ0jswuyVfDLdb73c8tokE7WqP9b10asX8fpDJ0vi1uWe/1XTW
         PybnRJVpzffaFWUh98mEFpjKTcgSurxUwQznxRGRFXYhDF9x/NHHXY9u/pRitLhT3UBc
         op/eC4kvnY8nSSxXZS90jyawgjj5vYrkdOPwE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pirU/tXY4eRWw+UKu3CN0oSf2FqguCC88BPI0NBg4zk=;
        b=aEL2OdawzMk+DzwOR6KVdlx22p4PBFFwtv9ecv0ztyxp4iCYI4OOb0lJat1gVJHs/Q
         CuGHrmcXvfm3dRUeo6v+HPd717Qy93fGx1ZfbgXqFQzD/m1hdN91OCunw4QyiSbWapK7
         6hYBbNxJ5iZASI5wuYqZgozsxz4BVk7twrdwZ86rPFOIJ8uodlF3XBOyiyAdNuRmUWUI
         IVff5ZbwPGpl0o5YMp5/HaMUMtbqX6yj63ZvJ5VhtBSZWu8IojaCpxAS98xSPUxrTYyH
         SpJ7aPW4cr6sg+7XFCKnxGbizmKmpWqheLeQCaac1Y8z5gKS9Q3UmCwLNvKIOnTo1jzJ
         FqBA==
X-Gm-Message-State: ACgBeo0I03OB8hoiUV6ptG0cE4518XdMAtOutEyLqupmPCccaBGPic2C
        w8x7e7uBGrPbXK8LE6VF8hryBg==
X-Google-Smtp-Source: AA6agR4B5ctQoc5fVJKg+DuHn4bH80FwHsSplQUE+ssiIavJJWY9EyYI8+IunEn5ELuJgRaGBerEIw==
X-Received: by 2002:a17:90b:380e:b0:1f2:5514:960c with SMTP id mq14-20020a17090b380e00b001f25514960cmr2209126pjb.14.1659071643948;
        Thu, 28 Jul 2022 22:14:03 -0700 (PDT)
Received: from dlunevwfh.roam.corp.google.com (n122-107-196-14.sbr2.nsw.optusnet.com.au. [122.107.196.14])
        by smtp.gmail.com with ESMTPSA id d1-20020a170902cec100b0016d8d277c02sm2463347plg.25.2022.07.28.22.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 22:14:03 -0700 (PDT)
From:   Daniil Lunev <dlunev@chromium.org>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Daniil Lunev <dlunev@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sohaib Mohamed <sohaib.amhmd@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH v4] ufs: core: print UFSHCD capabilities in controller's sysfs node
Date:   Fri, 29 Jul 2022 15:13:49 +1000
Message-Id: <20220729151301.v4.1.Ibf9efc9be50783eeee55befa2270b7d38552354c@changeid>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allows userspace to check if Clock Scaling, Write Booster functionality
status.

Signed-off-by: Daniil Lunev <dlunev@chromium.org>

---

Changes in v4:
* Dropped crypto node per Eric Biggers mentioning it can be queried from
  disk's queue node

Changes in v3:
* Expose each capability individually.
* Update documentation to represent new scheme.

Changes in v2:
* Add documentation entry for the new sysfs node.

 Documentation/ABI/testing/sysfs-driver-ufs | 26 ++++++++++++++++++
 drivers/ufs/core/ufs-sysfs.c               | 31 ++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 6b248abb1bd71..ddc405f87786f 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1591,6 +1591,32 @@ Description:	This entry shows the status of HPB.
 
 		The file is read only.
 
+What:		/sys/bus/platform/drivers/ufshcd/*/capabilities/clock_scaling
+What:		/sys/bus/platform/devices/*.ufs/capabilities/clock_scaling
+Date:		July 2022
+Contact:	Daniil Lunev <dlunev@chromium.org>
+Description:	Indicates status of clock scaling.
+
+		== ============================
+		0  Clock scaling is not enabled.
+		1  Clock scaling is enabled.
+		== ============================
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/capabilities/write_booster
+What:		/sys/bus/platform/devices/*.ufs/capabilities/write_booster
+Date:		July 2022
+Contact:	Daniil Lunev <dlunev@chromium.org>
+Description:	Indicates status of Write Booster.
+
+		== ============================
+		0  Write Booster can not be enabled.
+		1  Write Booster can be enabled.
+		== ============================
+
+		The file is read only.
+
 What:		/sys/class/scsi_device/*/device/hpb_param_sysfs/activation_thld
 Date:		February 2021
 Contact:	Avri Altman <avri.altman@wdc.com>
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 0a088b47d5570..5c53349337dd8 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -279,6 +279,36 @@ static const struct attribute_group ufs_sysfs_default_group = {
 	.attrs = ufs_sysfs_ufshcd_attrs,
 };
 
+static ssize_t clock_scaling_show(struct device *dev, struct device_attribute *attr,
+				  char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%d\n", ufshcd_is_clkscaling_supported(hba));
+}
+
+static ssize_t write_booster_show(struct device *dev, struct device_attribute *attr,
+				  char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%d\n", ufshcd_is_wb_allowed(hba));
+}
+
+static DEVICE_ATTR_RO(clock_scaling);
+static DEVICE_ATTR_RO(write_booster);
+
+static struct attribute *ufs_sysfs_capabilities_attrs[] = {
+	&dev_attr_clock_scaling.attr,
+	&dev_attr_write_booster.attr,
+	NULL
+};
+
+static const struct attribute_group ufs_sysfs_capabilities_group = {
+	.name = "capabilities",
+	.attrs = ufs_sysfs_capabilities_attrs,
+};
+
 static ssize_t monitor_enable_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
@@ -1134,6 +1164,7 @@ static const struct attribute_group ufs_sysfs_attributes_group = {
 
 static const struct attribute_group *ufs_sysfs_groups[] = {
 	&ufs_sysfs_default_group,
+	&ufs_sysfs_capabilities_group,
 	&ufs_sysfs_monitor_group,
 	&ufs_sysfs_device_descriptor_group,
 	&ufs_sysfs_interconnect_descriptor_group,
-- 
2.31.0

