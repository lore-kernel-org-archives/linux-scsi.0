From: Ewan Milne <emilne@redhat.com>
Subject: Re: kernel BUG at drivers/scsi/scsi_lib.c:1096!
Date: Fri, 20 Nov 2015 09:38:36 -0500
Message-ID: <1448030316.4067.18.camel@localhost.localdomain>
References: <1447838334.1564.2.camel@ellerman.id.au>
	 <1447855399.3974.24.camel@redhat.com>
	 <1447894964.15206.0.camel@ellerman.id.au>
	 <20151119082325.GA11419@infradead.org>  <564DEC41.5010600@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <564DEC41.5010600@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>, Mark Salter <msalter@redhat.com>, "James E. J. Bottomley" <JBottomley@odin.com>, brking <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-11-19 at 16:35 +0100, Hannes Reinecke wrote:
> On 11/19/2015 09:23 AM, Christoph Hellwig wrote:
> > It's pretty much guaranteed a block layer bug, most likely in the
> > merge bios to request infrastucture where we don't obey the merging
> > limits properly.
> > 
> > Does either of you have a known good and first known bad kernel?
> 
> Well, I have been fighting a similar issue for several months now,
> albeit with multipath enabled. Haven't had much progress with this,
> sadly.
> Seeing that this is our distro kernel it might or might not be
> related; however, as the symptoms are identical there still is a
> chance that this is actually a generic block-layer problem.
> 
> Cheers,
> 
> Hannes

We have seen this also.  (e.g.  req->nr_phys_segments was 3, but
blk_rq_map_sg() returned 4.)  I was suspicious of the patch:

bio: modify __bio_add_page() to accept pages that don't start a new segment

But we put some debugging code in and didn't hit it.  We haven't
found the problem yet, either, though.  We're still looking.

As Christoph said, it would seem to be a problem with the block layer
merging.

The API for this seems defective, in that blk_rq_map_sg() should
never be returning a value indicating that it overwrote past the
end of the supplied SG array and depend on the caller to check it.
(We could get data corruption on another I/O if it used adjacent
memory for a different SG list, for example.)

-Ewan
