From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 6/7] hpsa: remove function definition for
 sanitize_inquiry_string
Date: Tue, 23 Feb 2016 15:16:40 -0600
Message-ID: <20160223211640.5968.8939.stgit@brunhilda>
References: <20160223210957.5968.6998.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:37222 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755212AbcBWVQm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Feb 2016 16:16:42 -0500
In-Reply-To: <20160223210957.5968.6998.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

This patch depends on patch
 - commit ac10a3e4ed64
   ("Export function scsi_scan.c:sanitize_inquiry_string")

Suggested-by: Hannes Reinecke <hare@suse.de>
Suggested-by: Matthew R. Ochs mrochs@linux.vnet.ibm.com
Reviewed-by: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
Reviewed-by: Justin Lindley <justin.lindley@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index edbecf8..725eb8d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3665,18 +3665,6 @@ static int hpsa_device_supports_aborts(struct ctlr_info *h,
 	return rc;
 }
 
-static void sanitize_inquiry_string(unsigned char *s, int len)
-{
-	bool terminated = false;
-
-	for (; len > 0; (--len, ++s)) {
-		if (*s == 0)
-			terminated = true;
-		if (terminated || *s < 0x20 || *s > 0x7e)
-			*s = ' ';
-	}
-}
-
 static int hpsa_update_device_info(struct ctlr_info *h,
 	unsigned char scsi3addr[], struct hpsa_scsi_dev_t *this_device,
 	unsigned char *is_OBDR_device)
@@ -3707,8 +3695,8 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 		goto bail_out;
 	}
 
-	sanitize_inquiry_string(&inq_buff[8], 8);
-	sanitize_inquiry_string(&inq_buff[16], 16);
+	scsi_sanitize_inquiry_string(&inq_buff[8], 8);
+	scsi_sanitize_inquiry_string(&inq_buff[16], 16);
 
 	this_device->devtype = (inq_buff[0] & 0x1f);
 	memcpy(this_device->scsi3addr, scsi3addr, 8);

