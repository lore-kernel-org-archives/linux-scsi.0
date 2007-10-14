From: Rob Landley <rob@landley.net>
Subject: Re: What still uses the block layer?
Date: Sun, 14 Oct 2007 18:36:54 -0500
Message-ID: <200710141836.55211.rob@landley.net>
References: <200710112011.22000.rob@landley.net> <4711AF18.3030201@davidnewall.com> <471255E4.3070009@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:60474
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760250AbXJNXhE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Oct 2007 19:37:04 -0400
In-Reply-To: <471255E4.3070009@s5r6.in-berlin.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: David Newall <david@davidnewall.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Sunday 14 October 2007 12:46:12 pm Stefan Richter wrote:
> David Newall wrote:
> > That is so rude.

When a reply contains as a reply to the first paragraph "you're wrong" with no 
elaboration, and as a reply to the second paragraph nothing but expletives 
and personal insults, I tend to stop reading.  It really doesn't come across 
as a serious reply.

I was at least attempting to ask a serious question.

> Such responses sometimes happen after provocative posts like the thread
> starter's.  He could have asked straight away for help with fixing his
> boot environment instead of wrapping his question into a feigned design
> discussion.  It appeared as if he is out for a fight rather than
> interested in help.

Actually, I was going through Documentation/block thinking about making a 
00-INDEX for it, but my earlier questions of the scsi guys left me with the 
impression that the block layer is _not_ used by the SCSI layer.  And since 
every non-embedded modern storage device I'm aware of has been consumed by 
the SCSI layer (despite none of them actually having a discernably closer 
relationship to SCSI than ATA did), I didn't know whether or not it was more 
appropriate to index this directory or request its deletion.  So I asked.

Back when I  asked the scsi guys about this, I got no direct answer.  I 
asked "where does the block layer work into this" in the context of questiosn 
about the relationship between the scsi upper, middle, and lower layers, and 
I never got a reply, even though the question was quoted back at me here:
http://www.mail-archive.com/linux-scsi%40vger.kernel.org/msg09086.html

The closest I got to an answer was later in the thread:
http://www.mail-archive.com/linux-scsi%40vger.kernel.org/msg09131.html

Which said:
> That approach makes the Linux block layer either a nuisance,
> irrelevant or a complete anachronism (in the case of OSD).
> IMO the linux block layer should be morphed into a library
> of internal queue handling routines. Storage upper level
> drivers such as sd can continue to present the "block"
> view ** of storage devices such as disks.

The gist of the thread (and the documentation I was referred to) is that the 
scsi "upper layer" presents /dev nodes and ioctls, the scsi mid-layer is a 
routing layer very roughly analogus to a TCP/IP stack, and the scsi low-layer 
drivers interface with specific pieces of hardware.  Apparently, the block 
layer is not between any of these, they talk directly to each other.  This 
would seem to indicate that I/O requests made to scsi devices are never 
routed through a common block I/O request handling layer shared with non-SCSI 
block devices.  I was not, however, certain of this, hence my attempt to 
bring the topic back up.

Oh, and sending a patch correcting Jens Axboe's address in this old 
documentation.  He's apparently at Oracle now...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
