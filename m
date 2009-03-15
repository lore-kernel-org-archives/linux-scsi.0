From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/2] sd: Try READ CAPACITY 16 first for SBC-2 devices
Date: Sat, 14 Mar 2009 22:30:47 -0500
Message-ID: <1237087848.3907.87.camel@localhost.localdomain>
References: <1236882030-27964-1-git-send-email-willy@linux.intel.com>
	 <1236882030-27964-3-git-send-email-willy@linux.intel.com>
	 <1237063291.3907.64.camel@localhost.localdomain>
	 <20090314224843.GE14127@parisc-linux.org>
	 <1237073695.3907.84.camel@localhost.localdomain>
	 <49BC69A6.4080106@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58015 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753833AbZCODax (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Mar 2009 23:30:53 -0400
In-Reply-To: <49BC69A6.4080106@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>, linux-scsi@vger.kernel.org, Martin Petersen <mkp@mkp.net>

On Sat, 2009-03-14 at 22:36 -0400, Douglas Gilbert wrote:
> James Bottomley wrote:
> > On Sat, 2009-03-14 at 16:48 -0600, Matthew Wilcox wrote:
> >> On Sat, Mar 14, 2009 at 03:41:31PM -0500, James Bottomley wrote:
> >>> We're going to have to do something about the scary error messages on
> >>> SBC-2 supporting drives, this is what mine say (and this is after mkp's
> >>> chat reduction):
> >>>
> >>> sd 1:0:1:0: [sdc] READ CAPACITY(16) failed
> >>> sd 1:0:1:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> >>> sd 1:0:1:0: [sdc] Sense Key : Illegal Request [current] 
> >>> sd 1:0:1:0: [sdc] Add. Sense: Invalid command operation code
> >>> sd 1:0:1:0: [sdc] 71096640 512-byte hardware sectors: (36.4 GB/33.9 GiB)
> >> OK, that's relatively easy to fix.  Simply return early if the drive
> >> claims not to understand the command, and it'll try rc10 without printing
> >> the scary messages.  Like this, perhaps (note cunning factoring of code):
> >>
> >> (compile tested only, and I'll do you a nice changelog and sign-off for
> >> it if it fixes the problem and you approve of this approach).
> >>
> >> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> >> index f8260c0..60b31ea 100644
> >> --- a/drivers/scsi/sd.c
> >> +++ b/drivers/scsi/sd.c
> >> @@ -1139,6 +1139,14 @@ static int media_not_present(struct scsi_disk *sdkp,
> >>  	return 1;
> >>  }
> >>  
> >> +static int invalid_field_in_cdb(struct scsi_sense_hdr *sshdr)
> >> +{
> >> +	if (!scsi_sense_valid(sshdr))
> >> +		return 0;
> >> +	return sshdr->sense_key == ILLEGAL_REQUEST &&
> >> +			sshdr->asc == 0x24 && sshdr->ascq == 0x0;
> >> +
> > 
> > Actually, afraid not, you're trapped in the confusing maze of ASC/ASCQ
> > codes, all sounding alike but meaning slightly different things:
> > 0x24/0x00 is Invalid Field in CDB.  The problem I'm having is 0x20/00
> > (Invalid Command Operation Code).
> > 
> > This will fix it, though ... I'll just merge it into your patch.
> 
> Read Capacity(16) is actually Service Action In(16) with a
> Service Action field of 10h. My understanding is that if the
> device server doesn't support Service Action(16) (i.e. the
> "operation code" is the first byte of the cdb) then 20h/0h is
> the ASC/ASCQ response. However it if does support Service
> Action In(16) but not a Read Capacity(16) then 24h/0h is the
> correct ASC/ASCQ response.
> 
> The only example I can see of the latter case is if Read
> Long(16) is supported and Read Capacity(16) isn't. Then
> opcode 9eh (Service Action In(16)) is valid.
> 
> 
> I suspect that the folks who implement SCSI disk
> firmware are also confused. I'm pretty sure that I have
> seen these two ASC/ASCQ combinations used interchangeably
> for unsupported commands that have a service action field.

Well, better safe than sorry, so this should cover all eventualities?

James

---
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 19a7b98..ec7f773 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1333,9 +1333,11 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 			sense_valid = scsi_sense_valid(&sshdr);
 			if (sense_valid &&
 			    sshdr.sense_key == ILLEGAL_REQUEST &&
-			    sshdr.asc == 0x20 && sshdr.ascq == 0x00)
-				/* Invalid Command Operation Code,
-				 * just retry silently with RC10 */
+			    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
+			    sshdr.ascq == 0x00)
+				/* Invalid Command Operation Code or
+ 				 * Invalid Field in CDB, just retry
+ 				 * silently with RC10 */
 				return -EINVAL;
 		}
 		retries--;


