From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Possible bug in scsi_lib.c:scsi_req_map_sg()
Date: Mon, 27 Nov 2006 13:27:27 -0600
Message-ID: <456B3C1F.4050907@cs.wisc.edu>
References: <456B2416.7000101@panasas.com> <456B38E9.6060209@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55200 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1755447AbWK0T1n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Nov 2006 14:27:43 -0500
In-Reply-To: <456B38E9.6060209@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Benny Halevy <bhalevy@panasas.com>

Mike Christie wrote:
> Boaz Harrosh wrote:
>> Playing with some tests which I admit are not 100% orthodox I have
>> stumbled upon a bug that raises a serious question:
>>
>> In the call to scsi_execute_async() in the use_sg case, must the
>> scatterlist* (pointed to by buffer) map a buffer that's contiguous in
>> virtual memory or is it allowed to map disjoint segments of memory?
> 
> I thought they were continguous. I think James has said before that they
> can be disjoint. When we converted sg it did not look like sg or st
> supported disjoint. The main non dio path used a buffer from
> get_free_pages so I thought that would always be contiguous. The dio
> path then always set the first sg offset, but the rest it set to zero.

And the len is set to page size for the middle entries too.

But for the non DIO st path we can end up with some middle sg entires
that are not a full page so that code in scsi_execute_async is broken
for that.
