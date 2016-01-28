From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH V1] scsi: export function scsi_scan.c:sanitize_inquiry_string
Date: Wed, 27 Jan 2016 20:16:26 -0600
Message-ID: <20160128021625.11129.59242.stgit@brunhilda>
References: <20160128021338.11129.99989.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:54735 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934283AbcA1CRu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jan 2016 21:17:50 -0500
In-Reply-To: <20160128021338.11129.99989.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

The hpsa driver uses this function to cleanup inquiry
data. Our new pqi driver will also use this
function. This function was copied into both drivers.

This patch exports sanitize_inquiry_string so the hpsa
and the pqi drivers can use this function directly.

Hannes recommended the change in review:
https://www.marc.info/?l=linux-scsi&m=144619249003064&w=2
that using the existing function in scsi_scan would be
preferrable.

Matthew R. Ochs also recommended the change in review:
https://www.marc.info/?l=linux-scsi&m=144613827316617&w=2

Changes from initial upload:
 - Added prototype for sanitize_inquiry_string to scsi_device.h

Suggested-by: Hannes Reinecke <hare@suse.de>
Suggested-by: Matthew R. Ochs mrochs@linux.vnet.ibm.com
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/scsi_scan.c   |   12 +++++++-----
 include/scsi/scsi_device.h |    1 +
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 6a82066..1f02e84 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -518,7 +518,8 @@ void scsi_target_reap(struct scsi_target *starget)
 }
 
 /**
- * sanitize_inquiry_string - remove non-graphical chars from an INQUIRY result string
+ * scsi_sanitize_inquiry_string - remove non-graphical chars from an
+ *                                INQUIRY result string
  * @s: INQUIRY result string to sanitize
  * @len: length of the string
  *
@@ -531,7 +532,7 @@ void scsi_target_reap(struct scsi_target *starget)
  *	string terminator, so all the following characters are set to
  *	spaces.
  **/
-static void sanitize_inquiry_string(unsigned char *s, int len)
+void scsi_sanitize_inquiry_string(unsigned char *s, int len)
 {
 	int terminated = 0;
 
@@ -542,6 +543,7 @@ static void sanitize_inquiry_string(unsigned char *s, int len)
 			*s = ' ';
 	}
 }
+EXPORT_SYMBOL(scsi_sanitize_inquiry_string);
 
 /**
  * scsi_probe_lun - probe a single LUN using a SCSI INQUIRY
@@ -627,9 +629,9 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	}
 
 	if (result == 0) {
-		sanitize_inquiry_string(&inq_result[8], 8);
-		sanitize_inquiry_string(&inq_result[16], 16);
-		sanitize_inquiry_string(&inq_result[32], 4);
+		scsi_sanitize_inquiry_string(&inq_result[8], 8);
+		scsi_sanitize_inquiry_string(&inq_result[16], 16);
+		scsi_sanitize_inquiry_string(&inq_result[32], 4);
 
 		response_len = inq_result[4] + 5;
 		if (response_len > 255)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index f63a167..9173ab5a 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -397,6 +397,7 @@ extern void scsi_remove_target(struct device *);
 extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
+extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
 extern int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 			int data_direction, void *buffer, unsigned bufflen,
 			unsigned char *sense, int timeout, int retries,

