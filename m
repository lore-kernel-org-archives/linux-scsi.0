Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC9DC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 21:55:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA838610A4
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 21:55:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235636AbhJLV5S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 17:57:18 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:41643 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235541AbhJLV5R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 17:57:17 -0400
Received: by mail-pf1-f182.google.com with SMTP id y7so665472pfg.8
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 14:55:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wvyQqBNr6G51SoR7vrsnUxQjU1p6Z+tarUpYh5dSn+g=;
        b=5HIdXG/R6xUcewSGTi7mldHSXo1o1Nek902My48q/9eqwylTxOpYmNdUakawsX7JtA
         qgL0wOSZBDk2WN9rc+hGOJ1hOYRFXzafEkA2Ai0jVb5ULNlHJz3ai8Ltnsyzdd12/E5l
         TODMKBX9E44ybS82qpSw46pkk6f/23UWr4HiDVipHGASjmcGXQ581zdia/IWBZZApayW
         yVgilJ5/QvYOKXdsnBF4BCC/CFndVHY1VXTDKY6Y+hqQvfQnhOXVKWyxhCLkBAFyNspq
         l8cml5zX1VzM3FwtRZ7zrIiyfvWI22lAglo6XwLBOWEM1/MC5EcHiP0gVVTX7HB40HBh
         fRAg==
X-Gm-Message-State: AOAM532nt5wLIGNsKPjj5mXsytEhFUX3UepGHw63j8tYGunVMwynq2fO
        Fb5WRj5ZPn++XZxox2QoUKk=
X-Google-Smtp-Source: ABdhPJzHK0V8O+kl8f3re+JhMxK/H11jJjO0kmT7IN4eVeznMqCRgvcgFvJ7uGZC/o6xEFsZkhc45g==
X-Received: by 2002:a05:6a00:a1e:b0:44c:7602:e1ee with SMTP id p30-20020a056a000a1e00b0044c7602e1eemr34169775pfh.80.1634075715250;
        Tue, 12 Oct 2021 14:55:15 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id m73sm12038730pfd.152.2021.10.12.14.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 14:55:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 5/5] scsi: ufs: Add a sysfs attribute for triggering the UFS EH
Date:   Tue, 12 Oct 2021 14:54:33 -0700
Message-Id: <20211012215433.3725777-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211012215433.3725777-1-bvanassche@acm.org>
References: <20211012215433.3725777-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it possible to test the impact of the UFS error handler on software
that submits SCSI commands to the UFS driver.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 10 ++++++
 drivers/scsi/ufs/ufshcd.c                  | 37 ++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index ec3a7149ced5..2a46f91d3f1b 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1534,3 +1534,13 @@ Contact:	Avri Altman <avri.altman@wdc.com>
 Description:	In host control mode the host is the originator of map requests.
 		To avoid flooding the device with map requests, use a simple throttling
 		mechanism that limits the number of inflight map requests.
+
+What:		/sys/class/scsi_host/*/trigger_eh
+Date:		October 2021
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:	Writing into this sysfs attribute triggers the UFS error
+		handler. This is useful for testing how the UFS error handler
+		affects SCSI command processing. The supported values are as
+		follows: "1" triggers the error handler without resetting the
+		host controller and "2" starts the error handler and makes it
+		reset the host interface.
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ecfe1f124f8a..30ff93979840 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8144,6 +8144,42 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	}
 }
 
+static ssize_t trigger_eh_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct Scsi_Host *host = class_to_shost(dev);
+	struct ufs_hba *hba = shost_priv(host);
+
+	/*
+	 * Using locking would be a better solution. However, this is a debug
+	 * attribute so ufshcd_eh_in_progress() should be good enough.
+	 */
+	if (ufshcd_eh_in_progress(hba))
+		return -EBUSY;
+
+	if (sysfs_streq(buf, "1")) {
+		hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_NON_FATAL;
+		hba->saved_err |= UIC_ERROR;
+	} else if (sysfs_streq(buf, "2")) {
+		hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_FATAL;
+		hba->saved_err |= UIC_ERROR;
+	} else {
+		return -EINVAL;
+	}
+
+	scsi_schedule_eh(hba->host);
+
+	return count;
+}
+
+static DEVICE_ATTR_WO(trigger_eh);
+
+static struct device_attribute *ufshcd_shost_attrs[] = {
+	&dev_attr_trigger_eh,
+	NULL
+};
+
 static const struct attribute_group *ufshcd_driver_groups[] = {
 	&ufs_sysfs_unit_descriptor_group,
 	&ufs_sysfs_lun_attributes_group,
@@ -8183,6 +8219,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.max_segment_size	= PRDT_DATA_BYTE_COUNT_MAX,
 	.max_host_blocked	= 1,
 	.track_queue_depth	= 1,
+	.shost_attrs		= ufshcd_shost_attrs,
 	.sdev_groups		= ufshcd_driver_groups,
 	.dma_boundary		= PAGE_SIZE - 1,
 	.rpm_autosuspend_delay	= RPM_AUTOSUSPEND_DELAY_MS,
