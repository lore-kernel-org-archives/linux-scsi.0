Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194B13D47B2
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 01:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788227239; cv=none; b=JcRXUxSkrufgqa7u0bAMv+uQCPO2pIw//5osnpvULfnwYMN8N5uGwX3ztkwDL95JVLx0S+ShCpXfSpmrW/pgAxJaX62MN4x2O9x8fGcMgUnXrxdmZuQBv75FLSnmbgKBQCDzl4Yiz4CmrdkKRM2ryroXD6TVoeCW152faY+2VNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788227239; c=relaxed/simple;
	bh=AJU7kvyec/8/K9axi/CdS+dyi0PDMEtj+kkrf6c8WHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjhbgKXHvK/TJB7AmfyT4+WVOn6FoYDPhJXk1aNBopFWurFIObAFnDRzr02jI1ak1p9ItJ9TFTh0AVV8T02k4SkVuRUb82M1GVvoNxfIpLH49LGw3l/vVC2AQrNyPcddQLqKp0MX6O51torjq+TfGUDxd3nVqcBrLUQ7pAFwT0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aftDzsKw; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aftDzsKw"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-ca766c1c9ccso2858270a12.0
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 18:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788227223; x=1788832023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qn8m16h1ZIsyZncr3xk0OF7gEb6fuaXwGCP5imv6Fmk=;
        b=aftDzsKwLy38gnwzTgIZJlYhxtJXe8OFHjC0/6kqUfaVI2+iSJvRs5hjUnLQO7jD2n
         xJXsKa/OKG3s7jW0jbmk7yvOyCGLFCVSMIfLnyS4n3QqeKW/XUqclYQ9pG+psxcG1sPu
         oJLt/ITlK0J7rMneK90kZtf9JUV6VttNmyG4Hov6uvmkD1z+Me0agyL+f/GoGYIAFcKp
         7N5F6RmVCyDUPuNnyJs1l9tey8l6uJqvSDO1+DTkOsvrmZ65eF+0D/uRpy5EmAUbsclz
         uWVWVwHqfQuD18czju3DGECWL5Je/gaNLuK5hjZPBs9VqkHc8rZbeW4qxoctQrg09/WZ
         6UoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788227223; x=1788832023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qn8m16h1ZIsyZncr3xk0OF7gEb6fuaXwGCP5imv6Fmk=;
        b=QqKEn4H/e6jWZWP/k1UTpdJxSzVmpC7vpss943rPv2VZBcHa+VKcoL0JsYBlxJ5QVb
         U+ke0w8rqrTkzMURPYaCxBHbVVYZZJdJlPVFdKXb7pyReUHueMgc/06kyOANBmHWk7+O
         yNXb67YyNcEOSyLD4o9DUP5Zoxd325rtgwY1/FzwWmrpkudYfi4Ceyw+ViS7AJaZcbF1
         6hwXNaqX8uq0K0wXle+AL00++e7t/TRxec+Zr0gVdTKRbGISqd0fN0yYiAwvnarYxSWW
         WV9WZfCiDwO+2fsV3pUAHTHzF6qzl7iAds2zKbK1lYwCiZnoKVrIs9yyZd1N8FTssR1+
         jD1g==
X-Forwarded-Encrypted: i=1; AKwUvBxK0b+MYs16MV7jKGtRwLvkNz6wf61/bpGVYAYp9aLrFi6F2dnJeCtnu+YWLO9aIYLEDBqo31cRLlS0@vger.kernel.org
X-Gm-Message-State: AFuF++mhSnDk/H7I3gj03XTmijQTRK+OSAHDIYXkJ1Xe59+ii+7izL6I
	vOFDwd4/JjOcz86A4qAGeWt6I7QoLzIIXhvjP0ps9pvkHPnVrb/K2bxe
X-Gm-Gg: AYBFou3jzwV547LRHg/uWMSFmZr/bJn26t0Hs0M6+tt7OuNZe1JhpsECa7mgapjJD9E
	2zdqdQ88pGPTYqMEKqXvIaxjKmq5FcKhd5AdR8HqzD3E6WRUHikx4tm+776wqnvxqUiJm9YyDkX
	QMv4yzCwBbW4/V3nG8RZtDApD5JWQ2s6jagQEJlT+KAEacczqLJMMWRcXrCi74zzZEvL9OkqSUe
	om4PBaVSKER2PGLN2S9LBNYGpa69d7d/sU3i7v0HrXUUwDsPs5ynqBhTdJocz6Y9LGeT7RwWHJB
	XP7ps7tbsP4//lfMfDiOxQ3jQ+zAj1Bh9+LRWAL7znrzGrMifJqVtLIV9iAlVD5B1H/GzPdsGT5
	9vcx3XGRQCdvgfhukM6bud0sEZLTKZg13OxHJr2MEF1A92BxRjBH7RaqJY7MbsbFmxd/zyA2vK9
	FA9J2KXusAZmL3NMZYf/yhvbAZQr+ZUlO11o/wzRs9k1k+n5v8LmeouxdcDk2hc8d1ztm/F3qus
	1jG1PANAk1aCBUl
X-Received: by 2002:a17:90b:57cf:b0:398:d132:ba76 with SMTP id 98e67ed59e1d1-398d132c2e0mr19648664a91.21.1788227223247;
        Mon, 31 Aug 2026 18:47:03 -0700 (PDT)
Received: from toolbx.alistair23.me ([2403:581e:fdf9:0:13b2:851f:d9cb:44c5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990d62b807sm2561122a91.16.2026.08.31.18.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 18:47:02 -0700 (PDT)
From: alistair23@gmail.com
X-Google-Original-From: alistair.francis@wdc.com
To: mst@redhat.com,
	eperezma@redhat.com,
	linux-kernel@vger.kernel.org,
	xuanzhuo@linux.alibaba.com,
	jasowangio@gmail.com,
	linux-scsi@vger.kernel.org,
	mkp@kernel.org,
	virtualization@lists.linux.dev,
	James.Bottomley@HansenPartnership.com
Cc: alistair@alistair23.me,
	Alistair Francis <alistair.francis@wdc.com>
Subject: [PATCH 1/2] virtio_pci: Add a quirk to force DMA Map API for certain legacy devices
Date: Tue,  1 Sep 2026 11:46:49 +1000
Message-ID: <20260901014650.2728658-2-alistair.francis@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901014650.2728658-1-alistair.francis@wdc.com>
References: <20260901014650.2728658-1-alistair.francis@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alistair Francis <alistair.francis@wdc.com>

Legacy virtio devices only have 32 feature bits and therefore can't
set the VIRTIO_F_ACCESS_PLATFORM (bit 33) feature. This means the
vring_use_map_api() function will return false.

Currently Linux endpoint devices use the legacy virtio interface as
they aren't able to advertise the Common configuration capability.
As most PCI endpoint capable PCIe controllers do not allow modifying the
capability list, and thus are unable to advertise the Common configuration
capability. This means the device's inbound TLPs fault on the host
SMMU because the vring descriptors carry raw physical addresses.

This quirk forces a subset of legacy virtio devices to use the
DMA Map API (vring_use_map_api() will return true), which fixes this
issue.

This doesn't affect existing devices as we are checking for an
otherwise invalid vendor ID.

Ideally we would update the endpoint devices (like scsi-pci-epf)
to not use the legacy virtio interface, but lots of endpoint
hardware (like the one in the RK3588) doesn't allow us to add
custom capabilities.

Signed-off-by: Alistair Francis <alistair.francis@wdc.com>
---
 drivers/virtio/virtio_pci_legacy.c | 27 +++++++++++++++++++++++++++
 drivers/virtio/virtio_ring.c       |  7 +++++++
 include/linux/virtio.h             |  5 +++++
 3 files changed, 39 insertions(+)

diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
index d9cbb02b35a1..7b529bd451bb 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -16,6 +16,7 @@
 
 #include "linux/virtio_pci_legacy.h"
 #include "virtio_pci_common.h"
+#include <linux/virtio_ids.h>
 
 /* virtio config->get_features() implementation */
 static u64 vp_get_features(struct virtio_device *vdev)
@@ -220,6 +221,32 @@ int virtio_pci_legacy_probe(struct virtio_pci_device *vp_dev)
 
 	vp_dev->vdev.config = &virtio_pci_config_ops;
 
+	/*
+	 * Legacy virtio devices only have 32 feature bits and therefore can't
+	 * set the VIRTIO_F_ACCESS_PLATFORM (bit 33) feature. This means the
+	 * vring_use_map_api() function will return false.
+	 *
+	 * Currently Linux endpoint devices use the legacy virtio interface as
+	 * they aren't able to advertise the Common configuration capability.
+	 * This means the device's inbound TLPs fault on the host SMMU because
+	 * the vring descriptors carry raw physical addresses.
+	 *
+	 * This quirk forces a subset of legacy virtio devices to use the
+	 * DMA Map API (vring_use_map_api() will return true), which fixes this
+	 * issue.
+	 *
+	 * This doesn't affect existing devices as we are checking for an
+	 * otherwise invalid vendor ID.
+	 *
+	 * Ideally we would update the endpoint devices (like scsi-pci-epf)
+	 * to not use the legacy virtio interface, but lots of endpoint
+	 * hardware (like the one in the RK3588) doesn't allow us to add
+	 * custom capabilities.
+	 */
+	if (pci_dev->subsystem_vendor == 0xFFFF &&
+	    pci_dev->subsystem_device == VIRTIO_ID_SCSI)
+		vp_dev->vdev.force_use_map_api = true;
+
 	vp_dev->config_vector = vp_config_vector;
 	vp_dev->setup_vq = setup_vq;
 	vp_dev->del_vq = del_vq;
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 5c169fbb418a..c8f62180c9d3 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -384,6 +384,13 @@ static bool vring_use_map_api(const struct virtio_device *vdev)
 	if (!virtio_has_dma_quirk(vdev))
 		return true;
 
+	/*
+	 * A quirk set by certain legacy devices to force us to
+	 * pretend the VIRTIO_F_ACCESS_PLATFORM feature is enabled.
+	 */
+	if (vdev->force_use_map_api)
+		return true;
+
 	/* Otherwise, we are left to guess. */
 	/*
 	 * In theory, it's possible to have a buggy QEMU-supposed
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index f923e42cfd01..305c331f33f1 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -151,6 +151,10 @@ struct virtio_admin_cmd {
  * @config_driver_disabled: configuration change reporting disabled by
  *                          a driver
  * @config_change_pending: configuration change reported while disabled
+ * @force_use_map_api: A quirk set by certain legacy devices to force us
+ *                     to pretend the VIRTIO_F_ACCESS_PLATFORM feature is
+ *                     enabled. Set by transports that have no way to
+ *                     negotiate ACCESS_PLATFORM but sit behind a real IOMMU.
  * @config_lock: protects configuration change reporting
  * @vqs_list_lock: protects @vqs.
  * @dev: underlying device.
@@ -173,6 +177,7 @@ struct virtio_device {
 	bool config_core_enabled;
 	bool config_driver_disabled;
 	bool config_change_pending;
+	bool force_use_map_api;
 	spinlock_t config_lock;
 	spinlock_t vqs_list_lock;
 	struct device dev;
-- 
2.55.0

