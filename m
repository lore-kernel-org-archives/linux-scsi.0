From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH] sym53c8xx PPR negotiation fix
Date: Wed, 29 Oct 2003 17:50:45 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031029175045.GC25237@parcelfarce.linux.theplanet.co.uk>
References: <1067447221.3112.336.camel@compaq.xsintricity.com> <1067447490.1829.30.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:9430 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261262AbTJ2Rur
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 12:50:47 -0500
Content-Disposition: inline
In-Reply-To: <1067447490.1829.30.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Doug Ledford <dledford@redhat.com>, Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

On Wed, Oct 29, 2003 at 11:11:28AM -0600, James Bottomley wrote:
> On Wed, 2003-10-29 at 11:07, Doug Ledford wrote:
> > I haven't checked if this is applicable to 2.6 as well.  James?
> 
> Well, the sym driver doesn't exist anymore in 2.6...however sym_2 had a
> similar issue.  Matthew Wilcox has already fixed it though, I think.

Oh, wishful thinking.  I'm trying to fix it and haven't succeeded yet.
These days, there's a PPR bit in the scsi_device, but it never seems to
be set, so we don't even try negotiating it.  Maybe the drives I have
to play with aren't really U160.

my current patch looks something like this (terribly mangled):

@@ -518,16 +518,21 @@ static int sym_queue_command(struct sym_
        order = (lp && lp->s.reqtags) ? M_SIMPLE_TAG : 0;
 
+       /* Ensure we don't issue unwanted negotiations */
+       if (!ccb->device->ppr) {
+               tp->tinfo.goal.options &= ~PPR_OPT_MASK;
+       }
+
        /*
         *  Queue the SCSI IO.

but I have it mixed in with some other changes that're supposed to
help negotiate U160, so I can't say there might be some reason to not
do this.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
