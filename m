From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Possible bug in scsi_lib.c:scsi_req_map_sg()
Date: Tue, 28 Nov 2006 11:30:39 -0600
Message-ID: <456C723F.1040903@cs.wisc.edu>
References: <456B2416.7000101@panasas.com> <456B38E9.6060209@cs.wisc.edu> <456C5944.9060509@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37030 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S935922AbWK1Ra4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Nov 2006 12:30:56 -0500
In-Reply-To: <456C5944.9060509@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Benny Halevy <bhalevy@panasas.com>

Boaz Harrosh wrote:
> Mike Christie wrote:
>> Boaz Harrosh wrote:
>>> Playing with some tests which I admit are not 100% orthodox I have
>>> stumbled upon a bug that raises a serious question:
>>>
>>> In the call to scsi_execute_async() in the use_sg case, must the
>>> scatterlist* (pointed to by buffer) map a buffer that's contiguous in
>>> virtual memory or is it allowed to map disjoint segments of memory?
>>
>> I thought they were continguous. I think James has said before that they
>> can be disjoint. When we converted sg it did not look like sg or st
>> supported disjoint. The main non dio path used a buffer from
>> get_free_pages so I thought that would always be contiguous. The dio
>> path then always set the first sg offset, but the rest it set to zero.
>>
>> How did you hit this problem? Is it with sg or st, or with some other
>> code? Is it the mmap path maybe?
> 
> OK I admit, guilty as charged, I was using it from a kernel driver,
> OSD-Initiator from IBM. The code is unorthodox in mapping user space
> iovects into scatterlist*. I will have to work around it than.

Well, you do not have to work around it :)

I want to kill scsi_execute_async and just allow the ULDs to allocate a
request, call blk_rq_map_* (and add any new map helpers we need), then
call blk_execute_rq_nowait. This gives the ULDs some flexibility and
kills my ugly function. This is what I originally did here
http://marc.theaimsgroup.com/?l=linux-scsi&m=112356952007369&w=2

For some reason, I flip flopped and went with scsi_execute_async and the
scatterlist argument hack. I think I did this because I thought it would
be less problems in converting the ULDs in stages. First stage was to
remove scsi_request usage and clean/fix up scsi-ml and LLDs, next would
be to convert to block layer functions directly, but looking back it
might have been better to just go through one big headache.

I think Christoph Hellwig has patches to remove scsi_execute_async as
part of his bidi work. He needs help testing and reviewing them, so you
should help him out instead of working around it :)
