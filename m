From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH4/5] mpt fusion: Optimized SendEventNotification [Resendig updated patch]
Date: Sat, 10 Jan 2009 15:16:10 -0700
Message-ID: <20090110221609.GG6936@parisc-linux.org>
References: <20090108085912.GB4116@lsi.com> <1231625559.3642.54.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:57925 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889AbZAJWQM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Jan 2009 17:16:12 -0500
Content-Disposition: inline
In-Reply-To: <1231625559.3642.54.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Kashyap, Desai" <kashyap.desai@lsi.com>, linux-scsi@vger.kernel.org, eric.moore@lsi.com, sathya.prakash@lsi.com

On Sat, Jan 10, 2009 at 04:12:39PM -0600, James Bottomley wrote:
> > +                       dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "alt-ioc
> > +                               reply irq re-enabled\n",
> > +                               ioc->alt_ioc->name));
> 
> This isn't legal C: you can't split a string constant without a
> backslash:

Umm ... I don't think you can even split it with a backslash.  You need
to use string concatenation like so:

			dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "alt-ioc "
				"reply irq re-enabled\n",
				ioc->alt_ioc->name));

Or, since it's 100% more readable and greppable:

			dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT
				"alt-ioc reply irq re-enabled\n",
				ioc->alt_ioc->name));

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
