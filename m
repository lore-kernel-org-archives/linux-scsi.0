From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.8-rc5
Date: Tue, 06 Sep 2016 10:42:51 -0400
Message-ID: <1473172971.17204.11.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is really three fixes, but the SES one comes in a bundle of three
(making the replacement API available properly, using it and removing
the non-working one).  The SES problem causes an oops on hpsa devices
because they attach virtual disks to the host which aren't SAS attached
(the replacement API ignores them).  The other two fixes are fairly
minor: the sense key one means we actually resolve a newly added sense
key and the RDAC device blacklisting is needed to prevent us annoying
the universal XPORT lun of various RDAC arrays.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Johannes Thumshirn (3):
      scsi: sas: remove is_sas_attached()
      scsi: ses: use scsi_is_sas_rphy instead of is_sas_attached
      scsi: sas: provide stub implementation for scsi_is_sas_rphy

Tyrel Datwyler (1):
      scsi: fix upper bounds check of sense key in scsi_sense_key_string()

Xose Vazquez Perez (1):
      scsi: blacklist all RDAC devices for BLIST_NO_ULD_ATTACH

And the diffstat:

 drivers/scsi/constants.c          |  5 +++--
 drivers/scsi/scsi_devinfo.c       |  4 ++++
 drivers/scsi/scsi_transport_sas.c | 16 ----------------
 drivers/scsi/ses.c                |  2 +-
 include/scsi/scsi_transport_sas.h |  5 ++---
 5 files changed, 10 insertions(+), 22 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 83458f7..6dc96c8 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -361,8 +361,9 @@ static const char * const snstext[] = {
 
 /* Get sense key string or NULL if not available */
 const char *
-scsi_sense_key_string(unsigned char key) {
-	if (key <= 0xE)
+scsi_sense_key_string(unsigned char key)
+{
+	if (key < ARRAY_SIZE(snstext))
 		return snstext[key];
 	return NULL;
 }
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index eaccd65..2464569 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -246,6 +246,10 @@ static struct {
 	{"IBM", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"SUN", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"DELL", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
+	{"STK", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
+	{"NETAPP", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
+	{"LSI", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
+	{"ENGENIO", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"SMSC", "USB 2 HS-CF", NULL, BLIST_SPARSELUN | BLIST_INQUIRY_36},
 	{"SONY", "CD-ROM CDU-8001", NULL, BLIST_BORKEN},
 	{"SONY", "TSL", NULL, BLIST_FORCELUN},		/* DDS3 & DDS4 autoloaders */
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 3f0ff07..60b651b 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -341,22 +341,6 @@ static int do_sas_phy_delete(struct device *dev, void *data)
 }
 
 /**
- * is_sas_attached - check if device is SAS attached
- * @sdev: scsi device to check
- *
- * returns true if the device is SAS attached
- */
-int is_sas_attached(struct scsi_device *sdev)
-{
-	struct Scsi_Host *shost = sdev->host;
-
-	return shost->transportt->host_attrs.ac.class ==
-		&sas_host_class.class;
-}
-EXPORT_SYMBOL(is_sas_attached);
-
-
-/**
  * sas_remove_children  -  tear down a devices SAS data structures
  * @dev:	device belonging to the sas object
  *
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 0e8601a..8c9a35c 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -587,7 +587,7 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
 
 	ses_enclosure_data_process(edev, to_scsi_device(edev->edev.parent), 0);
 
-	if (is_sas_attached(sdev))
+	if (scsi_is_sas_rphy(&sdev->sdev_gendev))
 		efd.addr = sas_get_address(sdev);
 
 	if (efd.addr) {
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index 13c0b2b..73d8709 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -11,12 +11,12 @@ struct sas_rphy;
 struct request;
 
 #if !IS_ENABLED(CONFIG_SCSI_SAS_ATTRS)
-static inline int is_sas_attached(struct scsi_device *sdev)
+static inline int scsi_is_sas_rphy(const struct device *sdev)
 {
 	return 0;
 }
 #else
-extern int is_sas_attached(struct scsi_device *sdev);
+extern int scsi_is_sas_rphy(const struct device *);
 #endif
 
 static inline int sas_protocol_ata(enum sas_protocol proto)
@@ -202,7 +202,6 @@ extern int sas_rphy_add(struct sas_rphy *);
 extern void sas_rphy_remove(struct sas_rphy *);
 extern void sas_rphy_delete(struct sas_rphy *);
 extern void sas_rphy_unlink(struct sas_rphy *);
-extern int scsi_is_sas_rphy(const struct device *);
 
 struct sas_port *sas_port_alloc(struct device *, int);
 struct sas_port *sas_port_alloc_num(struct device *);
