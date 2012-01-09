From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH v3 12/14] isci: ->lldd_ata_check_ready handler
Date: Mon, 9 Jan 2012 09:57:36 +0800
Message-ID: <513F55D9529643AC8F6F4C5B4B9F4B9D@usish.com.cn>
References: <20120106005634.11464.64030.stgit@localhost6.localdomain6> <20120106010001.11464.91347.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120106010001.11464.91347.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: 'Dan Williams' <dan.j.williams@intel.com>, linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> +int isci_ata_check_ready(struct domain_device *dev)
> +{
> +	struct isci_port *iport = dev->port->lldd_port;
> +	struct isci_host *ihost = dev_to_ihost(dev);
> +	struct isci_remote_device *idev;
> +	unsigned long flags;
> +	int rc = 0;
> +
> +	spin_lock_irqsave(&ihost->scic_lock, flags);
> +	idev = isci_lookup_device(dev);
> +	spin_unlock_irqrestore(&ihost->scic_lock, flags);
> +
> +	if (!idev)
> +		goto out;
> +
> +	if (test_bit(IPORT_RESET_PENDING, &iport->state))
> +		goto out;
> +
> +	/* snapshot active phy mask */
> +	spin_lock_irqsave(&ihost->scic_lock, flags);
> +	rc = !!iport->active_phy_mask;
[Jack Wang] 
Hi Dan,

Could you explain why here you not directly use "
rc = !!iport->active_phy_mask;
"

> +	spin_unlock_irqrestore(&ihost->scic_lock, flags);
> + out:
> +	isci_put_device(idev);
> +
> +	return rc;
> +}
> +
>  void isci_port_deformed(struct asd_sas_phy *phy)
>  {
>  	struct isci_host *ihost = phy->ha->lldd_ha;
> diff --git a/drivers/scsi/isci/port.h b/drivers/scsi/isci/port.h
> index 78e1e82..b4a733c 100644
> --- a/drivers/scsi/isci/port.h
> +++ b/drivers/scsi/isci/port.h
> @@ -293,4 +293,5 @@ void isci_port_init(
> 
>  int isci_port_perform_hard_reset(struct isci_host *ihost, struct
isci_port
> *iport,
>  				 struct isci_phy *iphy);
> +int isci_ata_check_ready(struct domain_device *dev);
>  #endif /* !defined(_ISCI_PORT_H_) */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

