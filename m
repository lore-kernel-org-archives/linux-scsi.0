From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Full hostlock pushdown available
Date: Mon, 01 Nov 2010 14:06:19 -0700
Message-ID: <1288645579.7708.10.camel@haakon2.linux-iscsi.org>
References: <20101028150508.GA2385@basil.fritz.box>
	 <4CCD5F7F.8020808@panasas.com> <tkrat.c4793af298337eff@s5r6.in-berlin.de>
	 <4CCE271D.7040400@garzik.org> <20101101135338.GA25817@basil.fritz.box>
	 <4CCEE33F.5030300@garzik.org> <20101101175742.GG25817@basil.fritz.box>
	 <4CCF0DFE.4050106@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45657 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab0KAVLb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2010 17:11:31 -0400
In-Reply-To: <4CCF0DFE.4050106@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andi Kleen <andi@firstfloor.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Boaz Harrosh <bharrosh@panasas.com>, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, Linux IDE mailing list <linux-ide@vger.kernel.org>

On Mon, 2010-11-01 at 14:59 -0400, Jeff Garzik wrote:
> On 11/01/2010 01:57 PM, Andi Kleen wrote:
> > @@ -3186,11 +3186,14 @@ int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done
> >         struct ata_device *dev;
> >         struct scsi_device *scsidev = cmd->device;
> >         struct Scsi_Host *shost = scsidev->host;
> > +       unsigned long irqflags;
> >         int rc = 0;
> >
> >         ap = ata_shost_to_port(shost);
> >
> > -       spin_unlock(shost->host_lock);
> > +       spin_lock_irqsave(shost->host_lock, irqflags);
> > +       scsi_cmd_get_serial(shost, cmd);
> > +
> >         spin_lock(ap->lock);
> >
> >         ata_scsi_dump_cdb(ap, cmd);
> > @@ -3205,6 +3208,7 @@ int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(
> >
> >         spin_unlock(ap->lock);
> >         spin_lock(shost->host_lock);
> > +       spin_unlock_irqrestore(shost->host_lock, irqflags);
> >         return rc;
> >  }
> >
> 
> It's a bit disappointing that libata's lock profile in this patch is 
> quite different than that of current upstream: with your patch, libata 
> holds the scsi host lock for a considerably longer period of time, while 
> also holding the ATA port/host spinlock.
> 
> IOW, it's doing the exact opposite of what the previous code did 
> (release the scsi host lock, before acquiring the ATA port/host 
> spinlock), not at all an equivalent transformation.
> 
> The following sequence would seem to better preserve the existing lock 
> profile, correct?
> 
> 	local_irq_save(flags)
> 
> 	spin_lock(shost->host_lock)
> 	scsi_cmd_get_serial()
> 	spin_unlock(shost->host_lock)
> 
> 	spin_lock(ap->lock)
> 	...
> 	spin_unlock(ap->lock)
> 
> 	local_irq_restore(flags)
> 

Hmmmmm yes..   Along with Andi's generated patches I think we should
strongly consider including the atomic_t Scsi_Host->cmd_serial_number
patch here as well for scsi_cmd_get_serial() (which needs EXPORT_SYMBOL)

http://git.kernel.org/?p=linux/kernel/git/nab/lio-4.0.git;a=commitdiff;h=c047a53c52ee6c90daf048b045750e18173fd011#patch68
http://git.kernel.org/?p=linux/kernel/git/nab/lio-4.0.git;a=commitdiff;h=c047a53c52ee6c90daf048b045750e18173fd011#patch37
http://git.kernel.org/?p=linux/kernel/git/nab/lio-4.0.git;a=commitdiff;h=c047a53c52ee6c90daf048b045750e18173fd011#patch82

This ends up being a very simple change, and would allow libata to
immediately go host_lock less for scsi_cmd_dispatch() operation.

FYI, the current scoreboard for the global push down is available in
lio-core-4.0.git/host_lock-less-for-37-v9 at the top of the above
commit..  I think Andi is missing a few LLDs outside of /drivers/scsi/

Best,

--nab


