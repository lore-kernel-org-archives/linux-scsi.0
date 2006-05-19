From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/1] scsi : megaraid_{mm,mbox}: a fix on 64-bit DMA
	capability check
Date: Fri, 19 May 2006 16:28:00 -0500
Message-ID: <1148074080.3410.105.camel@mulgrave.il.steeleye.com>
References: <890BF3111FB9484E9526987D912B261901BD91@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:58326 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964849AbWESV2s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 May 2006 17:28:48 -0400
In-Reply-To: <890BF3111FB9484E9526987D912B261901BD91@NAMAIL3.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: Vasily Averin <vvs@sw.ru>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 2006-05-19 at 09:09 -0600, Ju, Seokmann wrote:

> +		adapter->pdev->device == PCI_DEVICE_ID_LINDSAY)) {
> +		if (pci_set_dma_mask(adapter->pdev, DMA_64BIT_MASK) !=
> 0) {
> +			con_log(CL_ANN, (KERN_WARNING
> +				"megaraid: could not set DMA mask for
> 64-bit.\n"));
>  
> -		goto out_free_sysfs_res;

Well, this really isn't quite right.  There are 32 bit platforms which
will refuse a 64 bit DMA mask on principle.  You need to retry with a 32
bit mask before erroring out, exactly like you've done in megaraid_sas.c

Also, it's a bit strange having a 32 bit mask set initially in probe_one
and then being reset in init_mbox.  Why not just consolidate all the PCI
register testing and mask setting in probe_one?

James


