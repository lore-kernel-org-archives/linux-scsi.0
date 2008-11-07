From: Theodore Tso <tytso@mit.edu>
Subject: Re: thin provisioned LUN support & file system allocation policy
Date: Fri, 7 Nov 2008 09:43:11 -0500
Message-ID: <20081107144311.GE9543@mit.edu>
References: <4913028B.6010405@redhat.com> <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <49143142.4010809@redhat.com> <20081107121934.GP21867@kernel.dk> <49145029.4040900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:43674 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752019AbYKGOnU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2008 09:43:20 -0500
Content-Disposition: inline
In-Reply-To: <49145029.4040900@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Chris Mason <chris.mason@oracle.com>, Dave Chinner <david@fromorbit.com>, David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>

On Fri, Nov 07, 2008 at 09:26:49AM -0500, Ric Wheeler wrote:
>
> One more consideration that I should have mentioned is that we can also  
> make our file system allocation policies "thin provisioned LUN" friendly.
>
> Basically, we need to try to re-allocate blocks instead of letting the  
> allocations happily progress across the entire block range. This might  
> be the inverse of an SSD friendly allocation policy, but would seem to  
> be fairly trivial to implement :-)

I would think that most non log-structured filesystems do this by
default.  

The one thing we might need for SSD-friendly allocation policies is to
tell the allocators to not try so hard to make sure allocations are
contiguous, but there are other reasons why you want contiguous
extents anyway (such as reducing the size of your extent tree and
reducing the number of block allocation data structures that need to
be updated).  And, I think to some extent SSD's do care to some level
about contiguous extents, from the point of view of reducing scatter
gather operations if nothing else, right?

					- Ted
