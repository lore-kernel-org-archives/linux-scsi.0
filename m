From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [RFC] FC pass thru - Rev V
Date: Sat, 7 Mar 2009 12:18:50 -0800
Message-ID: <3256D4E4-B8C7-434C-AF07-5A7D73D7832D@qlogic.com>
References: <1227043498.4949.21.camel@ogier> <1234365225.24194.3.camel@ogier> <968C4C03B4940B48A4A8B1EA417CD6D82D2639A19E@AVEXMB2.qlogic.org> <49B28869.6090507@emulex.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:2327 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbZCGUSy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Mar 2009 15:18:54 -0500
In-Reply-To: <49B28869.6090507@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: "futjita.tomonori@lab.ntt.co.jp" <futjita.tomonori@lab.ntt.co.jp>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "sven@linux.vnet.ibm.com" <sven@linux.vnet.ibm.com>, "bharrosh@panasas.com" <bharrosh@panasas.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


On Mar 7, 2009, at 6:44 AM, James Smart wrote:

>
>
> Seokmann Ju wrote:
>>> From: James Smart [mailto:James.Smart@Emulex.Com]
>>> Sent: Wednesday, February 11, 2009 7:14 AM
>>>
>>> Trying to kick-start this again...
>>> I've updated the prior RFC with the comments from Seokmann,
>>> SvenFujita, and Boaz. I would still like review on the
>>> blk_xxx completion calls in the std and error paths.
>> <snip>
>>> +static int
>>> +fc_bsg_map_buffer(struct fc_bsg_buffer *buf, struct request *req)
>>> +{
>>> +	size_t sz = (sizeof(struct scatterlist) * req->nr_phys_segments);
>>> +
>>> +	BUG_ON(!req->nr_phys_segments);
>>> +
>>> +	buf->sg_list = kzalloc(sz, GFP_KERNEL);
>>> +	if (!buf->sg_list)
>>> +		return -ENOMEM;
>>> +	sg_init_table(buf->sg_list, req->nr_phys_segments);
>>> +	buf->sg_cnt = blk_rq_map_sg(req->q, req, buf->sg_list);
>>> +	buf->payload_len = req->data_len;
>>> +	return 0;
>>> +}
>> It looks like that there is possibility that the dma buffer with more
>> than one sg element for ELS services - which is not allowed per FC  
>> spec.
>
> How can the T11 FC spec ever reference anything about sg elements ?  
> They
> are completely independent.
OK. Thanks for the clarification.

>
>
>> I've seen a couple of times from the driver testing.
>> I'm looking for some ways to making sure the ELS services
>> to get single sg for both request/reply_payload.
>> Any comments/suggestion?
>
> For ELS's, the payload should be small - usually <= 256bytes so it  
> fits
> within default login parameters. It should be 1 buffer, thus 1 sge.
> (Note: the routine above is for any request, which covers more than  
> just
> ELS's).
Yes, understood it.

>
>
> If you're getting multiple sg's, then either the buffer spans some
> condition that crosses a boundary that blk_rq_map_sg() enforces  
> (like a
> 4G boundary, but I doubt that's it), or - and more likely - your
> application has a buffer that spans 2 pages which look contiguous to  
> the
> app, but are actually virtual-memory mapped to 2 independent physical
> pages (thus the need for 2 sg's).  If your app knows the system page
> size, and was careful about buffer placement and length within page
> boundaries, it likely would never encounter this.  But, we would never
> want to force apps to be this smart, and this would be a good
> justification for supporting more than 1 sg.
OK. So the whole point that I brought up is implementation specific.
Thank you for the comment.

Seokmann
