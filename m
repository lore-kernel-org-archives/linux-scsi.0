From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [SAS ANNOUNCEMENT] MPT Fusion driver 3.02.07 update
Date: Wed, 10 Nov 2004 10:16:10 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C3769DB@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:58544 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262016AbUKJRQ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2004 12:16:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph - I'm working on this command line implementation right now.

I'm proposing to my co-workers to dump entirely the current 
implementation, in favor of the new one. 

Questions:
(1) MODULE_PARM is now depreciated in 2.6.10-rc.  What has replaced it?
(2) Will this new method work for command line parameters being passed
thru loading of the driver from ramdisk(initrd) image?


Here is my proposal:

# insmod mptscsih.ko dv=1 width=1 factor=0x8 saf_te=0 pt_clear=0
# modinfo mptscsih.ko

The output will be:

author:         LSI Logic Corporation
description:    Fusion MPT SCSI Host driver
license:        GPL
parm:           dv:DV Algorithm: enhanced = 1, basic = 0
(default=MPTSCSIH_DOMAIN_VALIDATION=1)
parm:           width:Max Bus Width: wide = 1, narrow = 0
(default=MPTSCSIH_MAX_WIDTH=1)
parm:           factor:Min Sync Factor: (default=MPTSCSIH_MIN_SYNC=0x08)
parm:           saf_te:Force enabling SEP Processor:
(default=MPTSCSIH_SAF_TE=0)
parm:           pt_clear:Clear persistency table:
(default=MPTSCSIH_PT_CLEAR=0)
vermagic:       2.6.10-rc1-bk18 SMP PENTIUMII REGPARM gcc-3.3
depends:        mptbase,scsi_mod,mptbase



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, November 10, 2004 10:04 AM
> To: Matthew Wilcox
> Cc: Christoph Hellwig; Moore, Eric Dean; linux-scsi@vger.kernel.org;
> Stephens, Larry
> Subject: Re: [SAS ANNOUNCEMENT] MPT Fusion driver 3.02.07 update
> 
> 
> On Tue, Nov 09, 2004 at 04:18:59PM +0000, Matthew Wilcox wrote:
> > On Tue, Nov 09, 2004 at 02:20:04PM +0000, Christoph Hellwig wrote:
> > > Well, you're disallowing one of the existant syntaxes 
> anyway, right?
> > > 
> > > At least add a separate one for each of the parameters (and only
> > > add those for the new parameter) so the old ones can spit 
> a warning
> > > and be removed after a longer timeframe.
> > 
> > This may not be possible.  It wasn't with sym2 -- the 
> module code said
> > "Oh, I found both old and new style parameters, I'm going to disable
> > the new ones".  Rusty refused to fix it, claiming he was 
> going to remove
> > the old code within a couple of minor releases.
> 
> Well, both could be module_param.
> 
