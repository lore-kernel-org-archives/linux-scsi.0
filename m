From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 0/3] libata: scsi error handling, encore
Date: Sun, 09 Oct 2005 09:23:48 -0400
Message-ID: <434919E4.1080601@pobox.com>
References: <43490BC8.9060504@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:59291 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750705AbVJINYE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Oct 2005 09:24:04 -0400
In-Reply-To: <43490BC8.9060504@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, htejun@gmail.com, russb@emc.com

Douglas Gilbert wrote:
> This is a series of patches that are equivalent to
> one sent on 2005/09/19:
> "[PATCH] libata: scsi error handling, lk 2.6.14-rc1"
> http://marc.theaimsgroup.com/?l=linux-scsi&m=112711945709949&w=2
> 
> The aim is to build more general sense buffers for SCSI
> errors detected in the SCSI ATA translation layer in libata.
> These patches are against Jeff's libata-dev git repository,
> upstream branch.
> Patch 1:  adds ata_scsi_set_sense() extern declaration and
>           definition
> Patch 2:  switch error processing in libata-scsi.c to use
>           ata_scsi_set_sense()
> Patch 3:  remove static inline definitions in libata.h that
>           are no longer used after patch 2
> 
> Signed-off-by: Douglas Gilbert <dougg@torque.net>

First and foremost, applied all three patches.  Thanks for your 
patience.  'upstream' branch will reflect your changes as soon as 
master.kernel.org propagates to the public mirrors.

The patches had to be hand-applied, for a few reasons, so I have some 
follow-up notes.


1) It would be nice if you could avoid using MIME attachments for 
patches, but rather, include them inline.


2) Your email subject should be descriptive and unique, since it is 
copied verbatim into the Linux Kernel changelog by Linus's patch merging 
tool, git-applymbox.  e.g.

       [patch 1/3] libata scsi EH: add ata_scsi_set_sense()
       [patch 2/3] libata scsi EH: upgrade EH using ata_scsi_set_sense()
       [patch 3/3] libata scsi EH: remove now-unused helpers

See http://linux.yyz.us/patch-format.html for more info.


3) The following change should have been in a separate patch, since it 
was largely unrelated to use of ata_scsi_set_sense() -- it changes 
behavior, and its easy for a reviewer to miss this behavior change, if 
it is buried deep inside a pile of unrelated changes:

>   - yield an error for mode sense requests for saved
>     values [sat-r06]

But that's just a note for the future.  As I stated, I applied your 
patches as-is...  The optimal, reviewer-friendly transformation IMO 
would have been:

       [patch 1/3] libata scsi EH: add ata_scsi_set_sense()
       [patch 2/3] libata scsi EH: upgrade EH using ata_scsi_set_sense()
       [patch 3/3] libata scsi EH: return err for MODE SENSE saved vals
	[and obviously, patch #3 depends on patch #2]


4) I excised the following chunk from patch #2, before applying:

> @@ -1572,7 +1628,7 @@
>  		 * time).  We need to issue REQUEST SENSE some other
>  		 * way, to avoid completing the command twice.
>  		 */
> -		cmd->result = SAM_STAT_CHECK_CONDITION;
> +		cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
>  
>  		qc->scsidone(cmd);

We don't yet have sense at this point; the code above largely serves as 
a trigger to a SCSI EH kthread, which will wake up and issue REQUEST 
SENSE for us.  Its a bit of a weird setup, and I'm also working in this 
area, so I simply removed the above quoted change from your patch, which 
was applied otherwise unaltered.

Thanks,

	Jeff



