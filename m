Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE4737107F;
	Mon, 27 Apr 2026 06:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777271415; cv=none; b=pli59E0zT/bG5UugWBXtzR6qAO+7/nWJ8L9NniAHWHc3OcjneHvBW7hek+Cc2vvY7N5/XqkyerOha4FeTdG/al2pnjbtoggguCVk0OuoU/AKr9aEfeW+9IwZxFdiSTZM8bEW1RI1EqzT2Op6sLUzW1v5OVgL3IRVg/hU6RXSylQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777271415; c=relaxed/simple;
	bh=177kbGeM6EeJpfIq+3NWyXjbal0uoklMJOGMVNybWDc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=s2ywCL2y5tDPKd1CDE5h2hpEroiWS6El8sQHWBkXusnvYgDnxMGwnQ56zlttnnQ9p0N377Qu/sT2Zb8wFriTwkC19aRkuNlCdv9+ebIz4b90OG383CrkVDYnWDVifGKsXKHUoOREw/35SKqevRam7qCCodHNWxNVtb/0Mw5059I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=NYHMuyhV; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="NYHMuyhV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=KTP5ZU+2rp6IFJWA9JeJed0+oeckjBUHCIH8AyI7xDs=;
	b=NYHMuyhVRK6kq2ReeNxxgKoHS+ggM9mPYcQjhbC0tnAna4LXn1NKQZNh0oBJWG
	nU47KjU/+tLt8tekY7/6j93gV91P64iL26mSnej4Ev6CSO9MFV/oBhRYKtv2Vv7U
	dcGyCA4BnevOydIOFUQq+jkr2irCVm68vHcqPU/JOIgno=
Received: from pek-lpg-core5.wrs.com (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgA3beoJAu9p5KzwBw--.24174S2;
	Mon, 27 Apr 2026 14:28:27 +0800 (CST)
From: Robert Garcia <rob_garcia@163.com>
To: stable@vger.kernel.org,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Robert Garcia <rob_garcia@163.com>,
	Bean Huo <beanhuo@micron.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E . J . Bottomley" <jejb@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Wang Shuaiwei <wangshuaiwei1@xiaomi.com>,
	Eric Biggers <ebiggers@google.com>,
	Manish Pandey <quic_mapa@quicinc.com>,
	Brian Kao <powenkao@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Archana Patni <archana.patni@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Mike Snitzer <snitzer@redhat.com>,
	Satya Tangirala <satyat@google.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5.15.y] scsi: ufs: core: Fix use-after free in init error and remove paths
Date: Mon, 27 Apr 2026 14:28:25 +0800
Message-Id: <20260427062825.495779-1-rob_garcia@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgA3beoJAu9p5KzwBw--.24174S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxtw13XFWfGw4DWryDKrWkCrg_yoW3tr48pr
	W0qay5Aw4kGr47Cr1UJw48CFWFkw1xG345G397u34F93WYkF93Wa4vyFy09FyrGFZ5Za1U
	XF4qyr48u3WjvaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zitEfrUUUUU=
X-CM-SenderInfo: 5uresw5dufxti6rwjhhfrp/xtbC5QzZRWnvAgz3cgAA34

From: André Draszik <andre.draszik@linaro.org>

[ Upstream commit f8fb2403ddebb5eea0033d90d9daae4c88749ada ]

devm_blk_crypto_profile_init() registers a cleanup handler to run when
the associated (platform-) device is being released. For UFS, the
crypto private data and pointers are stored as part of the ufs_hba's
data structure 'struct ufs_hba::crypto_profile'. This structure is
allocated as part of the underlying ufshcd and therefore Scsi_host
allocation.

During driver release or during error handling in ufshcd_pltfrm_init(),
this structure is released as part of ufshcd_dealloc_host() before the
(platform-) device associated with the crypto call above is released.
Once this device is released, the crypto cleanup code will run, using
the just-released 'struct ufs_hba::crypto_profile'. This causes a
use-after-free situation:

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
    * a memleak is plugged in tc-dwc-g210-pci.c remove() as a
      side-effect
    * EXPORT_SYMBOL_GPL(ufshcd_dealloc_host) can be removed fully as
      it's not needed anymore
    * no future drivers using ufshcd_alloc_host() could ever forget
      adding the cleanup

Fixes: cb77cb5abe1f ("blk-crypto: rename blk_keyslot_manager to blk_crypto_profile")
Fixes: d76d9d7d1009 ("scsi: ufs: use devm_blk_ksm_init()")
Cc: stable@vger.kernel.org
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Link: https://lore.kernel.org/r/20250124-ufshcd-fix-v4-1-c5d0144aae59@linaro.org
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Acked-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[ Delete modifications about ufshcd_parse_operating_points() for it's added from
commit 72208ebe181e3("scsi: ufs: core: Add support for parsing OPP")
and that in ufshcd_pltfrm_remove() for it's added from commit
897df60c16d54("scsi: ufs: pltfrm: Dellocate HBA during ufshcd_pltfrm_remove()"). ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
---
 drivers/scsi/ufs/ufshcd-pci.c    |  2 --
 drivers/scsi/ufs/ufshcd-pltfrm.c | 25 ++++++++-----------------
 drivers/scsi/ufs/ufshcd.c        | 31 +++++++++++++++++++++----------
 drivers/scsi/ufs/ufshcd.h        |  1 -
 4 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index ec483ece09b6..351e6915c33c 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -554,7 +554,6 @@ static void ufshcd_pci_remove(struct pci_dev *pdev)
 	pm_runtime_forbid(&pdev->dev);
 	pm_runtime_get_noresume(&pdev->dev);
 	ufshcd_remove(hba);
-	ufshcd_dealloc_host(hba);
 }
 
 /**
@@ -599,7 +598,6 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	err = ufshcd_init(hba, mmio_base, pdev->irq);
 	if (err) {
 		dev_err(&pdev->dev, "Initialization failed\n");
-		ufshcd_dealloc_host(hba);
 		return err;
 	}
 
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index adc302b1a57a..c254d5f697fc 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -339,21 +339,17 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 	struct device *dev = &pdev->dev;
 
 	mmio_base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(mmio_base)) {
-		err = PTR_ERR(mmio_base);
-		goto out;
-	}
+	if (IS_ERR(mmio_base))
+		return PTR_ERR(mmio_base);
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
-		err = irq;
-		goto out;
-	}
+	if (irq < 0)
+		return irq;
 
 	err = ufshcd_alloc_host(dev, &hba);
 	if (err) {
 		dev_err(&pdev->dev, "Allocation failed\n");
-		goto out;
+		return err;
 	}
 
 	hba->vops = vops;
@@ -362,13 +358,13 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 	if (err) {
 		dev_err(&pdev->dev, "%s: clock parse failed %d\n",
 				__func__, err);
-		goto dealloc_host;
+		return err;
 	}
 	err = ufshcd_parse_regulator_info(hba);
 	if (err) {
 		dev_err(&pdev->dev, "%s: regulator init failed %d\n",
 				__func__, err);
-		goto dealloc_host;
+		return err;
 	}
 
 	ufshcd_init_lanes_per_dir(hba);
@@ -376,18 +372,13 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 	err = ufshcd_init(hba, mmio_base, irq);
 	if (err) {
 		dev_err(dev, "Initialization failed\n");
-		goto dealloc_host;
+		return err;
 	}
 
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
 	return 0;
-
-dealloc_host:
-	ufshcd_dealloc_host(hba);
-out:
-	return err;
 }
 EXPORT_SYMBOL_GPL(ufshcd_pltfrm_init);
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 55eaf04d7593..637607868f55 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9322,16 +9322,6 @@ void ufshcd_remove(struct ufs_hba *hba)
 }
 EXPORT_SYMBOL_GPL(ufshcd_remove);
 
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
@@ -9348,11 +9338,25 @@ static int ufshcd_set_dma_mask(struct ufs_hba *hba)
 	return dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(32));
 }
 
+/**
+ * ufshcd_devres_release - devres cleanup handler, invoked during release of
+ *			   hba->dev
+ * @host: pointer to SCSI host
+ */
+static void ufshcd_devres_release(void *host)
+{
+	scsi_host_put(host);
+}
+
 /**
  * ufshcd_alloc_host - allocate Host Bus Adapter (HBA)
  * @dev: pointer to device handle
  * @hba_handle: driver private handle
  * Returns 0 on success, non-zero value on failure
+ *
+ * NOTE: There is no corresponding ufshcd_dealloc_host() because this function
+ * keeps track of its allocations using devres and deallocates everything on
+ * device removal automatically.
  */
 int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 {
@@ -9374,6 +9378,13 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 		err = -ENOMEM;
 		goto out_error;
 	}
+
+	err = devm_add_action_or_reset(dev, ufshcd_devres_release,
+				       host);
+	if (err)
+		return dev_err_probe(dev, err,
+				     "failed to add ufshcd dealloc action\n");
+
 	hba = shost_priv(host);
 	hba->host = host;
 	hba->dev = dev;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c8513cc6c2bd..3ceac158c7f3 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1001,7 +1001,6 @@ static inline void ufshcd_rmwl(struct ufs_hba *hba, u32 mask, u32 val, u32 reg)
 }
 
 int ufshcd_alloc_host(struct device *, struct ufs_hba **);
-void ufshcd_dealloc_host(struct ufs_hba *);
 int ufshcd_hba_enable(struct ufs_hba *hba);
 int ufshcd_init(struct ufs_hba *, void __iomem *, unsigned int);
 int ufshcd_link_recovery(struct ufs_hba *hba);
-- 
2.34.1

