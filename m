From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: thin provisioned LUN support
Date: Thu, 6 Nov 2008 10:15:28 -0700
Message-ID: <20081106171528.GA11773@parisc-linux.org>
References: <4913028B.6010405@redhat.com> <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:46554 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbYKFRPp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2008 12:15:45 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Jens Axboe <jens.axboe@oracle.com>

On Thu, Nov 06, 2008 at 03:24:05PM +0000, David Woodhouse wrote:
> I think we should be content to declare such devices 'broken'.
> 
> They have to keep track of individual sectors _anyway_, and dropping 
> information for small discard requests is just careless.

As an implementor of such a device, I say "ya, boo, sucks to you".
ata_ram simply ignores the bits of the trim which don't line up with the
page size chunks it's allocated.  Sure, it'd be possible to add a bitmap
to indicate which 512-byte chunks of the block contain data and which
don't, but I haven't done that yet.  I think there's even space in the
struct page that I can abuse to do that.

I think this really is a QoI thing.  Vendors who don't track individual
sectors will gradually get less and less efficient.  Hopefully users
will buy from vendors who don't cheat.  We can even write a quick
program to allocate the entire drive then trim sectors in a chessboard
patterns.  That'll let users see who's got a crap implementation and
who's got a good one.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
