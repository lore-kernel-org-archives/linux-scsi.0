From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] mpt2sas: fix non-x86 crash on shutdown
Date: Wed, 4 Jan 2012 11:21:02 -0800
Message-ID: <20120104192102.GB18214@kroah.com>
References: <20120103223332.GA4112@kroah.com>
 <20120103223325.206012007@clark.kroah.org>
 <A6888A6805518E4EA4AF7072A28264A60481D5AAEC@inbmail02.lsi.com>
 <1325690398.2758.10.camel@dabdike.int.hansenpartnership.com>
 <1325690713.2758.13.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1325690713.2758.13.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "David S. Miller" <davem@davemloft.net>
Cc: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Greg KH <gregkh@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 04, 2012 at 09:25:13AM -0600, James Bottomley wrote:
> From: "nagalakshmi.nandigama@lsi.com" <nagalakshmi.nandigama@lsi.com>

That's not a correct "from" line, sorry.  That would create a mess of
the log.  Oh, I see Linus's tree is already a mess here, ugh.  Please be
more careful when accepting patches, otherwise stuff like this causes me
to have to hand-edit the kernel git logs when I run the "who does what"
statistic reports...

David, any objection for me taking this patch (left below) instead of
your original one for the stable tree?

thanks,

greg k-h

> Upstrem commit: 911ae9434f83e7355d343f6c2be3ef5b00ea7aed
> 
> There's a bug in the MSIX backup and restore routines that cause a crash on
> non-x86 (direct access to PCI space not via read/write).  These routines are
> unnecessary and were removed by the above commit, so also remove them from
> stable to fix the crash.
> 
> Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
> Signed-off-by: James Bottomley <JBottomley@Parallels.com>
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index 83035bd..39e81cd 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -1082,41 +1082,6 @@ _base_config_dma_addressing(struct MPT2SAS_ADAPTER *ioc, struct pci_dev *pdev)
>  }
>  
>  /**
> - * _base_save_msix_table - backup msix vector table
> - * @ioc: per adapter object
> - *
> - * This address an errata where diag reset clears out the table
> - */
> -static void
> -_base_save_msix_table(struct MPT2SAS_ADAPTER *ioc)
> -{
> -	int i;
> -
> -	if (!ioc->msix_enable || ioc->msix_table_backup == NULL)
> -		return;
> -
> -	for (i = 0; i < ioc->msix_vector_count; i++)
> -		ioc->msix_table_backup[i] = ioc->msix_table[i];
> -}
> -
> -/**
> - * _base_restore_msix_table - this restores the msix vector table
> - * @ioc: per adapter object
> - *
> - */
> -static void
> -_base_restore_msix_table(struct MPT2SAS_ADAPTER *ioc)
> -{
> -	int i;
> -
> -	if (!ioc->msix_enable || ioc->msix_table_backup == NULL)
> -		return;
> -
> -	for (i = 0; i < ioc->msix_vector_count; i++)
> -		ioc->msix_table[i] = ioc->msix_table_backup[i];
> -}
> -
> -/**
>   * _base_check_enable_msix - checks MSIX capabable.
>   * @ioc: per adapter object
>   *
> @@ -1128,7 +1093,7 @@ _base_check_enable_msix(struct MPT2SAS_ADAPTER *ioc)
>  {
>  	int base;
>  	u16 message_control;
> -	u32 msix_table_offset;
> +
>  
>  	base = pci_find_capability(ioc->pdev, PCI_CAP_ID_MSIX);
>  	if (!base) {
> @@ -1141,14 +1106,8 @@ _base_check_enable_msix(struct MPT2SAS_ADAPTER *ioc)
>  	pci_read_config_word(ioc->pdev, base + 2, &message_control);
>  	ioc->msix_vector_count = (message_control & 0x3FF) + 1;
>  
> -	/* get msix table  */
> -	pci_read_config_dword(ioc->pdev, base + 4, &msix_table_offset);
> -	msix_table_offset &= 0xFFFFFFF8;
> -	ioc->msix_table = (u32 *)((void *)ioc->chip + msix_table_offset);
> -
>  	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "msix is supported, "
> -	    "vector_count(%d), table_offset(0x%08x), table(%p)\n", ioc->name,
> -	    ioc->msix_vector_count, msix_table_offset, ioc->msix_table));
> +	    "vector_count(%d)\n", ioc->name, ioc->msix_vector_count));
>  	return 0;
>  }
>  
> @@ -1162,8 +1121,6 @@ _base_disable_msix(struct MPT2SAS_ADAPTER *ioc)
>  {
>  	if (ioc->msix_enable) {
>  		pci_disable_msix(ioc->pdev);
> -		kfree(ioc->msix_table_backup);
> -		ioc->msix_table_backup = NULL;
>  		ioc->msix_enable = 0;
>  	}
>  }
> @@ -1189,14 +1146,6 @@ _base_enable_msix(struct MPT2SAS_ADAPTER *ioc)
>  	if (_base_check_enable_msix(ioc) != 0)
>  		goto try_ioapic;
>  
> -	ioc->msix_table_backup = kcalloc(ioc->msix_vector_count,
> -	    sizeof(u32), GFP_KERNEL);
> -	if (!ioc->msix_table_backup) {
> -		dfailprintk(ioc, printk(MPT2SAS_INFO_FMT "allocation for "
> -		    "msix_table_backup failed!!!\n", ioc->name));
> -		goto try_ioapic;
> -	}
> -
>  	memset(&entries, 0, sizeof(struct msix_entry));
>  	r = pci_enable_msix(ioc->pdev, &entries, 1);
>  	if (r) {
> @@ -3513,9 +3462,6 @@ _base_diag_reset(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
>  	u32 hcb_size;
>  
>  	printk(MPT2SAS_INFO_FMT "sending diag reset !!\n", ioc->name);
> -
> -	_base_save_msix_table(ioc);
> -
>  	drsprintk(ioc, printk(MPT2SAS_INFO_FMT "clear interrupts\n",
>  	    ioc->name));
>  
> @@ -3611,7 +3557,6 @@ _base_diag_reset(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
>  		goto out;
>  	}
>  
> -	_base_restore_msix_table(ioc);
>  	printk(MPT2SAS_INFO_FMT "diag reset: SUCCESS\n", ioc->name);
>  	return 0;
>  
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
> index 8d5be21..7df640f 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.h
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
> @@ -636,8 +636,6 @@ enum mutex_type {
>   * @wait_for_port_enable_to_complete:
>   * @msix_enable: flag indicating msix is enabled
>   * @msix_vector_count: number msix vectors
> - * @msix_table: virt address to the msix table
> - * @msix_table_backup: backup msix table
>   * @scsi_io_cb_idx: shost generated commands
>   * @tm_cb_idx: task management commands
>   * @scsih_cb_idx: scsih internal commands
> @@ -779,8 +777,6 @@ struct MPT2SAS_ADAPTER {
>  
>  	u8		msix_enable;
>  	u16		msix_vector_count;
> -	u32		*msix_table;
> -	u32		*msix_table_backup;
>  	u32		ioc_reset_count;
>  
>  	/* internal commands, callback index */
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
