From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 27/32] scsi_data_buffer
Date: Thu, 18 Oct 2007 02:54:00 -0600
Message-ID: <20071018085400.GB9883@parisc-linux.org>
References: <47164306.6090702@panasas.com> <4716529B.7020107@panasas.com> <20071018004722.GA14883@parisc-linux.org> <4717046E.9040101@panasas.com> <47171666.7080705@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41127 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861AbXJRIyD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Oct 2007 04:54:03 -0400
Content-Disposition: inline
In-Reply-To: <47171666.7080705@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Benny Halevy <bhalevy@panasas.com>, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, Alan Stern <stern@rowland.harvard.edu>, "David S. Miller" <davem@davemloft.net>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Pete Wyckoff <pw@osc.edu>

On Thu, Oct 18, 2007 at 10:16:38AM +0200, Boaz Harrosh wrote:
> Sorry Matthew, my mistake I forgot to send the last [33/33] patch
> this here should be done on top of that last one.

Yeah.  I'll rebase the series of 4 patches I just sent on top of it when
I wake up in the morning.

> I will grab your tool and play with it. The sglist pointer shuffle
> is good, and also I know that if you put the scsi_data_buffer
> at the beginning of scsi_cmnd, than you can fill the holes with small types
> following the sub-structure. I'll give it a try.

No, that doesn't work ;-(

I think a macro to hide the ugliness of my earlier suggestion might fly.
Something like ...

#define STRUCT_PACK(a, b, c, d) \
	union { a; struct { \
		char _packed_ ## __stringify(a) [sizeof(a) - sizeof(c) + sizeof(d)]; \
		b; \
	}; }

then we use it like:

struct scsi_cmnd {
	...
	STRUCT_PACK(struct scsi_data_buffer sdb, int result,
						sizeof(long), sizeof(int));
}

Even that's still pretty foul (and i have my grave doubts about using
stringify in that manner).  It's definitely past my bedtime now ... but
a hack like that could save us another 8 bytes on x86-64.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
