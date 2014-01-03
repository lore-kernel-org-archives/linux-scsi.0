From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Bug#733565: SIX messages per on boot console should be TWO
Date: Fri, 03 Jan 2014 18:19:26 -0500
Message-ID: <yq14n5kzm9t.fsf@sermon.lab.mkp.net>
References: <87vby7l08j.fsf@jidanni.org>
	<1388373281.2900.42.camel@deadeye.wl.decadent.org.uk>
	<yq1ob3szun7.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32440 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbaACXTu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jan 2014 18:19:50 -0500
In-Reply-To: <yq1ob3szun7.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Fri, 03 Jan 2014 15:18:36 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, jidanni@jidanni.org, 733565@bugs.debian.org, linux-scsi <linux-scsi@vger.kernel.org>

>>>>> "Martin" == Martin K Petersen <martin.petersen@oracle.com> writes:

Martin> I guess we could extend the first_scan logic to cover the error
Martin> case scenarios.

[SCSI] sd: Quiesce mode sense error messages

Messages about discovered disk properties are only printed once unless
they are found to have changed. Errors encountered during mode sense,
however, are printed every time we revalidate.

Quiesce mode sense errors so they are only printed during the first
scan.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 69725f7c32c1..14d601ed1956 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2283,7 +2283,7 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 
 	set_disk_ro(sdkp->disk, 0);
 	if (sdp->skip_ms_page_3f) {
-		sd_printk(KERN_NOTICE, sdkp, "Assuming Write Enabled\n");
+		sd_first_printk(KERN_NOTICE, sdkp, "Assuming Write Enabled\n");
 		return;
 	}
 
@@ -2315,7 +2315,7 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 	}
 
 	if (!scsi_status_is_good(res)) {
-		sd_printk(KERN_WARNING, sdkp,
+		sd_first_printk(KERN_WARNING, sdkp,
 			  "Test WP failed, assume Write Enabled\n");
 	} else {
 		sdkp->write_prot = ((data.device_specific & 0x80) != 0);
@@ -2383,7 +2383,8 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	if (!data.header_length) {
 		modepage = 6;
 		first_len = 0;
-		sd_printk(KERN_ERR, sdkp, "Missing header in MODE_SENSE response\n");
+		sd_first_printk(KERN_ERR, sdkp,
+				"Missing header in MODE_SENSE response\n");
 	}
 
 	/* that went OK, now ask for the proper length */
@@ -2396,7 +2397,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	if (len < 3)
 		goto bad_sense;
 	else if (len > SD_BUF_SIZE) {
-		sd_printk(KERN_NOTICE, sdkp, "Truncating mode parameter "
+		sd_first_printk(KERN_NOTICE, sdkp, "Truncating mode parameter "
 			  "data from %d to %d bytes\n", len, SD_BUF_SIZE);
 		len = SD_BUF_SIZE;
 	}
@@ -2419,8 +2420,9 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 				/* We're interested only in the first 3 bytes.
 				 */
 				if (len - offset <= 2) {
-					sd_printk(KERN_ERR, sdkp, "Incomplete "
-						  "mode parameter data\n");
+					sd_first_printk(KERN_ERR, sdkp,
+						"Incomplete mode parameter "
+							"data\n");
 					goto defaults;
 				} else {
 					modepage = page_code;
@@ -2434,14 +2436,15 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 				else if (!spf && len - offset > 1)
 					offset += 2 + buffer[offset+1];
 				else {
-					sd_printk(KERN_ERR, sdkp, "Incomplete "
-						  "mode parameter data\n");
+					sd_first_printk(KERN_ERR, sdkp,
+							"Incomplete mode "
+							"parameter data\n");
 					goto defaults;
 				}
 			}
 		}
 
-		sd_printk(KERN_ERR, sdkp, "No Caching mode page found\n");
+		sd_first_printk(KERN_ERR, sdkp, "No Caching mode page found\n");
 		goto defaults;
 
 	Page_found:
@@ -2455,7 +2458,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 
 		sdkp->DPOFUA = (data.device_specific & 0x10) != 0;
 		if (sdkp->DPOFUA && !sdkp->device->use_10_for_rw) {
-			sd_printk(KERN_NOTICE, sdkp,
+			sd_first_printk(KERN_NOTICE, sdkp,
 				  "Uses READ/WRITE(6), disabling FUA\n");
 			sdkp->DPOFUA = 0;
 		}
@@ -2477,16 +2480,19 @@ bad_sense:
 	    sshdr.sense_key == ILLEGAL_REQUEST &&
 	    sshdr.asc == 0x24 && sshdr.ascq == 0x0)
 		/* Invalid field in CDB */
-		sd_printk(KERN_NOTICE, sdkp, "Cache data unavailable\n");
+		sd_first_printk(KERN_NOTICE, sdkp, "Cache data unavailable\n");
 	else
-		sd_printk(KERN_ERR, sdkp, "Asking for cache data failed\n");
+		sd_first_printk(KERN_ERR, sdkp,
+				"Asking for cache data failed\n");
 
 defaults:
 	if (sdp->wce_default_on) {
-		sd_printk(KERN_NOTICE, sdkp, "Assuming drive cache: write back\n");
+		sd_first_printk(KERN_NOTICE, sdkp,
+				"Assuming drive cache: write back\n");
 		sdkp->WCE = 1;
 	} else {
-		sd_printk(KERN_ERR, sdkp, "Assuming drive cache: write through\n");
+		sd_first_printk(KERN_ERR, sdkp,
+				"Assuming drive cache: write through\n");
 		sdkp->WCE = 0;
 	}
 	sdkp->RCD = 0;
@@ -2515,7 +2521,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 
 	if (!scsi_status_is_good(res) || !data.header_length ||
 	    data.length < 6) {
-		sd_printk(KERN_WARNING, sdkp,
+		sd_first_printk(KERN_WARNING, sdkp,
 			  "getting Control mode page failed, assume no ATO\n");
 
 		if (scsi_sense_valid(&sshdr))
@@ -2527,7 +2533,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 	offset = data.header_length + data.block_descriptor_length;
 
 	if ((buffer[offset] & 0x3f) != 0x0a) {
-		sd_printk(KERN_ERR, sdkp, "ATO Got wrong page\n");
+		sd_first_printk(KERN_ERR, sdkp, "ATO Got wrong page\n");
 		return;
 	}
 
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 26895ff247c5..59956e9a5b80 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -104,6 +104,11 @@ static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
 		    (sdsk)->disk->disk_name, ##a) :			\
 	sdev_printk(prefix, (sdsk)->device, fmt, ##a)
 
+#define sd_first_printk(prefix,sdsk, fmt, a...)				\
+	do {								\
+	if ((sdkp)->first_scan) sd_printk(prefix, sdsk, fmt, ##a);	\
+	} while (0)
+
 static inline int scsi_medium_access_command(struct scsi_cmnd *scmd)
 {
 	switch (scmd->cmnd[0]) {
