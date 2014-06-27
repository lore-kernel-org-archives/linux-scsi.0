From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 3/4] pm8001: add a new spinlock to protect the CCB
Date: Fri, 27 Jun 2014 12:21:22 +0200
Message-ID: <53AD45A2.1030600@redhat.com>
References: <1403795856-4300-3-git-send-email-thenzl@redhat.com> <DB8BCD22E410A84DA91083F3479A3DB31CD56D32@BBYEXM02.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158AbaF0KV1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 06:21:27 -0400
In-Reply-To: <DB8BCD22E410A84DA91083F3479A3DB31CD56D32@BBYEXM02.pmc-sierra.internal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas G <Viswas.G@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Vasanthalakshmi Tharmarajan <Vasanthalakshmi.Tharmarajan@pmcs.com>, Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>

On 06/27/2014 08:09 AM, Viswas G wrote:
> HI Tomas,
>
> This lock is not needed as we are already protecting the tag allocation and freeing with the pm8001_ha->lock. We are always acquiring this lock before calling 
> pm8001_tag_alloc().
>
> We are allocating and freeing the tag in following paths, 
>
> 1) Request/Response path : This we are protecting using pm8001_ha->lock.
> 2)Driver initialization : We are not using the lock here . As there only one will be running, we don't need a lock here.
>  
> So there is no need of a specific lock for tag allocation.

I looked at and tested the pm8001_ctl_bios_version_show. From this function the 
pm8001_chip_get_nvmd_req is invoked and there is a new 'tag' allocated.
I have noticed your lock nowhere in the path, in addition I was able to trigger this -
[  813.749060] pm80xx mpi_sata_completion 1991:task null
[  813.758439] pm80xx mpi_sata_completion 1991:task null
[  813.809356] pm80xx mpi_sata_completion 1991:task null
[  813.819881] pm80xx mpi_sata_completion 1991:task null
[  813.829086] pm80xx mpi_sata_completion 1991:task null
[  844.376825] pm80xx pm8001_mpi_task_abort_resp 3776:task abort failed status 0x6 ,tag = 0x2, scp= 0x0
[  844.387057] pm80xx pm8001_mpi_task_abort_resp 3776:task abort failed status 0x6 ,tag = 0x2, scp= 0x0
[  844.397316] pm80xx pm8001_mpi_task_abort_resp 3776:task abort failed status 0x6 ,tag = 0x2, scp= 0x0
[  844.406550] pm80xx pm8001_abort_task 1246:rc= 5
[  844.411142] pm80xx pm8001_query_task 1169::rc= 5
and the system became 'unstable'.

--tm

>
> Regards,
> Viswas G
>
> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com] 
> Sent: Thursday, June 26, 2014 8:48 PM
> To: linux-scsi@vger.kernel.org
> Cc: zzzAnand Kumar Santhanam(Nov-20-2013); Vasanthalakshmi Tharmarajan; Suresh Thiagarajan; Viswas G; Tomas Henzl
> Subject: [PATCH 3/4] pm8001: add a new spinlock to protect the CCB
>
> Patch adds a new spinlock to protect the ccb management.
> It may happen that concurrent threads become the same tag value from the 'alloc' function', the spinlock prevents this situation.
>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 1 +  drivers/scsi/pm8001/pm8001_sas.c  | 7 ++++++-  drivers/scsi/pm8001/pm8001_sas.h  | 1 +
>  3 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index c4f31b21..56b61e5 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -246,6 +246,7 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,  {
>  	int i;
>  	spin_lock_init(&pm8001_ha->lock);
> +	spin_lock_init(&pm8001_ha->bitmap_lock);
>  	PM8001_INIT_DBG(pm8001_ha,
>  		pm8001_printk("pm8001_alloc: PHY:%x\n",
>  				pm8001_ha->chip->n_phy));
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index be55859..34cea82 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -77,11 +77,16 @@ inline int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha, u32 *tag_out)  {
>  	unsigned int tag;
>  	void *bitmap = pm8001_ha->tags;
> +	unsigned long flags;
>  
> +	spin_lock_irqsave(&pm8001_ha->bitmap_lock, flags);
>  	tag = find_first_zero_bit(bitmap, pm8001_ha->tags_num);
> -	if (tag >= pm8001_ha->tags_num)
> +	if (tag >= pm8001_ha->tags_num) {
> +		spin_unlock_irqrestore(&pm8001_ha->bitmap_lock, flags);
>  		return -SAS_QUEUE_FULL;
> +	}
>  	set_bit(tag, bitmap);
> +	spin_unlock_irqrestore(&pm8001_ha->bitmap_lock, flags);
>  	*tag_out = tag;
>  	return 0;
>  }
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index 14106ad..f6b2ac5 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -475,6 +475,7 @@ struct pm8001_hba_info {
>  	struct list_head	list;
>  	unsigned long		flags;
>  	spinlock_t		lock;/* host-wide lock */
> +	spinlock_t		bitmap_lock;
>  	struct pci_dev		*pdev;/* our device */
>  	struct device		*dev;
>  	struct pm8001_hba_memspace io_mem[6];
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

