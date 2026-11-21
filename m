Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.222.135.140
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795276433;
	b=P9KAP/WaLn85AeKxJx58mJYB3n4T1+vumKTgeOCFJ12NCaI2vmhPRn2w0bvIb8ZZAMDx
	 JgQkvaAEpjJCfQLAlXhRQpubFXzUCiNyFue/EJy+cBIwRAnnIeSG6f7jKAMmvvXdb+zeA
	 mQiLegjlXTcnagfxQUiR0LQ/WyK4X26AnaHd3RjddZ8NO+HFzuuogwAVpcBKpPOXGLQp5
	 kGIsAGBZ7uMHgZKR139iP742JuAmYYz33syLEJ4zeNFPRkjw7mVcgLAYRLjxRKKVWpLys
	 nhzdFpgLI0DcNucmfgwpxbpsTCfcqDa6wWnVNp5TOCk/vKXxKaeaZXkzu0+DqM84jtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795276433;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-WP-DKIM-Status:X-WP-MailID:X-WP-AV:
	 X-WP-SPAM;
	bh=bEEe6egzspd6y5R/11vdl+wxs2VdsriaqPR8CkHkzBQ=;
	b=qNslW2uDoOX41bB/7bwGofKgv2X3CX1UvGssKEcqENNwY8PbWWZKjat72BDMxY8NpGEz
	 gmF6CPLND+jsHfcyNIiCGeSs8499964CEyj+a5V0JVZM7ytDuglmevP6/qdTBfn/4aBrF
	 tum5K7zDodxwPSMY5aXl0ehyadnfLFwpx3nYGZiVBr0fefyQd/U2GVCfXlzZ9CiCrfNaF
	 kyLDZ7axRiXz+Am9x7AZxgbyILLqn7SicO9ZVxB54+0s6rOLOeY9mgl6bm1SpETLCSJeY
	 KlX/ZGKjKYXfOakyZ/h7MTSZUKDYnkvHY59Lp47ziMmELNGCHoiJcfTHYrI9lSxBYUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=o2.pl;
	spf=pass smtp.mailfrom=o2.pl;
	dkim=pass header.d=o2.pl header.i=@o2.pl header.a=rsa-sha256 header.s=s20261001 header.b=gwWPU4+g;
	arc=none smtp.remote-ip=193.222.135.140
Received: from mx-out.tlen.pl (mx-out.tlen.pl [193.222.135.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CA4606A32C
	for <linux-scsi@vger.kernel.org>; Sat, 21 Nov 2026 15:53:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8CA4606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=o2.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=o2.pl header.i=@o2.pl header.a=rsa-sha256 header.s=s20261001 header.b=gwWPU4+g
Received: (wp-smtpd smtp.tlen.pl 11511 invoked from network); 21 Nov 2026 16:53:43 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=s20261001;
          t=1795276423; bh=bEEe6egzspd6y5R/11vdl+wxs2VdsriaqPR8CkHkzBQ=;
          h=From:To:Cc:Subject;
          b=gwWPU4+gmCE/VZzs/r594ZD5JKjOoUJB+jOh/GWB3nEwpIqTWeproGFAw3HMXyvq0
           P1TWml3lbfud7g/rnBsjSn9R98r38NbclWouGTY1gVf8fyDXYsRnILrtcYSKPWJgBK
           FZTX3Xf7Xx8MXWfSulYDFoQIwSmU1KysW4Dyvg41lr9eSon6fyumYY5KpiPmY6D5RB
           zOZ7VATN3oFSKXFZ7kp84WS0kP86dvNS+1hy3vinqc/n0WhfejE1bsjNekny/D2FRZ
           /YMGuRz/nz/0n1t14+srAHNE7g5HlfDq69sHcaa/QXRgzG/NIjy/KSDxzVrC3gcexB
           u1P8ff6cuG+rA==
Received: from localhost.localdomain (apn-78-30-78-152.dynamic.gprs.plus.pl [78.30.78.152])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with SMTP
          for <oneukum@suse.com>; 21 Nov 2026 16:53:43 +0100
From: =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
To: Oliver Neukum <oneukum@suse.com>,
	Alan Stern <stern@rowland.harvard.edu>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Subject: [PATCH 1/2] usb: uas: expose US_FL_NO_ATA_1X in sysfs as ata_passthrough_disabled
Date: Sat, 21 Nov 2026 16:52:52 +0100
Message-ID: <20261121155253.4980-1-mat.jonczyk@o2.pl>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: o2.pl)                                                      
X-WP-MailID: a1d476e632da00398942db823da060ad
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 000000B [0SPk]                               

The uas driver blocks access to ATA passthrough commands for some
devices it considers buggy. However, it does not expose any meaningful
information whether the command was disabled by the driver or is
genuinly not supported by the hardware. This creates a problem for the
smartmontools program and makes it difficult for it to provide a useful
error message.

Link: https://www.smartmontools.org/wiki/SAT-with-UAS-Linux
Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>

---

v2:
- rename the attribute to ata_passthrough_disabled (to match others),
- add a proper documentation,
- add the ABI documentation for scsi to MAINTAINERS as appropriate,
- add a second patch to expose the information also for the usb-storage
  driver,
---
 .../ABI/testing/sysfs-class-scsi_device       | 10 ++++++++++
 MAINTAINERS                                   |  1 +
 drivers/usb/storage/uas.c                     | 20 +++++++++++++++++++
 3 files changed, 31 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-scsi_device

diff --git a/Documentation/ABI/testing/sysfs-class-scsi_device b/Documentation/ABI/testing/sysfs-class-scsi_device
new file mode 100644
index 000000000000..4dc8645bf59b
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-scsi_device
@@ -0,0 +1,10 @@
+What:		/sys/class/scsi_device/*/device/ata_passthrough_disabled
+Date:		Nov, 2026
+KernelVersion:	v7.5
+Contact:	usb-storage@lists.one-eyed-alien.net
+Description:	(RO) Indicates whether the driver blocks access from userspace
+		to ATA passthrough commands. Contains a value of '1' when such
+		commands are denied as the hardware is considered buggy and they
+		might interfere with a correct operation of the drive. Note that
+		a value of '0' does not necessarily mean that ATA passthrough is
+		available as it may not be supported by the hardware at all.
diff --git a/MAINTAINERS b/MAINTAINERS
index ccbcdc0799b9..d056984f4998 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -25293,6 +25293,7 @@ S:	Maintained
 Q:	https://patchwork.kernel.org/project/linux-scsi/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
+F:	Documentation/ABI/testing/sysfs-class-scsi_*
 F:	Documentation/devicetree/bindings/scsi/
 F:	drivers/scsi/
 F:	drivers/ufs/
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 8655edbd66b1..49481bfca34c 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -910,6 +910,25 @@ static int uas_sdev_configure(struct scsi_device *sdev,
 	return 0;
 }
 
+/* Sysfs interface */
+static ssize_t ata_passthrough_disabled_show(struct device *dev, struct device_attribute *attr,
+					     char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct uas_dev_info *devinfo = sdev->hostdata;
+
+	return sysfs_emit(buf, "%d\n", !!(devinfo->flags & US_FL_NO_ATA_1X));
+}
+
+static DEVICE_ATTR_RO(ata_passthrough_disabled);
+
+static struct attribute *uas_sdev_attrs[] = {
+	&dev_attr_ata_passthrough_disabled.attr,
+	NULL,
+};
+
+ATTRIBUTE_GROUPS(uas_sdev);
+
 static const struct scsi_host_template uas_host_template = {
 	.module = THIS_MODULE,
 	.name = "uas",
@@ -929,6 +948,7 @@ static const struct scsi_host_template uas_host_template = {
 	.dma_alignment = 511,
 	.dma_boundary = PAGE_SIZE - 1,
 	.cmd_size = sizeof(struct uas_cmd_info),
+	.sdev_groups = uas_sdev_groups,
 };
 
 #define UNUSUAL_DEV(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \
-- 
2.47.3

