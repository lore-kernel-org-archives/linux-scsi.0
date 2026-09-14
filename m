Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA4544781E
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 13:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789392714; cv=none; b=cOqoe+Fln9gd6EmD8J6Jjo/4GNqg9Xr1tpZrCPu8HHZ90kKUImHZYO7ihlwbG5TZxrzbSItQjaZhzEu4Ty5dT6arzCj8lLYvMRnfxnUzDL2U8JrtCUSQjKtpWgnMSP7DjLYIcyDJDAVRvfBR19S0aYHE+o3zQB1xLekqr9C4wdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789392714; c=relaxed/simple;
	bh=bMsdMvSus7U2Fs9+6bR7h1oluEPI74JhEILnfWIGtj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDE2CGQG4yHdsx7pYW8rJio0FbFRXe/QSdr9ZNhxR5Lz88+A4kWoLHwhK1npKvfapXZzKCqESQE+t6wgYVDw02z2KbqtQx/vf2CICWrl5lrn08R34qAmUnnHhafgz8YfcnrEaPUrEiAYa2A02WassX+qzBX9hg/Nswp5XfdIFrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DqjwOeIC; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DqjwOeIC"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d747ee1f38so22588485ad.2
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 06:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789392712; x=1789997512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=msYkVtDkbmBFevf86iAldrO7owfuyjwEGQdpBpjsguY=;
        b=DqjwOeICQwqyNzy0XtxT7DLbZGMUluk+fpHn2OJagMm2MWdvsQfjLBstwtnYo/1rUC
         1I2MCRMQ/cs0T8EPqODRirE5ykQk1uY7E9v7dunfa5w10WkoFQnaMAWvGeE/u0Mn4LS0
         5kpQ4npGWpugmjfCbD6T3cfluWhMQmvJR7GEueiuVLKpM9flnNDnkR2Cb9cytiMDBGQj
         6xXKO6XqyeyE4S4OcFtzSc8GQ8pvpefnk1t9kBimAmVwAESq/GtwpzeQB4xRczfMSAsN
         QBK7z2d0JnWePs81FpJC/Hdh9/nGwSoKAdUBeL4iyrwS5Q4ogozSLtpJrQ7s1CGywPyA
         GYMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789392712; x=1789997512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=msYkVtDkbmBFevf86iAldrO7owfuyjwEGQdpBpjsguY=;
        b=EPZ+4HwDhIJSqF/0qg9cfCKK3o39czPR9e/GwAbrnV7fDLVzzArya5bKM5vSCZboso
         zTiIQHMaOyjW1WZZjxOOKOrMdtF+NGeCoU84Leyh6h/0x+C/HtVR7Jl4i9SPrnliSqoS
         xcN0vOxJLxiBERF+Hycu7VbjMJ/D2Rv2/W32y2edgbbQqCf0GBaOIMXujde9U0n1pqZu
         naiYHIWE0JyjKhvAdTKQsnR79o/BDmE8wdF7/tAyvIZ6jtqM/XUF86M0ymXhteLQc/hg
         TDE5GW45Z3dPgJiJ7KrkmKKLVQZ/W6xeybXgxqHGwLcyl0SUm1i6hr83IEbc51FBfjld
         RwQQ==
X-Forwarded-Encrypted: i=1; AKwUvBxi++eGK3z/pom5iZpIbn+kcn9+6nlxd4xj4jzr0j/l2zOikert2tqcGaCaZCC2vVCfbWYlvM0bHkPi@vger.kernel.org
X-Gm-Message-State: AFuF++lYDALMSGfiVkM750pwvWzLszeuL5m3/WuQ/z5qejPf81D+i5ko
	dYY581D1gXMeOEDfVHjH0QfCtuHpWZunMChPvdKBrV5ZLQXNqY7J6MHl
X-Gm-Gg: AYBFou3O/ekYPLJOzMK3SKo2xQgV5lQB6scDnpVYVuy9Z/JEV7JnwofPrxiEtzVwBuU
	ZP/i1DZjrjJ7UGFLaNUOVK8Zs+OGp3QYuqsFQuAcJz5OmFSGdW8ftED/XOkRXWlJFprEVAnxhuo
	Ccr++DvH3gkISRl4O0t8eHchuKOE34INeOqebN09KnffaNb8DnOB0KWslDucK5K13OLv5lMAC62
	DYuafjPu/EI5JDjKpjFMUUait1SqcdNhS2SGwl7I94zOMIAQ2/AFAVeIfNwFVDuP5eg2OFzODgg
	Gxd6dvPic7CYEw9Oaypkb7Jqy/y2LkLdXUveKOSOMWZkf5P39OuKcQTMNLbDp8iGFQAv+ygVYEK
	d3ENYTXZ7D7sC9k/5bMFmpBHKvxXw/W9E+Fpxh/S9I9DhvT+x9jVvAiMiYhU51PhLi/5BQydgyi
	ykabRPANcPFI3iq1p4pPnGMxiaMMooCztcw9o5WfUrczRcDEAtA2LTuC7tjMttE48DOLfcZKfk1
	tEV2iFC7vi7A7eMAw==
X-Received: by 2002:a17:903:94e:b0:2db:117e:cf50 with SMTP id d9443c01a7336-2dd6c5bfe2bmr63442775ad.4.1789392712534;
        Mon, 14 Sep 2026 06:31:52 -0700 (PDT)
Received: from thangnn-ASUS.. ([2405:4802:1d4a:e90:380f:6f8c:214d:70f7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd2ceb1c94sm48433875ad.31.2026.09.14.06.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 06:31:51 -0700 (PDT)
From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	mst@redhat.com,
	jasowangio@gmail.com,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com,
	pbonzini@redhat.com,
	stefanha@redhat.com,
	eperezma@redhat.com,
	virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sashiko-bot@kernel.org
Subject: [PATCH v2] scsi: virtio_scsi: implement eh_host_reset_handler
Date: Mon, 14 Sep 2026 20:31:44 +0700
Message-ID: <20260914133144.15509-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <28865bba-ac60-4c6e-aec8-64b1fcdb1c8f@suse.de>
References: <20260911164417.33860-1-ngocthang2710.1999@gmail.com> <28865bba-ac60-4c6e-aec8-64b1fcdb1c8f@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Once virtscsi_eh_timed_out() lets SCSI EH run on an unresponsive host,
abort and device reset both fail the same way (same dead ctrl vq), and
since virtio_scsi implements neither target nor bus reset, EH falls
through to scsi_eh_offline_sdevs(), which frees the stuck commands' DMA
buffers without any guarantee the device has actually stopped touching
them. If bus mastering (or whatever broke the transport) comes back
later, the device can still write into memory the kernel has already
reused.

Add a real eh_host_reset_handler instead. virtio_reset_device() is the
guarantee scsi_eh_offline_sdevs() was missing: once it returns, the
device will not touch guest memory again, so it is safe to hand
outstanding commands' buffers back. Reuse virtscsi_remove_vqs() +
virtscsi_init() -- the exact sequence already used across
suspend/resume -- to tear the virtqueues down and rebuild them.

Verified with a QEMU virtio-scsi repro (PCI_COMMAND_MASTER cleared
mid-write): EH now runs abort -> device reset -> host reset -> abort ->
device reset -> host reset -> offline, then dd's stuck fsync returns
EIO and D-state drains to 0, in ~244s total. No task remains
uninterruptibly blocked.

Suggested-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
---
v1 -> v2: implemented eh_host_reset_handler as suggested by Hannes
Reinecke in review of the original RFC, instead of relying solely on
the EH loop falling through to offline.
---
 drivers/scsi/virtio_scsi.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index b4f20c487718..9698f4f91cc6 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -833,6 +833,8 @@ static enum scsi_timeout_action virtscsi_eh_timed_out(struct scsi_cmnd *scmnd)
 	return SCSI_EH_NOT_HANDLED;
 }
 
+static int virtscsi_host_reset(struct scsi_cmnd *sc);
+
 static const struct scsi_host_template virtscsi_host_template = {
 	.module = THIS_MODULE,
 	.name = "Virtio SCSI HBA",
@@ -846,6 +848,7 @@ static const struct scsi_host_template virtscsi_host_template = {
 	.eh_abort_handler = virtscsi_abort,
 	.eh_device_reset_handler = virtscsi_device_reset,
 	.eh_timed_out = virtscsi_eh_timed_out,
+	.eh_host_reset_handler = virtscsi_host_reset,
 	.sdev_init = virtscsi_device_alloc,
 
 	.dma_boundary = UINT_MAX,
@@ -947,6 +950,27 @@ static int virtscsi_init(struct virtio_device *vdev,
 	return err;
 }
 
+/*
+ * No bus/target reset in virtio-scsi, so EH lands here after device
+ * reset also times out. A virtio reset guarantees the device won't
+ * touch guest memory again, so stuck commands can be freed safely.
+ * Same teardown/rebuild already used for suspend/resume.
+ */
+static int virtscsi_host_reset(struct scsi_cmnd *sc)
+{
+	struct virtio_scsi *vscsi = shost_priv(sc->device->host);
+	struct virtio_device *vdev = vscsi->vdev;
+
+	scmd_printk(KERN_INFO, sc, "host reset\n");
+
+	virtscsi_remove_vqs(vdev);
+	if (virtscsi_init(vdev, vscsi))
+		return FAILED;
+
+	virtio_device_ready(vdev);
+	return SUCCESS;
+}
+
 static int virtscsi_probe(struct virtio_device *vdev)
 {
 	struct Scsi_Host *shost;
-- 
2.43.0

