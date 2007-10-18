From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 27/32] scsi_data_buffer
Date: Thu, 18 Oct 2007 10:26:58 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0710181024560.4335-100000@iolanthe.rowland.org>
References: <20071018085400.GB9883@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:58182 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757435AbXJRO1A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Oct 2007 10:27:00 -0400
In-Reply-To: <20071018085400.GB9883@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Pete Wyckoff <pw@osc.edu>

On Thu, 18 Oct 2007, Matthew Wilcox wrote:

> > I will grab your tool and play with it. The sglist pointer shuffle
> > is good, and also I know that if you put the scsi_data_buffer
> > at the beginning of scsi_cmnd, than you can fill the holes with small types
> > following the sub-structure. I'll give it a try.
> 
> No, that doesn't work ;-(
> 
> I think a macro to hide the ugliness of my earlier suggestion might fly.
> Something like ...
> 
> #define STRUCT_PACK(a, b, c, d) \
> 	union { a; struct { \
> 		char _packed_ ## __stringify(a) [sizeof(a) - sizeof(c) + sizeof(d)]; \
> 		b; \
> 	}; }
> 
> then we use it like:
> 
> struct scsi_cmnd {
> 	...
> 	STRUCT_PACK(struct scsi_data_buffer sdb, int result,
> 						sizeof(long), sizeof(int));
> }
> 
> Even that's still pretty foul (and i have my grave doubts about using
> stringify in that manner).  It's definitely past my bedtime now ... but
> a hack like that could save us another 8 bytes on x86-64.

This may seem heretical, but I doubt there's much point to saving a few 
bytes if it's going to incur this much work and confusion.  Rearranging 
the order of structure members is fine, it's easy, it won't bother 
anybody.  But this sort of thing is just beyond the bounds of reason.

Alan Stern

