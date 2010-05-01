From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: AACRAID driver update patch version - 26400
Date: Sat, 01 May 2010 14:03:01 -0500
Message-ID: <1272740581.4570.92.camel@mulgrave.site>
References: <C42A9BA25D0AB74D81491EF544ED520973D0D9DFC5@ADPE2K704.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779Ab0EATDP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 May 2010 15:03:15 -0400
In-Reply-To: <C42A9BA25D0AB74D81491EF544ED520973D0D9DFC5@ADPE2K704.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rajashekhara, Mahesh" <Mahesh_Rajashekhara@adaptec.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, AACRAID <AACRAID@adaptec.com>

On Wed, 2010-04-07 at 20:55 -0700, Rajashekhara, Mahesh wrote:
> (Resending in plain text as the earlier email got bounced)
> 
> Hi All,
> 
> We have prepared driver patch from latest driver source.
> 
> We worked on a issue related to SMARTCTL([Bugme-new] [Bug 15623] New: doesn't allow SMART-passthrough on Adaptec Series 5 controller) 
> and found the  root cause of this problem. We have responded to this bug, stating that we will be releasing the driver patch for addressing this problem.
> Also, in our recent program releases we have addressed some more issues.
> 
> Please look into the release notes.

Please, no.  What I actually need is a set of patches (one per change or
feature) with a properly added description and signoff as described in
Documentation/SubmittingPatches.

> Please find the attachments.
> 1. aacraid-version-26400-040510-patch - Driver patch
> 2. aacraid-scsi-misc-2.6-warnings.txt - Warning message text 
> 3. Release notes

So if I look at the Changelog it seems that there should be four
separate changes:


> AACRAID Driver for Linux - version 26400
> ----------------------------------------
> 
> Addressed issues:
> ----------------
> 1. The default driver setting is "expose_physicals=0", which means raw
> physical drives not exposed to OS. 
>    If the user wants to expose connected physical drives, enable
> "expose_physicals" module parameter.
>    With the new JBOD firmware, physical drives are not available for
> "expose_physicals>0".
>    In function "aac_expose_phy_device", added to reset the appropriate
> bit in the first byte of inquiry data.
>    This fix exposes the connected physical drives.

OK

> 2. Added support for handling ATA pass-through commands.
>    When the "CC" bit is set by the host in ATA pass-through CDB,
> driver is supposed to return DID_OK
>    When the "CC" bit is reset by the host, driver should return
> DID_ERROR

No, that's not correct.  You should return a result code of
SAM_STAT_CHECK_CONDITION, with a driver byte of DID_OK.  If you return
DID_ERROR, it will unconditionally trigger error handling and a retry.

> 3. Firmware exposes lesser container capacity than the actual one.
>    It exposes [actaul size - hidden reserved space(10MB)] to the OS,
> IO's to the 10MB should be prohibhited from the Linux
> driver.              
>    When the IO's falls into hidden reserved space, driver internally
> sets sensekey to HARDWARE_ERROR and sends notification to the SCSI mid
> layer.
>    Added "expose_hidden_space" flag, by default the fix will be
> executed. 
>    Only if the user sets "expose_hidden_space=1", user can access
> beyond the array reported size(hidden reserved space 10MB).

This doesn't exactly look like the right interface. Won't the user want
the hidden space exposed on a per array basis?  In which case a sysfs
flag in the host attributes would be far more appropriate than a module
flag?

> 4. Based on the notification from firmware, the driver sets up
> SDV_OFFLINE flag for a deleted array and 
>    the SCSI mid layer comes to know the attached  SCSI device has gone
> offline. But with 
>    this notification, scsi device entries are not being removed. 
>    Enabled "AAC_DEBUG_INSTRUMENT_AIF_DELETE" flag  in the header file,
> with this flag the driver uses "scsi_remove_device".     
>    On the notification from firmware, the driver calls
> "scsi_remove_device" for the deleted array.
>    This call not only informs the scsi device status to the SCSI mid
> layer but also
>    removes corresponding scsi device entry from the linux
> sysfs.        

OK, don't understand this.  As noted below, the define
AAC_DEBUG_INSTRUMENT_AIF_DELETE is set by your patch, but never appears
at all in the driver ... is there missing code?

> Thanks & Regards,
> Mahesh
> Linux Driver Development Engineer,
> Adaptec ODC, Bangalore



> diff -ru a/drivers/scsi/aacraid/aachba.c
> b/drivers/scsi/aacraid/aachba.c
> --- a/drivers/scsi/aacraid/aachba.c     2010-04-03 05:49:52.000000000
> -0700
> +++ b/drivers/scsi/aacraid/aachba.c     2010-04-07 12:35:36.468017040
> -0700
> @@ -109,6 +109,16 @@
>  #define BYTE2(x) (unsigned char)((x) >> 16)
>  #define BYTE3(x) (unsigned char)((x) >> 24)
>  
> +
> +/* ATA pass thru commands */
> +#ifndef ATA_12
> +#define ATA_12                0xa1      /* 12-byte pass-thru */
> +#endif
> +
> +#ifndef ATA_16
> +#define ATA_16                0x85      /* 16-byte pass-thru */
> +#endif
> +

This chunk is clearly wrong ... those defines are in include/scsi/scsi.h

> @@ -1647,6 +1671,27 @@
>                 count = (scsicmd->cmnd[7] << 8) | scsicmd->cmnd[8];
>                 break;
>         }
> +
> +       if (expose_hidden_space <= 0) {
> +               if ((lba + count) > (dev->fsa_dev[scmd_id(scsicmd)].size)) {
> +                       int cid = scmd_id(scsicmd);
> +                       dprintk((KERN_DEBUG "aacraid: Illegal lba\n"));
> +                       scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
> +                               SAM_STAT_CHECK_CONDITION;
> +                       set_sense(&dev->fsa_dev[cid].sense_data,
> +                               HARDWARE_ERROR,
> +                               SENCODE_INTERNAL_TARGET_FAILURE,
> +                               ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0);
> +                       memcpy(scsicmd->sense_buffer,
> +                               &dev->fsa_dev[cid].sense_data,
> +                               min_t(size_t,
> +                               sizeof(dev->fsa_dev[cid].sense_data),
> +                               SCSI_SENSE_BUFFERSIZE));
> +                       scsicmd->scsi_done(scsicmd);
> +                       return 1;
> +               }
> +       }
> +

This chunk is correctly indented, that's great.

>         dprintk((KERN_DEBUG "aac_read[cpu %d]: lba = %llu, t = %ld.\n",
>           smp_processor_id(), (unsigned long long)lba, jiffies));
>         if (aac_adapter_bounds(dev,scsicmd,lba))
> @@ -1727,6 +1772,26 @@
>                 count = (scsicmd->cmnd[7] << 8) | scsicmd->cmnd[8];
>                 fua = scsicmd->cmnd[1] & 0x8;
>         }
> +
> +       if (expose_hidden_space <= 0) {
> +               if ((lba + count) > (dev->fsa_dev[scmd_id(scsicmd)].size)) {
> +                       int cid = scmd_id(scsicmd);
> +                       dprintk((KERN_DEBUG "aacraid: Illegal lba\n"));
> +                       scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
> +                       SAM_STAT_CHECK_CONDITION;
> +                       set_sense(&dev->fsa_dev[cid].sense_data,
> +                       HARDWARE_ERROR, SENCODE_INTERNAL_TARGET_FAILURE,
> +                       ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0);
> +                       memcpy(scsicmd->sense_buffer,
> +                       &dev->fsa_dev[cid].sense_data,
> +                       min_t(size_t,
> +                       sizeof(dev->fsa_dev[cid].sense_data),
> +                       SCSI_SENSE_BUFFERSIZE));
> +
> +                       scsicmd->scsi_done(scsicmd);
> +                       return 1;
> +               }
> +       }

This one, and numerous others are wrongly indented ... the continuation
lines should have an extra tab or be aligned under the opening bracket
for a function/macro.  Indentation like this makes the file very hard to
read.

> diff -ru a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
> --- a/drivers/scsi/aacraid/aacraid.h    2010-04-03 05:49:52.000000000 -0700
> +++ b/drivers/scsi/aacraid/aacraid.h    2010-04-07 14:17:18.409380952 -0700
> @@ -1,6 +1,7 @@
>  #ifndef dprintk
>  # define dprintk(x)
>  #endif
> +#define AAC_DEBUG_INSTRUMENT_AIF_DELETE

What is this?  It's not used anywhere else in the file (a leftover from
some removed debugging code?)


> @@ -1065,6 +1065,10 @@
>  #define aac_adapter_ioremap(dev, size) \
>         (dev)->a_ops.adapter_ioremap(dev, size)
>  
> +#define aac_adapter_intr(dev) \
> +       ((dev)->a_ops.adapter_intr((dev)->pdev->irq, \
> +       (void *)dev))
> +

This is another very weird macro, but as far as I can tell, it's never
used either.


> --- a/drivers/scsi/aacraid/commctrl.c   2010-04-03 05:49:52.000000000
> -0700
> +++ b/drivers/scsi/aacraid/commctrl.c   2010-04-07 12:52:53.803318104
> -0700
> @@ -128,13 +128,13 @@
>                 retval =
> aac_fib_send(le16_to_cpu(kfib->header.Command), fibptr,
>                                 le16_to_cpu(kfib->header.Size) ,
> FsaNormal,
>                                 1, 1, NULL, NULL);
> -               if (retval) {
> -                       goto cleanup;
> -               }
>                 if (aac_fib_complete(fibptr) != 0) {
> +                       if (!retval)
>                         retval = -EINVAL;
> -                       goto cleanup;
> +               goto cleanup;

This looks wrong ... it's wrongly indented, but I'm assuming you meant
to remove the goto altogether so it gets swept up in the code below?

>                 }
> +               if (retval)
> +                       goto cleanup;


> @@ -534,6 +532,13 @@
>                                                   "update mother board
> BIOS or consider utilizing one of\n"
>                                                   "the SAFE mode
> kernel options (acpi, apic etc)\n");
>                                         }
> +                                       spin_lock_irqsave(&fibptr->event_lock,
> +                                       flags);
> +                                       fibptr->done = 2;
> +                                       spin_unlock_irqrestore(
> +                                       &fibptr->event_lock,
> +                                       flags);

So these locks ... even badly indented ... don't look necessary:
fibptr->done is a u32.  On all architectures that's updated atomically.
This means that the check on fibptr->done always reads either the old
value or the new value ... there's no need to add extra locking unless
there are other values or states that need updating atomically.

> +                                       dprintk((KERN_ERR "aacraid:
> sync. command timed out after 180 seconds\n"));

James


