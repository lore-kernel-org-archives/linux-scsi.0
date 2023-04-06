Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65A3AC77B70
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Apr 2023 11:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjDFL4m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Apr 2023 07:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238805AbjDFL4Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2023 07:56:24 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A574CA01;
        Thu,  6 Apr 2023 04:53:42 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id y15so50452286lfa.7;
        Thu, 06 Apr 2023 04:53:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680782019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B0Yh1xoxLJC8Qw/oaqgkkyeogcVxS4If3qQlfGjpvv8=;
        b=OMoGQMAphIw/MqkZlD+aJm3AsLC0qBE1LVq7zJ8rSFZkf1YRxNkz4yipevZKEJcMrb
         cu7FxItHw1wDzPJgjR6m13Ara6oJgRc5eB1raZdC7iU+97PMrGPCjOpypRk4JRqt4XEQ
         qI/h43G3EN/PUd1ZLZqPlN05KhYrp59nEHFef09UL2vrqfBXDe7UflN90az+E6kauUvD
         2Hkw3BIvWAgVDm30dwp/AdEvVBN8RyVBItR5YrF6dhGi0Os2RHz5nb2w6H2pFelHjBbC
         46S9INYSFPg0kxxwQlhtXdc+dlWUfBuRh/DdFB4CnUGH+GoF16mPf9xIHaDsGO8u6Krc
         /Rpw==
X-Gm-Message-State: AAQBX9d04DNUNvg6hG34qYk7w79pJi+e3U50RK1uX+Oat1PVI8zspK5S
        B71wboqAFU4EfkfioFzJwhV6TZpGZwUxDQ==
X-Google-Smtp-Source: AKy350bn/pegyfm0tPSVoBW7AhmqJwfStHkyHnTxyEHmNwz4Ifeayxm7C0Zmv61038++7SQFJMphqw==
X-Received: by 2002:a05:6512:3f19:b0:4e8:9058:ff05 with SMTP id y25-20020a0565123f1900b004e89058ff05mr1549515lfa.34.1680781199470;
        Thu, 06 Apr 2023 04:39:59 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id i3-20020ac25223000000b004eaf393dc46sm224207lfl.249.2023.04.06.04.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 04:39:59 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 422B96D7; Thu,  6 Apr 2023 13:39:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680781198; bh=D19GZR+26zritL67rmrhUpP8orS55QizRU2+GEKvLqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bY/1vON6TOVIF8IPvqKlK63lXsc4RFVGCjAFtWpcGuTq39jMQ9IqhxakkXVvS97NN
         wH691rV1yUElElju2+L7nOKEYVOCucPUrGvpjanZ3R7g37lSuxhq/IH016z9kv+l6I
         eGr/e+ed1ezPT5iOkczCQSRhzYtrWkAdng/ZcM8s=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 4240E9AF;
        Thu,  6 Apr 2023 13:33:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680780793; bh=D19GZR+26zritL67rmrhUpP8orS55QizRU2+GEKvLqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mdQ2pIuzFhMcYuayDSltnjQtqxrKdJ1tKHaVHqAsBPGRTAg3mS+UfzC9T7HI27xSW
         MnvX8UXsN6ne0yJ5Qm9/VWUolwfbVg5Yf+AtOnE6FblZXufejaE22uidQuIWqw7VCg
         wxV+6QS6etqCFNH9AMYqZnG+Xjajlir7ocywic5g=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Damien Le Moal <dlemoal@fastmail.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v6 09/19] scsi: allow enabling and disabling command duration limits
Date:   Thu,  6 Apr 2023 13:32:38 +0200
Message-Id: <20230406113252.41211-10-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113252.41211-1-nks@flawful.org>
References: <20230406113252.41211-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Add the sysfs scsi device attribute cdl_enable to allow a user to turn
enable or disable a device command duration limits feature. CDL is
disabled by default. This feature must be explicitly enabled by a user by
setting the cdl_enable attribute to 1.

The new function scsi_cdl_enable() does not do anything beside setting
the cdl_enable field of struct scsi_device in the case of a (real) scsi
device (e.g. a SAS HDD). For ATA devices, the command duration limits
feature needs to be enabled/disabled using the ATA feature sub-page of
the control mode page. To do so, the scsi_cdl_enable() function checks
if this mode page is supported using scsi_mode_sense(). If it is,
scsi_mode_select() is used to enable and disable CDL.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 Documentation/ABI/testing/sysfs-block-device | 13 ++++
 drivers/scsi/scsi.c                          | 62 ++++++++++++++++++++
 drivers/scsi/scsi_sysfs.c                    | 28 +++++++++
 include/scsi/scsi_device.h                   |  2 +
 4 files changed, 105 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-block-device b/Documentation/ABI/testing/sysfs-block-device
index ee3610a25845..626d48ac504b 100644
--- a/Documentation/ABI/testing/sysfs-block-device
+++ b/Documentation/ABI/testing/sysfs-block-device
@@ -104,3 +104,16 @@ Contact:	linux-scsi@vger.kernel.org
 Description:
 		(RO) Indicates if the device supports the command duration
 		limits feature found in some ATA and SCSI devices.
+
+
+What:		/sys/block/*/device/cdl_enable
+Date:		Mar, 2023
+KernelVersion:	v6.4
+Contact:	linux-scsi@vger.kernel.org
+Description:
+		(RW) For a device supporting the command duration limits
+		feature, write to the file to turn on or off the feature.
+		By default this feature is turned off.
+		Writing "1" to this file enables the use of command duration
+		limits for read and write commands in the kernel and turns on
+		the feature on the device. Writing "0" disables the feature.
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index c03814ce23ca..c4bf99a842f3 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -651,6 +651,68 @@ void scsi_cdl_check(struct scsi_device *sdev)
 	kfree(buf);
 }
 
+/**
+ * scsi_cdl_enable - Enable or disable a SCSI device supports for Command
+ *                   Duration Limits
+ * @sdev: The target device
+ * @enable: the target state
+ */
+int scsi_cdl_enable(struct scsi_device *sdev, bool enable)
+{
+	struct scsi_mode_data data;
+	struct scsi_sense_hdr sshdr;
+	struct scsi_vpd *vpd;
+	bool is_ata = false;
+	char buf[64];
+	int ret;
+
+	if (!sdev->cdl_supported)
+		return -EOPNOTSUPP;
+
+	rcu_read_lock();
+	vpd = rcu_dereference(sdev->vpd_pg89);
+	if (vpd)
+		is_ata = true;
+	rcu_read_unlock();
+
+	/*
+	 * For ATA devices, CDL needs to be enabled with a SET FEATURES command.
+	 */
+	if (is_ata) {
+		char *buf_data;
+		int len;
+
+		ret = scsi_mode_sense(sdev, 0x08, 0x0a, 0xf2, buf, sizeof(buf),
+				      5 * HZ, 3, &data, NULL);
+		if (ret)
+			return -EINVAL;
+
+		/* Enable CDL using the ATA feature page */
+		len = min_t(size_t, sizeof(buf),
+			    data.length - data.header_length -
+			    data.block_descriptor_length);
+		buf_data = buf + data.header_length +
+			data.block_descriptor_length;
+		if (enable)
+			buf_data[4] = 0x02;
+		else
+			buf_data[4] = 0;
+
+		ret = scsi_mode_select(sdev, 1, 0, buf_data, len, 5 * HZ, 3,
+				       &data, &sshdr);
+		if (ret) {
+			if (scsi_sense_valid(&sshdr))
+				scsi_print_sense_hdr(sdev,
+					dev_name(&sdev->sdev_gendev), &sshdr);
+			return ret;
+		}
+	}
+
+	sdev->cdl_enable = enable;
+
+	return 0;
+}
+
 /**
  * scsi_device_get  -  get an additional reference to a scsi_device
  * @sdev:	device to get a reference to
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 4994148e685b..0b155e52bb4d 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1222,6 +1222,33 @@ static DEVICE_ATTR(queue_ramp_up_period, S_IRUGO | S_IWUSR,
 		   sdev_show_queue_ramp_up_period,
 		   sdev_store_queue_ramp_up_period);
 
+static ssize_t sdev_show_cdl_enable(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	return sysfs_emit(buf, "%d\n", (int)sdev->cdl_enable);
+}
+
+static ssize_t sdev_store_cdl_enable(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	int ret;
+	bool v;
+
+	if (kstrtobool(buf, &v))
+		return -EINVAL;
+
+	ret = scsi_cdl_enable(to_scsi_device(dev), v);
+	if (ret)
+		return ret;
+
+	return count;
+}
+static DEVICE_ATTR(cdl_enable, S_IRUGO | S_IWUSR,
+		   sdev_show_cdl_enable, sdev_store_cdl_enable);
+
 static umode_t scsi_sdev_attr_is_visible(struct kobject *kobj,
 					 struct attribute *attr, int i)
 {
@@ -1302,6 +1329,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 #endif
 	&dev_attr_queue_ramp_up_period.attr,
 	&dev_attr_cdl_supported.attr,
+	&dev_attr_cdl_enable.attr,
 	REF_EVT(media_change),
 	REF_EVT(inquiry_change_reported),
 	REF_EVT(capacity_change_reported),
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6b8df9e253a0..b2cdb078b7bd 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -219,6 +219,7 @@ struct scsi_device {
 	unsigned no_vpd_size:1;		/* No VPD size reported in header */
 
 	unsigned cdl_supported:1;	/* Command duration limits supported */
+	unsigned cdl_enable:1;		/* Enable/disable Command duration limits */
 
 	unsigned int queue_stopped;	/* request queue is quiesced */
 	bool offline_already;		/* Device offline message logged */
@@ -367,6 +368,7 @@ extern void scsi_remove_device(struct scsi_device *);
 extern int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh);
 void scsi_attach_vpd(struct scsi_device *sdev);
 void scsi_cdl_check(struct scsi_device *sdev);
+int scsi_cdl_enable(struct scsi_device *sdev, bool enable);
 
 extern struct scsi_device *scsi_device_from_queue(struct request_queue *q);
 extern int __must_check scsi_device_get(struct scsi_device *);
-- 
2.39.2

