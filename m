From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] sym53c8xx PPR negotiation fix
Date: Wed, 29 Oct 2003 13:02:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067450547.3112.363.camel@compaq.xsintricity.com>
References: <1067447221.3112.336.camel@compaq.xsintricity.com>
	 <1067447490.1829.30.camel@mulgrave>
	 <20031029175045.GC25237@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:18698 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261262AbTJ2SDY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 13:03:24 -0500
In-Reply-To: <20031029175045.GC25237@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

On Wed, 2003-10-29 at 12:50, Matthew Wilcox wrote:
> On Wed, Oct 29, 2003 at 11:11:28AM -0600, James Bottomley wrote:
> > On Wed, 2003-10-29 at 11:07, Doug Ledford wrote:
> > > I haven't checked if this is applicable to 2.6 as well.  James?
> > 
> > Well, the sym driver doesn't exist anymore in 2.6...however sym_2 had a
> > similar issue.  Matthew Wilcox has already fixed it though, I think.
> 
> Oh, wishful thinking.  I'm trying to fix it and haven't succeeded yet.
> These days, there's a PPR bit in the scsi_device, but it never seems to
> be set, so we don't even try negotiating it.  Maybe the drives I have
> to play with aren't really U160.
> 
> my current patch looks something like this (terribly mangled):
> 
> @@ -518,16 +518,21 @@ static int sym_queue_command(struct sym_
>         order = (lp && lp->s.reqtags) ? M_SIMPLE_TAG : 0;
>  
> +       /* Ensure we don't issue unwanted negotiations */
> +       if (!ccb->device->ppr) {
> +               tp->tinfo.goal.options &= ~PPR_OPT_MASK;
> +       }
> +

Well, I do believe I recall adding the ppr bit to the scsi_device struct
long ago, and I thought I added the test to set it.  If not, then on
device scan once we have the inquiry return data and have determined
scsi level of the device this would be sufficient to properly set it:

if (sdev->scsi_level >= 3 || (inquiry_len >= 53 && inquiry[56] & 0x04))
	sdev->ppr = 1;

(I mainly added this so that drivers could rip out their INQUIRY
snooping code and rely upon the mid layer's snooping of INQUIRY to set
the relevant options, but I'm not sure that it's been completed well
enough that the drivers can do that yet)


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


