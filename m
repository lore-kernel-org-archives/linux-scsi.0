From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v2 06/36] ncr5380: Remove more useless prototypes
Date: Sun, 9 Nov 2014 23:19:50 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1411091121190.4669@nippy.intranet>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052608.595432496@telegraphics.com.au> <5450FD34.2020208@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:39057 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbaKIMUv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Nov 2014 07:20:51 -0500
In-Reply-To: <5450FD34.2020208@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org


Ping...

On Wed, 29 Oct 2014, Hannes Reinecke wrote:

> On 10/27/2014 06:26 AM, Finn Thain wrote:
> > Make use of the host template static initializer instead of assigning
> > handlers at run-time. Move __maybe_unused qualifiers from declarations
> > to definitions. Move the atari_scsi_bus_reset() wrapper after the
> > definition of NCR5380_bus_reset(). All of the host template handler
> > prototypes are now redundant so remove them.
> > 
> > The write_info() handler is only relevant to drivers using PSEUDO_DMA so
> > this patch fixes the compiler warning in atari_NCR5380.c and sun3_NCR5380.c:
> > 
> >   CC      drivers/scsi/atari_scsi.o
> >   drivers/scsi/NCR5380.h:329: warning: 'NCR5380_write_info' declared 'static' but never defined
> > 
> > Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> > 
> > ---
> >  drivers/scsi/NCR5380.h       |    8 ----
> >  drivers/scsi/atari_NCR5380.c |    3 +
> >  drivers/scsi/atari_scsi.c    |   76 ++++++++++++++++++++-----------------------
> >  drivers/scsi/dtc.c           |    7 +--
> >  drivers/scsi/pas16.c         |    7 +--
> >  drivers/scsi/sun3_NCR5380.c  |    3 +
> >  drivers/scsi/t128.c          |    7 +--
> >  7 files changed, 50 insertions(+), 61 deletions(-)
> > 
> > Index: linux/drivers/scsi/NCR5380.h
> > ===================================================================
> > --- linux.orig/drivers/scsi/NCR5380.h	2014-10-27 16:25:06.000000000 +1100
> > +++ linux/drivers/scsi/NCR5380.h	2014-10-27 16:25:14.000000000 +1100
> > @@ -322,14 +322,6 @@ static irqreturn_t NCR5380_intr(int irq,
> >  #endif
> >  static void NCR5380_main(struct work_struct *work);
> >  static void __maybe_unused NCR5380_print_options(struct Scsi_Host *instance);
> > -static int NCR5380_abort(Scsi_Cmnd * cmd);
> > -static int NCR5380_bus_reset(Scsi_Cmnd * cmd);
> > -static int NCR5380_queue_command(struct Scsi_Host *, struct scsi_cmnd *);
> > -static int __maybe_unused NCR5380_show_info(struct seq_file *,
> > -	struct Scsi_Host *);
> > -static int __maybe_unused NCR5380_write_info(struct Scsi_Host *instance,
> > -	char *buffer, int length);
> > -
> >  static void NCR5380_reselect(struct Scsi_Host *instance);
> >  static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd * cmd, int tag);
> >  #if defined(PSEUDO_DMA) || defined(REAL_DMA) || defined(REAL_DMA_POLL)
> > Index: linux/drivers/scsi/dtc.c
> > ===================================================================
> > --- linux.orig/drivers/scsi/dtc.c	2014-10-27 16:25:08.000000000 +1100
> > +++ linux/drivers/scsi/dtc.c	2014-10-27 16:25:14.000000000 +1100
> > @@ -219,10 +219,6 @@ static int __init dtc_detect(struct scsi
> >  	void __iomem *base;
> >  	int sig, count;
> >  
> > -	tpnt->proc_name = "dtc3x80";
> > -	tpnt->show_info = dtc_show_info;
> > -	tpnt->write_info = dtc_write_info;
> > -
> >  	for (count = 0; current_override < NO_OVERRIDES; ++current_override) {
> >  		addr = 0;
> >  		base = NULL;
> > @@ -477,6 +473,9 @@ static struct scsi_host_template driver_
> >  	.name				= "DTC 3180/3280 ",
> >  	.detect				= dtc_detect,
> >  	.release			= dtc_release,
> > +	.proc_name			= "dtc3x80",
> > +	.show_info			= dtc_show_info,
> > +	.write_info			= dtc_write_info,
> >  	.queuecommand			= dtc_queue_command,
> >  	.eh_abort_handler		= dtc_abort,
> >  	.eh_bus_reset_handler		= dtc_bus_reset,
> 
> What is the current consensus on using '.proc_name' ?
> At one point is was claimed to be deprecated, yet the only driver
> actually following this seems to be lpfc.
> (_And_ we have a patch in our tree to hook that back in).
> 
> Can't we just get it back for the time being and decide upon a
> proper solution later?
> 
> Cheers,
> 
> Hannes
> 
-- 
