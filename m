From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 27/32] scsi_data_buffer
Date: Thu, 18 Oct 2007 02:06:41 -0600
Message-ID: <20071018080640.GA9883@parisc-linux.org>
References: <47164306.6090702@panasas.com> <4716529B.7020107@panasas.com> <20071018004722.GA14883@parisc-linux.org> <4717046E.9040101@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:50695 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762222AbXJRIGp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Oct 2007 04:06:45 -0400
Content-Disposition: inline
In-Reply-To: <4717046E.9040101@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benny Halevy <bhalevy@panasas.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, Alan Stern <stern@rowland.harvard.edu>, "David S. Miller" <davem@davemloft.net>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Pete Wyckoff <pw@osc.edu>

On Thu, Oct 18, 2007 at 08:59:58AM +0200, Benny Halevy wrote:
> yeah. The sglist pointer shuffle makes sense and so are the field type
> changes and coalescing, but the union holding the deprecated fields
> of scsi_data_buff is going away.

Indeed.  We could always do ...

	union {
		struct scsi_data_pointer;
		struct {
			char _padding_[sizeof(struct scsi_data_pointer)];
			int result;
		}
	}

But that might set a new record of depths of obfuscation.

> #pragma pack(4) before struct scsi_cmnd
> (followed by #pragma pack()) should do the trick 
> by saving member padding bytes. As a general rule I don't like pragma's
> but this one works, is easy to understand, and is pretty standard.

But it might well have the effect of pessimising accesses to the struct,
and accesses to scsi_cmnd are pretty hot.  I've seen gcc revert to byte
loads and stores to packed structs in the past.  Maybe it's got better
now.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
