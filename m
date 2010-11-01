From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Full hostlock pushdown available
Date: Mon, 01 Nov 2010 14:59:10 -0400
Message-ID: <4CCF0DFE.4050106@garzik.org>
References: <20101028150508.GA2385@basil.fritz.box> <4CCD5F7F.8020808@panasas.com> <tkrat.c4793af298337eff@s5r6.in-berlin.de> <4CCE271D.7040400@garzik.org> <20101101135338.GA25817@basil.fritz.box> <4CCEE33F.5030300@garzik.org> <20101101175742.GG25817@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55878 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab0KAS7O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2010 14:59:14 -0400
In-Reply-To: <20101101175742.GG25817@basil.fritz.box>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Boaz Harrosh <bharrosh@panasas.com>, James.Bottomley@suse.de, nab@linux-iscsi.org, linux-scsi@vger.kernel.org, Linux IDE mailing list <linux-ide@vger.kernel.org>

On 11/01/2010 01:57 PM, Andi Kleen wrote:
> @@ -3186,11 +3186,14 @@ int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done
>         struct ata_device *dev;
>         struct scsi_device *scsidev = cmd->device;
>         struct Scsi_Host *shost = scsidev->host;
> +       unsigned long irqflags;
>         int rc = 0;
>
>         ap = ata_shost_to_port(shost);
>
> -       spin_unlock(shost->host_lock);
> +       spin_lock_irqsave(shost->host_lock, irqflags);
> +       scsi_cmd_get_serial(shost, cmd);
> +
>         spin_lock(ap->lock);
>
>         ata_scsi_dump_cdb(ap, cmd);
> @@ -3205,6 +3208,7 @@ int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(
>
>         spin_unlock(ap->lock);
>         spin_lock(shost->host_lock);
> +       spin_unlock_irqrestore(shost->host_lock, irqflags);
>         return rc;
>  }
>

It's a bit disappointing that libata's lock profile in this patch is 
quite different than that of current upstream: with your patch, libata 
holds the scsi host lock for a considerably longer period of time, while 
also holding the ATA port/host spinlock.

IOW, it's doing the exact opposite of what the previous code did 
(release the scsi host lock, before acquiring the ATA port/host 
spinlock), not at all an equivalent transformation.

The following sequence would seem to better preserve the existing lock 
profile, correct?

	local_irq_save(flags)

	spin_lock(shost->host_lock)
	scsi_cmd_get_serial()
	spin_unlock(shost->host_lock)

	spin_lock(ap->lock)
	...
	spin_unlock(ap->lock)

	local_irq_restore(flags)

Regards,

	Jeff


