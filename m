From: Anders Henke <anders.henke@1und1.de>
Subject: Re: broken dpt_i2o in 2.6.23 (was: ext2_check_page: bad entry in directory) (fwd)
Date: Fri, 30 Nov 2007 11:34:50 +0100
Message-ID: <20071130103450.GC7697@1und1.de>
References: <20071129130319.GA2642@atrey.karlin.mff.cuni.cz> <20071129235813Y.tomof@acm.org> <20071129164557.GD30957@1und1.de> <20071130021226T.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxintern.schlund.de ([212.227.126.204]:51948 "EHLO
	mxintern.schlund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbXK3Key (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Nov 2007 05:34:54 -0500
Content-Disposition: inline
In-Reply-To: <20071130021226T.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>, matthew@wil.cx
Cc: jack@ucw.cz, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Am 30.11.2007 schrieb FUJITA Tomonori:
> > > > According to the 2.6.23-rc1 short-form changelog, there is
> > > > one major edit on the dpt_i2o driver:
> > > > 
> > > > FUJITA Tomonori 
> > > > 
> > > >       [SCSI] dpt_i2o: convert to use the data buffer accessors
> > > > 
> > > > Stephen Rothwell 
> > > >       dpt_i2o depends on virt_to_bus
> > > > 
> > > > Fujita, would you please take a look at this?
> > > 
> > > Sorry about the bug. Can you try this?
> > > 
> > > 
> > > diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
> > > index 8258506..1255b26 100644
> > > --- a/drivers/scsi/dpt_i2o.c
> > > +++ b/drivers/scsi/dpt_i2o.c
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
> 
> Sorry, I misread your bug report. If you use 2.6.23, the sg chaining
> is unrelated.
> 
> What architecture do you use?

"Mainstream" 32-bit-x86, the affected boxes are running Intel Xeons (P4)
at 2.66 or 2.8 GHz. 

In between, I've ruled out that the static assignment isn't
source of the problem.  And due to some manually made "make clean" which 
didn't clean enough, I've also pointed out the wrong patch - sorry,
Fujita, definitely the right one which breaks my boxes is the dpt_i2o patch 
from 2.6.23-rc2 to 2.6.23-rc3 (7 kb in Size) from Matthew Wilcox.

commit 55d9fcf57ba5ec427544fca7abc335cf3da78160
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Mon Jul 30 15:19:18 2007 -0600

    [SCSI] dpt_i2o: convert to SCSI hotplug model
    
     - Delete refereces to HOSTS_C
     - Switch to module_init/module_exit instead of detect/release
     - Don't pass around the host template and rename it to
       adpt_template
     - Switch from scsi_register/scsi_unregister to scsi_host_alloc,
       scsi_add_host, scsi_scan_host and scsi_host_put.
    
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>
    Acked-by: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

"Definitely" as in
-applied the diff-patch onto 2.6.23.1 with a dpt_i2o from 2.6.23-rc1
 to verify that booting failes.
-Recompiled a clean unpacked 2.6.23-rc2 to verify that the driver
 from -rc2 still works.
-Recompiled a clean unpacked 2.6.23-rc3 to verify that the driver
 from -rc3 breaks booting on my boxes.

So sorry for mispointing the bug to you, it's an issue for Matthew.


Anders
-- 
1&1 Internet AG              System Design
Brauerstrasse 48             v://49.721.91374.50
D-76135 Karlsruhe            f://49.721.91374.225

Amtsgericht Montabaur HRB 6484
Vorstand: Henning Ahlert, Ralph Dommermuth, Matthias Ehrlich, Andreas Gauger,
Thomas Gottschlich, Matthias Greve, Robert Hoffmann, Norbert Lang, Achim Weiss
Aufsichtsratsvorsitzender: Michael Scheeren
