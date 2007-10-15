From: Rob Landley <rob@landley.net>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 16:51:52 -0500
Message-ID: <200710151651.53201.rob@landley.net>
References: <200710112011.22000.rob@landley.net> <200710141845.44750.rob@landley.net> <1192453849.6368.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:58434
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762485AbXJOVv7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 17:51:59 -0400
In-Reply-To: <1192453849.6368.26.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@oracle.com>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Monday 15 October 2007 8:10:49 am James Bottomley wrote:
> OK, so could we get back to the original discussion?  The question I
> think you meant to ask is "does SCSI use the block layer, and if so;
> how?"
>
> The answer is yes (just do an ls /sys/block on any scsi machine).  The
> how is that it bascially uses the block layer as a service library (i.e.
> most SCSI services are built on top of those already provided by block).
> The email you cited was basically from our one area of confusion:  SCSI
> and block both provide services to decode the SG_IO ioctl.  This is
> partly historical; block and SCSI are very much intertwined; so much so
> that they both tend to drive each other's development.  The programme
> over the last few years has been to identify features in SCSI that
> should be more generic (and hence moved to block).  SG_IO is one of
> these, so we end up with the situation where Block provides this as a
> service (and sr, st and sd make use of it) while the sg driver still
> doesn't use what the block layer provides but rolls its own.  I think
> the layout of how all this works is illustrated at a reasonably high
> level here on slide 15:
>
> http://licensing.steeleye.com/support/papers/ols_2005_slides.pdf

Thanks, that's exactly what I wanted to know.

> > However, the response to my attempts to express this dissatisfaction on
> > the SCSI list a few months ago came too close to a flamewar for me to
> > consider continuing it productive.  I'd still love to update the "2.4
> > scsi howto" and corresponding sg howto, but lack the expertise.  The SCSI
> > layer really isn't my area, and I was much happier back when I could
> > avoid using it at all.
>
> That was because your initial inquiry came across as "I'm trying to
> document this, and by the way it's rubbish".

Sorry about that.  Not my intent.  I was aiming more at "I'm trying to 
document this and I don't understand how it works at all, or why it does 
things this way.  It seems backwards from what I would expect."

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
