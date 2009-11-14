From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2/7]MVSAS:add supporting MSI feature
Date: Sat, 14 Nov 2009 15:56:27 -0700
Message-ID: <20091114225627.GK16033@parisc-linux.org>
References: <20091109120818.GA32336@Andy.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:59180 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbZKNW4X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Nov 2009 17:56:23 -0500
Content-Disposition: inline
In-Reply-To: <20091109120818.GA32336@Andy.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Yan <ayan@marvell.com>
Cc: james.bottomley@hansenpartnership.com, jeff@garzik.org, linux-scsi@vger.kernel.org, jfeng@marvell.com, qswang@marvell.com

On Mon, Nov 09, 2009 at 08:08:18PM +0800, Andy Yan wrote:
> +void mvs_enable_msi(struct mvs_info *mvi)
> +{
> +	u32 tmp;
> +	pci_read_config_dword(mvi->pdev, PCR_CMD, &tmp);
> +	tmp |= 1 << 10;    	/* disable interrupt */
> +	pci_write_config_dword(mvi->pdev, PCR_CMD, tmp);

What makes you think the pci_enable_msi() code doesn't set this bit?

> +	pci_read_config_dword(mvi->pdev, PCR_MSI_CTRL, &tmp);
> +	tmp |= 1 << 16; 		/* enable MSI */
> +	pci_write_config_dword(mvi->pdev, PCR_MSI_CTRL, tmp);

... and what makes you think it doesn't set this bit either?

> +static ssize_t
> +mvs_show_driver_version(struct device *cdev,
> +			struct device_attribute *attr,
> +			char *buffer)
> +{
> +	return snprintf(buffer, PAGE_SIZE, "%s\n", DRV_VERSION);
> +}

There's a lot of code in this patch not related to enabling MSI.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
