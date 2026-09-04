Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2164D48C8A5
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 11:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788519624; cv=none; b=CZ9GUD+fhb7+8yBuijzpQnlrvqB3K0MmuSuqjou3oaGMnfNJZumJ6Kkxd+iCVFlhMYoGyBrmF5HgRpRBhgxcWb5PSWf6GNoDVmqRxhm9ukNPPHudiu03WdGFjHdQT7PwEEyK3gFUa/I5ulOL2CnRIp/okRDrmgzV5WgfDwM3Org=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788519624; c=relaxed/simple;
	bh=zV+id8hgrmOYZ2zkH5wVp805A1ipbO2BAvtEYS6rNqM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZIMMYggAgPpYZNUjb75QIo0JqHe/I8zQQXqWBrgj88rZ4vDnWeilS+USZbqWyH8a2kN/6Xa2cXSZ5c5dmniY12sv/ss9WgD/IoVC8XXAsQInQdwfzSpNscaTuQ8NwmrPGxZlyKLWL3Ys1UmCS5WzYqeAu+1KipzJ8xDzOHXcSyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PtALMpdO; arc=none smtp.client-ip=209.85.216.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PtALMpdO"
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3968bb86fb7so1227176a91.2
        for <linux-scsi@vger.kernel.org>; Fri, 04 Sep 2026 04:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788519621; x=1789124421; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u84Mc5AIsSgNc1vzS18uPhdCuLSJJI70tZiWSF1FywQ=;
        b=PtALMpdOrBUcZkbWuQoAlZxwXACb00sfkDVO2LRqht2VnDzK+LwEMpRls0xzylDt/i
         dhufOY9+M8iZXakodqdtL2KtCKYlWVuCRF1mClwY7sW8eN0sf9vbJlcsoVr9eB5Of8J3
         bv0Mro6oX+1DwhGz8V7Lc0BKaoqnDEY5ubOkJun+A2D2KFxEIizb6zmU1kD4KhZ8omay
         oKsL4KgRz7gTxgF5+PggaUBwnyiJxeD8UQgbAarlYs0cJVYqfqE3jH0KzwJ39O7yW9VO
         D3YRZ5dQ6n8M3NfMV3myAM2tMBD1plw2WL1yPQMjHIKr7V0KaNIDLmSyg40IHXrPqQXT
         dJrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788519621; x=1789124421;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u84Mc5AIsSgNc1vzS18uPhdCuLSJJI70tZiWSF1FywQ=;
        b=FV6FJeUVMy6IDxgVEPuFGjRWP2AkZFuHHg4K4WShk3pKeLF/SSCLH5rFphOQR6hNsZ
         fXxH+xgJ2zIGJf01LPfGd5wrk7qN6sVV3G2e1ctSZv1HT5lPUQCgCmxYwX5n0ZLlhnwX
         t4zmerfNlH9W2oo18H71V0QoYYA2husXbD8l+KVZqSc+lp8mu6BDKTBefBk5LvsLt5Bx
         rjfx9PJWdAODoT8lcH/JibCV7REeGRxlO0UnvxzR7tC534I9QrrOyf6iDfmhDbQhGeFD
         SE75Fo4bOaQe9JMXyeVtuabP179vSaNjKtCuRpy8IcZCcEywfyxvirPfvc08ir0nthDm
         /Yiw==
X-Forwarded-Encrypted: i=1; AKwUvBw84WtKxlCanfbJqSS/B2Xs9CE+Ozn68Vugtb5XGlHju5VeD31RRwyHq3IwkJiIF4OCCIgSLEZSAthT@vger.kernel.org
X-Gm-Message-State: AFuF++kKeG6vzTKApWCk/BPdJN6L0iTHCNGm4x9BCc/dobPp7M5vKVZ8
	bkfWV+iWIbJajCDACMzIPdWs9UdRXlxP7Gd8nSSR/60xWkJralJRp3ytweUpt/g9QjGO+S1lC0h
	r2ZtuqcTpe2HxIvQv7FsJAg==
X-Received: from pjye12.prod.google.com ([2002:a17:90a:ee0c:b0:39b:1aab:f8c3])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2ccf:b0:398:a2a3:b631 with SMTP id 98e67ed59e1d1-39b262aaf3dmr8893505a91.19.1788519621001;
 Fri, 04 Sep 2026 04:00:21 -0700 (PDT)
Date: Fri,  4 Sep 2026 19:00:16 +0800
In-Reply-To: <20260904110017.3444852-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260904110017.3444852-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260904110017.3444852-2-stanleyjhu@google.com>
Subject: [PATCH 1/2] scsi: ufs: rpmb: Decouple device lifecycle from devres to
 avoid UAF
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Brian Kao <powenkao@google.com>, Bean Huo <beanhuo@micron.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@sandisk.com>, Can Guo <can.guo@oss.qualcomm.com>, 
	Peter Wang <peter.wang@mediatek.com>, linux-kernel@vger.kernel.org, 
	Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

The UFS RPMB driver suffers from three architectural lifetime flaws:

1. Lifecycle mismatch:
   The driver allocates struct ufs_rpmb_dev via devres tied to the
   parent controller, even though it embeds a struct device. A struct
   device's lifetime must be governed by its own reference count.
   When the controller unbinds, devres prematurely frees the memory
   while references (such as sysfs nodes or userspace file descriptors)
   remain active, triggering a use-after-free (UAF) Oops:
     "Unable to handle kernel paging request at virtual address
      0x006b6b6b6b6b6b9c"

2. Unpinned transport hierarchy:
   The RPMB device relies on the underlying SCSI WLUN and host
   controller for command submission, but does not acquire a reference
   to the SCSI device. Unbinding the controller during in-flight I/O
   dereferences destroyed SCSI structures.

3. Inverted teardown and error handling:
   Subsystem registration is conflated with device memory lifecycle.
   The device release callback improperly attempts subsystem teardown,
   while driver removal and probe error paths unregister the driver
   core device without first unregistering from the RPMB subsystem.

To resolve these issues, align the driver with standard kernel device
model principles:

1. Reference-counted lifecycle:
   Decouple ufs_rpmb from devres. Manage its memory strictly through the
   embedded struct device's reference count, freeing it only in the
   device release callback.

2. Topological pinning:
   Pin the underlying SCSI device for the duration of the RPMB device's
   existence, ensuring the SCSI host hierarchy remains valid until all
   references to the RPMB device are dropped.

3. Symmetrical teardown and state validation:
   Unregister subsystem interfaces before driver core devices, correct
   error rollback paths, initialize fields before exposing the device
   to userspace, and reject requests if the underlying device goes
   offline.

Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices")
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufs-rpmb.c | 86 +++++++++++++++++++++----------------
 1 file changed, 50 insertions(+), 36 deletions(-)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index aa925cbb07e8..4f41d0b64d20 100644
--- a/drivers/ufs/core/ufs-rpmb.c
+++ b/drivers/ufs/core/ufs-rpmb.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/rpmb.h>
 #include <linux/string.h>
@@ -33,15 +34,19 @@ struct ufs_rpmb_dev {
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
 	u8 cdb[12] = { };
 
+	if (!sdev || !scsi_device_online(sdev))
+		return -ENODEV;
+
 	cdb[0] = send ? SECURITY_PROTOCOL_OUT : SECURITY_PROTOCOL_IN;
 	cdb[1] = UFS_RPMB_SEC_PROTOCOL;
 	put_unaligned_be16(spsp, &cdb[2]);
@@ -53,13 +58,12 @@ static int ufs_sec_submit(struct ufs_hba *hba, u16 spsp, void *buffer, size_t le
 
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
@@ -67,8 +71,6 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 		return -ENODEV;
 	}
 
-	hba = ufs_rpmb->hba;
-
 	/* req_resp is at the end of an RPMB frame. */
 	if (req_len < sizeof(*frm_out))
 		return -EINVAL;
@@ -101,7 +103,7 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 
 	protocol_id = ufs_rpmb->region_id << 8 | UFS_RPMB_SEC_PROTOCOL_ID;
 
-	ret = ufs_sec_submit(hba, protocol_id, req, req_len, true);
+	ret = ufs_sec_submit(ufs_rpmb, protocol_id, req, req_len, true);
 	if (ret) {
 		dev_err(dev, "Command failed with ret=%d\n", ret);
 		return ret;
@@ -112,7 +114,7 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 
 		memset(frm_resp, 0, sizeof(*frm_resp));
 		put_unaligned_be16(RPMB_RESULT_READ, &frm_resp->req_resp);
-		ret = ufs_sec_submit(hba, protocol_id, resp, resp_len, true);
+		ret = ufs_sec_submit(ufs_rpmb, protocol_id, resp, resp_len, true);
 		if (ret) {
 			dev_err(dev, "Result read request failed with ret=%d\n", ret);
 			return ret;
@@ -120,7 +122,7 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 	}
 
 	if (!ret) {
-		ret = ufs_sec_submit(hba, protocol_id, resp, resp_len, false);
+		ret = ufs_sec_submit(ufs_rpmb, protocol_id, resp, resp_len, false);
 		if (ret)
 			dev_err(dev, "Response read failed with ret=%d\n", ret);
 	}
@@ -130,22 +132,24 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 
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
+	struct scsi_device *sdev = hba->ufs_rpmb_wlun;
 	struct ufs_rpmb_dev *ufs_rpmb, *it, *tmp;
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
@@ -167,14 +171,23 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
 		if (!cap)
 			continue;
 
-		ufs_rpmb = devm_kzalloc(hba->dev, sizeof(*ufs_rpmb), GFP_KERNEL);
+		ufs_rpmb = kzalloc(sizeof(*ufs_rpmb), GFP_KERNEL);
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
@@ -185,16 +198,14 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
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
 
 		descr.dev_id = cid;
@@ -203,29 +214,33 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
 
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
 
@@ -242,14 +257,13 @@ void ufs_rpmb_remove(struct ufs_hba *hba)
 
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
2.55.0.979.g7e5102b832-goog

