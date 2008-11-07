From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: thin provisioned LUN support & file system allocation policy
Date: Fri, 7 Nov 2008 07:55:50 -0700
Message-ID: <20081107145549.GG15439@parisc-linux.org>
References: <4913028B.6010405@redhat.com> <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <49143142.4010809@redhat.com> <20081107121934.GP21867@kernel.dk> <49145029.4040900@redhat.com> <20081107144311.GE9543@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:44086 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbYKGOzv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2008 09:55:51 -0500
Content-Disposition: inline
In-Reply-To: <20081107144311.GE9543@mit.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Chris Mason <chris.mason@oracle.com>, Dave Chinner <david@fromorbit.com>, David

On Fri, Nov 07, 2008 at 09:43:11AM -0500, Theodore Tso wrote:
> The one thing we might need for SSD-friendly allocation policies is to
> tell the allocators to not try so hard to make sure allocations are
> contiguous, but there are other reasons why you want contiguous
> extents anyway (such as reducing the size of your extent tree and
> reducing the number of block allocation data structures that need to
> be updated).  And, I think to some extent SSD's do care to some level
> about contiguous extents, from the point of view of reducing scatter
> gather operations if nothing else, right?

It's not so much s-g operations as it is that you can only have 32
commands outstanding with the drive at any given time.  Each read/write
command can specify only one extent.  So if you can ask for one 256k
extent rather than have to ask for a 4k extent 64 times, you're going
to get your data faster.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
