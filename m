From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH RFC] yet more struct scsi_lun
Date: Sun, 23 Oct 2005 03:00:11 -0400
Message-ID: <20051023070011.GA26569@havoc.gtf.org>
References: <20051023043301.GA22615@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:22241 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751100AbVJWHAP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 03:00:15 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id ED59D1C095D4
	for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2005 03:00:11 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9N70B35027000
	for linux-scsi@vger.kernel.org; Sun, 23 Oct 2005 03:00:11 -0400
Content-Disposition: inline
In-Reply-To: <20051023043301.GA22615@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Douglas Gilbert reminded me of a lun limitation I could kill.  This
patch applied on top of the previous two lun patches.

DO NOT APPLY.  For discussion only.

Changes:
* add SCSILUN_UNLIMITED for LLDDs without lun limits; set
	shost->max_lun = SCSILUN_UNLIMITED;

* remove the lun limits in scsi_report_lun_scan()


Special note:
With this patch (and previous patches in series), max_lun limitation
only remains in two areas, AFAICS:

  1) legacy LLDDs that perform sequential lun scans
  2) legacy userspace interfaces
  3) Any LLDD that fails to set max_lun = SCSILUN_UNLIMITED.



 drivers/scsi/scsi_scan.c |   39 ++++++++++++++-------------------------
 include/scsi/scsi.h      |    1 +
 2 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index fb1d9c7..09df4e7 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1070,7 +1070,6 @@ static int scsi_report_lun_scan(struct s
 	char devname[64];
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	unsigned int length;
-	unsigned int lun;
 	unsigned int num_luns;
 	unsigned int retries;
 	int result;
@@ -1202,29 +1201,17 @@ static int scsi_report_lun_scan(struct s
 	 * the header, so start at 1 and go up to and including num_luns.
 	 */
 	for (lunp = &lun_data[1]; lunp <= &lun_data[num_luns]; lunp++) {
-		lun = scsilun_to_int(lunp);
+		int lun;
+		char lunstr[SCSILUN_STR_LEN];
 
-		/*
-		 * Check if the unused part of lunp is non-zero, and so
-		 * does not fit in lun.
-		 */
-		if (memcmp(&lunp->scsi_lun[sizeof(lun)], "\0\0\0\0", 4)) {
-			int i;
+		lun = scsilun_to_int(lunp);
 
-			/*
-			 * Output an error displaying the LUN in byte order,
-			 * this differs from what linux would print for the
-			 * integer LUN value.
-			 */
-			printk(KERN_WARNING "scsi: %s lun 0x", devname);
-			data = (char *)lunp->scsi_lun;
-			for (i = 0; i < sizeof(struct scsi_lun); i++)
-				printk("%02x", data[i]);
-			printk(" has a LUN larger than currently supported.\n");
-		} else if (lun > sdev->host->max_lun) {
-			printk(KERN_WARNING "scsi: %s lun%d has a LUN larger"
-			       " than allowed by the host adapter\n",
-			       devname, lun);
+		if ((sdev->host->max_lun != SCSILUN_UNLIMITED) &&
+		    (lun > sdev->host->max_lun)) {
+			dev_printk(KERN_WARNING, &sdev->sdev_gendev,
+				"lun %s larger"
+				" than allowed by the host adapter\n",
+				scsilun_to_str(lunp, lunstr));
 		} else {
 			int res;
 
@@ -1234,9 +1221,11 @@ static int scsi_report_lun_scan(struct s
 				/*
 				 * Got some results, but now none, abort.
 				 */
-				printk(KERN_ERR "scsi: Unexpected response"
-				       " from %s lun %d while scanning, scan"
-				       " aborted\n", devname, lun);
+				dev_printk(KERN_ERR, &sdev->sdev_gendev,
+					"Unexpected response"
+					" from lun %s while scanning, scan"
+					" aborted\n",
+					scsilun_to_str(lunp, lunstr));
 				break;
 			}
 		}
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index deb1a27..7876a64 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -242,6 +242,7 @@ struct scsi_lun {
 	__u8 scsi_lun[8];
 };
 #define SCSILUN_STR_LEN 33
+#define SCSILUN_UNLIMITED ~0
 
 /*
  *  MESSAGE CODES
