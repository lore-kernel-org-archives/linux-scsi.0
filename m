Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74234493637
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 15:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788537194; cv=none; b=qWmlDGp991/flx5K5cs3wKZNo6aUo2bDR8kglj0TctOxJVEjxeb9CWLGQ2fI4xJ/wiBSwcXoS/r9dnrqAXAe5qE6scoEJSLQ3YVzV0B+w4NW/qgLffX3QvwIACjHeA3Trf1pkMdxz/MeMstXfJyk5ONOTAFKsqaD8dih7Keup+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788537194; c=relaxed/simple;
	bh=5KUfU2UUZ3fPmA3o93xPIyFBexPShXAE5Elg3/MLXI0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ICrSIi9tGvvOc1YHtFyQ7W9fpcZNhRVFDCFuRH1HTtWurSdAByQb9oNAC1Ayxmxe3vKg7TvpDdgq6+ZgRxGD03W38UyUTPjJMPh2zy+QYUDwjcfMl5EjUZEWN+3DUlb8Uf2FedpZd/TX/BZ32ZQMEqEooeISoY1d1BEwh8Zxf88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YGqbt+qS; arc=none smtp.client-ip=209.85.216.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YGqbt+qS"
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e475f83a2so2165295a91.1
        for <linux-scsi@vger.kernel.org>; Fri, 04 Sep 2026 08:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788537192; x=1789141992; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pt0L+O53/xVVWaghU8W5mtgRgEzuJWx3ygItaBNaDoI=;
        b=YGqbt+qS+5wY17ubQ5x1Kg8vThfV7Vw4gk2cQ773f74jldwXq2WADwq0yy8Y06zHQK
         u0Evd62RedatoonDavbxzP7//6zD4abUvMUOpAozjpFDGMANCdiA/SbOwSgN+T5+mFBA
         qT4ykgR6fd4hXaRcpf0x3sD3CUSe9Isu4MaflY+5IAUMbu1V5f5Iv56nGUZB9S7sTxcJ
         he5zIhFWH7ymmJcdrcv+O+91Kw7lW2jLBNQfpG/E4Jpp5rbYWUFuNKVQ4Bneu6bn9GDX
         KT//8hZVCbwEj/WT5jCKSbuXlq06dzOLDHE0IUreKAV0EM0GBOD+xxkv2FLaVJF+KTHZ
         lyVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788537192; x=1789141992;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Pt0L+O53/xVVWaghU8W5mtgRgEzuJWx3ygItaBNaDoI=;
        b=brXc9LZnr3sASBKhMZ1r2i7vIlvnC7bGilZaiTbALjUrSJjkwrLX0hVPUZ0tE3A37M
         l0gPEbkT2zqeKfpJVK0/FYUZLxiPyU4U9AGcDPn5zdrBpZIXDa0yqpAxxoVuSL69NFhz
         DqfvoTPLO/y8DUgX9hxPgyAlo18uWQ+L2ZT3lepofnZ4NVwNwt0ywwkUBYFH+RGN6S5b
         hsje582NB5icdLl7hvjmgYUPMyAJdxf5GbZNwYTJAJZf2kOOSp7rkYGFWbs4dTva0VDX
         jEaw26kGSDkdlVcc5dOc0i3YUhVRBuwS3PFPJrBRt314AghXAsLAE+qgON/InSpI81YW
         Rcnw==
X-Forwarded-Encrypted: i=1; AKwUvBxtPyELjsCTKyk27fvGugyR2rDM5LaWpepO2S/7Va1mRu8C8CzLNQ9u+CupHO9oL/cDG5/NB0W/zs6K@vger.kernel.org
X-Gm-Message-State: AFuF++kSgoMXhUb76Yhwrt4qRhs0ORgIkRYjY4Uf2cSkAHaW0ld0ieyE
	f7+oOho5ksXBJRVcSisQTB4euyTtaHRV4xm+I8IOE8oC4n2pt6Q32SAvFQipyKuODLEJ4wgpXHx
	GQP2sRgt91o0mE2PtqNnw3w==
X-Received: from pjyp14.prod.google.com ([2002:a17:90a:e70e:b0:395:1a86:4fe8])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:e7ce:b0:398:bacb:1137 with SMTP id 98e67ed59e1d1-39b2624a1bbmr9099604a91.19.1788537191083;
 Fri, 04 Sep 2026 08:53:11 -0700 (PDT)
Date: Fri,  4 Sep 2026 23:53:05 +0800
In-Reply-To: <20260904155307.150443-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260904155307.150443-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260904155307.150443-2-stanleyjhu@google.com>
Subject: [PATCH v2 1/3] rpmb: core: Pin parent device and guard requests with rwsem
From: Stanley Jhu <stanleyjhu@google.com>
To: Jens Wiklander <jens.wiklander@linaro.org>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Brian Kao <brian.kao@mediatek.com>, 
	Brian Kao <powenkao@google.com>, Avri Altman <avri.altman@wdc.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, Stanley Jhu <stanleyjhu@google.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When an RPMB device is unregistered, device_del(&rdev->dev) drops the
driver core's reference to the parent device. If external callers still
hold references to rdev, rdev outlives the parent provider (e.g. UFS
host). Once the parent is freed, subsequent access to rdev->dev.parent
causes a Use-After-Free (UAF).

Additionally, lockless access in rpmb_route_frames() races with parent
teardown, risking frame dispatch against an unpowered or torn-down host.

Fix these issues by explicitly pinning the parent device for the
lifetime of the RPMB device, and guarding in-flight requests against
device unregistration with an rw_semaphore teardown barrier.

Fixes: 1e9046e3a154 ("rpmb: add Replay Protected Memory Block (RPMB) subsystem")
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Cc: stable@vger.kernel.org
---
Changes in v2:
- New patch in v2 addressing cross-subsystem UAF and TOCTOU races (sashiko-bot).
- Pin parent device with get_device() in register and put_device() in release.
- Introduce rw_semaphore and dead flag to serialize in-flight requests.
 drivers/misc/rpmb-core.c | 24 +++++++++++++++++-------
 include/linux/rpmb.h     |  5 +++++
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/rpmb-core.c b/drivers/misc/rpmb-core.c
index ecf14acf230a..c0e19cfe3faa 100644
--- a/drivers/misc/rpmb-core.c
+++ b/drivers/misc/rpmb-core.c
@@ -50,11 +50,21 @@ EXPORT_SYMBOL_GPL(rpmb_dev_put);
 int rpmb_route_frames(struct rpmb_dev *rdev, u8 *req,
 		      unsigned int req_len, u8 *rsp, unsigned int rsp_len)
 {
-	if (!req || !req_len || !rsp || !rsp_len)
+	int ret;
+
+	if (!rdev || !req || !req_len || !rsp || !rsp_len)
 		return -EINVAL;
 
-	return rdev->descr.route_frames(rdev->dev.parent, req, req_len,
-					rsp, rsp_len);
+	down_read(&rdev->lock);
+	if (rdev->dead || !device_is_registered(&rdev->dev)) {
+		up_read(&rdev->lock);
+		return -ENODEV;
+	}
+
+	ret = rdev->descr.route_frames(rdev->dev.parent, req, req_len,
+				       rsp, rsp_len);
+	up_read(&rdev->lock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(rpmb_route_frames);
 
@@ -62,6 +72,7 @@ static void rpmb_dev_release(struct device *dev)
 {
 	struct rpmb_dev *rdev = to_rpmb_dev(dev);
 
+	put_device(rdev->dev.parent);
 	ida_free(&rpmb_ida, rdev->id);
 	kfree(rdev->descr.dev_id);
 	kfree(rdev);
@@ -133,6 +144,10 @@ int rpmb_dev_unregister(struct rpmb_dev *rdev)
 	if (!rdev)
 		return -EINVAL;
 
+	down_write(&rdev->lock);
+	rdev->dead = true;
+	up_write(&rdev->lock);
+
 	device_del(&rdev->dev);
 
 	rpmb_dev_put(rdev);
@@ -164,6 +179,7 @@ struct rpmb_dev *rpmb_dev_register(struct device *dev,
 	rdev = kzalloc_obj(*rdev);
 	if (!rdev)
 		return ERR_PTR(-ENOMEM);
+	init_rwsem(&rdev->lock);
 	rdev->descr = *descr;
 	rdev->descr.dev_id = kmemdup(descr->dev_id, descr->dev_id_len,
 				     GFP_KERNEL);
@@ -179,7 +195,7 @@ struct rpmb_dev *rpmb_dev_register(struct device *dev,
 
 	dev_set_name(&rdev->dev, "rpmb%d", rdev->id);
 	rdev->dev.class = &rpmb_class;
-	rdev->dev.parent = dev;
+	rdev->dev.parent = get_device(dev);
 
 	ret = device_register(&rdev->dev);
 	if (ret) {
diff --git a/include/linux/rpmb.h b/include/linux/rpmb.h
index ed3f8e431eff..2d8a41716883 100644
--- a/include/linux/rpmb.h
+++ b/include/linux/rpmb.h
@@ -7,6 +7,7 @@
 #define __RPMB_H__
 
 #include <linux/device.h>
+#include <linux/rwsem.h>
 #include <linux/types.h>
 
 /**
@@ -48,15 +49,19 @@ struct rpmb_descr {
  * struct rpmb_dev - device which can support RPMB partition
  *
  * @dev              : device
+ * @lock             : protects in-flight operations against teardown
  * @id               : device_id
  * @list_node        : linked list node
  * @descr            : RPMB description
+ * @dead             : set to true when device is unregistered
  */
 struct rpmb_dev {
 	struct device dev;
+	struct rw_semaphore lock;
 	int id;
 	struct list_head list_node;
 	struct rpmb_descr descr;
+	bool dead;
 };
 
 #define to_rpmb_dev(x)		container_of((x), struct rpmb_dev, dev)
-- 
2.55.0.979.g7e5102b832-goog

