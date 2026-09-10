Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C29833F368
	for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 01:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789005318; cv=none; b=XgssV/5RjFXzTxxnBsnr4oqe6UHc/a13zWoH3yAdLUHoi1QiCZWKBSGGwS/O0nhbE+EBWj4RhJ1B7kFzBwxeg88HLz3EwzsJm0azbYAHRqxIIcna3IcZbKpSJD2BqehHep0tHdKnyKlI2Azz/gP70Dz8sWH5/dHEYEEEMxcZRvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789005318; c=relaxed/simple;
	bh=PbtTiBlCJ93wycFbEUMoaBxmCsvne/aYHArz4TGngUE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SFTLhcjEC329GZW9O2fini37j16ECxET9oEqJOE5/WEXkvlHkclm4c4E8lNV9JDWHVHEr9jkUXDmD/cSt2/WhbTK5739SDo7p7Z1EHvAs8yf+oRKmcWJSgzilSg6pNLZv/kGdKuL2uNLtOp6zjNhqjkm09zZTdeKHCTsQV6W6sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pxq5W9oV; arc=none smtp.client-ip=209.85.214.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pxq5W9oV"
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ccb687f82eso78461845ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 09 Sep 2026 18:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789005311; x=1789610111; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C4/am/kdLlw6Qus0zXUv5BTnGPExVekY3lTJpwF5cR8=;
        b=pxq5W9oVmWAVTH9bJFGkw98NyUOBXdF3rHctNuhMiAzZBHLAREtwt+DFpFh2FJW3ip
         6ScCMPkZfzoGDZ1QF7mFkIrHA7Pkb0pBkaAYhvZZvPWUn9by8Y7q4ZUSjJk7qCYEf2Uw
         bmN8m0MB/XEZV97QdU/0D3AOGkbyUcnIp7VdowHiAqa5oeqgUwvQ/6JVOOjKgwOgfFBT
         ERYnLZpK21fUSslKRdSJ3Fv9U7QUjYFuDqJWyLwVhB3JA3MkZyN9TwhvPIjP6T45sJNX
         Ru9di/8+32Kxqf9BI14lUGycbANVFinOl9qHAmcQvs7J2BYH4aNszG18TS0VgY/+vVcA
         o49Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789005311; x=1789610111;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C4/am/kdLlw6Qus0zXUv5BTnGPExVekY3lTJpwF5cR8=;
        b=fatex9KedyYiMRAAflElK82lq+7cIX4m3YnjE7/yPAWoDaCzY9gBo6FWuey9fqkyjv
         DYBbYP0tz6YW7mQXQtBasHyKVAIhPoPZS89+nYtF4sPdWigbSmsvzmTAZPlahGnbzmKh
         7PmkJbbdtNZjegugyPOtMzh7NPRef/K209W3iEXOixDEiIJ4QRV0TGKIZAMlbFSEDMsD
         VE+sTUihcQVsfYdtBb7qPtHpY7HZDQ3HhC393vN87F3GqwUNACpNrog+5Olv0zxYNvkg
         fxFedbl5Y4UMnaue1KxXCzmdpeNrqRT3ZW1766HZjOowjO3En+V7c7JIj3YM0bRmKLMu
         ngmA==
X-Forwarded-Encrypted: i=1; AKwUvByv9Rb/Mq0G3AvzhgI/pqmHtr5ptuUj7yGDG+QhL20s7zXWd+gZvBDtks7aA898Ns1+P2LPQIpW+Bf3@vger.kernel.org
X-Gm-Message-State: AFuF++kIZrev89qrIufQjrhouu0gaVrZIzuxV+je4Tqrpf9IHa0ygW/A
	9NlSW08XhOeS2xmzXIG7Ck0hOUCUdjfeNU/A3GtazaNmVWODDia08wrn1fltzjmiVuny/dBtIgg
	KcOs/abEB0vxOXGAkd8vUcA==
X-Received: from pjqo8.prod.google.com ([2002:a17:90a:ac08:b0:39b:4704:7c5c])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5905:b0:398:9bd5:490b with SMTP id 98e67ed59e1d1-39b262133ccmr55053877a91.18.1789005309361;
 Wed, 09 Sep 2026 18:55:09 -0700 (PDT)
Date: Thu, 10 Sep 2026 09:55:03 +0800
In-Reply-To: <20260910015503.1991119-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260910015503.1991119-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260910015503.1991119-3-stanleyjhu@google.com>
Subject: [PATCH v3 2/2] scsi: ufs: rpmb: Decouple device lifecycle from devres
 to avoid UAF
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Brian Kao <powenkao@google.com>, Bean Huo <beanhuo@micron.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@sandisk.com>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, Li Qiang <liqiang01@kylinos.cn>, 
	Ao Sun <ao.sun@transsion.com>, linux-kernel@vger.kernel.org, 
	Stanley Jhu <stanleyjhu@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

struct ufs_rpmb_dev embeds struct device, but is allocated using
devm_kzalloc() tied to the host controller (hba->dev).

When the host controller unbinds, devres automatically frees ufs_rpmb
regardless of active references to ufs_rpmb->dev (such as sysfs users or
child devices). Subsequent access to ufs_rpmb->dev triggers a
Use-After-Free (UAF) kernel Oops.

Fix this lifetime defect:
- Allocate ufs_rpmb with kzalloc_obj() and free it in
  ufs_rpmb_device_release() via kfree(), strictly tying memory lifetime
  to the device reference count.
- Pin the underlying SCSI WLUN via scsi_device_get() in probe and
  release it with scsi_device_put() in device_release.
- Call rpmb_dev_unregister() in ufs_rpmb_remove() and probe error unwind
  before device_unregister().
- Check scsi_device_online() before submitting security commands.

Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices")
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Cc: stable@vger.kernel.org
---
 drivers/ufs/core/ufs-rpmb.c | 97 +++++++++++++++++++++----------------
 1 file changed, 55 insertions(+), 42 deletions(-)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index c7aade96c823..33b9a4a1b120 100644
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
@@ -43,15 +44,19 @@ struct ufs_rpmb_dev {
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
@@ -63,13 +68,12 @@ static int ufs_sec_submit(struct ufs_hba *hba, u16 spsp, void *buffer, size_t le
 
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
@@ -77,8 +81,6 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 		return -ENODEV;
 	}
 
-	hba = ufs_rpmb->hba;
-
 	/* req_resp is at the end of an RPMB frame. */
 	if (req_len < sizeof(*frm_out))
 		return -EINVAL;
@@ -111,7 +113,7 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 
 	protocol_id = ufs_rpmb->region_id << 8 | UFS_RPMB_SEC_PROTOCOL_ID;
 
-	ret = ufs_sec_submit(hba, protocol_id, req, req_len, true);
+	ret = ufs_sec_submit(ufs_rpmb, protocol_id, req, req_len, true);
 	if (ret) {
 		dev_err(dev, "Command failed with ret=%d\n", ret);
 		return ret;
@@ -122,7 +124,7 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 
 		memset(frm_resp, 0, sizeof(*frm_resp));
 		put_unaligned_be16(RPMB_RESULT_READ, &frm_resp->req_resp);
-		ret = ufs_sec_submit(hba, protocol_id, resp, resp_len, true);
+		ret = ufs_sec_submit(ufs_rpmb, protocol_id, resp, resp_len, true);
 		if (ret) {
 			dev_err(dev, "Result read request failed with ret=%d\n", ret);
 			return ret;
@@ -130,7 +132,7 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 	}
 
 	if (!ret) {
-		ret = ufs_sec_submit(hba, protocol_id, resp, resp_len, false);
+		ret = ufs_sec_submit(ufs_rpmb, protocol_id, resp, resp_len, false);
 		if (ret)
 			dev_err(dev, "Response read failed with ret=%d\n", ret);
 	}
@@ -140,22 +142,29 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 
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
@@ -166,25 +175,28 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
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
@@ -195,16 +207,14 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
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
@@ -213,29 +223,33 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
 
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
 
@@ -252,14 +266,13 @@ void ufs_rpmb_remove(struct ufs_hba *hba)
 
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

