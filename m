Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794444083;
	b=QRaoxSzPQSEccBrNlCRRM4OlK/6qkKI5toxOMY06ogrbCDzxt5EQ6wiBpm5zkD5xSsNF
	 RhXQtP09Fprqw84RvoD0zQsszpiaq9gD3YZUlPidw1P2/a8lu9Tck3A4hmF6CYNxORqMf
	 /WH/g/AkZF2XvATIeffXJXnPPrK6Kfk0j6CL0P6DTZotKYdtVGS1jZBumsFpa0WRsR6Sc
	 FQm7CfOkRcd/fzRcb1dAl9TW7BeI/ykUSkfI4daKrCzQdKc5iEIkKnzMynFVDue9FPXmC
	 temyTLhZoXl57oGrJ789iB4VxYQML1YS0sd8hYLz+wmceUMN3hh2OlTBhKWFhNr0cNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794444083;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=naLbHr/+oPV29aQuJv+P6GsGhs3mmPsOZjs4miyXzy8=;
	b=N/aHEmaBTsn6fnTZqTm4OuL4Za6Optu5lsBn2eaw4YjnfkXjKvPrMjzCoxivK8Kz76cS
	 TBe3WnW2EY9ApwecWm/+N7wun5iVqqdIqZcCXRnrWgo3kJZ9BvDQ+K2QlS4OV3OL/OUnJ
	 QTsbSLps7GAlY+5sEzg/RdVnVNlLUI0G7E2AE1TCwzWQv6RJyGGV1BYuJ1xBBIzYKO+Ae
	 G8YeZNlX6n5WCuoKEKe7mciy+yljOxmlKJVhyd56tgTZb19lIE1zXY2zto7s4mC2rjx7F
	 JGWBg0QK0Z5WiQucoLGIwV6NmQtfCtljxznpVRPuDXr1wKIFZkOrEUbWHuQefDQo18g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=D1gBieVl;
	arc=none smtp.remote-ip=209.85.210.197
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B79B606A32D
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 00:41:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B79B606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=D1gBieVl
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8a065d0e9deso315116b3a.0
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 16:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794444082; x=1795048882; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=naLbHr/+oPV29aQuJv+P6GsGhs3mmPsOZjs4miyXzy8=;
        b=D1gBieVl/Fa8IdsUJK/rSq9R0yBN2F8NBSeRAAcOPdZXwaFzfV0jvllDk74866QU3Y
         xeuQWyizGd+UbfzfXelnFqM1Xrh6czV9Jxz2cguXZvLiWdq3TAmaD2yC6HilAdBcAD/z
         C2+tH4e31FmtzMY94IBFuYY05cAZWNNXtevOdyiXEVyvJjMbxUYm8b7F4G3pfxiM6ZDB
         a/kNnqHLomw0iaHK2yMC2OGkfmFO75WhP/HIyeUajLjNfJ6sJT6zRmJzLafktIdgaXVj
         Y9VknezA61zJzdDWRITzvq8LHsvK2q2XHtUvz0EhTlVNZyMeEn8IR/VRSqAfsegSSMla
         IQjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794444082; x=1795048882;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=naLbHr/+oPV29aQuJv+P6GsGhs3mmPsOZjs4miyXzy8=;
        b=MzYwdvimwg0kVjbJv2afSHK9I24122kbeb6NxoTBVSYVCapHQSPlza8h8hd2wovEVr
         ddVs6Gi8XxKzrePZRpIgurl2sPXSyZBNX+oMTtUBYEMREYpeE2SALUF70wv3FTtUiZiR
         Vc6zbUhLOr9Z74ABIqkRsgzPCutd7H/i3KEoBONHB+A82oUqnJZ2ef4bM+Q02dzOK0P2
         J2pWoG7jdbwIYDtVLxuP4Nlu+aBENJQw+vIs77Mb2AKEHtPbDn4GzZMHjrXjWmmEev85
         kRO4/njR3tldkHSbQgLuXCxPajcIiFWNJpQoKKANfPOsRZpQhQm2ima9uKJpugh4sWh5
         eolw==
X-Forwarded-Encrypted: i=1; AL+hErEyayn9qzMLklXMMGnuAeKMbTbLiFqvhvJENdjiCeNO7KNkLuTFSNhhhmBbXT+Ib7LhtI1c8iuUEVLw@vger.kernel.org
X-Gm-Message-State: APuU4Z/+RSHvsw1NghWHwkDCJAihfJ6Rg4235ErNTFJ57zQYKTH4wF6J
	srKoZ5v7JgupxmjdOjeyN6ODueIwVCcA1642cbW6+MQb6RXD7g13G6qrZm6tXlCMREM814lSHAr
	IxaGn3WufI3mCru1HazujdA==
X-Received: from pfdu2-n2.prod.google.com ([2002:a05:6a00:c002:20b0:88e:f55:207e])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2e82:b0:8b8:39ac:fed9 with SMTP id d2e1a72fcca58-8bd625ff9b0mr641920b3a.27.1794444081601;
 Wed, 11 Nov 2026 16:41:21 -0800 (PST)
Date: Thu, 12 Nov 2026 08:41:11 +0800
In-Reply-To: <20261112004112.3059801-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261112004112.3059801-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.567.gdb80ae8cd5-goog
Message-ID: <20261112004112.3059801-3-stanleyjhu@google.com>
Subject: [PATCH v6 2/3] scsi: ufs: rpmb: Decouple device lifecycle from devres
 to avoid UAF
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, Jens Wiklander <jenswi@kernel.org>, linux-scsi@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Avri Altman <avri.altman@sandisk.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@iokpp.de>, 
	Bean Huo <beanhuo@micron.com>, Alexey Charkov <alchark@flipper.net>, 
	Can Guo <can.guo@oss.qualcomm.com>, Ulf Hansson <ulfh@kernel.org>, 
	Linus Walleij <linusw@kernel.org>, Shyam Saini <shyamsaini@linux.microsoft.com>, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Region device lifetime in ufs-rpmb fails on host removal in three ways:

1. ufs_rpmb_probe() allocates struct ufs_rpmb_dev with devm_kzalloc() on
   the host device even though it embeds a reference-counted struct
   device, so devres frees the memory on host unbind regardless of live
   references.
2. Probe takes no reference on hba->ufs_rpmb_wlun, so scsi_remove_host()
   frees the scsi_device while an RPMB request is still in flight.
3. Child rpmb_dev holds a parent reference on ufs_rpmb->dev until
   rpmb_dev_unregister() runs, which sits inside
   ufs_rpmb_device_release() and therefore never runs on unbind.

Allocate struct ufs_rpmb_dev with kzalloc_obj() and free it in
ufs_rpmb_device_release(), hold a get_device() reference on the WLUN
across the region lifetime, call rpmb_dev_unregister() explicitly during
removal and probe unwind, and reject requests when the WLUN is offline.

Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufs-rpmb.c | 79 +++++++++++++++++++++----------------
 1 file changed, 44 insertions(+), 35 deletions(-)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index 65f2d71cf073..11d2d8e789d0 100644
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
 			.sense_key = UNIT_ATTENTION,
@@ -62,6 +64,9 @@ static int ufs_sec_submit(struct ufs_hba *hba, u16 spsp, void *buffer, size_t le
 	};
 	u8 cdb[12] = { };
 
+	if (!sdev || !scsi_device_online(sdev))
+		return -ENODEV;
+
 	cdb[0] = send ? SECURITY_PROTOCOL_OUT : SECURITY_PROTOCOL_IN;
 	cdb[1] = UFS_RPMB_SEC_PROTOCOL;
 	put_unaligned_be16(spsp, &cdb[2]);
@@ -74,13 +79,12 @@ static int ufs_sec_submit(struct ufs_hba *hba, u16 spsp, void *buffer, size_t le
 
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
@@ -88,8 +92,6 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 		return -ENODEV;
 	}
 
-	hba = ufs_rpmb->hba;
-
 	/* req_resp is at the end of an RPMB frame. */
 	if (req_len < sizeof(*frm_out))
 		return -EINVAL;
@@ -122,7 +124,7 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 
 	protocol_id = ufs_rpmb->region_id << 8 | UFS_RPMB_SEC_PROTOCOL_ID;
 
-	ret = ufs_sec_submit(hba, protocol_id, req, req_len, true);
+	ret = ufs_sec_submit(ufs_rpmb, protocol_id, req, req_len, true);
 	if (ret) {
 		dev_err(dev, "Command failed with ret=%d\n", ret);
 		return ret;
@@ -133,7 +135,8 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 
 		memset(frm_resp, 0, sizeof(*frm_resp));
 		put_unaligned_be16(RPMB_RESULT_READ, &frm_resp->req_resp);
-		ret = ufs_sec_submit(hba, protocol_id, resp, resp_len, true);
+		ret = ufs_sec_submit(ufs_rpmb, protocol_id, resp, resp_len,
+				     true);
 		if (ret) {
 			dev_err(dev, "Result read request failed with ret=%d\n", ret);
 			return ret;
@@ -141,7 +144,8 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 	}
 
 	if (!ret) {
-		ret = ufs_sec_submit(hba, protocol_id, resp, resp_len, false);
+		ret = ufs_sec_submit(ufs_rpmb, protocol_id, resp, resp_len,
+				     false);
 		if (ret)
 			dev_err(dev, "Response read failed with ret=%d\n", ret);
 	}
@@ -151,23 +155,31 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 
 static void ufs_rpmb_device_release(struct device *dev)
 {
-	struct ufs_rpmb_dev *ufs_rpmb = dev_get_drvdata(dev);
+	struct ufs_rpmb_dev *ufs_rpmb =
+		container_of(dev, struct ufs_rpmb_dev, dev);
 
-	rpmb_dev_unregister(ufs_rpmb->rdev);
+	put_device(&ufs_rpmb->sdev->sdev_gendev);
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
@@ -178,25 +190,22 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
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
+		get_device(&sdev->sdev_gendev);
+
+		ufs_rpmb->sdev = sdev;
+		ufs_rpmb->region_id = region;
+		ufs_rpmb->dev.parent = &sdev->sdev_gendev;
 		ufs_rpmb->dev.bus = &ufs_rpmb_bus_type;
 		ufs_rpmb->dev.release = ufs_rpmb_device_release;
 		dev_set_name(&ufs_rpmb->dev, "ufs_rpmb%d", region);
@@ -207,16 +216,14 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
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
@@ -227,29 +234,30 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
 
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
 
@@ -269,6 +277,7 @@ void ufs_rpmb_remove(struct ufs_hba *hba)
 		dev_info(hba->dev, "Removing UFS RPMB region %d\n", ufs_rpmb->region_id);
 		/* Remove from list first */
 		list_del(&ufs_rpmb->node);
+		rpmb_dev_unregister(ufs_rpmb->rdev);
 		/* Unregister device */
 		device_unregister(&ufs_rpmb->dev);
 	}
-- 
2.56.0.567.gdb80ae8cd5-goog

