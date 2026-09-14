Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E26481247
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 14:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789397360; cv=none; b=oGBYBMiKRYj8V8EjGbNyi0GzzJhW8mCDmCf14oeFkj7zOSCg7jVTQS/JZjSgicGirGW2yI+zlC2ekfr5IXhdwVbU169WnQ7cbZmlHWn4LgPiYOVHoUaAIy8MpsY85eI7WiMT+uRPvt9DQC/tY96Xxp90GfJR/1NyM/M5YwDyOfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789397360; c=relaxed/simple;
	bh=obl2cCjLYsRHvlddO35s9bo6IUhBqtQRCY0KgoD6MBQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JnHe7bvanB4OXAa8Ybkom6aayL205uT5Cw2Se4NtPJLnioeV/1PrbahT9Gl+wdBtUQHcRlAPIFmW1O6SpxJzzm5K2fw8V9uY7o91LfhxVrqzL8QC6ZBTHgTpEpgukACBsP3mFDPlt/52wkIcMheBT8s9ikbHrqefL1Z2RAR/n58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HEoIP9Zu; arc=none smtp.client-ip=209.85.216.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HEoIP9Zu"
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39dfcc20aeaso12979a91.0
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 07:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789397357; x=1790002157; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IOO+RpAv5XBBhPyjNlwP8G1zq2cxe8MeaMUh9XKE/dI=;
        b=HEoIP9Zu8HBt2EJ8sfd1bgbUroI53OVg/AIJXElIVjYSvyXDcsFETULsfSKBrG8+UH
         TEo/5drw/e/eDjs/9NMoJMQBiJ3Wt96FkC/fDtHQ4gB0ldivKfffC+DlP8dZ/MdL7uN/
         ySED9PJyFbn0rPfE1jsDKRCjpIGKvBDBP4DtmMwgqBFycFQBaqTqrOPIWUSWq0kX4VpV
         lQkbRkeywPB3IhI4kMPpG4hFFuKiXrFDQ01FQPDMoxhdCM5tmfvJKvVFOCxzt+yS4Rg2
         Wz3UbM88HI0lGZKEPAAymo+JrRnML93Cxi2bghaKpApjXhkJhaZhvq0yZi/11fgqf5dQ
         70Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789397357; x=1790002157;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IOO+RpAv5XBBhPyjNlwP8G1zq2cxe8MeaMUh9XKE/dI=;
        b=TXc0lKMmKH3vvz5TVNkC7fSDURXdCGTmHh+HkhDxE5ZH6w5/Gp1IbDDeffVW8KPk0c
         H4emK8cjzsK7Ci8YPHPxvz9djjx4ne2gcjuDwFNRGLF8spY3InjLa/4XVxg3jPFca8bS
         fZuyHdrzP4L76cMoctchGx0bhqNzUv7euTc7L2ub/srrBdHaq9A8LS9QKgSwkOhqs6gC
         PAU3lhEjxy6WidS+5GEk5yYWUh0vUk45vl25teEbN5sjQA8GBIpPik4OvjRb/q/gTGkL
         6zC0MPYIs+7NxgmtfipZxQnaKAF+XxbhWyb2cdwfOVvTst/K6I31rO8UdpY54VI2uAyP
         FC6g==
X-Forwarded-Encrypted: i=1; AKwUvBx3CaZOAfjEqeHUehR+NB3t38Yfq16QB0pkG48noN8wgp/rcrsfkus57Ay5/art6LSB8VOOxwTUH+xM@vger.kernel.org
X-Gm-Message-State: AFuF++lZyCaFiX8J9ZwtU7liUyvq6V6n97EKGLzStC02KzbRwc72QlL+
	j4cGco5aac1K3V7yrFLD+AQB0WICzBa9tfoYaPpzcjqSPb3rIs21FfVC4AIMhuF6yiEjnt+Nhv8
	GFnsDWx4VYAfnmWv3B5POCA==
X-Received: from plrb7.prod.google.com ([2002:a17:902:a9c7:b0:2db:45f7:9948])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4b83:b0:39d:f351:8f06 with SMTP id 98e67ed59e1d1-39df351afe2mr3188001a91.14.1789397356254;
 Mon, 14 Sep 2026 07:49:16 -0700 (PDT)
Date: Mon, 14 Sep 2026 22:49:09 +0800
In-Reply-To: <20260914144910.931518-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260914144910.931518-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260914144910.931518-3-stanleyjhu@google.com>
Subject: [PATCH v5 2/3] scsi: ufs: rpmb: Decouple device lifecycle from devres
 to avoid UAF
From: Stanley Jhu <stanleyjhu@google.com>
To: jenswi@kernel.org, mkp@kernel.org
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, bvanassche@acm.org, 
	avri.altman@sandisk.com, alim.akhtar@samsung.com, beanhuo@micron.com, 
	can.guo@oss.qualcomm.com, ulfh@kernel.org, linusw@kernel.org, 
	shyamsaini@linux.microsoft.com, alex.bennee@linaro.org, 
	James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Stanley Jhu <stanleyjhu@google.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

struct ufs_rpmb_dev embeds a struct device but is allocated with
devm_kzalloc() against the host. That makes devres free it when the host
detaches, regardless of the device reference count. Probe takes no
reference on the RPMB well known LU either, so an in-flight request runs
on a freed scsi_device:

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
rpmb_dev_register() makes the rpmb_dev a child of ufs_rpmb->dev, so the
child holds a reference on the parent until rpmb_dev_unregister() runs.
The only caller of rpmb_dev_unregister() is the parent's own release
callback, ufs_rpmb_device_release(). With commit 36f35b8df697 ("driver
core: reject devices with unregistered buses") reverted so that
registration succeeds, all four rpmb_devs are still in /sys/class/rpmb
after the host is unbound and /sys/class/scsi_device is empty.

Tie the memory to the reference count instead:

- allocate with kzalloc_obj(), free in ufs_rpmb_device_release()
- pin the WLUN with scsi_device_get(), drop it in the same callback
- call rpmb_dev_unregister() from ufs_rpmb_remove() and the probe
  unwind, before device_unregister(), so the cycle is broken
- reject requests once the WLUN is offline

Since that commit nothing registers on UFS. On current kernels this
patch has no observable effect on its own; the trace above was taken
with registration restored.

Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
---
 drivers/ufs/core/ufs-rpmb.c | 80 +++++++++++++++++++++----------------
 1 file changed, 45 insertions(+), 35 deletions(-)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index 783ecfc7581d..a3e43902bf08 100644
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
@@ -177,25 +186,26 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
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
@@ -206,16 +216,14 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
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
@@ -226,29 +234,30 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
 
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
 		list_del(&it->node);
+		rpmb_dev_unregister(it->rdev);
 		device_unregister(&it->dev);
 	}
 
@@ -268,6 +277,7 @@ void ufs_rpmb_remove(struct ufs_hba *hba)
 		dev_info(hba->dev, "Removing UFS RPMB region %d\n", ufs_rpmb->region_id);
 		/* Remove from list first */
 		list_del(&ufs_rpmb->node);
+		rpmb_dev_unregister(ufs_rpmb->rdev);
 		/* Unregister device */
 		device_unregister(&ufs_rpmb->dev);
 	}
-- 
2.55.0.1007.g17ff1f9808-goog

