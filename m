From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [patch] wd7000: typo spin_unlock_irq() => spin_lock_irq()
Date: Thu, 8 Apr 2010 16:30:04 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1004081629350.8345@pobox.suse.cz>
References: <20100401155516.GF5265@bicker>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:58670 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757413Ab0DHOaF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Apr 2010 10:30:05 -0400
In-Reply-To: <20100401155516.GF5265@bicker>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: Miroslav Zagorac <zaga@fly.cc.fer.hr>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Adam Buchbinder <adam.buchbinder@gmail.com>, jgarzik@pobox.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Thu, 1 Apr 2010, Dan Carpenter wrote:

> This was introduced back in 2005 at the very start of the git era by:
> 	df0ae2497ddefd72a87f3a3b34ff32455d7d4ae0
> 	[SCSI] allow sleeping in ->eh_host_reset_handler()
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> Also this driver was written before some of our youngest kernel hackers
> were born.  Neat.  :)
> 
> diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
> index 2f6e9d8..bdfe59d 100644
> --- a/drivers/scsi/wd7000.c
> +++ b/drivers/scsi/wd7000.c
> @@ -1588,7 +1588,7 @@ static int wd7000_host_reset(struct scsi_cmnd *SCpnt)
>  {
>  	Adapter *host = (Adapter *) SCpnt->device->host->hostdata;
>  
> -	spin_unlock_irq(SCpnt->device->host->host_lock);
> +	spin_lock_irq(SCpnt->device->host->host_lock);
>  

Doesn't seem to be present in today's linux-next, so I have queued it in 
my tree so that it doesn't get lost.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
