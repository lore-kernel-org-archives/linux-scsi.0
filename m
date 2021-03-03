Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9178C2BA57
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CDBD64EE7
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447100AbhCCMrk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 07:47:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42517 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1444283AbhCCMP2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 07:15:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614773641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kUoH8Vyn/B9sleJnzpy65y0LAnQtC6/RFAeTcmxlxsw=;
        b=CqmxghloPlivpFlx/h+MIgNhnzTlxc9H4n49cY5DMTIpdsGlwdXyelG0dRnCyMv1M8skVP
        Z9mRv6sR+eIHrap1TAT+QR6fitRXUPzGxvySQDw8cXhgMXeFOA9ssiP0HYyV84+qDd4mYL
        H7arPI91t0iUJPYAjQ2WivZmP1TPX1I=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-NqkKJvZ6NJCjHgtsS5BoQA-1; Wed, 03 Mar 2021 04:08:35 -0500
X-MC-Unique: NqkKJvZ6NJCjHgtsS5BoQA-1
Received: by mail-ed1-f72.google.com with SMTP id h5so1995166edf.17
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 01:08:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=kUoH8Vyn/B9sleJnzpy65y0LAnQtC6/RFAeTcmxlxsw=;
        b=MDzXBBu9q+v7khdUE2oR8Xu5psO+QA0XSDewYDsB4DyFyF1esIoUDsj2ExKqvG0rd5
         zRLAmjDTPBsAODMFjEQCyAIZgT72t6zNgp0Zhf3NMWQU0C5cJqJfar6w1blAMRzsOyB0
         e1m6W0iQ/UnPUCD096tZ8EwUaBWbBZkP0zSofeMOtC9EFd38JK6XSzqaJwZi7CjSr7Id
         AtYi/BW6HI+CPvouXKhIJ10gRXOtxZbnRBxHFDbKdvJGIrjxTpmVcUcaYKE/n8UoGkf5
         7eKxgy//1r4zIV1w1htybUPk3kaJ0Lhn/CrXGz4zWs4aWh9y+ysaeS6vMPixhYCGtfAg
         rvrw==
X-Gm-Message-State: AOAM533U2pXxex22GZgKUhLgnIVDXXvscKrv9okNq/COqXakRnaPVVgG
        ATwUM9OkcL3LHKAlTu/bXE31aGpGyQkB/RNjGY1ZUyuNH6hUwKA8/fhZb94MKh6UVtrYCUrQfVL
        iPlQ8k9kBibSPWxB1bNPxZzUlYxjlu6AwpyLn8PM9AEpXZbV9v1SX+m08Pn3uGQJy6kjcw0PvfQ
        ==
X-Received: by 2002:a17:907:1b1c:: with SMTP id mp28mr21956413ejc.243.1614762513762;
        Wed, 03 Mar 2021 01:08:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzPRNyHGfOzCGecv1dJXu51I4Fb07WNs03fEQ81eIx+y8OXe5aoHUBPL/wnYdvm/NHmI8Q0kg==
X-Received: by 2002:a17:907:1b1c:: with SMTP id mp28mr21956387ejc.243.1614762513495;
        Wed, 03 Mar 2021 01:08:33 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id bv9sm15083248ejb.21.2021.03.03.01.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 01:08:33 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     kys@microsoft.com, martin.petersen@oracle.com,
        longli@microsoft.com, wei.liu@kernel.org, jejb@linux.ibm.com,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 1/1] scsi: storvsc: Enable scatterlist entry lengths
 > 4Kbytes
In-Reply-To: <1614120294-1930-1-git-send-email-mikelley@microsoft.com>
References: <1614120294-1930-1-git-send-email-mikelley@microsoft.com>
Date:   Wed, 03 Mar 2021 10:08:32 +0100
Message-ID: <87mtvkeh9r.fsf@vitty.brq.redhat.com>
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
>
> Changes in v2:
> * Add HVPFN_DOWN() macro and use it instead of open coding
>   [Vitaly Kuznetsov]
> * Change loop that fills pfn array and its initialization
>   [Vitaly Kuznetsov]
> * Use offset_in_hvpage() instead of open coding
>
>
>  drivers/scsi/storvsc_drv.c | 66 ++++++++++++++++------------------------------
>  include/linux/hyperv.h     |  1 +
>  2 files changed, 24 insertions(+), 43 deletions(-)
>
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 2e4fa77..5ba3145 100644
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
> @@ -1759,8 +1758,8 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
>  	payload_sz = sizeof(cmd_request->mpb);
>  
>  	if (sg_count) {
> -		unsigned int hvpgoff = 0;
> -		unsigned long offset_in_hvpg = sgl->offset & ~HV_HYP_PAGE_MASK;
> +		unsigned int hvpgoff, hvpfns_to_add;
> +		unsigned long offset_in_hvpg = offset_in_hvpage(sgl->offset);
>  		unsigned int hvpg_count = HVPFN_UP(offset_in_hvpg + length);
>  		u64 hvpfn;
>  
> @@ -1773,51 +1772,34 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
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
> +			 * Init values for the current sgl entry. hvpgoff
> +			 * and hvpfns_to_add are in units of Hyper-V size
> +			 * pages. Handling the PAGE_SIZE != HV_HYP_PAGE_SIZE
> +			 * case also handles values of sgl->offset that are
> +			 * larger than PAGE_SIZE. Such offsets are handled
> +			 * even on other than the first sgl entry, provided
> +			 * they are a multiple of PAGE_SIZE.
>  			 */
> -			unsigned int hvpgoff_in_page =
> -				(i + hvpgoff) % NR_HV_HYP_PAGES_IN_PAGE;
> +			hvpgoff = HVPFN_DOWN(sgl->offset);
> +			hvpfn = page_to_hvpfn(sg_page(sgl)) + hvpgoff;
> +			hvpfns_to_add =	HVPFN_UP(sgl->offset + sgl->length) -
> +						hvpgoff;
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
> -			}
> -
> -			payload->range.pfn_array[i] = hvpfn + hvpgoff_in_page;
> +			while (hvpfns_to_add--)
> +				payload->range.pfn_array[i++] =	hvpfn++;
>  		}
>  	}
>  
> @@ -1851,8 +1833,6 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
>  	.slave_configure =	storvsc_device_configure,
>  	.cmd_per_lun =		2048,
>  	.this_id =		-1,
> -	/* Make sure we dont get a sg segment crosses a page boundary */
> -	.dma_boundary =		PAGE_SIZE-1,
>  	/* Ensure there are no gaps in presented sgls */
>  	.virt_boundary_mask =	PAGE_SIZE-1,
>  	.no_write_same =	1,
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 5ddb479..a1eed76 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -1717,6 +1717,7 @@ static inline unsigned long virt_to_hvpfn(void *addr)
>  #define NR_HV_HYP_PAGES_IN_PAGE	(PAGE_SIZE / HV_HYP_PAGE_SIZE)
>  #define offset_in_hvpage(ptr)	((unsigned long)(ptr) & ~HV_HYP_PAGE_MASK)
>  #define HVPFN_UP(x)	(((x) + HV_HYP_PAGE_SIZE-1) >> HV_HYP_PAGE_SHIFT)
> +#define HVPFN_DOWN(x)	((x) >> HV_HYP_PAGE_SHIFT)
>  #define page_to_hvpfn(page)	(page_to_pfn(page) * NR_HV_HYP_PAGES_IN_PAGE)
>  
>  #endif /* _HYPERV_H */

Thank you for implementing my suggestion in v2,

Reviewed-by:  Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

