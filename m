Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607EE466B63
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 14:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789397357; cv=none; b=RdB5yMZNqj2w9S4Q8mDF0fR94qpT+bdyQ6VpfmNXS3aWm5qUG9+8xd36GbsRoswChyMENxlWNUCrmWrHqb7ON2plF1VfftfyNodPbDcBHVoj2HsDpArWtkjnI+n6eVqCz21tOfF1sx2Nk0EKTRWDkdzen9Etbdrtk39DoK3/Ctw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789397357; c=relaxed/simple;
	bh=06CvAkHxZWNyIyQS4urvFuXxGr2JJSfmD6apJNlQn3Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WAIcenU7hrVfQtrdpHMacYbr9T5KxQTuLtbbrG2E4mjCYgDl88S+OT2YR9UFQeKXAI1cSvNZ+7sYns9wcbgFNoOTAlR7OLU3TC3N6+YdggEWdk1i63k+K8gkGziC93dnn4o8d5uSXiI995WD6XfJCK9mNVmekXj0UN9cpJsaPZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=azdXlTat; arc=none smtp.client-ip=209.85.210.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="azdXlTat"
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8538a72b430so3327813b3a.2
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 07:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789397355; x=1790002155; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0DJi8X0xX37W1aEPPUVBbau+Duvv8iBwoY8wMaEV1PQ=;
        b=azdXlTatL4TCwfQaKrJHlsynmECxTn+54qxW1zR3ZzocFT9cqrGhdfGxQE4XLUm4Ge
         aH2q8+fe7tDAr6gWjuAuUxPZhZU+/Lwkz3v7RU69U1Vd9CJ7XAScthEeuJ67CpQ8aCRY
         flB2YhOuabHyEqemGemQ9UxCdGn9GevI/bARfQWJ7vTpiyYOcTdqJBy9nsFdKLiNDwq1
         q92Tm4d4ScYAgIIWmF0KUvqKk3/3wTORb1zjVkpKZmymg2+LZW0CaKywHDQu39wOyfzU
         Fnl7kPrj/bd5Vzdbf0FD8Tx4/w/dUTMv1vYYJWcjrUGzuni4qHBCmrxkdPCKoyI5dF4i
         onUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789397355; x=1790002155;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0DJi8X0xX37W1aEPPUVBbau+Duvv8iBwoY8wMaEV1PQ=;
        b=QiRm4JlT2JqBhtVvYJBLE1GMTrSzpb/v3rOanhWiSYL49+9MLOmKSk+5yy7KTK2PIc
         8sEcbpUxHPCDVmGNnH+5VpvQJ6hrMvxzzgAD3VBXY8vKHfj6afaLl99RZh9Wf/yQ/RxE
         xGTtj9gN7agqjTfu9CvXdMMtVazcZuKjEEfY0JuJ8pmIASVIxG1chjcgpaAZgO+VgssL
         3NMoI3evvubFBZM90RDs33DqiBNfip6h2S2lk99Q4DEDABRB8iQ9MzB9JDLZ8PhVqdpC
         K+zYePXghFp37ApqLDGzWLslhu6+X+LkwBakSubHkzIbpxGqhMqh76P67VQRxIGkmL7j
         SjiA==
X-Forwarded-Encrypted: i=1; AKwUvByK66oY8KeUEuQD94FiqgCnnQYTLSW31GIfoE4rM9SzOXAsz1HvA33Pf0jZ24vqaJfP6cWa5Pmi52UV@vger.kernel.org
X-Gm-Message-State: AFuF++nEGl5xOY68/PDnFec6frOQ+w8F8klDqFJx2nwLt62OWAJMmbPf
	tyzwQCbRjuiiis062avJopRXgt7JR3n1jFOlXDl3zjphJuNbjzdbdJKRXB5HcWhyfs6ob3Abm6C
	9jTZzdBrgsISI6dbDPjXUng==
X-Received: from pfbdn1.prod.google.com ([2002:a05:6a00:4981:b0:86b:e98b:a8ab])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1709:b0:86a:9be:6bf3 with SMTP id d2e1a72fcca58-86f863bede0mr5353125b3a.23.1789397354317;
 Mon, 14 Sep 2026 07:49:14 -0700 (PDT)
Date: Mon, 14 Sep 2026 22:49:08 +0800
In-Reply-To: <20260914144910.931518-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260914144910.931518-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260914144910.931518-2-stanleyjhu@google.com>
Subject: [PATCH v5 1/3] rpmb: core: Guard frame requests and teardown with mutex
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

rpmb_route_frames() has no serialisation. That has two independent
consequences.

Concurrent requests on one rpmb_dev corrupt each other. Two kthreads
issuing RPMB_GET_WRITE_COUNTER against the same UFS RPMB region, 20000
iterations each:

  race complete: MISMATCH=17030 ERRORS=0

A mismatch is a response whose echoed nonce belongs to the other thread:
43% of requests returned somebody else's frame, with no transport error.
An authenticated RPMB operation is not a single command. Per JESD220F
12.4.2 a region processes one at a time. Per 12.4.7 any request other
than a result read overwrites the region's result register. The rpmb_dev
is the granularity the device itself assumes.

A request can also be in flight when the provider tears down.
rpmb_dev_unregister() calls device_del(), which drops the reference
device_add() took on the parent. The parent can then be freed while the
rpmb_dev is still alive and routable through rdev->dev.parent. Unbinding
a UFS host under a consumer that keeps issuing requests:

  BUG: KASAN: slab-use-after-free in ufs_rpmb_route_frames+0x328/0x420
  Read of size 8 at addr fff00000c833bce8 by task rpmb_hold/100
  Call trace:
   ufs_rpmb_route_frames+0x328/0x420
   rpmb_route_frames+0x64/0xd0
  Freed by task 1:
   kfree+0x2b8/0x5c4
   ufs_rpmb_device_release+0x3c/0x60
   device_release+0xa0/0x1fc
   device_unregister+0x20/0x38
   ufs_rpmb_remove+0x130/0x230
   ufshcd_remove+0x54/0x22c

The stable tag is for eMMC. mmc_route_rpmb_frames() packs the sequence
into one block request, so eMMC cannot interleave. The teardown window
is still open there. mmc_blk_remove() reaches rpmb_dev_unregister() well
before tearing down the queue that request goes to. That window is from
source reading, not reproduced.

Add a mutex and a dead flag to struct rpmb_dev. One lock held across the
whole request both serialises requests and excludes unregistration. The
kerneldoc is wrong as well: until rpmb_dev_unregister() runs, the child
holds a reference that keeps the parent's release callback from running,
so a provider cannot unregister from there. Both tests then report
MISMATCH=0 and a clean unbind.

Fixes: 1e9046e3a154 ("rpmb: add Replay Protected Memory Block (RPMB) subsystem")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
---

Notes:
    Both measurements need all three patches applied: on current kernels no
    rpmb_dev registers on UFS, so this patch alone changes nothing there.

 drivers/misc/rpmb-core.c | 34 +++++++++++++++++++++++++++++-----
 include/linux/rpmb.h     |  5 +++++
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/rpmb-core.c b/drivers/misc/rpmb-core.c
index ecf14acf230a..bbc3c404ad6f 100644
--- a/drivers/misc/rpmb-core.c
+++ b/drivers/misc/rpmb-core.c
@@ -45,16 +45,28 @@ EXPORT_SYMBOL_GPL(rpmb_dev_put);
  * @rsp:	rpmb response frames
  * @rsp_len:	length of rpmb response frames in bytes
  *
+ * Context: Might sleep.
+ *
  * Returns: < 0 on failure
  */
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
+	mutex_lock(&rdev->lock);
+	if (rdev->dead) {
+		mutex_unlock(&rdev->lock);
+		return -ENODEV;
+	}
+
+	ret = rdev->descr.route_frames(rdev->dev.parent, req, req_len,
+				       rsp, rsp_len);
+	mutex_unlock(&rdev->lock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(rpmb_route_frames);
 
@@ -62,6 +74,7 @@ static void rpmb_dev_release(struct device *dev)
 {
 	struct rpmb_dev *rdev = to_rpmb_dev(dev);
 
+	mutex_destroy(&rdev->lock);
 	ida_free(&rpmb_ida, rdev->id);
 	kfree(rdev->descr.dev_id);
 	kfree(rdev);
@@ -123,8 +136,9 @@ EXPORT_SYMBOL_GPL(rpmb_interface_unregister);
  * rpmb_dev_unregister() - unregister RPMB partition from the RPMB subsystem
  * @rdev: the rpmb device to unregister
  *
- * This function should be called from the release function of the
- * underlying device used when the RPMB device was registered.
+ * This function should be called from the remove or unbind callback of the
+ * underlying device used when the RPMB device was registered, never from
+ * a device release callback.
  *
  * Returns: < 0 on failure
  */
@@ -133,6 +147,14 @@ int rpmb_dev_unregister(struct rpmb_dev *rdev)
 	if (!rdev)
 		return -EINVAL;
 
+	mutex_lock(&rdev->lock);
+	if (rdev->dead) {
+		mutex_unlock(&rdev->lock);
+		return 0;
+	}
+	rdev->dead = true;
+	mutex_unlock(&rdev->lock);
+
 	device_del(&rdev->dev);
 
 	rpmb_dev_put(rdev);
@@ -164,6 +186,7 @@ struct rpmb_dev *rpmb_dev_register(struct device *dev,
 	rdev = kzalloc_obj(*rdev);
 	if (!rdev)
 		return ERR_PTR(-ENOMEM);
+	mutex_init(&rdev->lock);
 	rdev->descr = *descr;
 	rdev->descr.dev_id = kmemdup(descr->dev_id, descr->dev_id_len,
 				     GFP_KERNEL);
@@ -194,6 +217,7 @@ struct rpmb_dev *rpmb_dev_register(struct device *dev,
 err_free_dev_id:
 	kfree(rdev->descr.dev_id);
 err_free_rdev:
+	mutex_destroy(&rdev->lock);
 	kfree(rdev);
 	return ERR_PTR(ret);
 }
diff --git a/include/linux/rpmb.h b/include/linux/rpmb.h
index ed3f8e431eff..65807f597735 100644
--- a/include/linux/rpmb.h
+++ b/include/linux/rpmb.h
@@ -7,6 +7,7 @@
 #define __RPMB_H__
 
 #include <linux/device.h>
+#include <linux/mutex.h>
 #include <linux/types.h>
 
 /**
@@ -48,15 +49,19 @@ struct rpmb_descr {
  * struct rpmb_dev - device which can support RPMB partition
  *
  * @dev              : device
+ * @lock             : serialises requests and protects them against teardown
  * @id               : device_id
  * @list_node        : linked list node
  * @descr            : RPMB description
+ * @dead             : set to true when device is unregistered
  */
 struct rpmb_dev {
 	struct device dev;
+	struct mutex lock;	/* Serialises route_frames(), guards @dead */
 	int id;
 	struct list_head list_node;
 	struct rpmb_descr descr;
+	bool dead;
 };
 
 #define to_rpmb_dev(x)		container_of((x), struct rpmb_dev, dev)
-- 
2.55.0.1007.g17ff1f9808-goog

