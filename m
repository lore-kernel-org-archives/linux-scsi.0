From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.26-rc6
Date: Wed, 18 Jun 2008 11:38:47 -0500
Message-ID: <1213807127.3515.70.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33197 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247AbYFRQiy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jun 2008 12:38:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is just a round of the usual pre release bug fixes.  We are still
chasing down some other bugs (mainly related to CDs).  The patch is
available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

James Bottomley (1):
      sr: fix corrupt CD data after media change and delay

Jeff Mahoney (1):
      dpt_i2o: Add PROC_IA64 define

Mike Christie (1):
      scsi_host regression: fix scsi host leak

And the diffstat:

 drivers/scsi/dpt/dptsig.h |    3 ++-
 drivers/scsi/hosts.c      |    9 +++++++--
 drivers/scsi/sr.c         |    3 +++
 3 files changed, 12 insertions(+), 3 deletions(-)

The full diff is attached below.

James

---

diff --git a/drivers/scsi/dpt/dptsig.h b/drivers/scsi/dpt/dptsig.h
index 72c8992..a6644b3 100644
--- a/drivers/scsi/dpt/dptsig.h
+++ b/drivers/scsi/dpt/dptsig.h
@@ -85,7 +85,7 @@ typedef unsigned int sigINT;
 /* ------------------------------------------------------------------ */
 /* What type of processor the file is meant to run on. */
 /* This will let us know whether to read sigWORDs as high/low or low/high. */
-#define PROC_INTEL      0x00    /* Intel 80x86 */
+#define PROC_INTEL      0x00    /* Intel 80x86/ia64 */
 #define PROC_MOTOROLA   0x01    /* Motorola 68K */
 #define PROC_MIPS4000   0x02    /* MIPS RISC 4000 */
 #define PROC_ALPHA      0x03    /* DEC Alpha */
@@ -104,6 +104,7 @@ typedef unsigned int sigINT;
 #define PROC_486        0x08    /* Intel 80486 */
 #define PROC_PENTIUM    0x10    /* Intel 586 aka P5 aka Pentium */
 #define PROC_SEXIUM	0x20	/* Intel 686 aka P6 aka Pentium Pro or MMX */
+#define PROC_IA64	0x40	/* Intel IA64 processor */
 
 /* PROC_i960: */
 #define PROC_960RX      0x01    /* Intel 80960RC/RD */
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 3690360..c6457bf 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -456,6 +456,10 @@ static int __scsi_host_match(struct device *dev, void *data)
  *
  * Return value:
  *	A pointer to located Scsi_Host or NULL.
+ *
+ *	The caller must do a scsi_host_put() to drop the reference
+ *	that scsi_host_get() took. The put_device() below dropped
+ *	the reference from class_find_device().
  **/
 struct Scsi_Host *scsi_host_lookup(unsigned short hostnum)
 {
@@ -463,9 +467,10 @@ struct Scsi_Host *scsi_host_lookup(unsigned short hostnum)
 	struct Scsi_Host *shost = ERR_PTR(-ENXIO);
 
 	cdev = class_find_device(&shost_class, &hostnum, __scsi_host_match);
-	if (cdev)
+	if (cdev) {
 		shost = scsi_host_get(class_to_shost(cdev));
-
+		put_device(cdev);
+	}
 	return shost;
 }
 EXPORT_SYMBOL(scsi_host_lookup);
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7ee86d4..c82df8b 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -178,6 +178,9 @@ int sr_test_unit_ready(struct scsi_device *sdev, struct scsi_sense_hdr *sshdr)
 		the_result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL,
 					      0, sshdr, SR_TIMEOUT,
 					      retries--);
+		if (scsi_sense_valid(sshdr) &&
+		    sshdr->sense_key == UNIT_ATTENTION)
+			sdev->changed = 1;
 
 	} while (retries > 0 &&
 		 (!scsi_status_is_good(the_result) ||


