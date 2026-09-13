Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A7E385D94
	for <linux-scsi@vger.kernel.org>; Sun, 13 Sep 2026 03:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789270599; cv=none; b=PPNzCjh1MkXc1NpoUTKwNR+M3xrkALveKYCgyYZ5/DFewBf7QbsnXtvdG4odE/zAY+gDI0MQ948KKRM4kNi5SifKhenQeti4PG15Ao35EGa+9TSmIOu7uPp/5cwTtTvw1ZeWEX+feXUfR2tVn8pDWah88l8O5NrX2+kmERrfJuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789270599; c=relaxed/simple;
	bh=Q7N55ZKGMhUVafnhQytlmQyt5wlMWqJxtit4S7G1Bmk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZbRyrFnGJFQW8Y53FAX+3TnHNEIkD3lDOHmfCSt45Nbw8M7XEeeU0DmMdoNyjUcxA4uUq/M86DewFAhe+EuGphfEC/6FieP730LwCO9UvkEWebNj55rWDuMmirFIHrPshgZFErwBNZ52qprnCv3z7MD9Y01ppt0wVSo3weAKOZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AVsL3icE; arc=none smtp.client-ip=209.85.216.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AVsL3icE"
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38dbf293831so4905281a91.3
        for <linux-scsi@vger.kernel.org>; Sat, 12 Sep 2026 20:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789270597; x=1789875397; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Fs6YuwwYNgKZrcAVirPLF9TAZSnieT4vB0v2ARdNeLY=;
        b=AVsL3icEivUKLI1imZpyNIlnWX/QL2QEz5HFVi6hUo3SKjEuDXFqjUyOU5FKK5NTXq
         lM/0ysM7cAiMJug8FHxRYsR+5lpAR7EP8kc9DR4prZGO1j2W7M60MAnTVOqp94NHnrPD
         fe7fRu1/dD6NdPaVAtXpEkkY6iq4l2za4vi1jpsfu1b5vdCpOkCJi1OAPP6ckuhTcJt3
         QOs+M/WpQwYScYvCyoZypJYBrL+ix3WcIrBidt/g/uDB6Jq+TP3puxzwoR7qrg55qXBS
         TJx+/Ts3lHZz0WpuYW5Za2i6kjb5FYy88vHVZA+59ilgfdd8yKIhHeoYdUNNbVirLWkZ
         dyrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789270597; x=1789875397;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Fs6YuwwYNgKZrcAVirPLF9TAZSnieT4vB0v2ARdNeLY=;
        b=LW2SL1Ne1gWAZBcDNG+ea9aQagkckd9IXplclpG3yQ3nhjuVtKOqkQ6xISCWk/gIt/
         PFUKn5/f7aCdbRVeLA1QOKE1u4mEy+yKxacsjdnGR9CgEJWtDz/ZPZZNqqWxSttnZ5JQ
         S9F9YuQh4vs6PUjxVu/+H549USHcJL1y6l8ejnebanDlK2ooeL1/elNn+hBox7WOvWrU
         2UyAayY89DuwdXR/XaRC24LxHqnlFpxlKJv450n3e3+p37+17/3eFmKiGlrc6EgjggCQ
         ZAOdg4y+XKvoDsYdopXBO1OyvwdV7LLw+au0nKwsEFLfsBQkZrwUBK1/1XrkFJyrLeUV
         1gvw==
X-Forwarded-Encrypted: i=1; AKwUvBy9MDaUxYk7Q9+f671rqbXD5Ory7PQfzbtOBmsHw0H65K+/5QIRHbSVKVkEahaInHZ+VPcQdXmLrZyz@vger.kernel.org
X-Gm-Message-State: AFuF++l99RLM5ojxWgdLjDpA7tbOHbUJA2RVS6RB+6oOIFLO9zrVWWLa
	JK5OUaEZuvY/zYo/b0T02/DME6SCF4G6+RFrVEHlB/8Pe1/DEhjMg3tSdMGKmTsK8X0A0qyxx4Y
	RhLDF5uiTjYpg9a5q47i6zw==
X-Received: from pjsd15.prod.google.com ([2002:a17:90a:bf8f:b0:39d:c24e:697b])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:d64c:b0:396:d27b:89b9 with SMTP id 98e67ed59e1d1-39d9bd6197bmr20361369a91.10.1789270596929;
 Sat, 12 Sep 2026 20:36:36 -0700 (PDT)
Date: Sun, 13 Sep 2026 11:36:31 +0800
In-Reply-To: <20260913033633.3159296-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260913033633.3159296-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260913033633.3159296-2-stanleyjhu@google.com>
Subject: [PATCH v4 1/3] rpmb: core: Guard frame requests and teardown with mutex
From: Stanley Jhu <stanleyjhu@google.com>
To: jenswi@kernel.org, mkp@kernel.org
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, bvanassche@acm.org, 
	avri.altman@sandisk.com, alim.akhtar@samsung.com, beanhuo@micron.com, 
	can.guo@oss.qualcomm.com, ulfh@kernel.org, linusw@kernel.org, 
	tomas.winkler@intel.com, shyamsaini@linux.microsoft.com, 
	alex.bennee@linaro.org, James.Bottomley@HansenPartnership.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Stanley Jhu <stanleyjhu@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

rpmb_route_frames() has no serialisation. That has two independent
consequences.

Concurrent requests on one rpmb_dev corrupt each other. Two kthreads on
different CPUs issuing RPMB_GET_WRITE_COUNTER against the same UFS RPMB
region, 20000 iterations each:

  thread 0 done: 20000 iterations, mismatches=10889, errors=0
  thread 1 done: 20000 iterations, mismatches=6141, errors=0
  race complete: MISMATCH=17030 ERRORS=0

A mismatch is a response whose echoed nonce belongs to the other thread,
so 43% of requests returned somebody else's frame. The errors count is
transport failures, so nothing failed and the corruption is silent to
the caller. An authenticated RPMB operation is not one command. The UFS
provider issues SECURITY PROTOCOL OUT carrying the request, then
SECURITY PROTOCOL IN to collect the response, with a result read request
in between for write-type operations. JESD220F 12.4.7 states that any
request other than a result read overwrites the result register of the
region, so a request landing in the middle of another initiator's
sequence destroys its response. The same chapter states that a region
processes one authenticated operation at a time, so the rpmb_dev is the
granularity the device itself assumes.

A request can also still be in flight when the provider tears down. The
core reaches the provider through rdev->dev.parent, and the provider is
free to release that device as soon as rpmb_dev_unregister() returns.
Reference counting on the rpmb_dev does not prevent this:
rpmb_dev_unregister() calls device_del(), which drops the reference that
device_add() took on the parent, so the parent can be freed while the
rpmb_dev is still alive and still routable. Unbinding a UFS host while a
consumer holds an rpmb_dev reference and keeps issuing requests:

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

Both measurements needed patches 2/3 and 3/3 of this series applied,
because UFS RPMB registration fails on mainline. The stable tag is for
eMMC, which registers today. mmc_route_rpmb_frames() packs the whole
sequence into one block request, so eMMC is not exposed to the
interleaving above, but it does have the teardown window:
mmc_blk_remove() reaches rpmb_dev_unregister() through
mmc_blk_remove_parts() near its start, while the queue that
mmc_route_rpmb_frames() submits to is only torn down at the end by
mmc_blk_remove_req(), whose comment notes that it is freeing the queue
that stops new requests being accepted. The eMMC window is from source
reading; I have not reproduced it.

The kerneldoc change is part of the fix. Calling rpmb_dev_unregister()
from a release callback cannot work, because the child rpmb_dev holds a
reference on its parent, so the parent's release callback never runs.
The UFS provider does exactly that today, inert only because its
registration fails; patch 2/3 moves the call to the remove path.

Add a mutex and a dead flag to struct rpmb_dev. rpmb_route_frames()
holds the mutex across the whole sequence and returns -ENODEV once the
flag is set. rpmb_dev_unregister() sets the flag under the mutex before
device_del(), so it cannot return while a request is inside the
provider. Closing the teardown window requires excluding unregistration
for the whole duration of a request, which is the same exclusion that
serialises two requests, so one mutex covers both.

On the same test with this patch applied, MISMATCH=0 and the unbind is
clean.

Fixes: 1e9046e3a154 ("rpmb: add Replay Protected Memory Block (RPMB) subsystem")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/misc/rpmb-core.c | 34 +++++++++++++++++++++++++++++-----
 include/linux/rpmb.h     |  6 ++++++
 2 files changed, 35 insertions(+), 5 deletions(-)

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
index ed3f8e431eff..814ac3e69337 100644
--- a/include/linux/rpmb.h
+++ b/include/linux/rpmb.h
@@ -7,6 +7,7 @@
 #define __RPMB_H__
 
 #include <linux/device.h>
+#include <linux/mutex.h>
 #include <linux/types.h>
 
 /**
@@ -48,15 +49,20 @@ struct rpmb_descr {
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
+	/* Protects in-flight operations against teardown */
+	struct mutex lock;
 	int id;
 	struct list_head list_node;
 	struct rpmb_descr descr;
+	bool dead;
 };
 
 #define to_rpmb_dev(x)		container_of((x), struct rpmb_dev, dev)
-- 
2.55.0.1007.g17ff1f9808-goog

