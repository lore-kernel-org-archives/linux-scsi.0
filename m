From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH] scsi: add a CONFIG_SCSI_MQ_DEFAULT option
Date: Wed, 1 Oct 2014 01:02:32 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CC5E9E@G4W3202.americas.hpqcorp.net>
References: <1412090453-24484-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:7435 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaJABEx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 21:04:53 -0400
In-Reply-To: <1412090453-24484-1-git-send-email-hch@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Christoph Hellwig
...
> Add a Kconfig option to enable the blk-mq path for SCSI by default
> to ease testing and deployment in setups that know they benefit
> from blk-mq.
...
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 1423cb1..79c77b4 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -1367,7 +1367,11 @@ MODULE_LICENSE("GPL");
>  module_param(scsi_logging_level, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(scsi_logging_level, "a bit mask of logging levels");
> 
> +#ifdef CONFIG_SCSI_MQ_DEFAULT
> +bool scsi_use_blk_mq = true;
> +#else
>  bool scsi_use_blk_mq = false;
> +#endif
>  module_param_named(use_blk_mq, scsi_use_blk_mq, bool, S_IWUSR | S_IRUGO);
> 
>  static int __init init_scsi(void)

A printk indicating the choice would be helpful; there's no indication
in the "Command line" or "Kernel command line" lines after this patch.

Reviewed-by: Robert Elliott <elliott@hp.com>
Tested-by: Robert Elliott <elliott@hp.com>

