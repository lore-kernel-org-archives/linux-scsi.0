From: "Grant Grundler" <grundler@google.com>
Subject: Re: Scatter-gather segment merges by IOMMU?
Date: Fri, 8 Aug 2008 13:25:59 -0700
Message-ID: <da824cf30808081325n416ec436y94eebe494d789207@mail.gmail.com>
References: <489CA21F.1030604@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:4365 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760156AbYHHU0F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2008 16:26:05 -0400
Received: from spaceape13.eur.corp.google.com (spaceape13.eur.corp.google.com [172.28.16.147])
	by smtp-out.google.com with ESMTP id m78KQ1x1007770
	for <linux-scsi@vger.kernel.org>; Fri, 8 Aug 2008 21:26:01 +0100
Received: from rv-out-0506.google.com (rvbg37.prod.google.com [10.140.83.37])
	by spaceape13.eur.corp.google.com with ESMTP id m78KQ0hN011180
	for <linux-scsi@vger.kernel.org>; Fri, 8 Aug 2008 13:26:00 -0700
Received: by rv-out-0506.google.com with SMTP id g37so1166055rvb.23
        for <linux-scsi@vger.kernel.org>; Fri, 08 Aug 2008 13:25:59 -0700 (PDT)
In-Reply-To: <489CA21F.1030604@s5r6.in-berlin.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Aug 8, 2008 at 12:44 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Hi all,
>
> the block layer usually tries to merge s/g segments if consecutive segments
> combined fit into the queue's max_segment_size.  When such a scatter gather
> list is DMA-mapped, can it happen that an IOMMU collapses the elements even
> further, so that sg_dma_len() of a DMA-mapped s/g segment exceeds
> max_segment_size?

I don't see how. The IOMMU code only collapses the "physical" mappings and
does not add new elements to the SG list. ergo sg_dma_len() shouldn't change.

grant

>
> As I understood some discussions in the past, this could indeed happen,
> which is a nuisance.  But I may have misunderstood something, or something
> may have changed in the meantime...
> --
> Stefan Richter
> -=====-==--- =--- -=---
> http://arcgraph.de/sr/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
