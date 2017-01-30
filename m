From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V3 15/24] aacraid: Include HBA direct interface
Date: Mon, 30 Jan 2017 12:02:09 +0100
Message-ID: <20170130110209.GK3603@linux-x5ow.site>
References: <20170127192853.10082-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170127192853.10082-16-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50515 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750752AbdA3LCN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 06:02:13 -0500
Content-Disposition: inline
In-Reply-To: <20170127192853.10082-16-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com

On Fri, Jan 27, 2017 at 11:28:44AM -0800, Raghava Aditya Renukunta wrote:
> Added support to send direct pasthru srb commands from management utilty
> to the  controller.
> 
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
> Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> 
> ---

[...]

Bonus points if you tidy up the following:

>  	byte_count = 0;
> -	if (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64) {
> +	if (is_native_device) {
> +		struct user_sgmap *usg32 = &user_srbcmd->sg;
> +		struct user_sgmap64 *usg64 =
> +			(struct user_sgmap64 *)&user_srbcmd->sg;
> +
> +		for (i = 0; i < usg32->count; i++) {
> +			void *p;
> +			u64 addr;
> +
> +			sg_count[i] = (actual_fibsize64 == fibsize) ?
> +				usg64->sg[i].count : usg32->sg[i].count;
> +			if (sg_count[i] >
> +				(dev->scsi_host_ptr->max_sectors << 9)) {
> +				pr_err("aacraid: upsg->sg[%d].count=%u>%u\n",
> +					i, sg_count[i],
> +					dev->scsi_host_ptr->max_sectors << 9);
> +				rcode = -EINVAL;
> +				goto cleanup;
> +			}
> +
> +			p = kmalloc(sg_count[i], GFP_KERNEL|__GFP_DMA);
> +			if (!p) {
> +				rcode = -ENOMEM;
> +				goto cleanup;
> +			}
> +
> +			if (actual_fibsize64 == fibsize) {
> +				addr = (u64)usg64->sg[i].addr[0];
> +				addr += ((u64)usg64->sg[i].addr[1]) << 32;
> +			} else {
> +				addr = (u64)usg32->sg[i].addr;
> +			}
> +
> +			sg_user[i] = (void __user *)(uintptr_t)addr;
> +			sg_list[i] = p; // save so we can clean up later
> +			sg_indx = i;
> +
> +			if (flags & SRB_DataOut) {
> +				if (copy_from_user(p, sg_user[i],
> +					sg_count[i])) {
> +					rcode = -EFAULT;
> +					goto cleanup;
> +				}
> +			}
> +			addr = pci_map_single(dev->pdev, p, sg_count[i],
> +						data_dir);
> +			hbacmd->sge[i].addr_hi = cpu_to_le32((u32)(addr>>32));
> +			hbacmd->sge[i].addr_lo = cpu_to_le32(
> +						(u32)(addr & 0xffffffff));
> +			hbacmd->sge[i].len = cpu_to_le32(sg_count[i]);
> +			hbacmd->sge[i].flags = 0;
> +			byte_count += sg_count[i];
> +		}
> +
> +		if (usg32->count > 0)	/* embedded sglist */
> +			hbacmd->sge[usg32->count-1].flags =
> +				cpu_to_le32(0x40000000);
> +		hbacmd->data_length = cpu_to_le32(byte_count);
> +
> +		status = aac_hba_send(HBA_IU_TYPE_SCSI_CMD_REQ, srbfib,
> +					NULL, NULL);
> +
> +	} else if (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64) {
>  		struct user_sgmap64* upsg = (struct user_sgmap64*)&user_srbcmd->sg;
>  		struct sgmap64* psg = (struct sgmap64*)&srbcmd->sg;
>  
> @@ -606,7 +719,9 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)

[...]

Anyways,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
