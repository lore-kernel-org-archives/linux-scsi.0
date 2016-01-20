From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH] scsi: export function scsi_scan.c:sanitize_inquiry_string
Date: Wed, 20 Jan 2016 13:41:41 -0600
Message-ID: <20160120194141.23159.5168.stgit@brunhilda>
References: <20160120194028.23159.25263.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [216.241.235.118] ([216.241.235.118]:45689 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752027AbcATTnU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jan 2016 14:43:20 -0500
In-Reply-To: <20160120194028.23159.25263.stgit@brunhilda>
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

Suggested-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/scsi_scan.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

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

