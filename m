From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 03/12]  be2iscsi: Adding crashdump support
Date: Sun, 04 Jul 2010 14:44:37 -0500
Message-ID: <4C30E4A5.2040101@cs.wisc.edu>
References: <20100629235800.GA20193@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48245 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757903Ab0GDTlj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Jul 2010 15:41:39 -0400
In-Reply-To: <20100629235800.GA20193@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On 06/29/2010 06:58 PM, Jayamohan Kallickal wrote:
> @@ -3819,6 +3833,33 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
>   		goto hba_free;
>   	}
>
> +	if (!num_hba) {
> +		real_offset = (u8 *)phba->csr_va + MPU_EP_SEMAPHORE;
> +		value = readl((void *)real_offset);
> +		if (value&  0x00010000) {
> +			gcrashmode++;
> +			shost_printk(KERN_ERR, phba->shost,
> +				"Loading Driver in crashdump mode\n");
> +			ret = beiscsi_pci_soft_reset(phba);
> +			if (ret) {
> +				shost_printk(KERN_ERR, phba->shost,
> +					"Reset Failed. Aborting Crashdump\n");
> +				goto hba_free;
> +			}
> +			ret = be_chk_reset_complete(phba);
> +			if (ret) {
> +				shost_printk(KERN_ERR, phba->shost,
> +					"Failed to get out of reset."
> +					"Aborting Crashdump\n");
> +				goto hba_free;
> +			}


Patch is fine.

This comment is for the future. These new functions return 0 or -EIO, 
but the other functions setting ret in this function return true/false 
or -1/0 or some -Exyzs. The -EIO/-Exyzs are the correct thing to do 
since you are passing them up to the dev probe, so you want to fix the 
-1 and true/falses in a later patch.
