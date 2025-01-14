Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7D01C1AAA
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jan 2025 16:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736871380; cv=none; b=QAvcBM1i+Rtr1v9qt4XPxhcbj+ZwydGeJpPN5uUcNqrzj2UWeVonT6iUSsDa7dFylcQqjIADtX1X817iGKiDmBQ5DYS8jsu9KLaCDs8gqe4bZnEgFUQRmPa9QKeHPFhA8DQKALwXqLKz5Bob7gmrLumuQGZbA7qDUYhJwR0irXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736871380; c=relaxed/simple;
	bh=ZgJo3DP4+WvK7jYux/ACpbJ4dQQ/62qBd5xk+YfnP7A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=ZmF60lnVAd6t2QW6OrVKAXcxa7qJe1WkCmuMDkI7vnkTfKkeqX7IzZ4UIbvZcGeYfqMV8EXf0o5lgZFYn8ZdQdzAnoOau4vEwZVlTBcVAkvAZz0nx+Pa2Tv8kRBKVpwp5dDDIUREuU9EEhfwVnRABoaf4zRdXfcxz7RjtQEMmUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=n4Iot13w; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="n4Iot13w"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5d0d32cd31aso8015605a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jan 2025 08:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736871377; x=1737476177; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mJqg+/HnHgg1RZbPnt+p/XNLoPcWEGRQ84Ss98oznDI=;
        b=n4Iot13wZSYT0UPXG23mU69j21J6RBrGctY68CgU7PTEFJWxlJv90WEP6uUVnAoExZ
         N3Q5eLRGnn2j5yX5+7nJGC1kpiweaccgtxq94P0Yo5L2jW2pFjxUyv+g6HoZIBrAVHLg
         VvTkfXYGZnJLRB6eJYA22Za7onDmiWGm3scQUQdNdnTtFVNG0OblSNYU8OhOL0t3G1lk
         ur2Pt6H/q0ylCJCtRAJ/iylxK7XwNfqAU4fTIKrV8Ha9TPnXUhO0uE0x0c0frKJHkbdd
         iqVpf4ucg5PHFSD/GySzMR/kHpeM2/r3CKGtkGUgzLpdLOgq/l+rHaC+z1f9hxWJP3/q
         +UeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736871377; x=1737476177;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mJqg+/HnHgg1RZbPnt+p/XNLoPcWEGRQ84Ss98oznDI=;
        b=ZTd3FeZk1DKRUc0FCtIHal6jxokvtwvw0w2op+PW0SDk97kxj9XekWTXEykCQnquxW
         h4guTSBXsLhDU7kc6lqCywF1yQedHg5DAnP7fT1nWgLIDjvE2t/3BwxCLLLk0wNYPgeb
         hEcKmgQAu6HV6R8gff5jHOgI86FSivYYMRR6aMzZWFrdM9hJQZG1SjbWT8OOIUooJnZh
         1lsXcArS0mJMTtPbIHIdFSt4QEJQ8FkL3R++yCV20gCrkl9PwuIfcJt/bv1lo8VNoRIZ
         EB9Trt/8JOTPe7h7vThI6SG9leKBWJBdZ8ZhwqKlSKxuRZ5ttoOJ6WnVaqL4h/G5Uv7r
         pM6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWGOj0vkWithAWIv5MoASR39Ct5MuUDDKUaTYSu1c44ukRVZjf2wDBf3IyvGxhbtI2EKYSalaViOvHD@vger.kernel.org
X-Gm-Message-State: AOJu0YyNi+vY1pFhYJZGEO8lhJ2/POMyGq/TRSy49tOFx+Oxnc0Oo9sI
	S1TAE1afT7HpiAbqIjFYZK9wR8BGtYVpeeVz6uAwFzcg2KVSdnQjsyXUAHv3BbQ=
X-Gm-Gg: ASbGncvHtViEAZmghK1U+5jbN8F1ngPSzQpg6vGQIQ2Y/uPsl0UtUG2AAwiEoQ8HyvH
	PANaDjJlBQfaj50wg3Qf2llPeGQLfnvg4IhOPero4VxsQ0K5Rit1EU0Mc4EByLBLm2HWIwR6AYa
	vns8US5UdJG08w9t8TpLVg9X3KAR79jJZQy8cLtjiEfXsbG6ZqegLpzCxz2gn4sLipGuLBxNadm
	2TuXu4xushL/94yAMg0Ph6f/nKVAyc4cHuWP5MizOIgGb8mb67HuQU3KcSw7m3Keo4D/ILhEuJr
	xKpJH0XFWqhhvBaHTKrrtmkv/Dww0UAH1eZ5x9rQ
X-Google-Smtp-Source: AGHT+IHmGJ4N4gtNTLAv7jsoVRRKVp2DJsAgH9A5WCYjUUasxTeYIS9hpw7fIgUeU/Q/iCGEhglboQ==
X-Received: by 2002:a05:6402:1e94:b0:5d9:fa36:5964 with SMTP id 4fb4d7f45d1cf-5d9fa365c32mr5873031a12.2.1736871375098;
        Tue, 14 Jan 2025 08:16:15 -0800 (PST)
Received: from puffmais.c.googlers.com (140.20.91.34.bc.googleusercontent.com. [34.91.20.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c90d52edsm643536066b.42.2025.01.14.08.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 08:16:14 -0800 (PST)
From: =?utf-8?q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>
Date: Tue, 14 Jan 2025 16:16:09 +0000
Subject: [PATCH v2] scsi: ufs: fix use-after free in init error and remove
 paths
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250114-ufshcd-fix-v2-1-2dc627590a4a@linaro.org>
X-B4-Tracking: v=1; b=H4sIAMiNhmcC/22MywrCMBAAf6Xs2ZVk2wh68j+kh5hHsyCJJDUoJ
 f9u7NnjDMxsUFxmV+AybJBd5cIpdqDDACbouDhk2xlIkBJSjvjyJRiLnt+oaBJnT3Yk76EHz+y
 63me3uXPgsqb82d9V/uzfTZUo0ejTaKWd7lap64OjzumY8gJza+0Lkj3a6qUAAAA=
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Peter Griffin <peter.griffin@linaro.org>, 
 Krzysztof Kozlowski <krzk@kernel.org>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
 Eric Biggers <ebiggers@kernel.org>
Cc: Tudor Ambarus <tudor.ambarus@linaro.org>, 
 Will McVicker <willmcvicker@google.com>, kernel-team@android.com, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-arm-msm@vger.kernel.org, stable@vger.kernel.org, 
 =?utf-8?q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>
X-Mailer: b4 0.13.0

devm_blk_crypto_profile_init() registers a cleanup handler to run when
the associated (platform-) device is being released. For UFS, the
crypto private data and pointers are stored as part of the ufs_hba's
data structure 'struct ufs_hba::crypto_profile'. This structure is
allocated as part of the underlying ufshd allocation.

During driver release or during error handling in ufshcd_pltfrm_init(),
this structure is released as part of ufshcd_dealloc_host() before the
(platform-) device associated with the crypto call above is released.
Once this device is released, the crypto cleanup code will run, using
the just-released 'struct ufs_hba::crypto_profile'. This causes a
use-after-free situation:

    exynos-ufshc 14700000.ufs: ufshcd_pltfrm_init() failed -11
    exynos-ufshc 14700000.ufs: probe with driver exynos-ufshc failed with error -11
    Unable to handle kernel paging request at virtual address 01adafad6dadad88
    Mem abort info:
      ESR = 0x0000000096000004
      EC = 0x25: DABT (current EL), IL = 32 bits
      SET = 0, FnV = 0
      EA = 0, S1PTW = 0
      FSC = 0x04: level 0 translation fault
    Data abort info:
      ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
      CM = 0, WnR = 0, TnD = 0, TagAccess = 0
      GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
    [01adafad6dadad88] address between user and kernel address ranges
    Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
    Modules linked in:
    CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Tainted: G        W          6.13.0-rc5-next-20250106+ #70
    Tainted: [W]=WARN
    Hardware name: Oriole (DT)
    pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
    pc : kfree+0x60/0x2d8
    lr : kvfree+0x44/0x60
    sp : ffff80008009ba80
    x29: ffff80008009ba90 x28: 0000000000000000 x27: ffffbcc6591e0130
    x26: ffffbcc659309960 x25: ffffbcc658f89c50 x24: ffffbcc659539d80
    x23: ffff22e000940040 x22: ffff22e001539010 x21: ffffbcc65714b22c
    x20: 6b6b6b6b6b6b6b6b x19: 01adafad6dadad80 x18: 0000000000000000
    x17: ffffbcc6579fbac8 x16: ffffbcc657a04300 x15: ffffbcc657a027f4
    x14: ffffbcc656f969cc x13: ffffbcc6579fdc80 x12: ffffbcc6579fb194
    x11: ffffbcc6579fbc34 x10: 0000000000000000 x9 : ffffbcc65714b22c
    x8 : ffff80008009b880 x7 : 0000000000000000 x6 : ffff80008009b940
    x5 : ffff80008009b8c0 x4 : ffff22e000940518 x3 : ffff22e006f54f40
    x2 : ffffbcc657a02268 x1 : ffff80007fffffff x0 : ffffc1ffc0000000
    Call trace:
     kfree+0x60/0x2d8 (P)
     kvfree+0x44/0x60
     blk_crypto_profile_destroy_callback+0x28/0x70
     devm_action_release+0x1c/0x30
     release_nodes+0x6c/0x108
     devres_release_all+0x98/0x100
     device_unbind_cleanup+0x20/0x70
     really_probe+0x218/0x2d0

In other words, the initialisation code flow is:

  platform-device probe
    ufshcd_pltfrm_init()
      ufshcd_alloc_host()
        scsi_host_alloc()
          allocation of struct ufs_hba
          creation of scsi-host devices
    devm_blk_crypto_profile_init()
      devm registration of cleanup handler using platform-device

and during error handling of ufshcd_pltfrm_init() or during driver
removal:

  ufshcd_dealloc_host()
    scsi_host_put()
      put_device(scsi-host)
        release of struct ufs_hba
  put_device(platform-device)
    crypto cleanup handler

To fix this use-after free, change ufshcd_alloc_host() to register a
devres action to automatically cleanup the underlying SCSI device on
ufshcd destruction, without requiring explicit calls to
ufshcd_dealloc_host(). This way:

    * the crypto profile and all other ufs_hba-owned resources are
      destroyed before SCSI (as they've been registered after)
    * a memleak is plugged in tc-dwc-g210-pci.c as a side-effect
    * EXPORT_SYMBOL_GPL(ufshcd_dealloc_host) can be removed fully as
      it's not needed anymore
    * no future drivers using ufshcd_alloc_host() could ever forget
      adding the cleanup

Fixes: cb77cb5abe1f ("blk-crypto: rename blk_keyslot_manager to blk_crypto_profile")
Fixes: d76d9d7d1009 ("scsi: ufs: use devm_blk_ksm_init()")
Cc: stable@vger.kernel.org
Signed-off-by: André Draszik <andre.draszik@linaro.org>
---
Changes in v2:
- completely new approach using devres action for Scsi_host cleanup, to
  ensure ordering
- add Fixes: and CC: stable tags (Eric)
- Link to v1: https://lore.kernel.org/r/20250113-ufshcd-fix-v1-1-ca63d1d4bd55@linaro.org
---
In my case, as per above trace I initially encountered an error in
ufshcd_verify_dev_init(), which made me notice this problem. For
reproducing, it'd be possible to change that function to just return an
error.

Other approaches for solving this issue I see are the following, but I
believe this one here is the cleanest:

* turn 'struct ufs_hba::crypto_profile' into a dynamically allocated
  pointer, in which case it doesn't matter if cleanup runs after
  scsi_host_put()
* add an explicit devm_blk_crypto_profile_deinit() to be called by API
  users when necessary, e.g. before ufshcd_dealloc_host() in this case
* register the crypto cleanup handler against the scsi-host device
  instead, like in v1 of this patch
---
 drivers/ufs/core/ufshcd.c        | 27 +++++++++++++++++----------
 drivers/ufs/host/ufshcd-pci.c    |  2 --
 drivers/ufs/host/ufshcd-pltfrm.c | 11 ++++-------
 include/ufs/ufshcd.h             |  1 -
 4 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 43ddae7318cb..84089f3f62b0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10279,16 +10279,6 @@ int ufshcd_system_thaw(struct device *dev)
 EXPORT_SYMBOL_GPL(ufshcd_system_thaw);
 #endif /* CONFIG_PM_SLEEP  */
 
-/**
- * ufshcd_dealloc_host - deallocate Host Bus Adapter (HBA)
- * @hba: pointer to Host Bus Adapter (HBA)
- */
-void ufshcd_dealloc_host(struct ufs_hba *hba)
-{
-	scsi_host_put(hba->host);
-}
-EXPORT_SYMBOL_GPL(ufshcd_dealloc_host);
-
 /**
  * ufshcd_set_dma_mask - Set dma mask based on the controller
  *			 addressing capability
@@ -10307,6 +10297,16 @@ static int ufshcd_set_dma_mask(struct ufs_hba *hba)
 	return dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(32));
 }
 
+/**
+ * ufshcd_scsi_host_put_callback - deallocate underlying Scsi_Host and
+ *				   thereby the Host Bus Adapter (HBA)
+ * @host: pointer to SCSI host
+ */
+static void ufshcd_scsi_host_put_callback(void *host)
+{
+	scsi_host_put(host);
+}
+
 /**
  * ufshcd_alloc_host - allocate Host Bus Adapter (HBA)
  * @dev: pointer to device handle
@@ -10334,6 +10334,13 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 		err = -ENOMEM;
 		goto out_error;
 	}
+
+	err = devm_add_action_or_reset(dev, ufshcd_scsi_host_put_callback,
+				       host);
+	if (err)
+		return dev_err_probe(dev, err,
+				     "failed to add ufshcd dealloc action\n");
+
 	host->nr_maps = HCTX_TYPE_POLL + 1;
 	hba = shost_priv(host);
 	hba->host = host;
diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index ea39c5d5b8cf..9cfcaad23cf9 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -562,7 +562,6 @@ static void ufshcd_pci_remove(struct pci_dev *pdev)
 	pm_runtime_forbid(&pdev->dev);
 	pm_runtime_get_noresume(&pdev->dev);
 	ufshcd_remove(hba);
-	ufshcd_dealloc_host(hba);
 }
 
 /**
@@ -605,7 +604,6 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	err = ufshcd_init(hba, mmio_base, pdev->irq);
 	if (err) {
 		dev_err(&pdev->dev, "Initialization failed\n");
-		ufshcd_dealloc_host(hba);
 		return err;
 	}
 
diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index 505572d4fa87..adb0a65d9df5 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -488,13 +488,13 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 	if (err) {
 		dev_err(dev, "%s: clock parse failed %d\n",
 				__func__, err);
-		goto dealloc_host;
+		goto out;
 	}
 	err = ufshcd_parse_regulator_info(hba);
 	if (err) {
 		dev_err(dev, "%s: regulator init failed %d\n",
 				__func__, err);
-		goto dealloc_host;
+		goto out;
 	}
 
 	ufshcd_init_lanes_per_dir(hba);
@@ -502,14 +502,14 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 	err = ufshcd_parse_operating_points(hba);
 	if (err) {
 		dev_err(dev, "%s: OPP parse failed %d\n", __func__, err);
-		goto dealloc_host;
+		goto out;
 	}
 
 	err = ufshcd_init(hba, mmio_base, irq);
 	if (err) {
 		dev_err_probe(dev, err, "Initialization failed with error %d\n",
 			      err);
-		goto dealloc_host;
+		goto out;
 	}
 
 	pm_runtime_set_active(dev);
@@ -517,8 +517,6 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 
 	return 0;
 
-dealloc_host:
-	ufshcd_dealloc_host(hba);
 out:
 	return err;
 }
@@ -534,7 +532,6 @@ void ufshcd_pltfrm_remove(struct platform_device *pdev)
 
 	pm_runtime_get_sync(&pdev->dev);
 	ufshcd_remove(hba);
-	ufshcd_dealloc_host(hba);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_put_noidle(&pdev->dev);
 }
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index da0fa5c65081..58eb6e897827 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1311,7 +1311,6 @@ static inline void ufshcd_rmwl(struct ufs_hba *hba, u32 mask, u32 val, u32 reg)
 void ufshcd_enable_irq(struct ufs_hba *hba);
 void ufshcd_disable_irq(struct ufs_hba *hba);
 int ufshcd_alloc_host(struct device *, struct ufs_hba **);
-void ufshcd_dealloc_host(struct ufs_hba *);
 int ufshcd_hba_enable(struct ufs_hba *hba);
 int ufshcd_init(struct ufs_hba *, void __iomem *, unsigned int);
 int ufshcd_link_recovery(struct ufs_hba *hba);

---
base-commit: 4e16367cfe0ce395f29d0482b78970cce8e1db73
change-id: 20250113-ufshcd-fix-52409f2d32ff

Best regards,
-- 
André Draszik <andre.draszik@linaro.org>

