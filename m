From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 3/5] bfa: use pci_iomap() and pci_iounmap()
Date: Fri, 19 Mar 2010 11:06:44 -0700
Message-ID: <1269022004-11958-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:35418 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966Ab0CSSd7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Mar 2010 14:33:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com

Use pci_iomap() and pci_iounmap() to simplify the code. Remove uncessary #ifdef
check for ia64 (it was added as a workaound for some RHEL 5.x release which 
doesn't export iounmap function) 

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfad.c     |    9 +--------
 drivers/scsi/bfa/bfad_drv.h |    1 -
 2 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index fcbba84..23b28d3 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -589,7 +589,6 @@ bfad_init_timer(struct bfad_s *bfad)
 int
 bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
 {
-	unsigned long   bar0_len;
 	int             rc = -ENODEV;
 
 	if (pci_enable_device(pdev)) {
@@ -609,9 +608,7 @@ bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
 			goto out_release_region;
 		}
 
-	bfad->pci_bar0_map = pci_resource_start(pdev, 0);
-	bar0_len = pci_resource_len(pdev, 0);
-	bfad->pci_bar0_kva = ioremap(bfad->pci_bar0_map, bar0_len);
+	bfad->pci_bar0_kva = pci_iomap(pdev, 0, pci_resource_len(pdev, 0));
 
 	if (bfad->pci_bar0_kva == NULL) {
 		BFA_PRINTF(BFA_ERR, "Fail to map bar0\n");
@@ -644,11 +641,7 @@ out:
 void
 bfad_pci_uninit(struct pci_dev *pdev, struct bfad_s *bfad)
 {
-#if defined(__ia64__)
 	pci_iounmap(pdev, bfad->pci_bar0_kva);
-#else
-	iounmap(bfad->pci_bar0_kva);
-#endif
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index f4b1439..0639aed 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -162,7 +162,6 @@ struct bfad_s {
 	const char *pci_name;
 	struct bfa_pcidev_s hal_pcidev;
 	struct bfa_ioc_pci_attr_s pci_attr;
-	unsigned long   pci_bar0_map;
 	void __iomem   *pci_bar0_kva;
 	struct completion comp;
 	struct completion suspend;
-- 
1.6.5.2

