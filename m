From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCH 27/32] scsi_data_buffer
Date: Thu, 18 Oct 2007 10:31:48 +0200
Message-ID: <471719F4.2020407@panasas.com>
References: <47164306.6090702@panasas.com> <4716529B.7020107@panasas.com> <20071018004722.GA14883@parisc-linux.org> <4717046E.9040101@panasas.com> <20071018080640.GA9883@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:9676 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753112AbXJRIcX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Oct 2007 04:32:23 -0400
In-Reply-To: <20071018080640.GA9883@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, Alan Stern <stern@rowland.harvard.edu>, "David S. Miller" <davem@davemloft.net>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Pete Wyckoff <pw@osc.edu>

On Oct. 18, 2007, 10:06 +0200, Matthew Wilcox <matthew@wil.cx> wrote:
> On Thu, Oct 18, 2007 at 08:59:58AM +0200, Benny Halevy wrote:
>> yeah. The sglist pointer shuffle makes sense and so are the field type
>> changes and coalescing, but the union holding the deprecated fields
>> of scsi_data_buff is going away.
> 
> Indeed.  We could always do ...
> 
> 	union {
> 		struct scsi_data_pointer;
> 		struct {
> 			char _padding_[sizeof(struct scsi_data_pointer)];
> 			int result;
> 		}
> 	}
> 
> But that might set a new record of depths of obfuscation.

agreed :)

> 
>> #pragma pack(4) before struct scsi_cmnd
>> (followed by #pragma pack()) should do the trick 
>> by saving member padding bytes. As a general rule I don't like pragma's
>> but this one works, is easy to understand, and is pretty standard.
> 
> But it might well have the effect of pessimising accesses to the struct,
> and accesses to scsi_cmnd are pretty hot.  I've seen gcc revert to byte
> loads and stores to packed structs in the past.  Maybe it's got better
> now.
> 

that's why I suggested pack(4) and not pack(1), assuming 4-byte alignment
is still as efficient as 8-byte alignment on most common 64 bit architectures.
