Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.87
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170909;
	b=HGsE7JDjn0KXJhGQemFpBAHL0r9F7QpyeMsjsE7eP2VeLrdoLRfq+6hnsGIhojx9PvJs
	 yNFbu63dUumX7kAnxAWTt/0qifmJ8M7hd/KRdECc0i0rPk6RG02sObQoxzwy9Sh6RQhSK
	 mZ4qAbMDPGi442DsiZSIzM3bZeEYAco8jV1bJoLXNRGzZw40XcvE9tUS3qbxS5+H247JV
	 xmG0rStyKKZSBgqN6Twc49XArPNpFo6on4xbHMbWMwn34NHnXbO+9wMY3lh0NvmdiJnHh
	 W2XKTQkaBbYq7Nf6nIJO7/XbuCPfe56bUfaTjYDLJKfEB8RRmjW23wEfMERSXkleT+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170909;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=aLBSphUPpkQSmk/BQU8w4WnHJtgwOWRaiwq4m3R70Zc=;
	b=FCwAgbehYPQ5Z7Ag4SMez8rAVdtya4qwrebFZXu+iKuVK74SEiGDJCkA+KAYWpgfaM2P
	 mFWyGNotl+13SjMGLCLFXDj6IMQBfRDeN3zhEj1u+ohIUxMel/+moVwTtNDrPDVgmANfD
	 Zmz4YqAQo/rNJTAKnxblse2DO+PyxrSNN0Q+3hTQJheUueo/2p7FIApXKEXjM6j0iRduu
	 mIBLWkSfs1niD1twDpuQXvJPqnCK7dlHA4RrQtlSOxwkhuuqDjl3NFKyqz46YteKeidWQ
	 yCb252MbRQtSwrxC+AjnGTI7TXt1+JmBAlreGBY6i1apiHNIg++aqD0OKV2jUruOpyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CuTd5rkN;
	arc=none smtp.remote-ip=91.218.175.87
Received: from mta0.migadu.com (out-87.mta0.migadu.com [91.218.175.87])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC3D606D82A
	for <linux-scsi@vger.kernel.org>; Sun,  8 Nov 2026 20:48:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FC3D606D82A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CuTd5rkN
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=yUyDco5Tbx6PoduIOfYi9iHiRgOj0lG9rUJG6HkMHEY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170906; v=1; x=1794775706;
 b=CuTd5rkNsbW27Id7uZBFk7XgMqScOKbnoGAu7ZTJ1i8d3IwtTjQcEBSRZF/H5PRAafYOBKeM
 DpAataKvwRUoeSPFfJ2MmuQRaTtAPwKYJExNrI3K/BmZ2naPhy1q3jS/NLuNdGnNTC7RZ/684hF
 i7ZnqS3BmMmF3c2x+cv6ohYk=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 37ce54ce466a1928;
	Sun, 08 Nov 2026 20:48:25 +0000
X-Mizu-Trace-ID: 37ce54ce466a1928
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
Subject: [PATCH v9 28/29] scsi: sd: add mpath_numa_nodes dev attribute
Date: Sun,  8 Nov 2026 20:47:32 +0000
Message-ID: <20261108204733.557995-29-john.garry@linux.dev>
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

Add an attribute to show multipath NUMA node per-path (scsi_disk).

The following is an example of reading the file:

$ cat /sys/devices/platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0/numa_
mpath_numa_nodes
0-3
$ cat /sys/devices/platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1/numa_
mpath_numa_nodes
$

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/sd.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8469feb9ba5f..5ea604c4bbb0 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4165,8 +4165,22 @@ static ssize_t sd_mpath_dev_show(struct device *dev,
 }
 static DEVICE_ATTR(mpath_dev, 0444, sd_mpath_dev_show, NULL);
 
+static ssize_t sd_mpath_numa_nodes_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+
+	return mpath_numa_nodes_show(mpath_device, buf);
+}
+static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NULL);
+
 static struct attribute *sd_mpath_dev_attrs[] = {
 	&dev_attr_mpath_dev.attr,
+	&dev_attr_mpath_numa_nodes.attr,
 	NULL
 };
 
-- 
2.43.0

