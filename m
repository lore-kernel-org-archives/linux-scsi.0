From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] SG: cap reserved_size values at max_sectors
Date: Tue, 20 Feb 2007 13:31:51 -0600
Message-ID: <45DB4CA7.5090007@cs.wisc.edu>
References: <Pine.LNX.4.44L0.0702201310340.8957-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55082 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932982AbXBTTcX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Feb 2007 14:32:23 -0500
In-Reply-To: <Pine.LNX.4.44L0.0702201310340.8957-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@SteelEye.com>, Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, Jens Axboe <jens.axboe@oracle.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> On Tue, 20 Feb 2007, Mike Christie wrote:
> 
>> I think you actually want max_hw_sectors. Well, you might and you might
>> not :)
> 
> I think we do not.  We don't care about the maximum transfer length the
> driver can theoretically support; we care about the maximum transfer
> length the system will allow.  For example, if max_sectors is 240 and
> max_hw_sectors is 512 then the system will reject a attempted transfer of
> 300 sectors, even though the hardware is capable of carrying it out.

The sg/REQ_TYPE_BLOCK_PC code (really the scatterlist and request
building code) checks max_hw_sectors so it will allow what the
driver/hardware can support for that value. You are correct for normal
fs io though.

> 
>> I think a estimate of the max transfer length would be more like:
>>
>> unsigned int max_segment_size, max_xfer,
>> int max_segments;
>>
>> /*
>>  * does not account for any weird arch segments boundary limits
>>  * or vmerge limits
>>  */
>> if (!(q->queue_flags & (1 << QUEUE_FLAG_CLUSTER)))
>> 	max_segment_size = PAGE_SIZE;
>> else
>> 	max_segment_size = q->max_segment_size;
>>
>> max_segments = min(q->max_hw_segments, q->max_phys_segments);
>>
>> max_xfer = min(q->max_hw_sectors * 512,
>> 		max_segments * max_segment_size);
> 
> Isn't it possible that this multiplication might overflow?

I am not posting this as actual patch. I was just posting so you could
see what other values come into play. It is not just max_hw_sectors
which limits the size.

> 
>> return max_xfer;
>>
>>
>> The problem is that we assume we will get nice large segments. When
>> using sg it will try to allocate multiple pages and make large segments.
>> We could hit a bad case where we cannot allocate enough large segments,
>> so a worst case would result in a max_segment_size of PAGE_SIZE:
>>
>> max_segments = min(q->max_hw_segments, q->max_phys_segments);
>>
>> max_xfer = min(q->max_hw_sectors * 512,
>> 		max_segments * PAGE_SIZE);
>>
>> return max_xfer;
> 
> That is a very pessimistic    I don't see any reason for using it, 
> especially since sg sets aside a reserved buffer which guarantees that a 
> certain minimum amount of memory will always be available.

Yeah you are right getting memory is not a problem I replied about that
in the other mail. You do not have to use it, but the min of the
reserved buffer and max_sectors or max_hw_sectors could still be off for
drivers that do not support clustering or if there is a weird arch
segment boundary or limit (maybe the arch segment limits and boundary is
not used much though).

I am working on fix to both the hack and make sure the reserved buffer
is actually a size that the driver can handle. It is those patches that
converts sg to use the scatterlist and request helpers and modify the
sg.c code to allocate the reserved buffer within all the system, driver
and hw limits.

If you are pushing your fixes for the current release, I would say do
not wait for me, but I am also saying max_sectors and the reserved
buffer size is not always a correct estimate for a couple reasons.
