Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46E71D54FA
	for <linux-scsi@vger.kernel.org>; Sun,  5 Oct 2025 19:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759691171; cv=none; b=tWD9a/hAP7Sj8Up3hJ47t5XhPo3y9V+GNHup3NaAgKI1oSSb996MBZ25bOYSWMvUjLOdzxJR95ubbYeSApVvnjPEXm2id/Qcl/kmRbrPs9w2SfmEohV/7xhcdz+FRqbJAq1NJYzLR71IC7N/NQJ1408MHA0cDbCcjvvM1hrHbvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759691171; c=relaxed/simple;
	bh=WcElxaeYWnn2XjUmvDJHyoaC7VLSnHjbZrDjkygQnVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0DkuMda01DdkqagCi+f/xiavM2VXbnOOb88O1ItH8oUqkDSOCkABFpueFbo2mowNTO7MG/KxJ3ETPmK5etgIgA+amw9jbxsVFvWZ6TxSp3IuCXCVnGz1rdCfWDllq6F4nW5Cax/dXLG4uNekLdrRQSl8uNAhdYPDcPgKUJa6r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=ge8aaKo8; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="ge8aaKo8"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 90B36240029
	for <linux-scsi@vger.kernel.org>; Sun,  5 Oct 2025 21:06:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de; s=2017;
	t=1759691167; bh=mlXfXyAhfEzh4M6SA5pi1ALa7mmBwTn4klmpU9G2dRA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Autocrypt:OpenPGP:From;
	b=ge8aaKo8elmxbaeYBhWwQq8wGmA+V0OvON+9F+90zcYVih8bf+uBln3XIoFJXv+mB
	 2c4B1ky/cETpXLElMfUEiXHQ5VZjFb/i29ynz4u8cPb7J/Ws9DApuoyEw4n7HnSufJ
	 Fz7OJLBSllAa4o6+soZqUxl9OcNWyvlN8iLLUhK7GJD65kmef3iAlducwLV8U5if/P
	 2/HvYlzShtaeIRB+YcPS6NR5JXALv1HmhqOru23eoiwsmZae9O8xcjnd26B0cNCCA3
	 kmtczmz6zAVXZR9W8i1EJrXhe21T4KfcTdIVVQ1vK6WhNg/gb2M2Arh+PXvmBD9Y6u
	 azzp50JJIMcaA==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4cfsLk3K7Xz9rxW;
	Sun,  5 Oct 2025 21:06:06 +0200 (CEST)
From: Markus Probst <markus.probst@posteo.de>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Markus Probst <markus.probst@posteo.de>
Subject: [PATCH 1/2] Add manage_restart device attribute to scsi_disk
Date: Sun, 05 Oct 2025 19:06:07 +0000
Message-ID: <20251005190559.1472308-1-markus.probst@posteo.de>
In-Reply-To: <8c3cb28c57462f9665b08fdaa022e6abc57fcd9e.camel@posteo.de>
References: <8c3cb28c57462f9665b08fdaa022e6abc57fcd9e.camel@posteo.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Autocrypt: addr=markus.probst@posteo.de; prefer-encrypt=mutual;
  keydata=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
  aBeNN4ijKZchBXHPgVx+YtWRHfcm4l8=
OpenPGP: url=https://posteo.de/keys/markus.probst@posteo.de.asc; preference=encrypt

there is already manage_shutdown, manage_system_start_stop and
manage_runtime_start_stop device attributes that allows the high-level
device driver (sd) manage the device power state, expect for the
system_state SYSTEM_RESTART. With this device attribute, it is possible to
let the high-level device driver (sd) manage the device power state for
SYSTEM_RESTART too.

Signed-off-by: Markus Probst <markus.probst@posteo.de>
---
 drivers/scsi/sd.c          | 35 ++++++++++++++++++++++++++++++++++-
 include/scsi/scsi_device.h |  6 ++++++
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5b8668accf8e..a3e9c2e9d9f4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -318,6 +318,36 @@ static ssize_t manage_shutdown_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(manage_shutdown);
 
+static ssize_t manage_restart_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+	struct scsi_device *sdp = sdkp->device;
+
+	return sysfs_emit(buf, "%u\n", sdp->manage_restart);
+}
+
+
+static ssize_t manage_restart_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+	struct scsi_device *sdp = sdkp->device;
+	bool v;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (kstrtobool(buf, &v))
+		return -EINVAL;
+
+	sdp->manage_restart = v;
+
+	return count;
+}
+static DEVICE_ATTR_RW(manage_restart);
+
 static ssize_t
 allow_restart_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -654,6 +684,7 @@ static struct attribute *sd_disk_attrs[] = {
 	&dev_attr_manage_system_start_stop.attr,
 	&dev_attr_manage_runtime_start_stop.attr,
 	&dev_attr_manage_shutdown.attr,
+	&dev_attr_manage_restart.attr,
 	&dev_attr_protection_type.attr,
 	&dev_attr_protection_mode.attr,
 	&dev_attr_app_tag_own.attr,
@@ -4175,7 +4206,9 @@ static void sd_shutdown(struct device *dev)
 	    (system_state == SYSTEM_POWER_OFF &&
 	     sdkp->device->manage_shutdown) ||
 	    (system_state == SYSTEM_RUNNING &&
-	     sdkp->device->manage_runtime_start_stop)) {
+	     sdkp->device->manage_runtime_start_stop) ||
+	    (system_state == SYSTEM_RESTART &&
+	     sdkp->device->manage_restart)) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		sd_start_stop_device(sdkp, 0);
 	}
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6d6500148c4b..c7e657ac8b6d 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -178,6 +178,12 @@ struct scsi_device {
 	 */
 	unsigned manage_shutdown:1;
 
+	/*
+	 * If true, let the high-level device driver (sd) manage the device
+	 * power state for system restart (reboot) operations.
+	 */
+	unsigned manage_restart:1;
+
 	/*
 	 * If set and if the device is runtime suspended, ask the high-level
 	 * device driver (sd) to force a runtime resume of the device.
-- 
2.49.1

