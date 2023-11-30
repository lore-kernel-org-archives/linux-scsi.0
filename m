Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail.nfschina.com (unknown [42.101.60.195])
	by lindbergh.monkeyblade.net (Postfix) with SMTP id 09BF110E3;
	Wed, 29 Nov 2023 18:42:04 -0800 (PST)
Received: from localhost.localdomain (unknown [180.167.10.98])
	by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPSA id 09CE860DF8F3F;
	Thu, 30 Nov 2023 10:41:48 +0800 (CST)
X-MD-Sfrom: suhui@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: Su Hui <suhui@nfschina.com>
To: hare@suse.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com
Cc: Su Hui <suhui@nfschina.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: aic7xxx: fix some problem of return value
Date: Thu, 30 Nov 2023 10:41:23 +0800
Message-Id: <20231130024122.1193324-1-suhui@nfschina.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

aic7770_probe() should return negative error code rather than positive.
However, aic7770_config() only return positive error code,
ahc_linux_register_host() return both positive and negative error
code. Make aic7770_probe() return negative if error happened and let
ahc_linux_register_host() only return positive error code to fix this
problem.

ahc_linux_pci_dev_probe() should return the value of
ahc_linux_register_host() rather than zero.

Signed-off-by: Su Hui <suhui@nfschina.com>
---
 drivers/scsi/aic7xxx/aic7770_osm.c     | 8 ++++----
 drivers/scsi/aic7xxx/aic7xxx_osm.c     | 2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7770_osm.c b/drivers/scsi/aic7xxx/aic7770_osm.c
index bdd177e3d762..3c1aca15d956 100644
--- a/drivers/scsi/aic7xxx/aic7770_osm.c
+++ b/drivers/scsi/aic7xxx/aic7770_osm.c
@@ -87,23 +87,23 @@ aic7770_probe(struct device *dev)
 	sprintf(buf, "ahc_eisa:%d", eisaBase >> 12);
 	name = kstrdup(buf, GFP_ATOMIC);
 	if (name == NULL)
-		return (ENOMEM);
+		return -ENOMEM;
 	ahc = ahc_alloc(&aic7xxx_driver_template, name);
 	if (ahc == NULL)
-		return (ENOMEM);
+		return -ENOMEM;
 	ahc->dev = dev;
 	error = aic7770_config(ahc, aic7770_ident_table + edev->id.driver_data,
 			       eisaBase);
 	if (error != 0) {
 		ahc->bsh.ioport = 0;
 		ahc_free(ahc);
-		return (error);
+		return -error;
 	}
 
  	dev_set_drvdata(dev, ahc);
 
 	error = ahc_linux_register_host(ahc, &aic7xxx_driver_template);
-	return (error);
+	return -error;
 }
 
 static int
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 4ae0a1c4d374..158aaeca8941 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1117,7 +1117,7 @@ ahc_linux_register_host(struct ahc_softc *ahc, struct scsi_host_template *templa
 	if (retval) {
 		printk(KERN_WARNING "aic7xxx: scsi_add_host failed\n");
 		scsi_host_put(host);
-		return retval;
+		return -retval;
 	}
 
 	scsi_scan_host(host);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
index a07e94fac673..e17eb8df12c4 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
@@ -241,8 +241,8 @@ ahc_linux_pci_dev_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		ahc_linux_pci_inherit_flags(ahc);
 
 	pci_set_drvdata(pdev, ahc);
-	ahc_linux_register_host(ahc, &aic7xxx_driver_template);
-	return (0);
+	error = ahc_linux_register_host(ahc, &aic7xxx_driver_template);
+	return -error;
 }
 
 /******************************* PCI Routines *********************************/
-- 
2.30.2

