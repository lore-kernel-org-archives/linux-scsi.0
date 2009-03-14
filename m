From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2/2] sd: Try READ CAPACITY 16 first for SBC-2 devices
Date: Sat, 14 Mar 2009 16:48:44 -0600
Message-ID: <20090314224843.GE14127@parisc-linux.org>
References: <1236882030-27964-1-git-send-email-willy@linux.intel.com> <1236882030-27964-3-git-send-email-willy@linux.intel.com> <1237063291.3907.64.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42872 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbZCNWtE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Mar 2009 18:49:04 -0400
Content-Disposition: inline
In-Reply-To: <1237063291.3907.64.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-scsi@vger.kernel.org, Martin Petersen <mkp@mkp.net>

On Sat, Mar 14, 2009 at 03:41:31PM -0500, James Bottomley wrote:
> We're going to have to do something about the scary error messages on
> SBC-2 supporting drives, this is what mine say (and this is after mkp's
> chat reduction):
> 
> sd 1:0:1:0: [sdc] READ CAPACITY(16) failed
> sd 1:0:1:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> sd 1:0:1:0: [sdc] Sense Key : Illegal Request [current] 
> sd 1:0:1:0: [sdc] Add. Sense: Invalid command operation code
> sd 1:0:1:0: [sdc] 71096640 512-byte hardware sectors: (36.4 GB/33.9 GiB)

OK, that's relatively easy to fix.  Simply return early if the drive
claims not to understand the command, and it'll try rc10 without printing
the scary messages.  Like this, perhaps (note cunning factoring of code):

(compile tested only, and I'll do you a nice changelog and sign-off for
it if it fixes the problem and you approve of this approach).

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f8260c0..60b31ea 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1139,6 +1139,14 @@ static int media_not_present(struct scsi_disk *sdkp,
 	return 1;
 }
 
+static int invalid_field_in_cdb(struct scsi_sense_hdr *sshdr)
+{
+	if (!scsi_sense_valid(sshdr))
+		return 0;
+	return sshdr->sense_key == ILLEGAL_REQUEST &&
+			sshdr->asc == 0x24 && sshdr->ascq == 0x0;
+}
+
 /*
  * spinup disk - called only in sd_revalidate_disk()
  */
@@ -1362,6 +1370,8 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
+		if (invalid_field_in_cdb(&sshdr))
+			return -EINVAL;
 
 		if (the_result)
 			sense_valid = scsi_sense_valid(&sshdr);
@@ -1739,10 +1749,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	}
 
 bad_sense:
-	if (scsi_sense_valid(&sshdr) &&
-	    sshdr.sense_key == ILLEGAL_REQUEST &&
-	    sshdr.asc == 0x24 && sshdr.ascq == 0x0)
-		/* Invalid field in CDB */
+	if (invalid_field_in_cdb(&sshdr))
 		sd_printk(KERN_NOTICE, sdkp, "Cache data unavailable\n");
 	else
 		sd_printk(KERN_ERR, sdkp, "Asking for cache data failed\n");

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
