From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH resend] mpt2sas: setpci reset kernel panic fix
Date: Fri, 19 Jun 2015 04:15:12 -0700
Message-ID: <20150619111512.GA12992@infradead.org>
References: <20150619111644.GA25830@nagalsi.ban.indi.seagate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35888 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbbFSLPM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2015 07:15:12 -0400
Content-Disposition: inline
In-Reply-To: <20150619111644.GA25830@nagalsi.ban.indi.seagate.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nagarajkumar Narayanan <nagarajkumar.narayanan@seagate.com>
Cc: linux-scsi@vger.kernel.org

> @@ -79,7 +79,8 @@ static int _scsih_scan_finished(struct Scsi_Host *shost, unsigned long time);
>  
>  /* global parameters */
>  LIST_HEAD(mpt2sas_ioc_list);
> -
> +/* global ioc lock for list operations */
> +spinlock_t gioc_lock;
>  /* local parameters */
>  static u8 scsi_io_cb_idx = -1;
>  static u8 tm_cb_idx = -1;
> @@ -279,6 +280,20 @@ static struct pci_device_id scsih_pci_table[] = {
>  MODULE_DEVICE_TABLE(pci, scsih_pci_table);
>  
>  /**
> + * mpt2sas_initialize_gioc_lock - initialize the gobal ioc lock
> + */
> +void
> +mpt2sas_initialize_gioc_lock(void)
> +{
> +	static int gioc_lock_initialize;
> +
> +	if (!gioc_lock_initialize) {
> +		spin_lock_init(&gioc_lock);
> +		gioc_lock_initialize = 1;
> +	}
> +}

Just use DEFINE_SPINLOCK() to initialize the lock at compile time.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
