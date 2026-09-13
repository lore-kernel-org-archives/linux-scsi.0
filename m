Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D389F38236F
	for <linux-scsi@vger.kernel.org>; Sun, 13 Sep 2026 03:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789270602; cv=none; b=c2D0UJSrvtDGvc4cxAQ8B57aj/Bb0T5SJ/zJOFAwrAQ3a2oWXzi03SkgyRqJ6DcTNi1FDdO6lli1MAihXKFive7/OGaPvg4dNXUbvTscZ8x7bSx6SHzM6qvAfHjuW+Mqm6tp+rXpV/Zk+Y7nPdqfZhoZscRftfmoluWBzowsvew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789270602; c=relaxed/simple;
	bh=zsX6NYnNsejgjNazlrChC+W6g+2YM7MKSFREvyxN8NA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nBUdtooU0ka5FQN9kFDsueSsZ2c+HG8mmsnkNxDGC5CYbaJLo3hLHivT5mwNQveHN6pYSm1BlekqthTmpRvjiUCyCmJaF4zGdfmCTh7SOENd9JNaHS97PKs5ISrZtzrUEwe/OSYonYXPEYAHdEFDGqaPZGDce7+QEMZeCPPKRos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uVu4OEIP; arc=none smtp.client-ip=209.85.214.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uVu4OEIP"
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2d001671a54so41617155ad.2
        for <linux-scsi@vger.kernel.org>; Sat, 12 Sep 2026 20:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789270599; x=1789875399; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3+n+gxC6c8qCaIycTzSiuzlL3MF13bppr3mewDj0veo=;
        b=uVu4OEIPoMmCWywAwsMZEoj6TeJxyPS2ulx3G5KKbmJwMFy7xm19sXVY/xyLSWwMi+
         Iimv1fxJnLOVnEaKcJ9rW6XJoskvRHOXSBMlrNMxxeZbUbDwbgc/A5K2dXKeSxrKkq18
         gip4Z//WUxghYQCuPKWw9cwwH/4Vj45VGldgY0sw9OQGJHDiRwTwwM3hha1ACV3cVs0G
         fHT+/GKXiDZ8TS1teXM/V8zzrASO681hUcl3x3A9KHSqVczqJIKW/gBqrvvFpN5pGY6z
         Q6zGgUetKCFN+oZP7IjBKYehAIjr8VO3uIB5+epnvYsCnM4UhuIOmrXamCgNzz4H9b/O
         CpQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789270599; x=1789875399;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3+n+gxC6c8qCaIycTzSiuzlL3MF13bppr3mewDj0veo=;
        b=MaopeJ6efAwXsoFWr9flx13O3GL766Iycyk36lS93IHCSfOmzoO9HCkloWD6O8lBoC
         3PjlYxN669xT0HCL4qeDvHN/4grpgVms7ZXZ97NTk7gG2wp+9ZqD1+NSJjH0zkwDji6a
         0fJ4XZPyH6IQET4GzwQxbrjxjiOYbN3qBDCi+9MB39cjGdBcCff7BJxqdS+/5JaN00Ij
         94NsAoeRnLHdkwNUBKWTahCWmYd1AL7PU17dadfmoVTe5zbDwYdtkS16E0fItNV2pSQq
         TIzl2qAmVL8dU0v1KJpHMT6KF6AgZafCyAj9uyYLoyVIdnZnVyhGZhPVGfrao2XaKCJF
         xJBw==
X-Forwarded-Encrypted: i=1; AKwUvBxa6hzwSuB4yYmtqh0xxs3rYtDWlwu4KOQq2nOCn9RJin0vvpDq3h2+plisCgvm2r/2RoR2WAEBE3nl@vger.kernel.org
X-Gm-Message-State: AFuF++m1BcBGSjJ4lAf8j9L+7HD5IYPPotC9sj7lQl6H0fKlybfrjN0x
	OAUqJwihvofL+lH0N2JKjjg/hKIcdnRpiaYZRSkple+rX2NJRsBkw6fIwzMuyiQD4GoXy0SYcc7
	pqq8hQKLeQJEApkCyRCs/xA==
X-Received: from pjbgb3.prod.google.com ([2002:a17:90b:603:b0:39d:a358:fc00])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2588:b0:36a:5d1f:7b6 with SMTP id 98e67ed59e1d1-39dbbe87b09mr9428532a91.2.1789270598806;
 Sat, 12 Sep 2026 20:36:38 -0700 (PDT)
Date: Sun, 13 Sep 2026 11:36:32 +0800
In-Reply-To: <20260913033633.3159296-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260913033633.3159296-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260913033633.3159296-3-stanleyjhu@google.com>
Subject: [PATCH v4 2/3] scsi: ufs: rpmb: Decouple device lifecycle from devres
 to avoid UAF
From: Stanley Jhu <stanleyjhu@google.com>
To: jenswi@kernel.org, mkp@kernel.org
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, bvanassche@acm.org, 
	avri.altman@sandisk.com, alim.akhtar@samsung.com, beanhuo@micron.com, 
	can.guo@oss.qualcomm.com, ulfh@kernel.org, linusw@kernel.org, 
	tomas.winkler@intel.com, shyamsaini@linux.microsoft.com, 
	alex.bennee@linaro.org, James.Bottomley@HansenPartnership.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

struct ufs_rpmb_dev embeds a struct device but is allocated with
devm_kzalloc() against the host controller. devres frees that memory
when the host driver detaches, regardless of the device reference count,
and probe takes no reference on the RPMB well known LU either. An
in-flight request then runs on a freed scsi_device:

  BUG: KASAN: slab-use-after-free in scsi_execute_cmd+0x998/0xab0
  Read of size 8 at addr fff00000c82d4008 by task rpmb_hold/100
  Call trace:
   scsi_execute_cmd+0x998/0xab0
   ufs_sec_submit.isra.0+0x110/0x150
   ufs_rpmb_route_frames+0x148/0x460
   rpmb_route_frames+0x64/0xd0
  Freed by task 1:
   kfree+0x2b8/0x5c4
   scsi_device_dev_release+0x6b8/0xb7c
   __scsi_remove_device+0x1c8/0x318
   scsi_remove_host+0xc0/0x258
   ufshcd_remove+0x1c0/0x22c

The release callback cannot clean this up, because it never runs.
rpmb_dev_register() makes the rpmb_dev a child of ufs_rpmb->dev, so
device_add() holds a reference on the parent. ufs_rpmb_remove() only
calls device_unregister() on that parent, whose count therefore never
reaches zero, and ufs_rpmb_device_release() is the only caller of
rpmb_dev_unregister().

Tie the memory to the reference count instead:

- allocate with kzalloc_obj() and free with kfree() in
  ufs_rpmb_device_release()
- pin the SCSI WLUN with scsi_device_get() in probe and release it with
  scsi_device_put() in the release callback
- call rpmb_dev_unregister() from ufs_rpmb_remove() and from the probe
  error unwind, before device_unregister(), so the cycle is broken
- reject requests once the WLUN is offline, rather than submitting to a
  device that SCSI has already removed

On its own this patch changes nothing observable: device_register()
still fails because the ufs_rpmb bus is never registered, so no RPMB
device exists. The next patch removes that bus, and the trace above was
taken with both applied. The ordering is deliberate: no commit in this
series enables RPMB registration before the lifetime handling is
correct.

Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices")
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufs-rpmb.c | 97 +++++++++++++++++++++----------------
 1 file changed, 55 insertions(+), 42 deletions(-)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index 783ecfc7581d..373b60aba916 100644
--- a/drivers/ufs/core/ufs-rpmb.c
+++ b/drivers/ufs/core/ufs-rpmb.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/rpmb.h>
 #include <linux/string.h>
@@ -36,13 +37,14 @@ struct ufs_rpmb_dev {
 	u8 region_id;
 	struct device dev;
 	struct rpmb_dev *rdev;
-	struct ufs_hba *hba;
+	struct scsi_device *sdev;
 	struct list_head node;
 };
 
-static int ufs_sec_submit(struct ufs_hba *hba, u16 spsp, void *buffer, size_t len, bool send)
+static int ufs_sec_submit(struct ufs_rpmb_dev *ufs_rpmb, u16 spsp,
+			  void *buffer, size_t len, bool send)
 {
-	struct scsi_device *sdev = hba->ufs_rpmb_wlun;
+	struct scsi_device *sdev = ufs_rpmb->sdev;
 	struct scsi_failure failure_defs[] = {
 		{
 			.sense = UNIT_ATTENTION,
@@ -61,6 +63,9 @@ static int ufs_sec_submit(struct ufs_hba *hba, u16 spsp, void *buffer, size_t le
 	};
 	u8 cdb[12] = { };
 
+	if (!sdev || !scsi_device_online(sdev))
+		return -ENODEV;
+
 	cdb[0] = send ? SECURITY_PROTOCOL_OUT : SECURITY_PROTOCOL_IN;
 	cdb[1] = UFS_RPMB_SEC_PROTOCOL;
 	put_unaligned_be16(spsp, &cdb[2]);
@@ -73,13 +78,12 @@ static int ufs_sec_submit(struct ufs_hba *hba, u16 spsp, void *buffer, size_t le
 
 /* UFS RPMB route frames implementation */
 static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_len, u8 *resp,
-					unsigned int resp_len)
+				 unsigned int resp_len)
 {
 	struct ufs_rpmb_dev *ufs_rpmb = dev_get_drvdata(dev);
 	struct rpmb_frame *frm_out = (struct rpmb_frame *)req;
 	bool need_result_read = true;
 	u16 req_type, protocol_id;
-	struct ufs_hba *hba;
 	int ret;
 
 	if (!ufs_rpmb) {
@@ -87,8 +91,6 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 		return -ENODEV;
 	}
 
-	hba = ufs_rpmb->hba;
-
 	/* req_resp is at the end of an RPMB frame. */
 	if (req_len < sizeof(*frm_out))
 		return -EINVAL;
@@ -121,7 +123,7 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 
 	protocol_id = ufs_rpmb->region_id << 8 | UFS_RPMB_SEC_PROTOCOL_ID;
 
-	ret = ufs_sec_submit(hba, protocol_id, req, req_len, true);
+	ret = ufs_sec_submit(ufs_rpmb, protocol_id, req, req_len, true);
 	if (ret) {
 		dev_err(dev, "Command failed with ret=%d\n", ret);
 		return ret;
@@ -132,7 +134,7 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 
 		memset(frm_resp, 0, sizeof(*frm_resp));
 		put_unaligned_be16(RPMB_RESULT_READ, &frm_resp->req_resp);
-		ret = ufs_sec_submit(hba, protocol_id, resp, resp_len, true);
+		ret = ufs_sec_submit(ufs_rpmb, protocol_id, resp, resp_len, true);
 		if (ret) {
 			dev_err(dev, "Result read request failed with ret=%d\n", ret);
 			return ret;
@@ -140,7 +142,7 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 	}
 
 	if (!ret) {
-		ret = ufs_sec_submit(hba, protocol_id, resp, resp_len, false);
+		ret = ufs_sec_submit(ufs_rpmb, protocol_id, resp, resp_len, false);
 		if (ret)
 			dev_err(dev, "Response read failed with ret=%d\n", ret);
 	}
@@ -150,23 +152,30 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 
 static void ufs_rpmb_device_release(struct device *dev)
 {
-	struct ufs_rpmb_dev *ufs_rpmb = dev_get_drvdata(dev);
+	struct ufs_rpmb_dev *ufs_rpmb = container_of(dev, struct ufs_rpmb_dev, dev);
 
-	rpmb_dev_unregister(ufs_rpmb->rdev);
+	scsi_device_put(ufs_rpmb->sdev);
+	kfree(ufs_rpmb);
 }
 
 /* UFS RPMB device registration */
 int ufs_rpmb_probe(struct ufs_hba *hba)
 {
+	struct rpmb_descr descr = {
+		.type = RPMB_TYPE_UFS,
+		.route_frames = ufs_rpmb_route_frames,
+		.reliable_wr_count = hba->dev_info.rpmb_io_size,
+	};
+	struct scsi_device *sdev = hba->ufs_rpmb_wlun;
 	struct ufs_rpmb_dev *ufs_rpmb, *it, *tmp;
 	u8 dev_id[UFS_RPMB_ID_LEN];
 	struct rpmb_dev *rdev;
-	char *cid = NULL;
+	char *cid;
 	int region;
 	u32 cap;
 	int ret;
 
-	if (!hba->ufs_rpmb_wlun || hba->dev_info.b_advanced_rpmb_en) {
+	if (!sdev || hba->dev_info.b_advanced_rpmb_en) {
 		dev_info(hba->dev, "Skip OP-TEE RPMB registration\n");
 		return -ENODEV;
 	}
@@ -177,25 +186,28 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
 		return -EINVAL;
 	}
 
-	struct rpmb_descr descr = {
-		.type = RPMB_TYPE_UFS,
-		.route_frames = ufs_rpmb_route_frames,
-		.reliable_wr_count = hba->dev_info.rpmb_io_size,
-	};
-
 	for (region = 0; region < ARRAY_SIZE(hba->dev_info.rpmb_region_size); region++) {
 		cap = hba->dev_info.rpmb_region_size[region];
 		if (!cap)
 			continue;
 
-		ufs_rpmb = devm_kzalloc(hba->dev, sizeof(*ufs_rpmb), GFP_KERNEL);
+		ufs_rpmb = kzalloc_obj(*ufs_rpmb);
 		if (!ufs_rpmb) {
 			ret = -ENOMEM;
 			goto err_out;
 		}
 
-		ufs_rpmb->hba = hba;
-		ufs_rpmb->dev.parent = &hba->ufs_rpmb_wlun->sdev_gendev;
+		INIT_LIST_HEAD(&ufs_rpmb->node);
+
+		ret = scsi_device_get(sdev);
+		if (ret) {
+			kfree(ufs_rpmb);
+			goto err_out;
+		}
+
+		ufs_rpmb->sdev = sdev;
+		ufs_rpmb->region_id = region;
+		ufs_rpmb->dev.parent = &sdev->sdev_gendev;
 		ufs_rpmb->dev.bus = &ufs_rpmb_bus_type;
 		ufs_rpmb->dev.release = ufs_rpmb_device_release;
 		dev_set_name(&ufs_rpmb->dev, "ufs_rpmb%d", region);
@@ -206,16 +218,14 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
 		ret = device_register(&ufs_rpmb->dev);
 		if (ret) {
 			dev_err(hba->dev, "Failed to register UFS RPMB device %d\n", region);
-			put_device(&ufs_rpmb->dev);
-			goto err_out;
+			goto err_put;
 		}
 
 		/* Create unique ID by appending region number to device_id */
 		cid = kasprintf(GFP_KERNEL, "%s-R%d", hba->dev_info.device_id, region);
 		if (!cid) {
-			device_unregister(&ufs_rpmb->dev);
 			ret = -ENOMEM;
-			goto err_out;
+			goto err_unreg;
 		}
 
 		blake2b(NULL, 0, cid, strlen(cid), dev_id, UFS_RPMB_ID_LEN);
@@ -226,29 +236,33 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
 
 		/* Register RPMB device */
 		rdev = rpmb_dev_register(&ufs_rpmb->dev, &descr);
+		kfree(cid);
 		if (IS_ERR(rdev)) {
 			dev_err(hba->dev, "Failed to register UFS RPMB device.\n");
-			device_unregister(&ufs_rpmb->dev);
 			ret = PTR_ERR(rdev);
-			goto err_out;
+			goto err_unreg;
 		}
 
-		kfree(cid);
-		cid = NULL;
-
 		ufs_rpmb->rdev = rdev;
-		ufs_rpmb->region_id = region;
-
 		list_add_tail(&ufs_rpmb->node, &hba->rpmbs);
 
 		dev_info(hba->dev, "UFS RPMB region %d registered (capacity=%u)\n", region, cap);
 	}
 
 	return 0;
+
+err_unreg:
+	device_unregister(&ufs_rpmb->dev);
+	goto err_out;
+err_put:
+	put_device(&ufs_rpmb->dev);
 err_out:
-	kfree(cid);
 	list_for_each_entry_safe(it, tmp, &hba->rpmbs, node) {
-		list_del(&it->node);
+		list_del_init(&it->node);
+		if (it->rdev) {
+			rpmb_dev_unregister(it->rdev);
+			it->rdev = NULL;
+		}
 		device_unregister(&it->dev);
 	}
 
@@ -265,14 +279,13 @@ void ufs_rpmb_remove(struct ufs_hba *hba)
 
 	/* Remove all registered RPMB devices */
 	list_for_each_entry_safe(ufs_rpmb, tmp, &hba->rpmbs, node) {
-		dev_info(hba->dev, "Removing UFS RPMB region %d\n", ufs_rpmb->region_id);
-		/* Remove from list first */
-		list_del(&ufs_rpmb->node);
-		/* Unregister device */
+		list_del_init(&ufs_rpmb->node);
+		if (ufs_rpmb->rdev) {
+			rpmb_dev_unregister(ufs_rpmb->rdev);
+			ufs_rpmb->rdev = NULL;
+		}
 		device_unregister(&ufs_rpmb->dev);
 	}
-
-	dev_info(hba->dev, "All UFS RPMB devices unregistered\n");
 }
 
 MODULE_LICENSE("GPL v2");
-- 
2.55.0.1007.g17ff1f9808-goog

