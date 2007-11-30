From: Anders Henke <anders.henke@1und1.de>
Subject: Re: broken dpt_i2o in 2.6.23 (was: ext2_check_page: bad entry in directory) (fwd)
Date: Fri, 30 Nov 2007 14:27:45 +0100
Message-ID: <20071130132745.GF7697@1und1.de>
References: <20071129130319.GA2642@atrey.karlin.mff.cuni.cz> <20071129235813Y.tomof@acm.org> <20071129164557.GD30957@1und1.de> <20071129170413.GC2584@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxintern.schlund.de ([212.227.126.204]:59717 "EHLO
	mxintern.schlund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbXK3N1r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Nov 2007 08:27:47 -0500
Content-Disposition: inline
In-Reply-To: <20071129170413.GC2584@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: FUJITA Tomonori <tomof@acm.org>, jack@ucw.cz, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Am 29.11.2007 schrieb Matthew Wilcox:
> On Thu, Nov 29, 2007 at 05:45:57PM +0100, Anders Henke wrote:
> > On Nov 29 2007, FUJITA Tomonori wrote:
> > > @@ -3295,7 +3295,7 @@ static struct scsi_host_template adpt_template = {
> > >  	.this_id		= 7,
> > >  	.cmd_per_lun		= 1,
> > >  	.use_clustering		= ENABLE_CLUSTERING,
> > > -	.use_sg_chaining	= ENABLE_SG_CHAINING,
> > > +	.use_sg_chaining	= DISABLE_SG_CHAINING,
> > >  };
> > >  
> > >  static s32 adpt_scsi_register(adpt_hba* pHba)
> > 
> > The structure to patch does look different and doesn't include an
> > tag "use_sg_chaining":
> > 
> >         .this_id                = 7,
> >         .cmd_per_lun            = 1,
> >         .use_clustering         = ENABLE_CLUSTERING,
> 
> Just add the line
> 	.use_sg_chaining	= DISABLE_SG_CHAINING,
> 
> > };


Just out of curiosity, I've tried 2.6.24-rc3 and patched the kernel
accordingly (DISABLE_SG_CHAINING): doesn't boot successfully,
same error as usual:

EXT2-fs error (device sda1): ext2_check_page: bad entry in directory #2:
rec_len is smaller than minimal - offset=0, inode=0, rec_len=0,
name_len=0
Warning: unable to open an initial console.
Kernel panic - not syncing: No init found.  Try passing init= option to
kernel.

As sent in a parallel mail, I've found out that 2.6.23-rc2 works and
2.6.23-rc3 shows the same problems - so the problem has to be searched
in the dpt_i2o-changes made for 2.6.23-rc3.


Anders
-- 
1&1 Internet AG              System Design
Brauerstrasse 48             v://49.721.91374.50
D-76135 Karlsruhe            f://49.721.91374.225

Amtsgericht Montabaur HRB 6484
Vorstand: Henning Ahlert, Ralph Dommermuth, Matthias Ehrlich, Andreas Gauger,
Thomas Gottschlich, Matthias Greve, Robert Hoffmann, Norbert Lang, Achim Weiss
Aufsichtsratsvorsitzender: Michael Scheeren
