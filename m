From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] aacraid updates for new proing APIs
Date: Tue, 18 Nov 2003 13:29:22 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069190962.26419.29.camel@markh1.pdx.osdl.net>
References: <20031118110110.A22400@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:6068 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263788AbTKRV3a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2003 16:29:30 -0500
In-Reply-To: <20031118110110.A22400@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2003-11-18 at 03:01, Christoph Hellwig wrote:
> Anyone interested in reviewing and testing this?

I tried it out on my system and it seems to be working OK.  It found my
controller and configured the disks.  I can create a filesystem and copy
files back and forth.  I'll keep testing for a while and let you know if
I find something.


> +static int __devinit aac_probe_one(struct pci_dev *pdev,
> +		const struct pci_device_id *id)
>  {
> -	printk("aacraid: abort failed\n");
> -	return FAILED;
> +	unsigned index = id->driver_data;
> +	struct Scsi_Host *shost;
> +	struct fsa_scsi_hba *fsa_dev_ptr;
> +	struct aac_dev *aac;
> +	int container;
> +	int error = -ENODEV;
> +
> +	if (pci_enable_device(pdev))
> +		goto out;
> +
> +	pci_set_master(pdev);
> +	pci_set_dma_mask(pdev, 0xFFFFFFFFULL);

I've been told that the return value of this should be checked as it is
possible for it to fail.


Mark.
-- 
Mark Haverkamp <markh@osdl.org>

