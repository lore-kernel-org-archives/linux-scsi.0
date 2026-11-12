Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794444080;
	b=bcYicSFywtVrMN4XrV6WBBtFWqeikgtGJg3T2BGY2/RhLJPqe8I+SVc1EfibwyIQe9Yz
	 VUzg4vd+rQjADYeOIPCeTQieKWZPXWk+3aBE+FLNfffLpoD/Rl3k2bgTuxcg4i6GYTTDc
	 mVwjBwHH2CFYLV5KGPIdDYTRIhH9DQ4OAD0Nr9wepv0WAB2onmGHL75W9NItGfslzbjrr
	 M3XAqTIOE6C3Tzdw9yyK2b85hgX0s1OhU6otfg+YzxiuszHh4pU4WwhfL9ht9JuClpfYC
	 N2lWnBcV5jU1bBgivEa6RlLDpnwymKRhmvjIXKXTgVtkgkCrVKKdVK8rzbPGggNNMVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794444080;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=sFiTj1V9ORohuicZdlyi6G8w7v9+PWw4rbDBBSUy/HI=;
	b=qu/4lvtt6DkdGJc5DsZccdlUkg6VbuntlDSEGNEHI1+7EbHXZQpEKrzuo5z9srcuwQ6F
	 WUrL461tqxyjVGx4gIwY0ZJfuuWxNYfyrXlLvuPBNscCeVfCSeH5BFqEKaPkDWT4ih4N2
	 DsqsxUw76tpZpzj6xf0JD0iwt1iGq3C2Ytl/PqRQ5QphYctNlAJvRapGFF+x3kQFxM3Tt
	 xcCauzfvRYNlZzoQ5+1WhxygYbP/5KaDj4MXeEh3/NoPvgxWqnBhk4NvmuhMkaB4pIQmi
	 pral4JA3Fv6vSu2XNRPIUvnmjlIbIRznEgVN6iBSjnBnzNEEOrZwKl0mPf/3tCa9s/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hX0aa1cA;
	arc=none smtp.remote-ip=209.85.216.70
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD5E606A890
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 00:41:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFD5E606A890
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hX0aa1cA
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ae1d132d52so3287234a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 16:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794444079; x=1795048879; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sFiTj1V9ORohuicZdlyi6G8w7v9+PWw4rbDBBSUy/HI=;
        b=hX0aa1cAZuU/cWlJiAGzqRhuzmmFjiavmDF1monemszKlOm4RissaytZrtK59qSRwh
         qvoWzqyuwjvKs2bZV8voXGBbRVhl6FMNE/DVXlPZ0e3P8NvHWQOAe6nnaQNl9LvFfrHP
         FVqpLqYoUiiLf4xD2PuR+zs6OkVHvhoK3IXUndKvq2TdpcqqAI8vksbQCScUvu+DhbzE
         qWMB/t9iwVHrp6Ch9izFQjXGvE5Bx/XwCQhIF+DELq/h2003auRjoO/BWO/7r26vsKVw
         7L9K8Y/GuXhvulSpB+NtYaRyFvs65BG3WPxS17u7npqu68+mc8ZP8UWfTZydfUvskLtc
         gF2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794444079; x=1795048879;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sFiTj1V9ORohuicZdlyi6G8w7v9+PWw4rbDBBSUy/HI=;
        b=RkOZl/ulOcEd4fH5WDt1KIZM2Cluk72oonqTSymOrWobECU//fVkWAdUai726+jIrN
         jKovevKX3IJ884SSu5H1gs2JsnINmfHVqgav/MmLuFyTSBbReSO1ernJsJYBU+54x8z0
         2xPgqXDf3cvCLMGc8Cw6h0gdizhK5m6TxPcteh37IUSjb8gtlDaCLK0L6FddkLQNTt1/
         mO9ufpBqzjk6KcDcLUbN/8h64OEnJPqgW0G9pm4aBBsVPRTZj+RM/1HtAFzeMHWIwwGA
         NDbgevg5Mym2W38+cN45svWzmtR6R7V5s022vJhSx6O97t4F9+gB1Jpbgms/1QHSr7fY
         YUNA==
X-Forwarded-Encrypted: i=1; AL+hErHf6w8HzVSB4M7mvMmE0Ml2aAbQdPrPXPNx0GjhlSJIGaR98Q0+i/nGt/NYEGvI7poE0lDGecZo5jbQ@vger.kernel.org
X-Gm-Message-State: APuU4Z8BWslB/LT6iKLrJ/rqTiyQcqGjitzu6ZxP+aIcaYfW/BgiPJ4r
	uY3QtEBQ0XUE4B3bCjZrXCUs9O5kskHPDMhzlKsyqHmI8417wRG+O+bXCCW6h8WYhOia7a8D1Ol
	z0jufpA46vVWJQz5xq+JsqQ==
X-Received: from plih6.prod.google.com ([2002:a17:903:37c6:b0:2e8:ac89:717d])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2710:b0:3a6:f1d2:57f3 with SMTP id 98e67ed59e1d1-3b182fd55a2mr3751521a91.58.1794444079037;
 Wed, 11 Nov 2026 16:41:19 -0800 (PST)
Date: Thu, 12 Nov 2026 08:41:10 +0800
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
Message-ID: <20261112004112.3059801-2-stanleyjhu@google.com>
Subject: [PATCH v6 1/3] rpmb: core: Guard frame requests and teardown with mutex
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

rpmb_route_frames() invokes the provider callback without serialization,
which causes two races:

1. Concurrent callers on the same rpmb_dev interleave multi-frame
   authenticated sequences on the region's single result register and
   receive each other's responses without error.
2. rpmb_dev_unregister() calls device_del() and allows the parent
   provider device to be freed while an in-flight rpmb_route_frames()
   call still dereferences rdev->dev.parent, causing a use-after-free.

Serialize rpmb_route_frames() and rpmb_dev_unregister() with a mutex in
struct rpmb_dev and clear descr.route_frames on unregistration so new
requests fail with -ENODEV. Also update the stale kerneldoc note
advising providers to unregister from their parent release callback,
which cannot run while the child rpmb_dev still holds a parent
reference.

Fixes: 1e9046e3a154 ("rpmb: add Replay Protected Memory Block (RPMB) subsystem")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
Jens, if this looks good to you, an Acked-by would let Martin take
the whole series through the SCSI tree. Patches 2/3 and 3/3 depend
on this one.

 drivers/misc/rpmb-core.c | 20 ++++++++++++++++++--
 include/linux/rpmb.h     |  3 +++
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/rpmb-core.c b/drivers/misc/rpmb-core.c
index ecf14acf230a..0fda893dd74d 100644
--- a/drivers/misc/rpmb-core.c
+++ b/drivers/misc/rpmb-core.c
@@ -45,6 +45,8 @@ EXPORT_SYMBOL_GPL(rpmb_dev_put);
  * @rsp:	rpmb response frames
  * @rsp_len:	length of rpmb response frames in bytes
  *
+ * Context: Might sleep.
+ *
  * Returns: < 0 on failure
  */
 int rpmb_route_frames(struct rpmb_dev *rdev, u8 *req,
@@ -53,6 +55,10 @@ int rpmb_route_frames(struct rpmb_dev *rdev, u8 *req,
 	if (!req || !req_len || !rsp || !rsp_len)
 		return -EINVAL;
 
+	guard(mutex)(&rdev->lock);
+	if (!rdev->descr.route_frames)
+		return -ENODEV;
+
 	return rdev->descr.route_frames(rdev->dev.parent, req, req_len,
 					rsp, rsp_len);
 }
@@ -62,6 +68,7 @@ static void rpmb_dev_release(struct device *dev)
 {
 	struct rpmb_dev *rdev = to_rpmb_dev(dev);
 
+	mutex_destroy(&rdev->lock);
 	ida_free(&rpmb_ida, rdev->id);
 	kfree(rdev->descr.dev_id);
 	kfree(rdev);
@@ -123,8 +130,9 @@ EXPORT_SYMBOL_GPL(rpmb_interface_unregister);
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
@@ -133,6 +141,12 @@ int rpmb_dev_unregister(struct rpmb_dev *rdev)
 	if (!rdev)
 		return -EINVAL;
 
+	scoped_guard(mutex, &rdev->lock) {
+		if (!rdev->descr.route_frames)
+			return 0;
+		rdev->descr.route_frames = NULL;
+	}
+
 	device_del(&rdev->dev);
 
 	rpmb_dev_put(rdev);
@@ -164,6 +178,7 @@ struct rpmb_dev *rpmb_dev_register(struct device *dev,
 	rdev = kzalloc_obj(*rdev);
 	if (!rdev)
 		return ERR_PTR(-ENOMEM);
+	mutex_init(&rdev->lock);
 	rdev->descr = *descr;
 	rdev->descr.dev_id = kmemdup(descr->dev_id, descr->dev_id_len,
 				     GFP_KERNEL);
@@ -194,6 +209,7 @@ struct rpmb_dev *rpmb_dev_register(struct device *dev,
 err_free_dev_id:
 	kfree(rdev->descr.dev_id);
 err_free_rdev:
+	mutex_destroy(&rdev->lock);
 	kfree(rdev);
 	return ERR_PTR(ret);
 }
diff --git a/include/linux/rpmb.h b/include/linux/rpmb.h
index ed3f8e431eff..11a5d2646e38 100644
--- a/include/linux/rpmb.h
+++ b/include/linux/rpmb.h
@@ -7,6 +7,7 @@
 #define __RPMB_H__
 
 #include <linux/device.h>
+#include <linux/mutex.h>
 #include <linux/types.h>
 
 /**
@@ -48,12 +49,14 @@ struct rpmb_descr {
  * struct rpmb_dev - device which can support RPMB partition
  *
  * @dev              : device
+ * @lock             : serialises requests and protects them against teardown
  * @id               : device_id
  * @list_node        : linked list node
  * @descr            : RPMB description
  */
 struct rpmb_dev {
 	struct device dev;
+	struct mutex lock;
 	int id;
 	struct list_head list_node;
 	struct rpmb_descr descr;
-- 
2.56.0.567.gdb80ae8cd5-goog

