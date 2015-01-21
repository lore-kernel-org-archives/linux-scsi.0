From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/3] scsi: Only blacklist WRITE SAME for VMware virtual disks
Date: Tue, 20 Jan 2015 19:58:37 -0500
Message-ID: <1421801919-7137-1-git-send-email-martin.petersen@oracle.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org.#.v3.18+
List-Id: linux-scsi@vger.kernel.org

Commit 4089b71cc820 blacklisted WRITE SAME for all VMware disks.
However, the WRITE SAME commands are supported for passthrough
disks. Change the heuristic so we only blacklist virtual disks.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reported-by: Petr Vandrovec <petr@vmware.com>
Tested-by: Chris J Arges <chris.j.arges@canonical.com>
Cc: stable@vger.kernel.org # v3.18+
---
 drivers/message/fusion/mptspi.c | 5 -----
 drivers/scsi/scsi_devinfo.c     | 2 ++
 drivers/scsi/scsi_scan.c        | 3 +++
 include/scsi/scsi_devinfo.h     | 1 +
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 613231c16194..787933d43d32 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1419,11 +1419,6 @@ mptspi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_mptspi_probe;
         }
 
-	/* VMWare emulation doesn't properly implement WRITE_SAME
-	 */
-	if (pdev->subsystem_vendor == 0x15AD)
-		sh->no_write_same = 1;
-
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
 
 	/* Attach the SCSI Host to the IOC structure
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 262ab837a704..0118ddf163eb 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -251,6 +251,8 @@ static struct {
 	{"TOSHIBA", "CD-ROM", NULL, BLIST_ISROM},
 	{"Traxdata", "CDR4120", NULL, BLIST_NOLUN},	/* locks up */
 	{"USB2.0", "SMARTMEDIA/XD", NULL, BLIST_FORCELUN | BLIST_INQUIRY_36},
+	{"VMware", "Virtual disk", "1.0", BLIST_NO_WRITE_SAME }, /* ESX */
+	{"VMware,", "VMware Virtual S", "1.0", BLIST_NO_WRITE_SAME }, /* WS,Fusion */
 	{"WangDAT", "Model 2600", "01.7", BLIST_SELECT_NO_ATN},
 	{"WangDAT", "Model 3200", "02.2", BLIST_SELECT_NO_ATN},
 	{"WangDAT", "Model 1300", "02.4", BLIST_SELECT_NO_ATN},
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 0deb385ad4d6..49bf1e9dcfb9 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -950,6 +950,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (*bflags & BLIST_NO_DIF)
 		sdev->no_dif = 1;
 
+	if (*bflags & BLIST_NO_WRITE_SAME)
+		sdev->no_write_same = 1;
+
 	sdev->eh_timeout = SCSI_DEFAULT_EH_TIMEOUT;
 
 	if (*bflags & BLIST_TRY_VPD_PAGES)
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 183eaab7c380..1a24efb4b1d6 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -36,5 +36,6 @@
 					     for sequential scan */
 #define BLIST_TRY_VPD_PAGES	0x10000000 /* Attempt to read VPD pages */
 #define BLIST_NO_RSOC		0x20000000 /* don't try to issue RSOC */
+#define BLIST_NO_WRITE_SAME	0x40000000 /* don't try to issue WRITE SAME */
 
 #endif
-- 
1.9.3
