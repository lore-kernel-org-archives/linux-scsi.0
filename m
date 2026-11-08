Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170907;
	b=0bmteZVwN/Bo8nn0lKQbDEkdgltieQSZ/LcMvbFXhspo32SMgMFYX5S2BahxvPJQlT5r
	 gJi9Sum+UA+RvBrTeGaPUsxzDLqxchkaFpApWT0REqNY6skaxRx9wUd0NUAaTL2tzf5IN
	 +fc6yGKhnPVrTMwvP3zWlU2r+viE/bb1TVfv1PpB9ywRCLAJ7Afol1uasfUMpqIzf+/fr
	 Uyy+g/nwiKl/ZqwDlq91XN90L4BC/sRe2OfgdaT4nshdu0fGl2om9Cjn5qPM1j2gDjJ4+
	 IdgrYrfcuq2sXnj18iV43SugYxYnxtwCLQnosfIWfMilIM03uTPXA8tDyP2cMvRbPew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170907;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hgQyJUm3fD2hbrVKtDPbJw7PYul+RUHS+0oIlFRIqb8=;
	b=c9aDEZGYeTVRrAeVqG5wr+pTJqnv72yN24g/B4pdrgeYGzMj+iXOrQ1KZ2rT1Q4tMcRR
	 4Eq7UosW39yRfTnIHvofl+HeVTBJZTqY2XIwawNDvfgdVOPetYaZ45tqiitYXclJ3s6QQ
	 CQ+00mTVoihwzz0PDKWYV9uWgnG/KR7/IHwFc/6uMX1YcgRqbL2NU9s8v4xGUBIFZSVx7
	 wQ2epCXnVUssiGuE/4CyY55NS7anXNHH9oELNKKj2y2vXFgbEs6QUWl9VqkB9JO23cgn1
	 bk1xxSDADwfUdhKEHMUSXoQxGJFp178a1ktn0UlD1eRvWw4ak+H2sn3iRSENH3X3eBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hlLC5qu8;
	arc=none smtp.remote-ip=91.218.175.80
Received: from mta0.migadu.com (out-80.mta0.migadu.com [91.218.175.80])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A70606A31C
	for <linux-scsi@vger.kernel.org>; Sun,  8 Nov 2026 20:48:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31A70606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hlLC5qu8
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=GyT5fWgsqH1g3ZJJxZVOHEbN4qoGZGT9aB6YYU68Beg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170905; v=1; x=1794775705;
 b=hlLC5qu8chfob7N75gFTXP++Xc4//l+vg8qqxVP8QsxiGPT+E2p7Mf4zgqDrcrZzjezTUv7I
 BBFPEjg71FCprVtZFbjzGpeFxGT543yf3OOaIcLsr9RPcggLzcxnECz/sp2W1zt311vM0ztBlS8
 ANxUnMRqUXtCebswkY4QtxqU=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 6b66009fe5bd4c37;
	Sun, 08 Nov 2026 20:48:25 +0000
X-Mizu-Trace-ID: 6b66009fe5bd4c37
X-Migadu-Flow: FLOW_OUT
From: John Garry <john.garry@linux.dev>
To: james.bottomley@hansenpartnership.com,
	mkp@kernel.org
Cc: hare@suse.com,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	snitzer@kernel.org,
	jmeneghi@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	hch@lst.de,
	michael.christie@oracle.com,
	John Garry <john.garry@linux.dev>
Subject: [PATCH v9 27/29] scsi: sd: add mpath_dev file
Date: Sun,  8 Nov 2026 20:47:31 +0000
Message-ID: <20261108204733.557995-28-john.garry@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261108204733.557995-1-john.garry@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a mpath_dev file so that the multipath disk can be looked up from
per-path scsi_disk directory.

The following is an example of this usage:

$ ls -l /dev/sdc
brw-rw----    1 root     disk        8,  32 Feb 24 16:08 /dev/sdc
$ cat /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/sdc:0/mpath_dev
8:32

This can be used by a util like lsscsi, which would find that the gendisk
for the per-path scsi_disk is missing.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/sd.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ab4ce6c2a8dd..8469feb9ba5f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4124,6 +4124,77 @@ static int sd_mpath_add_disk(struct scsi_disk *sdkp)
 	return 0;
 }
 
+static ssize_t sd_mpath_dev_show(struct device *dev,
+			struct device_attribute *attr, char *page)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct sd_mpath_disk *sd_mpath_disk;
+	struct gendisk *disk;
+	char devt_str[13];
+	ssize_t ret = -EINVAL;
+
+	/*
+	 * This attr is for the per-path scsi_disk block device. We need to
+	 * handle the scenario that the multipath disk has been deleted and
+	 * the per-path scsi_disk (and its attr files) is still present.
+	 */
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk = sd_mpath_find_disk(scsi_mpath_head);
+	if (!sd_mpath_disk)
+		goto out_unlock;
+	if (!sd_mpath_disk->disk_count)
+		goto out_put_disk;
+
+	disk = mpath_head->disk;
+	/* A reference to this disk is held through sd_mpath_disk */
+	if (!disk || !test_bit(GD_ADDED, &disk->state))
+		goto out_put_disk;
+	format_dev_t(devt_str, disk_to_dev(disk)->devt);
+	ret = sysfs_emit(page, "%s\n", devt_str);
+out_put_disk:
+	sd_mpath_put_disk(sd_mpath_disk);
+out_unlock:
+	mutex_unlock(&sd_mpath_disks_lock);
+	return ret;
+}
+static DEVICE_ATTR(mpath_dev, 0444, sd_mpath_dev_show, NULL);
+
+static struct attribute *sd_mpath_dev_attrs[] = {
+	&dev_attr_mpath_dev.attr,
+	NULL
+};
+
+static umode_t sd_mpath_dev_attr_is_visible(struct kobject *kobj,
+				struct attribute *attr, int i)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_device = sdev->scsi_mpath_dev;
+
+	if (!scsi_mpath_device)
+		return 0;
+
+	return attr->mode;
+}
+
+static const struct attribute_group sd_mpath_dev_attr_group = {
+	.is_visible = sd_mpath_dev_attr_is_visible,
+	.attrs = sd_mpath_dev_attrs,
+};
+
+static const struct attribute_group *sd_mpath_dev_groups[] = {
+	&sd_mpath_dev_attr_group,
+	NULL
+};
+
 static ssize_t sd_mpath_device_delayed_removal_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
@@ -4405,6 +4476,8 @@ static int sd_mpath_add_disk(struct scsi_disk *sdkp)
 {
 	return 0;
 }
+
+#define sd_mpath_dev_groups NULL
 #endif
 
 /**
@@ -4557,7 +4630,7 @@ static int sd_probe(struct scsi_device *sdp)
 			sdp->host->rpm_autosuspend_delay);
 	}
 
-	error = device_add_disk(dev, gd, NULL);
+	error = device_add_disk(dev, gd, sd_mpath_dev_groups);
 	if (error) {
 		sd_mpath_fail_probe(sdkp);
 		device_unregister(&sdkp->disk_dev);
-- 
2.43.0

