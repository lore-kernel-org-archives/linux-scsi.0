From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: thin provisioned LUN support & file system allocation policy
Date: Fri, 7 Nov 2008 07:34:26 -0700
Message-ID: <20081107143425.GE15439@parisc-linux.org>
References: <4913028B.6010405@redhat.com> <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <49143142.4010809@redhat.com> <20081107121934.GP21867@kernel.dk> <49145029.4040900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56600 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbYKGOe1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2008 09:34:27 -0500
Content-Disposition: inline
In-Reply-To: <49145029.4040900@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>

On Fri, Nov 07, 2008 at 09:26:49AM -0500, Ric Wheeler wrote:
> One more consideration that I should have mentioned is that we can also 
> make our file system allocation policies "thin provisioned LUN" friendly.
> 
> Basically, we need to try to re-allocate blocks instead of letting the 
> allocations happily progress across the entire block range. This might 
> be the inverse of an SSD friendly allocation policy, but would seem to 
> be fairly trivial to implement :-)

It's the opposite of a _flash_ friendly policy.  But SSDs are not naive
flash implementations -- if you overwrite a block, it'll just write
elsewhere and update its internal mapping of LBAs to sectors.  I
honestly think there's no difference in performance between overwriting
a block and writing elsewhere ... as long as you TRIM the LBAs you're no
longer using, of course ;-)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
