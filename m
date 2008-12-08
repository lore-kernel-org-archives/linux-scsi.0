From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/2] mpt fusion: port "4.00.43.00" to mainstream git
	kernel
Date: Mon, 08 Dec 2008 09:17:34 -0600
Message-ID: <1228749454.3260.12.camel@localhost.localdomain>
References: <1228483610-18502-1-git-send-email-crquan@gmail.com>
	 <1228483610-18502-2-git-send-email-crquan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754317AbYLHPRo@vger.kernel.org>
In-Reply-To: <1228483610-18502-2-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: crquan@gmail.com
Cc: Eric Moore <Eric.Moore@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2008-12-05 at 21:26 +0800, crquan@gmail.com wrote:
> From: Cheng Renquan <crquan@gmail.com>
> 
> this one just can build with mainstream git kernel, I did not even test it.
> 
> I just have tested it with kernel 2.6.26.2, that patch is very similar to
> this, and it did work well with 2.6.26.2.
> 
> Signed-off-by: Cheng Renquan <crquan@gmail.com>
> ---
>  drivers/message/fusion/linux_compat.h |    3 +-

I don't quite understand what this patch is about.  This file isn't in
the upstream and hasn't been for a while if I recall, so what is this
patch actually patching?

>  drivers/message/fusion/mptbase.c      |   10 +-
>  drivers/message/fusion/mptbase.h      |    6 +-
>  drivers/message/fusion/mptfc.c        |    4 +-
>  drivers/message/fusion/mptsas.c       |   14 +---
>  drivers/message/fusion/mptscsih.c     |  169 +++++++++++++--------------------
>  drivers/message/fusion/mptscsih.h     |    2 +-
>  7 files changed, 79 insertions(+), 129 deletions(-)
> 
> diff --git a/drivers/message/fusion/linux_compat.h b/drivers/message/fusion/linux_compat.h
> index 24ad3f1..92e9797 100644
> --- a/drivers/message/fusion/linux_compat.h
> +++ b/drivers/message/fusion/linux_compat.h
> @@ -31,7 +31,6 @@ static inline void *shost_private(struct Scsi_Host *shost)
>  #define spi_dv_pending(x) (((struct spi_transport_attrs *)&(x)->starget_data)->dv_pending)
>  #endif
>  
> -#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23))
>  /**
>   * mpt_scsilun_to_int: convert a scsi_lun to an int
>   * @scsilun:    struct scsi_lun to be converted.
> @@ -62,7 +61,7 @@ static inline int mpt_scsilun_to_int(struct scsi_lun *scsilun)
>                                scsilun->scsi_lun[i + 1]) << (i * 8));
>          return lun;
>  }
> -#endif
> +
>  #if (defined(CONFIG_SUSE_KERNEL) && !defined(scsi_is_sas_phy_local))
>  #define SUSE_KERNEL_BASE	1
>  #endif
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index 2979b63..36dd62a 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -1618,7 +1618,7 @@ mpt_mapresources(MPT_ADAPTER *ioc)
>  	}
>  #else
>  	ioc->bars = pci_select_bars(pdev, IORESOURCE_MEM);
> -	if (pci_enable_device_bars(pdev, ioc->bars)) {
> +	if (pci_enable_device(pdev)) {

API reversal.

>  		printk(MYIOC_s_ERR_FMT "pci_enable_device_bars() with MEM "
>  		    "failed\n",ioc->name);
>  		return r;
> @@ -1826,7 +1826,8 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
>  #endif
>  
>  	/* Initialize workqueue */
> -	snprintf(ioc->reset_work_q_name, KOBJ_NAME_LEN, "mpt_poll_%d", ioc->id);
> +	snprintf(ioc->reset_work_q_name, sizeof(ioc->reset_work_q_name),
> +			"mpt_poll_%d", ioc->id);
>  	ioc->reset_work_q =
>  		create_singlethread_workqueue(ioc->reset_work_q_name);
>  	if (!ioc->reset_work_q) {
> @@ -1949,7 +1950,8 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  	INIT_LIST_HEAD(&ioc->fw_event_list);
>  	spin_lock_init(&ioc->fw_event_lock);
> -	snprintf(ioc->fw_event_q_name, KOBJ_NAME_LEN, "mpt/%d", ioc->id);
> +	snprintf(ioc->fw_event_q_name, sizeof(ioc->fw_event_q_name),
> +			"mpt/%d", ioc->id);
>  	ioc->fw_event_q = create_singlethread_workqueue(ioc->fw_event_q_name);
>  
>  	if ((r = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,
> @@ -2303,7 +2305,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
>  		pci_release_selected_regions(ioc->pcidev, ioc->bars);
>  		ioc->bars = pci_select_bars(ioc->pcidev, IORESOURCE_MEM |
>  		    IORESOURCE_IO);
> -		if (pci_enable_device_bars(ioc->pcidev, ioc->bars))
> +		if (pci_enable_device(ioc->pcidev))

Things like this are reversing kernel API changes and can't go in.

What you need to do is isolate the necessary changes to current git head
(or scsi-misc) and then send it to the LSI maintainers.  The route to
inclusion is via them.

Alternatively, we can just continue on with debugging the actual problem
you have rather than trying to upport some vendor driver.

James
