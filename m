From: Neil Brown <neilb@suse.de>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 11:23:43 +1000
Message-ID: <18194.49439.864088.169436@notabene.brown>
References: <200710112011.22000.rob@landley.net>
	<4711AF18.3030201@davidnewall.com>
	<471255E4.3070009@s5r6.in-berlin.de>
	<200710141836.55211.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:52945 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbXJOBXy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Oct 2007 21:23:54 -0400
In-Reply-To: message from Rob Landley on Sunday October 14
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, David Newall <david@davidnewall.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Sunday October 14, rob@landley.net wrote:
> On Sunday 14 October 2007 12:46:12 pm Stefan Richter wrote:
> > David Newall wrote:
> > > That is so rude.
> 
> When a reply contains as a reply to the first paragraph "you're wrong" with no 
> elaboration, and as a reply to the second paragraph nothing but expletives 
> and personal insults, I tend to stop reading.  It really doesn't come across 
> as a serious reply.
> 
> I was at least attempting to ask a serious question.

Indeed you were, and let me try to answer it as best I can.

I like to think of the "block layer" as two main parts.

Firstly there is the "interface" which it defines, embodied primarily
in generic_make_request() and 'struct bio'.  There are various other
small routines in ll_rw_blk.c, and there is 'struct request_queue'
which is also involved in the other half of the block layer.

This interface defines how requests are passed down, how their
completion is acknowledged, and various other little details

Any block device can register a make_request_fn function and get the
requests (struct bio) almost exactly as the client (filesystem or
whatever) sent them down - just with a few sanity checks and some
translation (for partitions) applied.

The other half of the "block layer" is the io scheduler code.
This involves the 'struct request' and __make_request() and the various
routines it calls.
This collects bios (passed down from clients) and produces 'requests'
which devices can handle.  One of the important differences between
bios and requests is the amount of parallelism.
A filesystem can send down as may concurrent bios as it likes (or as
it can allocate memory for).
A device can only handle a limited number of requests at a time,
depending on the limit of the 'tags command queueing' mechanism
particular to that device.
The scheduler bridges this parallelism gap by .... scheduling.

So the "block layer" consists of "block interface" and "io scheduler"

All block devices use the "block interface" - they have no choice.
Many block devices use the "io scheduler", but many don't.
md and dm, loop, umem, and others do their own scheduling as they have
needs that are specific to the devices, or that otherwise don't
benefit from the io scheduler (which is really designed for
rotating-media style devices).

SCSI devices can be both block device and non-block devices
(traditionally 'char devices').

The 'scsi generic' or 'sg' interface to SCSI devices allows arbitrary
SCSI commands to be sent to a SCSI device.  There are many SCSI
devices that are not block devices as all (media robots, etc).

When a SCSI device is being used as a block device, the block
interface is used.  When it is being used as a 'generic device', the
block interface is not used.

Now we get to the heart of the matter, and to where my knowledge
becomes a little less detailed - so please forgive if I say something
silly.

I believe that the SCSI-generic handling still uses the IO scheduler,
even though it doesn't use the block interface.
It is probable that the IO scheduler is not a perfect match for the
needs of SCSI-generic handling.  Given it's origin, that should not be
surprising.

I believe the linux-scsi email that you referred was addressing this
issue.  When the author says:

    That approach makes the Linux block layer either a nuisance,
    irrelevant or a complete anachronism 

I believe he is referring to what I would call the IO scheduler, and is
observing that it is not a perfect fit.  He is probably right.

So to answer your question:

  SCSI block devices use both the "block interface" and the "io
  scheduler" and I believe that when people talk about "the block layer"
  they refer to these two things.
  i.e. the SCSI layer provides "scsi_request_fn".  The block interface
  calls __make_request which performs IO scheduling and calls
  scsi_request_fn for each request.

Hope that helps.

NeilBrown
