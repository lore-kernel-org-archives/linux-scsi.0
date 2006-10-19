From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] AIC94XX: call tasklet_kill while unloading the module
Date: Thu, 19 Oct 2006 14:57:19 -0400
Message-ID: <1161284239.11219.19.camel@mulgrave.il.steeleye.com>
References: <20061019032551.GB19570@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:20100 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1946374AbWJSS51 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Oct 2006 14:57:27 -0400
In-Reply-To: <20061019032551.GB19570@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: malahal@us.ibm.com
Cc: linux-scsi@vger.kernel.org

On Wed, 2006-10-18 at 20:25 -0700, malahal@us.ibm.com wrote:
> Signed-off-by: Malahal Naineni <malahal@us.ibm.com>
> 
> diff -r d134b26a8da8 drivers/scsi/aic94xx/aic94xx_init.c
> --- a/drivers/scsi/aic94xx/aic94xx_init.c	Wed Oct 18 16:34:30 2006 -0700
> +++ b/drivers/scsi/aic94xx/aic94xx_init.c	Wed Oct 18 18:21:40 2006 -0700
> @@ -737,6 +737,11 @@ static void __devexit asd_pci_remove(str
>  	/* XXX more here as needed */
>  
>  	free_irq(dev->irq, asd_ha);
> +
> +	/* We already disabled interrupts and freed the IRQ. Now, it is
> +	 * safe to kill the tasklet that processes done list */
> +	tasklet_kill(&asd_ha->seq.dl_tasklet);
> +

Actually, this should be in asd_destroy_ha_caches() which is where the
asd_init_hw() teardown path is ... not that I'm very happy with this;
the teardown should be in aic94xx_hwi.c where the init path is ...

James


