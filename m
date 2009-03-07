From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: RE: [RFC] FC pass thru - Rev V
Date: Sat, 7 Mar 2009 04:17:40 -0800
Message-ID: <968C4C03B4940B48A4A8B1EA417CD6D82D2639A19E@AVEXMB2.qlogic.org>
References: <1227043498.4949.21.camel@ogier> <1234365225.24194.3.camel@ogier>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:35771 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbZCGMRp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Mar 2009 07:17:45 -0500
In-Reply-To: <1234365225.24194.3.camel@ogier>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Smart@Emulex.Com" <James.Smart@Emulex.Com>, "futjita.tomonori@lab.ntt.co.jp" <futjita.tomonori@lab.ntt.co.jp>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, "sven@linux.vnet.ibm.com" <sven@linux.vnet.ibm.com>, "bharrosh@panasas.com" <bharrosh@panasas.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> From: James Smart [mailto:James.Smart@Emulex.Com]
> Sent: Wednesday, February 11, 2009 7:14 AM
> 
> Trying to kick-start this again...
> I've updated the prior RFC with the comments from Seokmann,
> SvenFujita, and Boaz. I would still like review on the
> blk_xxx completion calls in the std and error paths.
<snip>
> +static int
> +fc_bsg_map_buffer(struct fc_bsg_buffer *buf, struct request *req)
> +{
> +	size_t sz = (sizeof(struct scatterlist) * req->nr_phys_segments);
> +
> +	BUG_ON(!req->nr_phys_segments);
> +
> +	buf->sg_list = kzalloc(sz, GFP_KERNEL);
> +	if (!buf->sg_list)
> +		return -ENOMEM;
> +	sg_init_table(buf->sg_list, req->nr_phys_segments);
> +	buf->sg_cnt = blk_rq_map_sg(req->q, req, buf->sg_list);
> +	buf->payload_len = req->data_len;
> +	return 0;
> +}
It looks like that there is possibility that the dma buffer with more
than one sg element for ELS services - which is not allowed per FC spec.
I've seen a couple of times from the driver testing.
I'm looking for some ways to making sure the ELS services
to get single sg for both request/reply_payload.
Any comments/suggestion?

Thank you,
Seokmann
