Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 025C8C77B7C
	for <linux-scsi@archiver.kernel.org>; Thu, 11 May 2023 01:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236897AbjEKBUp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 May 2023 21:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjEKBUn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2023 21:20:43 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFF52121;
        Wed, 10 May 2023 18:20:42 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4f22908a082so5911897e87.1;
        Wed, 10 May 2023 18:20:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683768040; x=1686360040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U8HWIrEVqYQDNE7ZSpxoyO0srjfJONXJNmQNnULPTKU=;
        b=a85wfO0KKk0S0LC6qYocXThNoFGhNfwaNQXWov+cuQC4jp37t3g6jaeen8uUXZ4xHB
         ubBKEbdUrIc3RZwioOQXfqloCdEAYUl3A4iU1xo3YN/LzY5J9jc7oovbYyKuv5f55txM
         Tzwvwu8MrIe90BULuoGKvFj4X7R/sotYJazSMqii8ebQNzzINnb3btvPCyFxhzPN+y4p
         J01T43PcilPnkG7cOcaC3NS+1pzFRJ5YKryuz7s+JgcdtAX+H/ONnI6rwEYkk6BmlJI5
         KM4lqR4E60tR9XOW7MGWu3ebVhv0VBU5Bi69/KEHOVhJruGUmPThhx4DkZ8ssx7Zw3gA
         ORLQ==
X-Gm-Message-State: AC+VfDw+a6Itj6o1SKnNz4q/MtPdoBHCgzrEX4L0qMDJ/JTcUqipv4iT
        Rd+g2LfCOwtXIpNoLGIslAhyQhWIIrfaJnqq
X-Google-Smtp-Source: ACHHUZ7nrec4FPoRkdY5lBxH9wzCORULxpsjSRw6xRFsEALpUN8I3AAmszTq2iUB67YnOunAjsPPTg==
X-Received: by 2002:ac2:4c8a:0:b0:4dd:af29:92c1 with SMTP id d10-20020ac24c8a000000b004ddaf2992c1mr2024055lfl.44.1683768040493;
        Wed, 10 May 2023 18:20:40 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id i22-20020a056512007600b004ece331c830sm915358lfo.206.2023.05.10.18.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 18:20:40 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 5E5D23C7; Thu, 11 May 2023 03:20:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683768039; bh=8FtWUNOJUPSj52U4ttEG+f0MMlscHQOu52huS2ltEPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SufS3o1GM5NH2A5X4CtFdN4zv3LQBgOkqggX220QhaOylThKRZ1PInvIoeDdJxvA4
         kqZCzBQsocXByEWnIVC+CqrKbeFLZywRWTP3+HqpoX4VthPzI6HfzjZJ3Vqbl5Imov
         svneUjXbPnjQGQKBQkNJpSCFI7y/OG1iNT1MqvaI=
Received: from x1-carbon.. (unknown [64.141.80.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 57E5474F;
        Thu, 11 May 2023 03:15:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683767716; bh=8FtWUNOJUPSj52U4ttEG+f0MMlscHQOu52huS2ltEPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JFG4BwD2ROz4PfYLKe9i8zWSz3QBB1/eCD9/2G5JkDBAJYNzQ+GVbosbQCx/jo2vv
         ZJe6VLAm6dwqcHZyzX7rlaRUCj0xAGFoH9zrVx6aAnhK4v22hh8QkY8rz/hRVUxqyC
         m4AcO08t2g0emNpH4AMAaDXAKesmn9RaXSCipjeU=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v7 09/19] scsi: allow enabling and disabling command duration limits
Date:   Thu, 11 May 2023 03:13:42 +0200
Message-Id: <20230511011356.227789-10-nks@flawful.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511011356.227789-1-nks@flawful.org>
References: <20230511011356.227789-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <dlemoal@kernel.org>

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

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 Documentation/ABI/testing/sysfs-block-device | 13 ++++
 drivers/scsi/scsi.c                          | 62 ++++++++++++++++++++
 drivers/scsi/scsi_sysfs.c                    | 28 +++++++++
 include/scsi/scsi_device.h                   |  2 +
 4 files changed, 105 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-block-device b/Documentation/ABI/testing/sysfs-block-device
index ffc3358cba57..2d543cfa4079 100644
--- a/Documentation/ABI/testing/sysfs-block-device
+++ b/Documentation/ABI/testing/sysfs-block-device
@@ -104,3 +104,16 @@ Contact:	linux-scsi@vger.kernel.org
 Description:
 		(RO) Indicates if the device supports the command duration
 		limits feature found in some ATA and SCSI devices.
+
+
+What:		/sys/block/*/device/cdl_enable
+Date:		May, 2023
+KernelVersion:	v6.5
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
index 98fcbbf1c1e3..60317676e45f 100644
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
2.40.1

