Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 134DBC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 14:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7C1364E58
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 14:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbhBWObq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 09:31:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38621 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232953AbhBWObl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Feb 2021 09:31:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614090613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9pO3T2cbJS4Rpm9OV6tjMBa2+TGmBBvLNzgN1PnGQzE=;
        b=dknCD5kaw2OfL2ObXrUx9lWlqiw/6RiWz4kD4qaDYwugufa6eKRijuFmRMgP0IaXwNQvN9
        x6eKxNtukR20UpXNNTmFLOvC5jG+4AWrsTWR+JKh2I7a/KpzcoE0UDK5E8cnW7J5G6ZVpn
        n0HwecVGoYxUWn/V6lPCXDd6GpXqcM4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-r-VeFg3EPt2SSeiUQFdn5g-1; Tue, 23 Feb 2021 09:30:11 -0500
X-MC-Unique: r-VeFg3EPt2SSeiUQFdn5g-1
Received: by mail-ed1-f71.google.com with SMTP id t9so8715589edd.3
        for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2021 06:30:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9pO3T2cbJS4Rpm9OV6tjMBa2+TGmBBvLNzgN1PnGQzE=;
        b=Nj/pDwczLEs51dEAAPj2bYyRP2lkjLvn+srMCgv6Ya8HaBYgKozlr7O39tOsak19DN
         cKqaKePL2+6AxpYUWxUg8Vu1ZggVHiWoJZh60FbnusWUbB0tQ7CNTJR/F91hBfpCpFmq
         bURpcD8xx/GEYQYDYDAoH5yJ89HPoj566TY9meyxfxZ41fzFeO43VSsWHmPwBcYCyYuo
         Ki4CBMiBTN5eDT5THP+LgOD24Coy4wq7HjEKHWLVtOX8t6r9EEweGWX9zth2/edpjkkD
         Bmz7HTVUFRV9IYbsPcTknFBXROg3DVp6hXWFI0sSE7deOdVZ+l0t5mptE5NeJVt75mgD
         xSVQ==
X-Gm-Message-State: AOAM530yIvDILWf17UTipVuXn9Df1fNgfaBQyFaG4hm3P413zJXcTHmO
        pomAVTJa9mBbqPG/FFyJtCVbwe4lVaxtzXgzbE+VHXbmDRk+yo1eAtQk3gNFazlZkaL6IlixYWY
        Zig4KdQdG8CYcK3H+C5/B6FkveMR2O+D4aBGWYT/a4cgyKwpNDqtf25wbAnJtvhKyQv5D/VpYBA
        ==
X-Received: by 2002:a17:906:3881:: with SMTP id q1mr26294955ejd.490.1614090609628;
        Tue, 23 Feb 2021 06:30:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxg5crHmlZHVNk8852FVic9/mZuxxr1Qu26zSap68yY9I5Spp0olcTGMtoK8GqInkBcdxFo7w==
X-Received: by 2002:a17:906:3881:: with SMTP id q1mr26294590ejd.490.1614090607121;
        Tue, 23 Feb 2021 06:30:07 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id x21sm6136096eds.9.2021.02.23.06.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 06:30:06 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     kys@microsoft.com, martin.petersen@oracle.com,
        longli@microsoft.com, wei.liu@kernel.org, jejb@linux.ibm.com,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] scsi: storvsc: Enable scatterlist entry lengths >
 4Kbytes
In-Reply-To: <1613682087-102535-1-git-send-email-mikelley@microsoft.com>
References: <1613682087-102535-1-git-send-email-mikelley@microsoft.com>
Date:   Tue, 23 Feb 2021 15:30:05 +0100
Message-ID: <874ki2yhzm.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Michael Kelley <mikelley@microsoft.com> writes:

> storvsc currently sets .dma_boundary to limit scatterlist entries
> to 4 Kbytes, which is less efficient with huge pages that offer
> large chunks of contiguous physical memory. Improve the algorithm
> for creating the Hyper-V guest physical address PFN array so
> that scatterlist entries with lengths > 4Kbytes are handled.
> As a result, remove the .dma_boundary setting.
>
> The improved algorithm also adds support for scatterlist
> entries with offsets >= 4Kbytes, which is supported by many
> other SCSI low-level drivers.  And it retains support for
> architectures where possibly PAGE_SIZE != HV_HYP_PAGE_SIZE
> (such as ARM64).
>
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c | 63 ++++++++++++++++------------------------------
>  1 file changed, 22 insertions(+), 41 deletions(-)
>
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 2e4fa77..5d06061 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1678,9 +1678,8 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
>  	struct storvsc_cmd_request *cmd_request = scsi_cmd_priv(scmnd);
>  	int i;
>  	struct scatterlist *sgl;
> -	unsigned int sg_count = 0;
> +	unsigned int sg_count;
>  	struct vmscsi_request *vm_srb;
> -	struct scatterlist *cur_sgl;
>  	struct vmbus_packet_mpb_array  *payload;
>  	u32 payload_sz;
>  	u32 length;
> @@ -1759,7 +1758,7 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
>  	payload_sz = sizeof(cmd_request->mpb);
>  
>  	if (sg_count) {
> -		unsigned int hvpgoff = 0;
> +		unsigned int hvpgoff, sgl_size;
>  		unsigned long offset_in_hvpg = sgl->offset & ~HV_HYP_PAGE_MASK;
>  		unsigned int hvpg_count = HVPFN_UP(offset_in_hvpg + length);
>  		u64 hvpfn;
> @@ -1773,51 +1772,35 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
>  				return SCSI_MLQUEUE_DEVICE_BUSY;
>  		}
>  
> -		/*
> -		 * sgl is a list of PAGEs, and payload->range.pfn_array
> -		 * expects the page number in the unit of HV_HYP_PAGE_SIZE (the
> -		 * page size that Hyper-V uses, so here we need to divide PAGEs
> -		 * into HV_HYP_PAGE in case that PAGE_SIZE > HV_HYP_PAGE_SIZE.
> -		 * Besides, payload->range.offset should be the offset in one
> -		 * HV_HYP_PAGE.
> -		 */
>  		payload->range.len = length;
>  		payload->range.offset = offset_in_hvpg;
> -		hvpgoff = sgl->offset >> HV_HYP_PAGE_SHIFT;
>  
> -		cur_sgl = sgl;
> -		for (i = 0; i < hvpg_count; i++) {
> +
> +		for (i = 0; sgl != NULL; sgl = sg_next(sgl)) {
>  			/*
> -			 * 'i' is the index of hv pages in the payload and
> -			 * 'hvpgoff' is the offset (in hv pages) of the first
> -			 * hv page in the the first page. The relationship
> -			 * between the sum of 'i' and 'hvpgoff' and the offset
> -			 * (in hv pages) in a payload page ('hvpgoff_in_page')
> -			 * is as follow:
> -			 *
> -			 * |------------------ PAGE -------------------|
> -			 * |   NR_HV_HYP_PAGES_IN_PAGE hvpgs in total  |
> -			 * |hvpg|hvpg| ...              |hvpg|... |hvpg|
> -			 * ^         ^                                 ^                 ^
> -			 * +-hvpgoff-+                                 +-hvpgoff_in_page-+
> -			 *           ^                                                   |
> -			 *           +--------------------- i ---------------------------+
> +			 * Init values for the current sgl entry. sgl_size
> +			 * and hvpgoff are in units of Hyper-V size pages.
> +			 * Handling the PAGE_SIZE != HV_HYP_PAGE_SIZE case
> +			 * also handles values of sgl->offset that are
> +			 * larger than PAGE_SIZE. Such offsets are handled
> +			 * even on other than the first sgl entry, provided
> +			 * they are a multiple of PAGE_SIZE.
>  			 */
> -			unsigned int hvpgoff_in_page =
> -				(i + hvpgoff) % NR_HV_HYP_PAGES_IN_PAGE;
> +			sgl_size = HVPFN_UP(sgl->offset + sgl->length);
> +			hvpgoff = sgl->offset >> HV_HYP_PAGE_SHIFT;
> +			hvpfn = page_to_hvpfn(sg_page(sgl));
>  
>  			/*
> -			 * Two cases that we need to fetch a page:
> -			 * 1) i == 0, the first step or
> -			 * 2) hvpgoff_in_page == 0, when we reach the boundary
> -			 *    of a page.
> +			 * Fill the next portion of the PFN array with
> +			 * sequential Hyper-V PFNs for the continguous physical
> +			 * memory described by the sgl entry. The end of the
> +			 * last sgl should be reached at the same time that
> +			 * the PFN array is filled.
>  			 */
> -			if (hvpgoff_in_page == 0 || i == 0) {
> -				hvpfn = page_to_hvpfn(sg_page(cur_sgl));
> -				cur_sgl = sg_next(cur_sgl);
> +			while (hvpgoff != sgl_size) {
> +				payload->range.pfn_array[i++] =
> +							hvpfn + hvpgoff++;
>  			}

Minor nitpicking: while this seems to be correct I, personally, find it
a bit hard to read: 'hvpgoff' stands for "'sgl->offset' measured in
Hyper-V pages' but we immediately re-use it as a cycle counter.

If I'm not mistaken, we can count right away how many entries we're
going to add. Also, we could've introduced HVPFN_DOWN() to complement
HVPFN_UP():
...
#define HVPFN_DOWN(x)	((x) >> HV_HYP_PAGE_SHIFT)
...

hvpgoff = HVPFN_DOWN(sgl->offset);
hvpfn = page_to_hvpfn(sg_page(sgl)) + hvpgoff;
hvpfns_to_add = HVPFN_UP(sgl->offset + sgl->length) - hvpgoff;

and the cycle can look like:

while (hvpfns_to_add) {
	payload->range.pfn_array[i++] = hvpfn++;
	hvpfns_to_add--;
}

> -
> -			payload->range.pfn_array[i] = hvpfn + hvpgoff_in_page;
>  		}

and then we can also make an explicit 

BUG_ON(i != hvpg_count) after the cycle to prove our math is correct :-)

>  	}
>  
> @@ -1851,8 +1834,6 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
>  	.slave_configure =	storvsc_device_configure,
>  	.cmd_per_lun =		2048,
>  	.this_id =		-1,
> -	/* Make sure we dont get a sg segment crosses a page boundary */
> -	.dma_boundary =		PAGE_SIZE-1,
>  	/* Ensure there are no gaps in presented sgls */
>  	.virt_boundary_mask =	PAGE_SIZE-1,
>  	.no_write_same =	1,

-- 
Vitaly

