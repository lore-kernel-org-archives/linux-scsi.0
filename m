From: Hannes Reinecke <hare@suse.de>
Subject: st: Fixup -ENOMEDIUM
Date: Thu, 05 Oct 2006 11:26:02 +0200
Message-ID: <4524CFAA.3010309@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020301070003010808040806"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:30357 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1751568AbWJEJ0E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2006 05:26:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Kai.Makisara@kolumbus.fi

This is a multi-part message in MIME format.
--------------020301070003010808040806
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi all,

currently the tape driver doesn't believe in ENOMEDIUM. Even if the 
sense code from TUR indicates that no tape is present the command will 
be retried; maybe the user is fast enough to slip a medium in in the 
meantime ...
And even if not, it will return 'EIO' in any case.

This patch fixes the ENOMEDIUM handling: TUR will _not_ be retried if no 
medium is present and the correct error number ENOMEDIUM will be set on 
exit.

Please apply.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------020301070003010808040806
Content-Type: text/x-patch;
 name="st-no-tape.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="st-no-tape.diff"

st: Fix no medium handling

Currently the 'st' driver doesn't believe in -ENOMEDIUM.
Whenever the sense code indicates 'No tape' we might as well
return that status instead of retrying for ages.
And even then we really should return that error code to userland.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 7f669b6..b77fd61 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -877,6 +877,12 @@ static int test_ready(struct scsi_tape *
 			}
 
 			if (scode == NOT_READY) {
+				if ((STp->device)->scsi_level >= SCSI_2 &&
+				    cmdstatp->sense_hdr.asc == 0x3a) {
+					/* Early exit if there is no tape */
+					retval = CHKRES_NO_TAPE;
+					break;
+				}
 				if (waits < max_wait) {
 					if (msleep_interruptible(1000)) {
 						retval = (-EINTR);
@@ -885,14 +891,9 @@ static int test_ready(struct scsi_tape *
 					waits++;
 					continue;
 				}
-				else {
-					if ((STp->device)->scsi_level >= SCSI_2 &&
-					    cmdstatp->sense_hdr.asc == 0x3a)	/* Check ASC */
-						retval = CHKRES_NO_TAPE;
-					else
-						retval = CHKRES_NOT_READY;
-					break;
-				}
+				/* Accept we won't be getting anywhere */
+				retval = CHKRES_NOT_READY;
+				break;
 			}
 		}
 
@@ -1177,7 +1178,10 @@ static int st_open(struct inode *inode, 
 		goto err_out;
 	if ((filp->f_flags & O_NONBLOCK) == 0 &&
 	    retval != CHKRES_READY) {
-		retval = (-EIO);
+		if (STp->ready == ST_NO_TAPE)
+			retval = (-ENOMEDIUM);
+		else
+			retval = (-EIO);
 		goto err_out;
 	}
 	return 0;

--------------020301070003010808040806--
