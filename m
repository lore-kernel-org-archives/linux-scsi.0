From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 27/32] scsi_data_buffer
Date: Thu, 18 Oct 2007 10:16:38 +0200
Message-ID: <47171666.7080705@panasas.com>
References: <47164306.6090702@panasas.com> <4716529B.7020107@panasas.com> <20071018004722.GA14883@parisc-linux.org> <4717046E.9040101@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:10535 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752615AbXJRIRQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Oct 2007 04:17:16 -0400
In-Reply-To: <4717046E.9040101@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benny Halevy <bhalevy@panasas.com>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, Alan Stern <stern@rowland.harvard.edu>, "David S. Miller" <davem@davemloft.net>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Pete Wyckoff <pw@osc.edu>

On Thu, Oct 18 2007 at 8:59 +0200, Benny Halevy <bhalevy@panasas.com> wrote:
>>
>> Updated patch below.  I'm fully expecting the 'result' shenanigan to get
>> it NACKed, but I'd like to see if it inspires anyone else to a more
>> creative way of saving this space.
> 
> 
> yeah. The sglist pointer shuffle makes sense and so are the field type
> changes and coalescing, but the union holding the deprecated fields
> of scsi_data_buff is going away.
> 
> #pragma pack(4) before struct scsi_cmnd
> (followed by #pragma pack()) should do the trick 
> by saving member padding bytes. As a general rule I don't like pragma's
> but this one works, is easy to understand, and is pretty standard.
> 
>> ---
>>

Sorry Matthew, my mistake I forgot to send the last [33/33] patch
this here should be done on top of that last one.

I will grab your tool and play with it. The sglist pointer shuffle
is good, and also I know that if you put the scsi_data_buffer
at the beginning of scsi_cmnd, than you can fill the holes with small types
following the sub-structure. I'll give it a try.

Boaz
