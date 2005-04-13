From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH [2/5]  qla2xxx: add remote port codes...
Date: Wed, 13 Apr 2005 22:40:23 +0100
Message-ID: <20050413214023.GA18161@infradead.org>
References: <20050413191548.GI9703@plap.qlogic.org> <20050413191824.GK9703@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:16095 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261207AbVDMVkX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2005 17:40:23 -0400
Content-Disposition: inline
In-Reply-To: <20050413191824.GK9703@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

> +#include <linux/version.h>

not needed (this is in qla_attr.c)

> +struct scsi_transport_template *
> +qla2x00_alloc_transport_tmpl(void)
> +{
> +	return (fc_attach_transport(&qla2xxx_transport_functions));
> +}

I don't see much of a point in this function vs just making
qla2xxx_transport_functions non-static.

> --- a/drivers/scsi/qla2xxx/qla_gbl.h	2005-04-13 08:38:23.000000000 -0700
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h	2005-04-13 08:42:33.000000000 -0700
> @@ -24,6 +24,7 @@
>  #define	__QLA_GBL_H
>  
>  #include <linux/interrupt.h>
> +#include <scsi/scsi_transport.h>

shouldn't be needed, a simple forward-declaration of
struct scsi_transport_template should do it.

>  	atomic_set(&fcport->state, FCS_ONLINE);
> +	if (ha->flags.init_done)
> +		qla2x00_reg_remote_port(ha, fcport);
>  }

...

> -		goto probe_failed;
> +		goto probe_alloc_failed;
>  	}
>  
> +	pci_set_drvdata(pdev, ha);
> +	host->this_id = 255;
> +	host->cmd_per_lun = 3;
> +	host->unique_id = ha->instance;
> +	host->max_cmd_len = MAX_CMDSZ;
> +	host->max_channel = ha->ports - 1;
> +	host->max_id = ha->max_targets;
> +	host->max_lun = ha->max_luns;
> +	host->transportt = qla2xxx_transport_template;
> +	if (scsi_add_host(host, &pdev->dev))
> +		goto probe_alloc_failed;
> +
> +	qla2x00_alloc_sysfs_attr(ha);
> +
>  	if (qla2x00_initialize_adapter(ha) &&
>  	    !(ha->device_flags & DFLG_NO_CABLE)) {

Now this I don't undersant.  You're moving the host registration earlier,
maybe too earlier but I haven't checked that yet, why do you still need
the special case for delaying registration of the targets?

Also please propagate the full error that scsi_add_host returned.

