Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94797C77B60
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Apr 2023 18:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236478AbjDDSe2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Apr 2023 14:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236385AbjDDSeK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2023 14:34:10 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8AE7AA9;
        Tue,  4 Apr 2023 11:31:34 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id x20so34857245ljq.9;
        Tue, 04 Apr 2023 11:31:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680633093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=laWPLn081d5VPfahsGu6BqueKGfg+QZwf4pkTPBTIXI=;
        b=b9MaLgV6AyJfPsK5xa0R4BBVGAKzr06vKVBDaSkqcN3J/xpw6EXZ97/v45b1eIf8Mb
         QuWgK20wTuKR7Vr4DB+X2xiom+pC9diMX9V/n3F7F8IL4FY5J8QrFTtXpwvqLe6IJftP
         u62H4C301D2UuyQQ2acCvP7/sb/IIHThLKKWG2U4TXkbCSykozZntG4zBPZ59p2O0DZM
         0upU2ksoyCi+63WJEVswIeYzmMjCtm/R5PtOJTzyKVmqnN/aU3f5g3DopzRrFN2+t5Wo
         csje+wZkNRoIjtNMh3wx2G/xzp1rqSSJ/RgDcPnLLz0YMA/CGMhaqFnBfk2B5oxkH2bE
         YStQ==
X-Gm-Message-State: AAQBX9fbDWB70hNzuMKlWUz/HVhBZoxTl2+KRavY8t2hAXpdG9r3By5l
        xYI4PtkwQ/e9jW7NBM5MuZSz98nSC5AljQ==
X-Google-Smtp-Source: AKy350bCt3GHsbw6tf/YJsYkKdBhs+94kJ7B0Fc39Tc6DnzqwA335w4Na4SdHZVcxJ3mEGcafV517w==
X-Received: by 2002:a2e:7315:0:b0:2a3:6b99:4030 with SMTP id o21-20020a2e7315000000b002a36b994030mr1296530ljc.36.1680633092913;
        Tue, 04 Apr 2023 11:31:32 -0700 (PDT)
Received: from flawful.org (c-a3f5e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.245.163])
        by smtp.gmail.com with ESMTPSA id h13-20020a2e900d000000b00295733a3390sm2418960ljg.101.2023.04.04.11.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 11:31:32 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 699A6B5; Tue,  4 Apr 2023 20:31:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680633091; bh=fJkyCUCmYaJG48RjauqpSErCyOrMsg8LLyg8ClLNQ3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UUOyAiwwS+oue4ytlqRTO3vOk1NbB0+OWmACx4x+JaSZabvb01sYzcdRpeUIK1gzU
         fME106RfHYcMk6dLesMMpXSFWMmskhA98Z0seEvukgXsj8lYCE272rGTNQZtWkA9aY
         coQRRo4o7DIewfF62I8I/AFlgROm226VHXJROFr8=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id EFBD7EC7;
        Tue,  4 Apr 2023 20:25:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680632741; bh=fJkyCUCmYaJG48RjauqpSErCyOrMsg8LLyg8ClLNQ3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dnx7ExpMIpN3Ug+1+fVqkbd/M5jGefMZrhFp3/zdL3ws3sIFxRt54/ptXQVocRxUz
         ttDY0/3iaz94JJk9BdYbXi5KaiXvKOB0XWh4OkhOoRGwKyGstZsm/6yJ6VZ8vmGJO3
         Eww4iHKcoHo2n4hnAaurPBslGA4OCJbhKR6eURqU=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v5 09/19] scsi: allow enabling and disabling command duration limits
Date:   Tue,  4 Apr 2023 20:24:14 +0200
Message-Id: <20230404182428.715140-10-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404182428.715140-1-nks@flawful.org>
References: <20230404182428.715140-1-nks@flawful.org>
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
 drivers/scsi/scsi_sysfs.c                    | 31 ++++++++++
 include/scsi/scsi_device.h                   |  2 +
 4 files changed, 108 insertions(+)

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
index 4994148e685b..9a54b2c0fee7 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1222,6 +1222,36 @@ static DEVICE_ATTR(queue_ramp_up_period, S_IRUGO | S_IWUSR,
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
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
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
@@ -1302,6 +1332,7 @@ static struct attribute *scsi_sdev_attrs[] = {
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

