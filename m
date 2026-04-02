Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE26D386C1C
	for <linux-scsi@vger.kernel.org>; Thu,  2 Apr 2026 23:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775172308; cv=none; b=k71z5e1GMa6F7SmtnPNLSxrb4fZopwpczqpD4rxFyBD0f2ryYpeIsXCgwefgN+awrA3IQr4ER/WlUOPqkf8sO7GwEDJ5rgukzuam0qAOC/kVdAM5kjmtNyMH+R/YClXD/hDFgI2dmitwa8cFqd1DNWrputtM2k1zN9QcVySqjjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775172308; c=relaxed/simple;
	bh=m7Y9x5hmK/1mAYjJkK1dYeKybym7hWpayHvUvPY01bc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zfd+66WkQfimnvRs4EclCNC+spVad+6zrSpRkehirilrSycj8l+XWA4ksGPFkOIOjgO0W+b+/fC4Ueuor4sKfoFe8hv1Xtm+SMJW4eDvQf2PgzqC/3hHool8TfHSpdfsUEepk9BP8MGP4Q+n3gOuE81sgQ+lGt7e5wsUcicyzEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jJ3K7bET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jJ3K7bET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1BDC19424;
	Thu,  2 Apr 2026 23:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775172308;
	bh=m7Y9x5hmK/1mAYjJkK1dYeKybym7hWpayHvUvPY01bc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jJ3K7bETKt8+vVWurtVfd8gbshIbBofM+VTtFSuQ4NldVVCsI69dDCcy2oCNQ8RPt
	 p84zgmYl/h6gDXju81DHZJv9NsNUqGnQ3DMcO75pC6wvaJmnE7r/JZouP913QuEjHR
	 V6Qu7SpT60al34ymsaHjAYbZQ+3x6E9u9j2nN1Slp+9T1uZIxRoKTMqWFtkgLzZcJn
	 cL4bn9f8LZLntHeCuu7TTQwprGW2Ms9h/NFJXMWORXiD48extg/M1DNSlhLqk7eXIx
	 4mdD6pnYKAm3W4dID3Pxo34tIsi9Sa69W09t+P4vU8pEsr0NKC+TaLpPUIQ5zhRMX4
	 THp6IAaRmY0fQ==
Message-ID: <8198c919-1f4d-4d18-925b-f6c0e80d8b3e@kernel.org>
Date: Fri, 3 Apr 2026 08:25:04 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] block: Increase BLK_DEF_MAX_SECTORS_CAP
To: Keith Busch <kbusch@kernel.org>, Friedrich Weber <f.weber@proxmox.com>
Cc: Mira Limbeck <m.limbeck@proxmox.com>, hch@lst.de,
 martin.petersen@oracle.com, Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 Ranjan Kumar <ranjan.kumar@broadcom.com>,
 linux-scsi <linux-scsi@vger.kernel.org>
References: <20250618060045.37593-1-dlemoal@kernel.org>
 <291f78bf-4b4a-40dd-867d-053b36c564b3@proxmox.com>
 <ff5e2877-840b-4eb6-b449-bb64fb2e4097@kernel.org>
 <ac2256a0-25ce-4453-8c47-04cb7716d46a@proxmox.com>
 <7a0cfc66-3131-4b94-87f2-cbb96595ebb6@kernel.org>
 <9bf5286c-bac7-4cb7-9bfe-f47195e18b79@proxmox.com>
 <ac6FVPT3ZCDoVtb7@kbusch-mbp>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ac6FVPT3ZCDoVtb7@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/3/26 00:03, Keith Busch wrote:
> On Thu, Apr 02, 2026 at 04:33:47PM +0200, Friedrich Weber wrote:
>> We only have limited access to the test machine, so testing this is not
>> trivial. If I understand correctly, there is a lead pointing in the direction
>> of mpt3sas [1], so I'd postpone this test for now. But if needed, we're happy
>> to look into it.
> 
> Yeah, the mpt3sas driver isn't using an appropriate sized buffer for
> nvme prp handling. The easy option is just force the block layer to
> split requests so the driver never sees anything bigger than what it can
> currently handle. This should do it. I don't have any such device to
> test on, though.
> 
> ---
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 6ff7885572942..c76f5b958c56f 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -2739,7 +2739,10 @@ scsih_sdev_configure(struct scsi_device *sdev, struct queue_limits *lim)
>  				pcie_device->connector_name);
>  
>  		if (pcie_device->nvme_mdts)
> -			lim->max_hw_sectors = pcie_device->nvme_mdts / 512;
> +			lim->max_hw_sectors = min(pcie_device->nvme_mdts / 512,
> +						(SZ_2M / 512) - 8);
> +		else
> +			lim->max_hw_sectors = (SZ_2M / 512) - 8;

(note: redirecting this to linux-scsi since this is clearly not a block layer issue)

Keith,

Thanks for this. But where do you see that the DMA pool size is 2M ?
Looking at the code, it seems that ioc->pcie_sgl_dma_pool is created using
_base_allocate_pcie_sgl_pool() with a size that is calculated as:

        /*
         * The number of NVMe page sized blocks needed is:
         *     (((sg_tablesize * 8) - 1) / (page_size - 8)) + 1
         * ((sg_tablesize * 8) - 1) is the max PRP's minus the first PRP entry
         * that is placed in the main message frame.  8 is the size of each PRP
         * entry or PRP list pointer entry.  8 is subtracted from page_size
         * because of the PRP list pointer entry at the end of a page, so this
         * is not counted as a PRP entry.  The 1 added page is a round up.
         *
         * To avoid allocation failures due to the amount of memory that could
         * be required for NVMe PRP's, only each set of NVMe blocks will be
         * contiguous, so a new set is allocated for each possible I/O.
         */

        ioc->chains_per_prp_buffer = 0;
        if (ioc->facts.ProtocolFlags & MPI2_IOCFACTS_PROTOCOL_NVME_DEVICES) {
                nvme_blocks_needed =
                        (ioc->shost->sg_tablesize * NVME_PRP_SIZE) - 1;
                nvme_blocks_needed /= (ioc->page_size - NVME_PRP_SIZE);
                nvme_blocks_needed++;

                sz = sizeof(struct pcie_sg_list) * ioc->scsiio_depth;
                ioc->pcie_sg_lookup = kzalloc(sz, GFP_KERNEL);
                if (!ioc->pcie_sg_lookup) {
                        ioc_info(ioc, "PCIe SGL lookup: kzalloc failed\n");
                        goto out;
                }
                sz = nvme_blocks_needed * ioc->page_size;
                rc = _base_allocate_pcie_sgl_pool(ioc, sz);
                if (rc == -ENOMEM)
                        return -ENOMEM;
                else if (rc == -EAGAIN)
                        goto try_32bit_dma;
                total_sz += sz * ioc->scsiio_depth;
        }

in _base_allocate_memory_pools().

What am I missing here ?


Broadcom people,

Please help fix your driver.

-- 
Damien Le Moal
Western Digital Research
