From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] ncr53c8xx updates
Date: Fri, 11 Mar 2005 08:52:38 +0200
Message-ID: <1110523958.5250.7.camel@mulgrave>
References: <20050306201153.GV28741@parcelfarce.linux.theplanet.co.uk>
	 <20050307004015.GA7697@infradead.org>
	 <20050307023251.GZ28741@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:48876 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261333AbVCKIsd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2005 03:48:33 -0500
In-Reply-To: <20050307023251.GZ28741@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-03-07 at 02:32 +0000, Matthew Wilcox wrote:
> Thanks for reminding me; still the only person who cares about the Q720
> also follows the parisc-linux-cvs list ;-)

Hey, I have more than one user!

Also, I don't really follow the parisc CVS tree on the voyagers;
primarily because I haven't been keeping the BK copy very well up to
date (the voyagers are still my main SCSI machines, so they follow the
kernel BK head).

So, if you submit it minus the pieces that are already in scsi-misc-2.6
I'll give it a go when I get back home

> One of the issues with trying to turn sym2 into the all-singing,
> all-dancing 7xx,8xx,1010 driver is that there's two parisc models
> (the 735 and 755) that have an ncr53c720 chip but don't support dma
> coherent memory.  I'd really rather not have sym2 use the advanced magic
> DMA APIs.  I'm also not looking forward to trying to make ncr53c8xx use
> them either ...  maybe the right thing to do is teach ncr53c700 to drive
> the 720 chip too?

Really, no.  The scripts engine of the 700 and the 710 chips is very
unsophisticated.  The key difference is that they don't have the table
addressing mode sophistication that the 720 does.  In theory, 720
scripts can do reselection without interrupt until the transfer is
complete.  The 700 and 710 have to interrupt for the driver to find the
tag.

I think it makes the most sense for the 53c700 to be optimised for the
700-710; the ncr53c8xx for the 720 and the sym2 for everything else.

Adding the incoherent API isn't hard ... I can probably do that in the
ncr53c8xx (once it's slimmed down as far as it will go).  The slight
nasty is that the driver uses self modifying scripts fragments, so they
all have to be audited.

James


