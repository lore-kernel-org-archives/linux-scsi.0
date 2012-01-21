From: "Jack Wang" <jack_wang@usish.com>
Subject: Re: [PATCH v6 2/7] libsas: improve ata debug statements
Date: Sat, 21 Jan 2012 13:36:26 +0800
Message-ID: <FA947937481B428783C02E0BD63531CA@usish.com.cn>
References: <20120121014910.24930.54011.stgit@localhost6.localdomain6> <20120121015049.24930.6244.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:48059 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab2AUFiJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Jan 2012 00:38:09 -0500
In-Reply-To: <20120121015049.24930.6244.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Williams' <dan.j.williams@intel.com>, linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org

> 

[Jack Wang] 
Nice improvement.
Thanks.
> It's difficult to determine which domain_device is triggering error
recovery,
> so convert messages like:
> 
>   sas: ex 5001b4da000e703f phy08:T attached: 5001b4da000e7028
>   sas: ex 5001b4da000e703f phy09:T attached: 5001b4da000e7029
>   ...
>   ata7: sas eh calling libata port error handler
>   ata8: sas eh calling libata port error handler
> 
> ...into:
> 
>   sas: ex 5001517e85cfefff phy05:T:9 attached: 5001517e85cfefe5 (stp)
>   sas: ex 5001517e3b0af0bf phy11:T:8 attached: 5001517e3b0af0ab (stp)
>   ...
>   sas: ata7: end_device-21:1: dev error handler
>   sas: ata8: end_device-20:0:5: dev error handler
> 
> which shows attached link rate, device type, and associates a
> domain_device with its ata_port id to correlate messages emitted from
> libata-eh.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/scsi/libsas/sas_ata.c      |   43
> ++++++++++++++++++++++++++++--------
>  drivers/scsi/libsas/sas_expander.c |   38
++++++++++++++++++++++++++------
>  2 files changed, 64 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index 0ee6831..b43e395 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -317,6 +317,28 @@ static int local_ata_check_ready(struct ata_link
*link)
>  	}
>  }
> 
> +static int sas_ata_printk(const char *level, const struct domain_device
> *ddev,
> +		          const char *fmt, ...)
> +{
> +	struct ata_port *ap = ddev->sata_dev.ap;
> +	struct device *dev = &ddev->rphy->dev;
> +	struct va_format vaf;
> +	va_list args;
> +	int r;
> +
> +	va_start(args, fmt);
> +
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +
> +	r = printk("%ssas: ata%u: %s: %pV",
> +		   level, ap->print_id, dev_name(dev), &vaf);
> +
> +	va_end(args);
> +
> +	return r;
> +}
> +
>  static int sas_ata_hard_reset(struct ata_link *link, unsigned int *class,
>  			      unsigned long deadline)
>  {
> @@ -333,7 +355,7 @@ static int sas_ata_hard_reset(struct ata_link *link,
> unsigned int *class,
>  	res = i->dft->lldd_I_T_nexus_reset(dev);
> 
>  	if (res != TMF_RESP_FUNC_COMPLETE)
> -		SAS_DPRINTK("%s: Unable to reset ata device?\n", __func__);
> +		sas_ata_printk(KERN_DEBUG, dev, "Unable to reset ata
device?\n");
> 
>  	phy = sas_get_local_phy(dev);
>  	if (scsi_is_sas_phy_local(phy))
> @@ -344,7 +366,7 @@ static int sas_ata_hard_reset(struct ata_link *link,
> unsigned int *class,
> 
>  	ret = ata_wait_after_reset(link, deadline, check_ready);
>  	if (ret && ret != -EAGAIN)
> -		ata_link_err(link, "COMRESET failed (errno=%d)\n", ret);
> +		sas_ata_printk(KERN_ERR, dev, "reset failed (errno=%d)\n",
ret);
> 
>  	/* XXX: if the class changes during the reset the upper layer
>  	 * should be informed, if the device has gone away we assume
> @@ -665,7 +687,7 @@ static void async_sas_ata_eh(void *data,
async_cookie_t
> cookie)
>  	 * remove once all commands are completed
>  	 */
>  	kref_get(&dev->kref);
> -	ata_port_printk(ap, KERN_DEBUG, "sas eh calling libata port error
> handler");
> +	sas_ata_printk(KERN_DEBUG, dev, "dev error handler\n");
>  	ata_scsi_port_error_handler(ha->core.shost, ap);
>  	sas_put_device(dev);
> 
> @@ -708,26 +730,27 @@ void sas_ata_eh(struct Scsi_Host *shost, struct
> list_head *work_q,
>  		struct list_head *done_q)
>  {
>  	struct scsi_cmnd *cmd, *n;
> -	struct ata_port *ap;
> +	struct domain_device *eh_dev;
> 
>  	do {
>  		LIST_HEAD(sata_q);
> -
> -		ap = NULL;
> +		eh_dev = NULL;
> 
>  		list_for_each_entry_safe(cmd, n, work_q, eh_entry) {
>  			struct domain_device *ddev = cmd_to_domain_dev(cmd);
> 
>  			if (!dev_is_sata(ddev) || TO_SAS_TASK(cmd))
>  				continue;
> -			if (ap && ap != ddev->sata_dev.ap)
> +			if (eh_dev && eh_dev != ddev)
>  				continue;
> -			ap = ddev->sata_dev.ap;
> +			eh_dev = ddev;
>  			list_move(&cmd->eh_entry, &sata_q);
>  		}
> 
>  		if (!list_empty(&sata_q)) {
> -			ata_port_printk(ap, KERN_DEBUG, "sas eh calling
libata cmd
> error handler\n");
> +			struct ata_port *ap = eh_dev->sata_dev.ap;
> +
> +			sas_ata_printk(KERN_DEBUG, eh_dev, "cmd error
handler\n");
>  			ata_scsi_cmd_error_handler(shost, ap, &sata_q);
>  			/*
>  			 * ata's error handler may leave the cmd on the list
> @@ -743,7 +766,7 @@ void sas_ata_eh(struct Scsi_Host *shost, struct
list_head
> *work_q,
>  			while (!list_empty(&sata_q))
>  				list_del_init(sata_q.next);
>  		}
> -	} while (ap);
> +	} while (eh_dev);
>  }
> 
>  void sas_ata_schedule_reset(struct domain_device *dev)
> diff --git a/drivers/scsi/libsas/sas_expander.c
> b/drivers/scsi/libsas/sas_expander.c
> index 68a80a0..f8d941f 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -176,9 +176,10 @@ static void sas_set_ex_phy(struct domain_device *dev,
int
> phy_id,
>  	struct smp_resp *resp = disc_resp;
>  	struct discover_resp *dr = &resp->disc;
>  	struct sas_rphy *rphy = dev->rphy;
> -	int rediscover = (phy->phy != NULL);
> +	bool new_phy = !phy->phy;
> +	char *type;
> 
> -	if (!rediscover) {
> +	if (new_phy) {
>  		phy->phy = sas_phy_alloc(&rphy->dev, phy_id);
> 
>  		/* FIXME: error_handling */
> @@ -223,20 +224,43 @@ static void sas_set_ex_phy(struct domain_device
*dev,
> int phy_id,
>  	phy->phy->maximum_linkrate = dr->pmax_linkrate;
>  	phy->phy->negotiated_linkrate = phy->linkrate;
> 
> -	if (!rediscover)
> +	if (new_phy)
>  		if (sas_phy_add(phy->phy)) {
>  			sas_phy_free(phy->phy);
>  			return;
>  		}
> 
> -	SAS_DPRINTK("ex %016llx phy%02d:%c attached: %016llx\n",
> +	switch (phy->attached_dev_type) {
> +	case NO_DEVICE:
> +		type = "no device";
> +		break;
> +	case SAS_END_DEV:
> +		if (phy->attached_iproto) {
> +			if (phy->attached_tproto)
> +				type = "host+target";
> +			else
> +				type = "host";
> +		} else {
> +			if (dr->attached_sata_dev)
> +				type = "stp";
> +			else
> +				type = "ssp";
> +		}
> +		break;
> +	case EDGE_DEV:
> +	case FANOUT_DEV:
> +		type = "smp";
> +		break;
> +	default:
> +		type = "unknown";
> +	}
> +
> +	SAS_DPRINTK("ex %016llx phy%02d:%c:%X attached: %016llx (%s)\n",
>  		    SAS_ADDR(dev->sas_addr), phy->phy_id,
>  		    phy->routing_attr == TABLE_ROUTING ? 'T' :
>  		    phy->routing_attr == DIRECT_ROUTING ? 'D' :
>  		    phy->routing_attr == SUBTRACTIVE_ROUTING ? 'S' : '?',
> -		    SAS_ADDR(phy->attached_sas_addr));
> -
> -	return;
> +		    phy->linkrate, SAS_ADDR(phy->attached_sas_addr), type);
>  }
> 
>  /* check if we have an existing attached ata device on this expander phy
*/
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

