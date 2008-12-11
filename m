From: "Chris Leech" <christopher.leech@intel.com>
Subject: Re: [PATCH 2/3] libfc: A modular Fibre Channel library
Date: Wed, 10 Dec 2008 16:49:53 -0800
Message-ID: <41b516cb0812101649w128cf6a8rd35169f55679ab5b@mail.gmail.com>
References: <20081209231005.17830.92133.stgit@fritz>
	 <20081209231016.17830.87180.stgit@fritz>
	 <20081210000333.GC23556@one.firstfloor.org>
Reply-To: chris.leech@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:29561 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbYLKAty (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2008 19:49:54 -0500
Received: by wf-out-1314.google.com with SMTP id 27so449241wfd.4
        for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2008 16:49:53 -0800 (PST)
In-Reply-To: <20081210000333.GC23556@one.firstfloor.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Robert Love <robert.w.love@intel.com>, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, jgarzik@redhat.com, davem@davemloft.net, james.smart@emulex.com, michaelc@cs.wisc.edu, jeykholt@cisco.com, jeffrey.t.kirsher@intel.com

On Tue, Dec 9, 2008 at 4:03 PM, Andi Kleen <andi@firstfloor.org> wrote:

> Is the put_page() here really correct? The original reference in the skb
> will be still around, won't it?

But you didn't quote the part with the alloc_page call.  Here's the
whole function.

> static int fcoe_get_paged_crc_eof(struct sk_buff *skb, int tlen)
> {
> 	struct fcoe_percpu_s *fps;
> 	struct page *page;
> 	int cpu_idx;
>
> 	cpu_idx = get_cpu();
> 	fps = fcoe_percpu[cpu_idx];
> 	page = fps->crc_eof_page;
> 	if (!page) {
> 		page = alloc_page(GFP_ATOMIC);
> 		if (!page) {
> 			put_cpu();
> 			return -ENOMEM;
> 		}
> 		fps->crc_eof_page = page;
> 		WARN_ON(fps->crc_eof_offset != 0);
> 	}
>
> 	get_page(page);
> 	skb_fill_page_desc(skb, skb_shinfo(skb)->nr_frags, page,
> 			   fps->crc_eof_offset, tlen);
> 	skb->len += tlen;
> 	skb->data_len += tlen;
> 	skb->truesize += tlen;
> 	fps->crc_eof_offset += sizeof(struct fcoe_crc_eof);
>
> 	if (fps->crc_eof_offset >= PAGE_SIZE) {
> 		fps->crc_eof_page = NULL;
> 		fps->crc_eof_offset = 0;
> 		put_page(page);
> 	}
> 	put_cpu();
> 	return 0;
> }

FCoE needs to attach an 8 byte trailer to all FC frames created by
libfc before transmitting.  If the skb is non-linear, say a SCSI write
data frame, the only way to do that is to attach a fragment page to
the skb.

In order to avoid repeated calls to alloc_page when only 8 bytes are
needed, the fcoe module keeps a reference to the page using it
repeatedly until it reaches the end.  Then then call to put_page
happens, and a new page is allocated on the next transmit.  At this
point the page may still have references from any skbs that are still
outstanding (get_page before skb_fill_page_desc).  With 4k pages 512
fragmented frames can be sent before calling alloc_page again.

- Chris
