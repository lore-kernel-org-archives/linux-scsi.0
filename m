From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] Fix for aacraid and high memory on 2.6.1
Date: 14 Jan 2004 16:17:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074115078.2054.166.camel@mulgrave>
References: <1074113037.7662.45.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:47750 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264163AbUANVSC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2004 16:18:02 -0500
In-Reply-To: <1074113037.7662.45.camel@markh1.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Wed, 2004-01-14 at 15:43, Mark Haverkamp wrote:
> +	if (aac_drivers[index].quirks & AAC_QUIRK_31BIT) {
> +		if (pci_set_dma_mask(pdev, 0x7FFFFFFFULL))
[...]
> +	/*
> +	 * If we had set a smaller DMA mask earlier, set it to 4gig
> +	 * now since the adapter can dma data to at least a 4gig
> +	 * address space.
> +	 */
> +	if (aac_drivers[index].quirks & AAC_QUIRK_31BIT)
> +		if (pci_set_dma_mask(pdev, 0xFFFFFFFFULL))
> +			goto out_free_fibs;

Rather than doing this, could you just do a 

pci_set_consistent_dma_mask()?

Unfortunately, it's currently not correctly implemented for this case on
x86 (and you don't seem to be able to do what you want on many non-x86
archs), but I think we can get the implementation fixed.

James


