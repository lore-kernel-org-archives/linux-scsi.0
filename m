Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.91
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170910;
	b=O8QlS3eZUQ2b4JHL5Q17h+8HbE7bTZl6dZKBfZ9ZpXPi0GjhndxRgc5FW6+sA1ImZBaU
	 TJVCKXRBThbI4ihcVFFJ1P8jpYND3Yw3nK7I7tvu31bGDz9WXAjvWE+t46dQHICwlT6Fg
	 VoCN9pQkVfNJGAE5SomU5lxO4MvZRnGXPAuTruFEZMY+Z0QCLUoONT3E+Lq86Xl8S0Vrb
	 cCi20Lb5/XSlF9rDLQ5me+ttrNVDDV+M4TQGbd52RM3FZZkZIUhpaRSzTDlIiamma9Bc4
	 Rzhq5sRzJOBpgRsl8yLPGEbTRnHZkVZ1LYIuwta9rnrw4L6GaYsmL995l37PE6Xoa6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170910;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=U2xG8uBDS3ZX6a/oBks6CKUJxumAGYWP5iIhTx2myFE=;
	b=Er7yRx4vcOgqX6y2Phl0p8H0mXMUCBmqhJaL+E3ni3wvx/9T3KV7XmlOwcM/WdOKKdiu
	 +0xnHgRhOL5wIcJb2GODsKpl4vD+GlFOJ3RbqyQJjXTJGxNENZWeb+Ddt0ZSEysuqEyoU
	 DPtiTBpOQOdbRmxKPTCEw+zNbz4ErxYzXHbjL5CrC0q6bhf4fEFHcaVpPt90IFC8Ybbhm
	 yK8Bmk1LcKl13k+zUIz2v7/bJOrTui5XiEikFf+FoODqssZHFuPTZLtxCootvATjQw+wI
	 AIK5cIl17nz6rW5QGwjy6v32QOAu5Z7ArhbeIGOlGwNEDk5PWHHySkti1BQ8yD14WtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BBtI6KRw;
	arc=none smtp.remote-ip=91.218.175.91
Received: from mta0.migadu.com (out-91.mta0.migadu.com [91.218.175.91])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE08606D810
	for <linux-scsi@vger.kernel.org>; Sun,  8 Nov 2026 20:48:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FE08606D810
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BBtI6KRw
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=H0+4Td4UmVtpFq6ZyOOwjEU0diM7bm7DIDQy7pV4k4k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170908; v=1; x=1794775708;
 b=BBtI6KRwD+LgJiIsK0tbzEbJR7XsAlORonJND3gVANNlrjgRXyd1H+m32fr7hZVUC4xoDS1p
 i4s7LfzLzOygTVkWCc25DuTs6H8vBPkpEKrrMR1Hypwz05btOwR/atXuAINj2ux4LsaHuQPWduz
 eYvMAEqwCdrmO6J9UfsKowEk=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id a74b715b38ffa497;
	Sun, 08 Nov 2026 20:48:26 +0000
X-Mizu-Trace-ID: a74b715b38ffa497
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
Subject: [PATCH v9 29/29] scsi: sd: add mpath_queue_depth dev attribute
Date: Sun,  8 Nov 2026 20:47:33 +0000
Message-ID: <20261108204733.557995-30-john.garry@linux.dev>
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

Add a queue_depth file so that the multipath dynamic queue depth can be
looked up from per-path gendisk (scsi_disk) directory.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/sd.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5ea604c4bbb0..29ac1ee806c5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4178,9 +4178,28 @@ static ssize_t sd_mpath_numa_nodes_show(struct device *dev,
 }
 static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NULL);
 
+static ssize_t sd_mpath_queue_depth_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct Scsi_Host *shost = sdev->host;
+
+	if (!mpath_qd_iopolicy(&scsi_mpath_head->iopolicy))
+		return 0;
+
+	return sysfs_emit(buf, "%d\n", atomic_read(&shost->mpath_nr_active));
+}
+static DEVICE_ATTR(mpath_queue_depth, 0444, sd_mpath_queue_depth_show, NULL);
+
 static struct attribute *sd_mpath_dev_attrs[] = {
 	&dev_attr_mpath_dev.attr,
 	&dev_attr_mpath_numa_nodes.attr,
+	&dev_attr_mpath_queue_depth.attr,
 	NULL
 };
 
-- 
2.43.0

