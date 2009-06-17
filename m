From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] ipr: differentiate pci-x and pci-e based adapters
Date: Wed, 17 Jun 2009 10:41:47 -0500
Message-ID: <4A390EBB.8040208@linux.vnet.ibm.com>
References: <20090616220853.799518360@linux.vnet.ibm.com> <4A381917.9000309@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:60439 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbZFQPlu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2009 11:41:50 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n5HFeRTA016027
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2009 09:40:27 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5HFfmeF259676
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2009 09:41:50 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5HFfm2X011472
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2009 09:41:48 -0600
In-Reply-To: <4A381917.9000309@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Wayne Boyer wrote:
> @@ -7539,7 +7539,8 @@
>  	ata_host_init(&ioa_cfg->ata_host, &pdev->dev,
>  		      sata_port_info.flags, &ipr_sata_ops);
> 
> -	ioa_cfg->chip_cfg = ipr_get_chip_cfg(dev_id);
> +	ioa_cfg->ipr_chip = ipr_get_chip_info(dev_id);
> +	ioa_cfg->chip_cfg = ioa_cfg->ipr_chip->cfg;

If ipr_get_chip_info returns NULL you will oops here.

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


