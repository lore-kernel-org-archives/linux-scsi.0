From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: scsi-mq and 3.17rc1
Date: Sun, 7 Sep 2014 22:43:09 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C56608@G4W3202.americas.hpqcorp.net>
References: <94D0CD8314A33A4D9D801C0FE68B402958C22037@G9W0745.americas.hpqcorp.net>
 <20140825145033.GA21318@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:47094 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbaIGWsi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Sep 2014 18:48:38 -0400
In-Reply-To: <20140825145033.GA21318@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Monday, 25 August, 2014 9:51 AM
> To: Elliott, Robert (Server Storage)
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: scsi-mq and 3.17rc1
> 
> On Mon, Aug 25, 2014 at 02:31:58PM +0000, Elliott, Robert (Server
> Storage) wrote:
> > Two scsi-mq tips:
> >
> > 1. Several people have been wondering how to enable scsi-mq.
> > Add this to your kernel command line (e.g., in /boot/grub/grub.conf
> > if using grub-1):
> > 	scsi_mod.use_blk_mq=Y
> 
> Btw, I heard a few complaints about this, and one suggestion would be
> to add a config option to enable it by default.  Would you or others
> like this?

Yes.  It shouldn't become a command line parameter that clutters up
user boot configuration files for years.  A config option will ease
the transition from defaulting to off to defaulting to on.

The command line parameter could override both ways:
config default=N, scsi_mod.use_blk_mq=Y: on
config default=N, scsi_mod.use_blk_mq=N: off
config default=N, scsi_mod.use_blk_mq not specified: off
config default=Y, scsi_mod.use_blk_mq=Y: on
config default=Y, scsi_mod.use_blk_mq=N: off
config default=Y, scsi_mod.use_blk_mq not specified: on

Right now, shost->hostt->disable_blk_mq also allows the LLD to
override to off if needed.  Perhaps that should move to
shost->disable_blk_mq so the LLD could have per-scsi_host 
control (e.g., let the user specify they want it off for for
an HBA attached mostly to HDDs and on for an HBA attached
mostly to SSDs).

I also suggest that scsi_add_host_with_dma use shost_printk 
to indicate what was selected for each scsi_host.

---
Rob Elliott    HP Server Storage



