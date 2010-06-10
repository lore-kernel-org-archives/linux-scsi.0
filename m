From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [patch 2/2] be2iscsi: null dereference on error path
Date: Thu, 10 Jun 2010 15:43:17 -0500
Message-ID: <4C114E65.90305@cs.wisc.edu>
References: <20100610075305.GJ5483@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58948 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756903Ab0FJUlL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jun 2010 16:41:11 -0400
In-Reply-To: <20100610075305.GJ5483@bicker>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: Jayamohan Kallickal <jayamohank@serverengines.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On 06/10/2010 02:53 AM, Dan Carpenter wrote:
> "phba" is always null here so we can't dereference it.
>
> Signed-off-by: Dan Carpenter<error27@gmail.com>
>
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index 779e1d1..efadde9 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -3774,8 +3774,8 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
>
>   	ret = beiscsi_enable_pci(pcidev);
>   	if (ret<  0) {
> -		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
> -			     "Failed to enable pci device \n");
> +		dev_err(&pcidev->dev, "beiscsi_dev_probe-"
> +			" Failed to enable pci device\n");
>   		return ret;
>   	}
>

Looks good. Thanks.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
