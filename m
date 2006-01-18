From: linas@austin.ibm.com (linas)
Subject: Re: [PATCH] PCI Error Recovery: Symbios SCSI device driver
Date: Wed, 18 Jan 2006 11:54:08 -0600
Message-ID: <20060118175408.GS26221@austin.ibm.com>
References: <20060118165345.GA31920@austin.ibm.com> <20060118170716.GA9569@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:64232 "EHLO
	e36.co.us.ibm.com") by vger.kernel.org with ESMTP id S932460AbWARRyP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jan 2006 12:54:15 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k0IHsB0j008744
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2006 12:54:11 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k0IHuK2r176904
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2006 10:56:20 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k0IHsAtL003907
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2006 10:54:10 -0700
Content-Disposition: inline
In-Reply-To: <20060118170716.GA9569@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James.Bottomley@steeleye.com, brking@us.ibm.com, gregkh@suse.de, linux-scsi@vger.kernel.org

On Wed, Jan 18, 2006 at 10:07:16AM -0700, Matthew Wilcox was heard to remark:
> On Wed, Jan 18, 2006 at 10:53:45AM -0600, linas wrote:
> > Hi James,
> 
> Actually, I'm the sym2 maintainer.

Ah, sorry, then.

> > +static void sym_eeh_timeout(u_long p)
> 
> Please don't propagate more uses of this u_long crap.  I haven't got
> rid of all of them, but there's no need to add more.

I was trying to follow the coding style as currently found in 
that file; the other routines of this type use u_long.  Should
I use u_int instead? or unsigned long? 

> > @@ -1630,6 +1682,8 @@ static struct Scsi_Host * __devinit sym_
> >  	np->maxoffs	= dev->chip.offset_max;
> >  	np->maxburst	= dev->chip.burst_max;
> >  	np->myaddr	= dev->host_id;
> > +	np->s.io_state = pci_channel_io_normal;
> > +	np->s.io_reset_wait = NULL;
> 
> Is there a good reason to put them in the 's'?  It's really a dirty
> hack.

The struct sym_shcb is defined in a file "sym_glue.h" which seems to
contain linux-kernel specific code.  The comments before this struct 
state that its a "System specific host data structure."

By contrast, struct sym_hcb is defined in "sym_hipd.h", which appears
to have no Linux-specific structs in it. Thus, I assumed that it 
should go into the glue struct rather than the main struct.  I can
of course add it to sym_hcb if that is a better location.

> I really hate "if (constant == variable)".

Sorry, I'll fix it. I find it easier on the eyes to read that way. 
Old habit.  (It has the marginal benefit of flagging as a compiler 
error any accidental drop of an =, such as if (variable = constant) 
which is usually not what the coder intended).

I'll fix the other bits you mentioned as well.

--linas
