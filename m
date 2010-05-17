From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 4/5] AACRAID driver update
Date: Sun, 16 May 2010 22:59:20 -0400
Message-ID: <1274065160.14187.139.camel@mulgrave.site>
References: <C42A9BA25D0AB74D81491EF544ED520973D0D9DFC5@ADPE2K704.adaptec.com>
	 <1272740581.4570.92.camel@mulgrave.site>
	 <C42A9BA25D0AB74D81491EF544ED520973D1140BE0@ADPE2K704.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:43789 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab0EQC7a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 May 2010 22:59:30 -0400
In-Reply-To: <C42A9BA25D0AB74D81491EF544ED520973D1140BE0@ADPE2K704.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rajashekhara, Mahesh" <Mahesh_Rajashekhara@adaptec.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, AACRAID <AACRAID@adaptec.com>

On Mon, 2010-05-10 at 04:24 -0700, Rajashekhara, Mahesh wrote:
> diff -ru a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> --- a/drivers/scsi/aacraid/aachba.c     2010-05-13 12:50:36.684220912 -0700
> +++ b/drivers/scsi/aacraid/aachba.c     2010-05-13 12:59:59.412673184 -0700
> @@ -1598,6 +1598,7 @@
>         int status;
>         struct aac_dev *dev;
>         struct fib * cmd_fibcontext;
> +       int cid;
> 
>         dev = (struct aac_dev *)scsicmd->device->host->hostdata;
>         /*
> @@ -1647,6 +1648,22 @@
>                 count = (scsicmd->cmnd[7] << 8) | scsicmd->cmnd[8];
>                 break;
>         }
> +
> +       if ((lba + count) > (dev->fsa_dev[scmd_id(scsicmd)].size)) {
> +               cid = scmd_id(scsicmd);
> +               dprintk((KERN_DEBUG "aacraid: Illegal lba\n"));
> +               scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
> +                               SAM_STAT_CHECK_CONDITION;
> +               set_sense(&dev->fsa_dev[cid].sense_data,
> +                       HARDWARE_ERROR, SENCODE_INTERNAL_TARGET_FAILURE,
> +                       ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0);
> +               memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
> +                       min_t(size_t, sizeof(dev->fsa_dev[cid].sense_data),
> +                       SCSI_SENSE_BUFFERSIZE));
> +               scsicmd->scsi_done(scsicmd);
> +               return 1;
> +       }
> +
>         dprintk((KERN_DEBUG "aac_read[cpu %d]: lba = %llu, t = %ld.\n",
>           smp_processor_id(), (unsigned long long)lba, jiffies));
>         if (aac_adapter_bounds(dev,scsicmd,lba))
> @@ -1688,6 +1705,7 @@
>         int status;
>         struct aac_dev *dev;
>         struct fib * cmd_fibcontext;
> +       int cid;
> 
>         dev = (struct aac_dev *)scsicmd->device->host->hostdata;
>         /*
> @@ -1727,6 +1745,22 @@
>                 count = (scsicmd->cmnd[7] << 8) | scsicmd->cmnd[8];
>                 fua = scsicmd->cmnd[1] & 0x8;
>         }
> +
> +       if ((lba + count) > (dev->fsa_dev[scmd_id(scsicmd)].size)) {
> +               cid = scmd_id(scsicmd);
> +               dprintk((KERN_DEBUG "aacraid: Illegal lba\n"));
> +               scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
> +                               SAM_STAT_CHECK_CONDITION;
> +               set_sense(&dev->fsa_dev[cid].sense_data,
> +                       HARDWARE_ERROR, SENCODE_INTERNAL_TARGET_FAILURE,
> +                       ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0);
> +               memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
> +                       min_t(size_t, sizeof(dev->fsa_dev[cid].sense_data),
> +                       SCSI_SENSE_BUFFERSIZE));
> +               scsicmd->scsi_done(scsicmd);
> +               return 1;
> +       }
> +
>         dprintk((KERN_DEBUG "aac_write[cpu %d]: lba = %llu, t = %ld.\n",
>           smp_processor_id(), (unsigned long long)lba, jiffies));
>         if (aac_adapter_bounds(dev,scsicmd,lba))

For some reason, this patch is whitespace damaged ... all the tabs have
become spaces ... I fixed it up (for this one time).

James


