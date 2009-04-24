From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6 of 9] sd: Block limits VPD support
Date: Fri, 24 Apr 2009 01:32:27 -0400
Message-ID: <0b5b58a8ea4d77219f8f.1240551147__18125.1638722189$1240551488$gmane$org@sermon.lab.mkp.net>
References: <patchbomb.1240551141@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:42232 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbZDXFgM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2009 01:36:12 -0400
In-Reply-To: <patchbomb.1240551141@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, jens.axboe@oracle.com, matthew@wil.cx, linux-ide

Query the block limits VPD page and adjust queue minimum and optimal I/O
sizes.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
1 file changed, 24 insertions(+)
drivers/scsi/sd.c |   24 ++++++++++++++++++++++++



diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1801,6 +1801,29 @@ void sd_read_app_tag_own(struct scsi_dis
 }
 
 /**
+ * sd_read_block_limits - Query disk device for preferred I/O sizes.
+ * @disk: disk to query
+ */
+static void sd_read_block_limits(struct scsi_disk *sdkp)
+{
+	unsigned int sector_sz = sdkp->device->sector_size;
+	char *buffer;
+
+	/* Block Limits VPD */
+	buffer = scsi_get_vpd_page(sdkp->device, 0xb0);
+
+	if (buffer == NULL)
+		return;
+
+	blk_queue_io_min(sdkp->disk->queue,
+			 get_unaligned_be16(&buffer[6]) * sector_sz);
+	blk_queue_io_opt(sdkp->disk->queue,
+			 get_unaligned_be32(&buffer[12]) * sector_sz);
+
+	kfree(buffer);
+}
+
+/**
  * sd_read_block_characteristics - Query block dev. characteristics
  * @disk: disk to query
  */
@@ -1860,6 +1883,7 @@ static int sd_revalidate_disk(struct gen
 	 */
 	if (sdkp->media_present) {
 		sd_read_capacity(sdkp, buffer);
+		sd_read_block_limits(sdkp);
 		sd_read_block_characteristics(sdkp);
 		sd_read_write_protect_flag(sdkp, buffer);
 		sd_read_cache_type(sdkp, buffer);


