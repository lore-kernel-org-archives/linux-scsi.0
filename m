From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] FC pass thru - Rev V
Date: Sat, 7 Mar 2009 09:44:57 -0500
Message-ID: <49B28869.6090507@emulex.com>
References: <1227043498.4949.21.camel@ogier> <1234365225.24194.3.camel@ogier> <968C4C03B4940B48A4A8B1EA417CD6D82D2639A19E@AVEXMB2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50388 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbZCGOpN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Mar 2009 09:45:13 -0500
In-Reply-To: <968C4C03B4940B48A4A8B1EA417CD6D82D2639A19E@AVEXMB2.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: "futjita.tomonori@lab.ntt.co.jp" <futjita.tomonori@lab.ntt.co.jp>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "sven@linux.vnet.ibm.com" <sven@linux.vnet.ibm.com>, "bharrosh@panasas.com" <bharrosh@panasas.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Smart, James" <James.Smart@Emulex.Com>



Seokmann Ju wrote:
>> From: James Smart [mailto:James.Smart@Emulex.Com]
>> Sent: Wednesday, February 11, 2009 7:14 AM
>>
>> Trying to kick-start this again...
>> I've updated the prior RFC with the comments from Seokmann,
>> SvenFujita, and Boaz. I would still like review on the
>> blk_xxx completion calls in the std and error paths.
> <snip>
>> +static int
>> +fc_bsg_map_buffer(struct fc_bsg_buffer *buf, struct request *req)
>> +{
>> +	size_t sz = (sizeof(struct scatterlist) * req->nr_phys_segments);
>> +
>> +	BUG_ON(!req->nr_phys_segments);
>> +
>> +	buf->sg_list = kzalloc(sz, GFP_KERNEL);
>> +	if (!buf->sg_list)
>> +		return -ENOMEM;
>> +	sg_init_table(buf->sg_list, req->nr_phys_segments);
>> +	buf->sg_cnt = blk_rq_map_sg(req->q, req, buf->sg_list);
>> +	buf->payload_len = req->data_len;
>> +	return 0;
>> +}
> It looks like that there is possibility that the dma buffer with more
> than one sg element for ELS services - which is not allowed per FC spec.

How can the T11 FC spec ever reference anything about sg elements ? They 
are completely independent.

> I've seen a couple of times from the driver testing.
> I'm looking for some ways to making sure the ELS services
> to get single sg for both request/reply_payload.
> Any comments/suggestion?

For ELS's, the payload should be small - usually <= 256bytes so it fits 
within default login parameters. It should be 1 buffer, thus 1 sge. 
(Note: the routine above is for any request, which covers more than just 
ELS's).

If you're getting multiple sg's, then either the buffer spans some 
condition that crosses a boundary that blk_rq_map_sg() enforces (like a 
4G boundary, but I doubt that's it), or - and more likely - your 
application has a buffer that spans 2 pages which look contiguous to the 
app, but are actually virtual-memory mapped to 2 independent physical 
pages (thus the need for 2 sg's).  If your app knows the system page 
size, and was careful about buffer placement and length within page 
boundaries, it likely would never encounter this.  But, we would never 
want to force apps to be this smart, and this would be a good 
justification for supporting more than 1 sg.

-- james s


