From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] sr: avoid kmalloc 8 bytes
Date: Thu, 12 Jun 2008 15:36:33 +0900
Message-ID: <20080612154101H.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:60830 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbYFLGgk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jun 2008 02:36:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

We don't do DMA to sshdr here so there is no need to complicate the
code by allocating only 8 bytes.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sr.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7ee86d4..af93ca5 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -200,18 +200,17 @@ static int sr_media_change(struct cdrom_device_info *cdi, int slot)
 {
 	struct scsi_cd *cd = cdi->handle;
 	int retval;
-	struct scsi_sense_hdr *sshdr;
+	struct scsi_sense_hdr sshdr;
 
 	if (CDSL_CURRENT != slot) {
 		/* no changer support */
 		return -EINVAL;
 	}
 
-	sshdr =  kzalloc(sizeof(*sshdr), GFP_KERNEL);
-	retval = sr_test_unit_ready(cd->device, sshdr);
-	if (retval || (scsi_sense_valid(sshdr) &&
+	retval = sr_test_unit_ready(cd->device, &sshdr);
+	if (retval || (scsi_sense_valid(&sshdr) &&
 		       /* 0x3a is medium not present */
-		       sshdr->asc == 0x3a)) {
+		       sshdr.asc == 0x3a)) {
 		/* Media not present or unable to test, unit probably not
 		 * ready. This usually means there is no disc in the drive.
 		 * Mark as changed, and we will figure it out later once
@@ -239,11 +238,10 @@ out:
 		sdev_evt_send_simple(cd->device, SDEV_EVT_MEDIA_CHANGE,
 				     GFP_KERNEL);
 	cd->previous_state = retval;
-	kfree(sshdr);
 
 	return retval;
 }
- 
+
 /*
  * sr_done is the interrupt routine for the device driver.
  *
-- 
1.5.4.2

