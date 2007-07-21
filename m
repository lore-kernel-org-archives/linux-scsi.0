From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 7/7] gdth: switch to modern scsi host registration
Date: Sat, 21 Jul 2007 16:23:25 -0400
Message-ID: <46A26B3D.5070508@garzik.org>
References: <20070721170216.GH4150@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:34082 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761983AbXGUUX1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jul 2007 16:23:27 -0400
In-Reply-To: <20070721170216.GH4150@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: leubner@adaptec.com, linux-scsi@vger.kernel.org


in general, is sane.  three problems...


Christoph Hellwig wrote:
> +	/* As default we do not probe for EISA or ISA controllers */
> +	if (probe_eisa_isa) {
> +		/* scanning for controllers, at first: ISA controller */
> +#ifdef CONFIG_ISA
> +		for (isa_bios = 0xc8000UL; isa_bios <= 0xd8000UL;
> +			     isa_bios += 0x8000UL) {
> +			if (gdth_ctr_count >= MAXHA)
> +                		break;
> +			gdth_isa_probe_one(isa_bios);
> +		}
> +#endif
> +#ifdef CONFIG_EISA
> +		for (eisa_slot = 0x1000; eisa_slot <= 0x8000; eisa_slot += 0x1000) {
> +			if (gdth_ctr_count >= MAXHA)
> +				break;
> +			gdth_eisa_probe_one(eisa_slot);
> +		}
> +	}
> +#endif

1) endif should be above the brace


> +static void __exit gdth_exit(void)
> +{
> +	gdth_ha_str *ha;
> +
> +	list_for_each_entry(ha, &gdth_instances, list)
> +		gdth_remove_one(ha);

2) I think it's nicer to have two loops:  scsi_remove_host() for all 
ha-attached devices, and then the cleanup.  More pragmatic:  gives 
hardware more time to "settle" before turning off DMA engines.  A safer 
approach, and one that scsi_module.c follows.

3) This introduces a modicum of confusion between the gdth_ctr_tab[] 
stuff and the gdth_instances list.  While not strictly broken, this 
separation creates a foundation where the two can easily get out of sync.

	Jeff


