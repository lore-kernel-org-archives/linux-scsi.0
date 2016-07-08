From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.7-rc6
Date: Fri, 08 Jul 2016 13:20:44 -0700
Message-ID: <1468009244.2431.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55770 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755818AbcGHUVE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2016 16:21:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Three fixes.  One is the qla24xx MSI regression, one is a theoretical
problem over blacklist matching, which would bite USB badly if it ever
triggered and one is a system hang with a particular type of IPR
device.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Alan Stern (1):
      SCSI: fix new bug in scsi_dev_info_list string matching

Brian King (1):
      ipr: Clear interrupt on croc/crocodile when running with LSI

Bruno Pr=C3=83=C2=A9mont (1):
      qla2xxx: Fix NULL pointer deref in QLA interrupt

And the diffstat:

 drivers/scsi/ipr.c             |  1 +
 drivers/scsi/qla2xxx/qla_isr.c |  2 +-
 drivers/scsi/scsi_devinfo.c    | 10 ++++++----
 3 files changed, 8 insertions(+), 5 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index d6a691e..d6803a9 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -10093,6 +10093,7 @@ static int ipr_probe_ioa(struct pci_dev *pdev,
 		ioa_cfg->intr_flag =3D IPR_USE_MSI;
 	else {
 		ioa_cfg->intr_flag =3D IPR_USE_LSI;
+		ioa_cfg->clear_isr =3D 1;
 		ioa_cfg->nvectors =3D 1;
 		dev_info(&pdev->dev, "Cannot enable MSI.\n");
 	}
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_=
isr.c
index 5649c20..a92a62d 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2548,7 +2548,7 @@ void qla24xx_process_response_queue(struct scsi_q=
la_host *vha,
 	if (!vha->flags.online)
 		return;
=20
-	if (rsp->msix->cpuid !=3D smp_processor_id()) {
+	if (rsp->msix && rsp->msix->cpuid !=3D smp_processor_id()) {
 		/* if kernel does not notify qla of IRQ's CPU change,
 		 * then set it here.
 		 */
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index ff41c31..eaccd65 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -429,7 +429,7 @@ static struct scsi_dev_info_list *scsi_dev_info_lis=
t_find(const char *vendor,
 	 * here, and we don't know what device it is
 	 * trying to work with, leave it as-is.
 	 */
-	vmax =3D 8;	/* max length of vendor */
+	vmax =3D sizeof(devinfo->vendor);
 	vskip =3D vendor;
 	while (vmax > 0 && *vskip =3D=3D ' ') {
 		vmax--;
@@ -439,7 +439,7 @@ static struct scsi_dev_info_list *scsi_dev_info_lis=
t_find(const char *vendor,
 	while (vmax > 0 && vskip[vmax - 1] =3D=3D ' ')
 		--vmax;
=20
-	mmax =3D 16;	/* max length of model */
+	mmax =3D sizeof(devinfo->model);
 	mskip =3D model;
 	while (mmax > 0 && *mskip =3D=3D ' ') {
 		mmax--;
@@ -455,10 +455,12 @@ static struct scsi_dev_info_list *scsi_dev_info_l=
ist_find(const char *vendor,
 			 * Behave like the older version of get_device_flags.
 			 */
 			if (memcmp(devinfo->vendor, vskip, vmax) ||
-					devinfo->vendor[vmax])
+					(vmax < sizeof(devinfo->vendor) &&
+						devinfo->vendor[vmax]))
 				continue;
 			if (memcmp(devinfo->model, mskip, mmax) ||
-					devinfo->model[mmax])
+					(mmax < sizeof(devinfo->model) &&
+						devinfo->model[mmax]))
 				continue;
 			return devinfo;
 		} else {

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
