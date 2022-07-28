Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0C36C04A68
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 04:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbiG1Etl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 00:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiG1Eti (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 00:49:38 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC2D5727B
        for <linux-scsi@vger.kernel.org>; Wed, 27 Jul 2022 21:49:37 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id e16so924001pfm.11
        for <linux-scsi@vger.kernel.org>; Wed, 27 Jul 2022 21:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dIU+0kp3XN3YAPMWZ5u0JzDJny+Q5/T546hhxY9/MfE=;
        b=A3sLGIAmpGd9lKIDOhhq2hO5j80ogagK4XK4GFtQnARt4AIiSbaTzZIev/8/RK64dm
         IoPap9nhtD+S410RMzgKbqmbyRJch/aDkX+U2Mbo3tGqrioZ4UdbR2Dky3+NMXqYuhCl
         BChxx+YrgUl2Fgl1eZB2jV7hWmHzxKVSnT07A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dIU+0kp3XN3YAPMWZ5u0JzDJny+Q5/T546hhxY9/MfE=;
        b=hjCCmoIJdnvTBQY60vIp/9oXEaTBBtHkPmNOZeCQmBvj2ryayORnSuI4t3Vmn1K92E
         8aIzCMVbICIIJJzXbI5rE68JBjjIsB3ARDknC7hkgW4XW9Vqat5ANFn8LbtZsAELXnNR
         +i4dfxMPKB6lHG0MyT9jL0nGrYEXrkF/6Wuz4jMc20EvxsHfKQGmYKfE2G9EIPcdUlFr
         6Cbyxw1h35dPoXGBEaOHmLoHSbVU53NLTG7csl++CgKjdDlURTyYpVc1ltYCoSbokV+d
         MyYsdl3L3ACpMnRAYCTwUd3HJL+WVeVjCdxyZamXd1JiISwYCPpu5Gshrz4l6RvdBjiM
         qmKQ==
X-Gm-Message-State: AJIora+YOwuszF5682ahTRBPR9pXlQwek65vKMxs2ZMLu/HIquEtz1BB
        wmlQhUUxM+FjfN/05rm3W4Yh4Q==
X-Google-Smtp-Source: AGRyM1uXJ6dajQE24lZ91bt+VAFIy4MIeVWoq2tZj6TXIQoLp+R4aE+8WfwpXl9CllMHDU7nsU4wVQ==
X-Received: by 2002:a63:e80e:0:b0:419:d02c:fc8b with SMTP id s14-20020a63e80e000000b00419d02cfc8bmr21198632pgh.385.1658983777433;
        Wed, 27 Jul 2022 21:49:37 -0700 (PDT)
Received: from dlunevwfh.roam.corp.google.com (n122-107-196-14.sbr2.nsw.optusnet.com.au. [122.107.196.14])
        by smtp.gmail.com with ESMTPSA id u8-20020a1709026e0800b001640aad2f71sm14530251plk.180.2022.07.27.21.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 21:49:37 -0700 (PDT)
From:   Daniil Lunev <dlunev@chromium.org>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     Daniil Lunev <dlunev@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH] ufs: core: print capabilities in controller's sysfs node
Date:   Thu, 28 Jul 2022 14:49:25 +1000
Message-Id: <20220728144710.1.Id612b86fd30936dfd4c456b3341547c15cecf321@changeid>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allows userspace to check supported by the controller/device
functionality, e.g. write booster.

Signed-off-by: Daniil Lunev <dlunev@chromium.org>

---

 drivers/ufs/core/ufs-sysfs.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 0a088b47d5570..b0c294c367519 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -254,6 +254,14 @@ static ssize_t wb_on_store(struct device *dev, struct device_attribute *attr,
 	return res < 0 ? res : count;
 }
 
+static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "0x%08llx\n", hba->caps);
+}
+
 static DEVICE_ATTR_RW(rpm_lvl);
 static DEVICE_ATTR_RO(rpm_target_dev_state);
 static DEVICE_ATTR_RO(rpm_target_link_state);
@@ -262,6 +270,7 @@ static DEVICE_ATTR_RO(spm_target_dev_state);
 static DEVICE_ATTR_RO(spm_target_link_state);
 static DEVICE_ATTR_RW(auto_hibern8);
 static DEVICE_ATTR_RW(wb_on);
+static DEVICE_ATTR_RO(caps);
 
 static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_rpm_lvl.attr,
@@ -272,6 +281,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_spm_target_link_state.attr,
 	&dev_attr_auto_hibern8.attr,
 	&dev_attr_wb_on.attr,
+	&dev_attr_caps.attr,
 	NULL
 };
 
-- 
2.31.0

