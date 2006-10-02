From: Frederik Deweerdt <deweerdt@free.fr>
Subject: [RFC PATCH] move drm to pci_request_irq
Date: Mon, 2 Oct 2006 20:12:29 +0000
Message-ID: <20061002201229.GF3003@slug>
References: <1159550143.13029.36.camel@localhost.localdomain> <20060929235054.GB2020@slug> <1159573404.13029.96.camel@localhost.localdomain> <20060930140946.GA1195@slug> <451F049A.1010404@garzik.org> <20061001142807.GD16272@parisc-linux.org> <1159729523.2891.408.camel@laptopd505.fenrus.org> <20061001193616.GF16272@parisc-linux.org> <1159755141.2891.434.camel@laptopd505.fenrus.org> <20061002200048.GC3003@slug>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:56948 "EHLO
	ug-out-1314.google.com") by vger.kernel.org with ESMTP
	id S965221AbWJBSNz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Oct 2006 14:13:55 -0400
Received: by ug-out-1314.google.com with SMTP id o38so536957ugd
        for <linux-scsi@vger.kernel.org>; Mon, 02 Oct 2006 11:13:54 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20061002200048.GC3003@slug>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, "Linux-Kernel," <linux-kernel@vger.kernel.org>, "J.A. Magall??n" <jamagallon@ono.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Andrew Morton <akpm@osdl.org>, Jeff Garzik <jeff@garzik.org>

Hi,

This proof-of-concept patch converts the drm driver to use the
pci_request_irq() function.

Regards,
Frederik



diff --git a/drivers/char/drm/drm_drv.c b/drivers/char/drm/drm_drv.c
index b366c5b..5b000cd 100644
--- a/drivers/char/drm/drm_drv.c
+++ b/drivers/char/drm/drm_drv.c
@@ -234,6 +234,8 @@ int drm_lastclose(drm_device_t * dev)
 	}
 	mutex_unlock(&dev->struct_mutex);
 
+	pci_set_drvdata(dev, NULL);
+
 	DRM_DEBUG("lastclose completed\n");
 	return 0;
 }
diff --git a/drivers/char/drm/drm_irq.c b/drivers/char/drm/drm_irq.c
index 4553a3a..5dd12cb 100644
--- a/drivers/char/drm/drm_irq.c
+++ b/drivers/char/drm/drm_irq.c
@@ -132,8 +132,10 @@ static int drm_irq_install(drm_device_t 
 	if (drm_core_check_feature(dev, DRIVER_IRQ_SHARED))
 		sh_flags = IRQF_SHARED;
 
-	ret = request_irq(dev->irq, dev->driver->irq_handler,
-			  sh_flags, dev->devname, dev);
+	pci_set_drvdata(dev->pdev, dev);
+
+	ret = pci_request_irq(dev->pdev, dev->driver->irq_handler,
+			  sh_flags, dev->devname);
 	if (ret < 0) {
 		mutex_lock(&dev->struct_mutex);
 		dev->irq_enabled = 0;
@@ -173,7 +175,7 @@ int drm_irq_uninstall(drm_device_t * dev
 
 	dev->driver->irq_uninstall(dev);
 
-	free_irq(dev->irq, dev);
+	pci_free_irq(dev->pdev);
 
 	return 0;
 }
