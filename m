Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97DB1C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 08:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240222AbiEaIFu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 May 2022 04:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237948AbiEaIFs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2022 04:05:48 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF7091559
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 01:05:46 -0700 (PDT)
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LC4VB0X8Tz67xZG;
        Tue, 31 May 2022 16:01:22 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 31 May 2022 10:05:44 +0200
Received: from [10.47.88.115] (10.47.88.115) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 31 May
 2022 09:05:43 +0100
Message-ID: <17747966-ea44-ebe5-3d79-df7c33b6a16e@huawei.com>
Date:   Tue, 31 May 2022 09:05:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 01/10] scsi/mvsas: Kill CONFIG_SCSI_MVSAS_TASKLET
To:     Davidlohr Bueso <dave@stgolabs.net>, <linux-scsi@vger.kernel.org>
CC:     <martin.petersen@oracle.com>, <ejb@linux.ibm.com>,
        <bigeasy@linutronix.de>, <tglx@linutronix.de>
References: <20220530231512.9729-1-dave@stgolabs.net>
 <20220530231512.9729-2-dave@stgolabs.net>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220530231512.9729-2-dave@stgolabs.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.88.115]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 31/05/2022 00:15, Davidlohr Bueso wrote:
> Tasklets have long been deprecated as being too heavy on the system
> by running in irq context - and this is not a performance critical
> path. If a higher priority process wants to run, it must wait for
> the tasklet to finish before doing so. A more suitable equivalent
> is to converted to threaded irq instead.

/s/converted/convert/

> 
> As such remove CONFIG_SCSI_MVSAS_TASKLET (which is horrible to begin
> with) and continue to do the async work, unconditionally now, just
> in task context. Just as with the tasklet version, device interrupts
> (MVS_IRQ_SAS_A/B) continues to be disabled from when the work was

/s/continues/continue/

> putted until it is actually complete. 

Question: Can there be any good reason to do this?

> Because there are no guarantees
> vs ksoftirqd, if this is broken for threaded irqs, then they are
> also broken for tasklets.
> 
> Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>

Apart some comments/nits:

Reviewed-by: John Garry <john.garry@huawei.com>

> ---
>   drivers/scsi/mvsas/Kconfig   |  7 ------
>   drivers/scsi/mvsas/mv_init.c | 44 ++++++------------------------------
>   drivers/scsi/mvsas/mv_sas.h  |  1 -
>   3 files changed, 7 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/scsi/mvsas/Kconfig b/drivers/scsi/mvsas/Kconfig
> index 79812b80743b..e9dd8dc84b1c 100644
> --- a/drivers/scsi/mvsas/Kconfig
> +++ b/drivers/scsi/mvsas/Kconfig
> @@ -23,10 +23,3 @@ config SCSI_MVSAS_DEBUG
>   	help
>   		Compiles the 88SE64XX/88SE94XX driver in debug mode.  In debug mode,
>   		the driver prints some messages to the console.
> -config SCSI_MVSAS_TASKLET
> -	bool "Support for interrupt tasklet"
> -	default n
> -	depends on SCSI_MVSAS
> -	help
> -		Compiles the 88SE64xx/88SE94xx driver in interrupt tasklet mode.In this mode,
> -		the interrupt will schedule a tasklet.
> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
> index 2fde496fff5f..f36b270ba502 100644
> --- a/drivers/scsi/mvsas/mv_init.c
> +++ b/drivers/scsi/mvsas/mv_init.c
> @@ -146,12 +146,10 @@ static void mvs_free(struct mvs_info *mvi)
>   	kfree(mvi);
>   }
>   
> -#ifdef CONFIG_SCSI_MVSAS_TASKLET
> -static void mvs_tasklet(unsigned long opaque)
> +static irqreturn_t mvs_async(int irq, void *opaque)
>   {
>   	u32 stat;
>   	u16 core_nr, i = 0;
> -
>   	struct mvs_info *mvi;
>   	struct sas_ha_struct *sha = (struct sas_ha_struct *)opaque;

nit: you could have dropped this cast

>   
> @@ -172,46 +170,29 @@ static void mvs_tasklet(unsigned long opaque)
>   out:
>   	MVS_CHIP_DISP->interrupt_enable(mvi);
>   
> +	return IRQ_HANDLED;
>   }
> -#endif
>   
>   static irqreturn_t mvs_interrupt(int irq, void *opaque)
>   {
>   	u32 stat;
>   	struct mvs_info *mvi;
>   	struct sas_ha_struct *sha = opaque;
> -#ifndef CONFIG_SCSI_MVSAS_TASKLET
> -	u32 i;
> -	u32 core_nr;
> -
> -	core_nr = ((struct mvs_prv_info *)sha->lldd_ha)->n_host;
> -#endif
>   
>   	mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[0];
>   
>   	if (unlikely(!mvi))
>   		return IRQ_NONE;
> -#ifdef CONFIG_SCSI_MVSAS_TASKLET
> +
>   	MVS_CHIP_DISP->interrupt_disable(mvi);
> -#endif
>   
>   	stat = MVS_CHIP_DISP->isr_status(mvi, irq);
>   	if (!stat) {
> -	#ifdef CONFIG_SCSI_MVSAS_TASKLET
>   		MVS_CHIP_DISP->interrupt_enable(mvi);
> -	#endif
>   		return IRQ_NONE;
>   	}
>   
> -#ifdef CONFIG_SCSI_MVSAS_TASKLET
> -	tasklet_schedule(&((struct mvs_prv_info *)sha->lldd_ha)->mv_tasklet);
> -#else
> -	for (i = 0; i < core_nr; i++) {
> -		mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[i];
> -		MVS_CHIP_DISP->isr(mvi, irq, stat);
> -	}
> -#endif
> -	return IRQ_HANDLED;
> +	return IRQ_WAKE_THREAD;
>   }
>   
>   static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
> @@ -557,14 +538,6 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
>   		}
>   		nhost++;
>   	} while (nhost < chip->n_host);
> -#ifdef CONFIG_SCSI_MVSAS_TASKLET
> -	{
> -	struct mvs_prv_info *mpi = SHOST_TO_SAS_HA(shost)->lldd_ha;
> -
> -	tasklet_init(&(mpi->mv_tasklet), mvs_tasklet,
> -		     (unsigned long)SHOST_TO_SAS_HA(shost));
> -	}
> -#endif
>   
>   	mvs_post_sas_ha_init(shost, chip);
>   
> @@ -575,8 +548,9 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
>   	rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
>   	if (rc)
>   		goto err_out_shost;
> -	rc = request_irq(pdev->irq, irq_handler, IRQF_SHARED,
> -		DRV_NAME, SHOST_TO_SAS_HA(shost));
> +	rc = request_threaded_irq(pdev->irq, irq_handler, mvs_async,

any reason not to use devm version?

> +				  IRQF_SHARED, DRV_NAME,
> +				  SHOST_TO_SAS_HA(shost));
>   	if (rc)
>   		goto err_not_sas;
>   
> @@ -607,10 +581,6 @@ static void mvs_pci_remove(struct pci_dev *pdev)
>   	core_nr = ((struct mvs_prv_info *)sha->lldd_ha)->n_host;
>   	mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[0];
>   
> -#ifdef CONFIG_SCSI_MVSAS_TASKLET
> -	tasklet_kill(&((struct mvs_prv_info *)sha->lldd_ha)->mv_tasklet);
> -#endif
> -
>   	sas_unregister_ha(sha);
>   	sas_remove_host(mvi->shost);
>   
> diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
> index 509d8f32a04f..a0e87fdab98a 100644
> --- a/drivers/scsi/mvsas/mv_sas.h
> +++ b/drivers/scsi/mvsas/mv_sas.h
> @@ -403,7 +403,6 @@ struct mvs_prv_info{
>   	u8 scan_finished;
>   	u8 reserve;
>   	struct mvs_info *mvi[2];
> -	struct tasklet_struct mv_tasklet;
>   };
>   
>   struct mvs_wq {

