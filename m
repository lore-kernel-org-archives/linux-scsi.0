Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709D24CC288
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 15:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788537197; cv=none; b=kVQmeTAePTh++/fYuwolTi8FrDvibim3cPVjleWynb769lcHUqz8uF3hRgKBBoYm/hZxcthn82e6YodHgxF/PQKA3X8BDXiq3tNFxq96Pw2zsI7eE0eajaWSskWhc9MqKBMSmw5896m3jkTsGmProjrX7jO9qR8hdp6Hcz/BAzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788537197; c=relaxed/simple;
	bh=KxQ/xT0DYKwU2LbKreDOy6TYIoy1TjmaHvLHDuiy/ao=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e5xrHnE3xKflutDlkYRsEl1GxhulZybSNBgIBZBBD+bGaGcAkTz8gDRjCYt08sLWe53drpq3L4Cvmu/W0+EEbIe47aI56jaM7wBBxFo1KzwCLHPa1VgXzsZGUQyjwPIsahxbssAOcM+jbZdzPqASmTyUfUKo+hknkgWGHhGDubw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vi0UwXF5; arc=none smtp.client-ip=209.85.216.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vi0UwXF5"
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39906175917so1332114a91.2
        for <linux-scsi@vger.kernel.org>; Fri, 04 Sep 2026 08:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788537194; x=1789141994; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SZ/ecOPIdjxmv5yFmcmarX+CSOgmUYOSBiePLwGv5ws=;
        b=vi0UwXF5UZLWSeVDIuskfguuNUf0rQnFGE+TbjC/Shi6e8fr6Y5503fov9XU/urzCe
         k8V6rBVsi6rmY0B2JRCSdsvGDPP1GU7J9NHbLI+Bf/kTjH3w3654eqzQWt2PoMFVVzTI
         JwgDOzgNqxOhP3ApFGsE7ZAvZoA2MzfPFkszbzNbaRLZxoLi8+CJFajN2SmIQeeRdm4Z
         x3FnCWwQyP5NYLVAkt1h+bvl2+jpvRtHMFFICT6WpBmB1EPIkD1WztxOibgActkIQ/89
         nV3Eu1+6LTepAyL3yFV52aKsov2QkjlL8zkYYVPGgny+6LIriDWoMEk4lM79B6VC7gsh
         xcGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788537194; x=1789141994;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SZ/ecOPIdjxmv5yFmcmarX+CSOgmUYOSBiePLwGv5ws=;
        b=rqSHC3CzArtOqJdaeAY6iBSyepJ1jEzK8azrPM2QPKELdUQBKY7JdcCn0h4V0tlez2
         P/Mrz41TUAwKZFpVHb/a4uS1zc+jHt+/40pMzCsFlUN8Wfj6U849m/iprNrsMjC8Zxvt
         vnxeCRuXPRweLFpKUcYn5V9AQjy8/uiZSiXXqIbnHmrY8UdzvYIEHpGa/oThR+mrg2ju
         7Gmooh1ENWCxM9ZiKYf9UUYq4acEZq8c4tkPR7eS2kIlArIAYH5OpT+EGN1bu5bM4Qz8
         vC5ddKm01Sc675f2DMe8pirGiuBKkMyCipIY/Rg9HGvmbioDMvsJmG8QFRDmNSxGoAaW
         ea9Q==
X-Forwarded-Encrypted: i=1; AKwUvBzOStmhhAF1pMwPsr6MK7eLqF4ao922jfp0Z8Ufxr1VGM9crYUlAEaE6ir1n22lTzYN8/c1fTT2GDQa@vger.kernel.org
X-Gm-Message-State: AFuF++kjBfCSMwOg+kvwFhKD2oOu993tv1d0wSQhA6OWWDTvanTE76wD
	BGScbnAhiF1LGUr64DwAxr16PszJLzuTCpxQ/mkcR1iuQwANYhILVNX6josQfv7kidJjl7+vRYU
	NCdHeHsjryVMAcEhMZqYcTQ==
X-Received: from pjbmd22.prod.google.com ([2002:a17:90b:23d6:b0:38e:6cdf:217a])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4fca:b0:38e:5b59:c2ff with SMTP id 98e67ed59e1d1-39b260dd278mr10377291a91.3.1788537193245;
 Fri, 04 Sep 2026 08:53:13 -0700 (PDT)
Date: Fri,  4 Sep 2026 23:53:06 +0800
In-Reply-To: <20260904155307.150443-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260904155307.150443-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260904155307.150443-3-stanleyjhu@google.com>
Subject: [PATCH v2 2/3] scsi: ufs: rpmb: Decouple device lifecycle from devres
 to avoid UAF
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

struct ufs_rpmb_dev embeds struct device, but is allocated using
devm_kzalloc() tied to the host controller (hba->dev).

When the host controller unbinds, devres automatically frees ufs_rpmb
regardless of active references to ufs_rpmb->dev (such as sysfs users or
child devices). Subsequent access to ufs_rpmb->dev triggers a
Use-After-Free (UAF) kernel Oops.

Fix this by decoupling ufs_rpmb from devres, managing its lifetime
strictly through the embedded device reference count, and pinning the
underlying SCSI device.

Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices")
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Cc: stable@vger.kernel.org
---
Changes in v2:
- Explicitly unregister rpmb device before unregistering ufs_rpmb dev.
 drivers/ufs/core/ufs-rpmb.c | 86 +++++++++++++++++++++----------------
 1 file changed, 50 insertions(+), 36 deletions(-)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index aa925cbb07e8..fe96acdde278 100644
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

