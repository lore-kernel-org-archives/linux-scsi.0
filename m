From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: Possible bug in scsi_lib.c:scsi_req_map_sg()
Date: Wed, 29 Nov 2006 11:30:20 +0200
Message-ID: <456D532C.6040008@panasas.com>
References: <456B2416.7000101@panasas.com> <456B38E9.6060209@cs.wisc.edu> <456B3C1F.4050907@cs.wisc.edu> <20061128185708.GE5400@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:25318 "EHLO
	cassoulet.panasas.com") by vger.kernel.org with ESMTP
	id S966606AbWK2JbC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Nov 2006 04:31:02 -0500
In-Reply-To: <20061128185708.GE5400@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>

Jens Axboe wrote:
> On Mon, Nov 27 2006, Mike Christie wrote:
>> Mike Christie wrote:
>>> Boaz Harrosh wrote:
>>>> Playing with some tests which I admit are not 100% orthodox I have
>>>> stumbled upon a bug that raises a serious question:
>>>>
>>>> In the call to scsi_execute_async() in the use_sg case, must the
>>>> scatterlist* (pointed to by buffer) map a buffer that's contiguous in
>>>> virtual memory or is it allowed to map disjoint segments of memory?
>>> I thought they were continguous. I think James has said before that they
>>> can be disjoint. When we converted sg it did not look like sg or st
>>> supported disjoint. The main non dio path used a buffer from
>>> get_free_pages so I thought that would always be contiguous. The dio
>>> path then always set the first sg offset, but the rest it set to zero.
>> And the len is set to page size for the middle entries too.
>>
>> But for the non DIO st path we can end up with some middle sg entires
>> that are not a full page so that code in scsi_execute_async is broken
>> for that.
> 
> If something doesn't work with non-contig sg entries, that would be a
> bug. If the question is regarding holes in the sg list, that is probably
> unchartered territory and I would not regard that as supported.
> 

Jens, I'm not sure I understand the terms you used.  Can you please
define more clearly what you mean by "non-contig sg entries" vs.
"holes in the sg list"?

