From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: thin provisioned LUN support & file system allocation policy
Date: Fri, 7 Nov 2008 08:45:50 -0700
Message-ID: <20081107154550.GH15439__41417.5466904$1226072839$gmane$org@parisc-linux.org>
References: <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <49143142.4010809@redhat.com> <20081107121934.GP21867@kernel.dk> <49145029.4040900@redhat.com> <20081107144311.GE9543@mit.edu> <4914568A.7090307@redhat.com> <49145E0C.4030705@hp.com> <20081107153624.GG9543@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38536 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbYKGPpw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2008 10:45:52 -0500
Content-Disposition: inline
In-Reply-To: <20081107153624.GG9543@mit.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, jim owens <jowens@hp.com>, Ric Wheeler <rwheeler@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Chris Mason <chris.mason@oracle.com>, Dave Chinner <da>

On Fri, Nov 07, 2008 at 10:36:24AM -0500, Theodore Tso wrote:
> The discussion here has been around Intel-style SSD's, which
> apparently have a log-structured filesystem in the device, such that
> wear leveling is done automatically, and in fact it is *better* for
> these devices if we reuse the same block since then the SSD
> automatically knows that contents at the old location is logically
> "gone".  (I don't believe, or at least don't see, why there would be
> any benefit of reusing block ranges versus explicitly using a TRIM
> command to tell the SSD that the old block was no longer being used;
> it should have the same effect as far as the SSD is concerned.)
> 
> The one thing which I am somewhat concerned about is whether all SSD's
> will be doing things the Intel way, or whether other SSD's might not

Given that most of my information about how SSDs work comes from a
presentation given by Samsung at the FS/IO storage workshop, I feel
fairly confident all the manufacturers do something very similar with a
log-structured FS internally.

Of course, this probably doesn't apply to the $5 1Gb USB keys that you
get in the conference schwag, but if we start optimising for those,
we've probably already lost.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
