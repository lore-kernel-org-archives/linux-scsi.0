From: Alan Stern <stern@rowland.harvard.edu>
Subject: Revised PATCH: (as73b) Do a minimal transfer for disk-cache mode-sense
 page
Date: Thu, 31 Jul 2003 11:12:38 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307311101130.1018-100000@ida.rowland.org>
References: <1059599085.1849.264.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:5892 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S272509AbTGaPMj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2003 11:12:39 -0400
In-Reply-To: <1059599085.1849.264.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On 30 Jul 2003, James Bottomley wrote:

> On Wed, 2003-07-30 at 15:36, Alan Stern wrote:
> > 	It sets the DBD flag to prevent the transfer of unwanted Block 
> > Descriptors.
> 
> I'm afraid I think we've already been around the houses on this one and
> decided that we can't do it.
> 
> The problem is that most CD-ROMS and some USB storage devices follow one
> of the ATAPI packet specifications which has the DBD bit as reserved,
> and someone actually found one which gets annoyed if DBD is set.

Okay.  The revised patch doesn't set DBD and adds an explanatory comment.

> > 	It transfers only the first 4 bytes of the cache page; the 
> > information we want is in the 3rd byte.
> 
> I didn't actually spot this anywhere in the patch.

It's in the line where len is set to the sum of the two headers plus 4.

> Won't work.  SAM_STAT_BUSY will cause an immediate retry, which still
> won't get satisfied.  I think you need to follow the original logic but
> change 128 to 512

I disagree.  All that will happen is that res will fail the 
scsi_status_is_good() test, so the routine will by default assume a 
write-through cache.

However, there would be nothing wrong with changing SAM_STAT_BUSY to a 
different error code, such as SAM_STAT_TASK_SET_FULL.  It doesn't matter 
what the value is, so long as it doesn't pass scsi_status_is_good().

Alan Stern


===== sd.c 1.52 vs edited =====
--- 1.52/drivers/scsi/sd.c	Tue Jul  1 17:54:19 2003
+++ edited/drivers/scsi/sd.c	Thu Jul 31 11:05:01 2003
@@ -1080,6 +1080,7 @@
 sd_read_write_protect_flag(struct scsi_disk *sdkp, char *diskname,
 		   struct scsi_request *SRpnt, unsigned char *buffer) {
 	int res;
+	const int dbd = 0;	   /* Some devices don't like DBD */
 	struct scsi_mode_data data;
 
 	/*
@@ -1087,7 +1088,7 @@
 	 * We have to start carefully: some devices hang if we ask
 	 * for more than is available.
 	 */
-	res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 4, &data);
+	res = sd_do_mode_sense(SRpnt, dbd, 0x3F, buffer, 4, &data);
 
 	/*
 	 * Second attempt: ask for page 0
@@ -1095,13 +1096,13 @@
 	 * Sense Key 5: Illegal Request, Sense Code 24: Invalid field in CDB.
 	 */
 	if (!scsi_status_is_good(res))
-		res = sd_do_mode_sense(SRpnt, 0, 0, buffer, 4, &data);
+		res = sd_do_mode_sense(SRpnt, dbd, 0, buffer, 4, &data);
 
 	/*
 	 * Third attempt: ask 255 bytes, as we did earlier.
 	 */
 	if (!scsi_status_is_good(res))
-		res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 255, &data);
+		res = sd_do_mode_sense(SRpnt, dbd, 0x3F, buffer, 255, &data);
 
 	if (!scsi_status_is_good(res)) {
 		printk(KERN_WARNING
@@ -1124,7 +1125,7 @@
 		   struct scsi_request *SRpnt, unsigned char *buffer) {
 	int len = 0, res;
 
-	const int dbd = 0;	   /* DBD */
+	const int dbd = 0;	   /* Some devices don't like DBD */
 	const int modepage = 0x08; /* current values, cache page */
 	struct scsi_mode_data data;
 
@@ -1134,10 +1135,11 @@
 
 	if (scsi_status_is_good(res)) {
 		/* that went OK, now ask for the proper length */
-		len = data.length;
-		if (len > 128)
-			len = 128;
-		res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer,
+		len = data.header_length + data.block_descriptor_length + 4;
+		if (len > 512)
+			res = SAM_STAT_BUSY;
+		else
+			res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer,
 				       len, &data);
 	}
 

