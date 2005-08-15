From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] allow a transport to pre-initialize starget_data
Date: Mon, 15 Aug 2005 11:18:10 -0400
Message-ID: <4300B232.9000308@adaptec.com>
References: <20050815134210.GA19426@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:4300 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S964793AbVHOPSO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 11:18:14 -0400
In-Reply-To: <20050815134210.GA19426@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On 08/15/05 09:42, Christoph Hellwig wrote:
> Add a new void *transport_data argument to scsi_scan_target so that a
> transport-class can fill in known information before actually scanning
> the target.  This is needed by the upcoming SAS transport class patch.

Hmm, yes, this has been due for 5 years now.

While you're at it, rip out the extremely broken "channel" and "id",
and leave only the opaque token.

	Luben

> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: scsi-misc-2.6/drivers/scsi/scsi_scan.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/scsi_scan.c	2005-08-13 13:53:54.000000000 +0200
> +++ scsi-misc-2.6/drivers/scsi/scsi_scan.c	2005-08-15 15:32:57.000000000 +0200
> @@ -329,7 +329,8 @@
>  }
>  
>  static struct scsi_target *scsi_alloc_target(struct device *parent,
> -					     int channel, uint id)
> +					     int channel, uint id,
> +					     void *transport_data)
>  {
>  	struct Scsi_Host *shost = dev_to_shost(parent);
>  	struct device *dev = NULL;
> @@ -344,6 +345,12 @@
>  		return NULL;
>  	}
>  	memset(starget, 0, size);
> +
> +	if (transport_data) {
> +		memcpy((char *)starget->starget_data, transport_data,
> +				shost->transportt->target_size);
> +	}
> +
>  	dev = &starget->dev;
>  	device_initialize(dev);
>  	starget->reap_ref = 1;
> @@ -1244,8 +1251,9 @@
>  	struct scsi_device *sdev;
>  	struct device *parent = &shost->shost_gendev;
>  	int res;
> -	struct scsi_target *starget = scsi_alloc_target(parent, channel, id);
> +	struct scsi_target *starget;
>  
> +	starget = scsi_alloc_target(parent, channel, id, NULL);
>  	if (!starget)
>  		return ERR_PTR(-ENOMEM);
>  
> @@ -1301,7 +1309,8 @@
>   *     sequential scan of LUNs on the target id.
>   **/
>  void scsi_scan_target(struct device *parent, unsigned int channel,
> -		      unsigned int id, unsigned int lun, int rescan)
> +		      unsigned int id, unsigned int lun, int rescan,
> +		      void *transport_data)
>  {
>  	struct Scsi_Host *shost = dev_to_shost(parent);
>  	int bflags = 0;
> @@ -1316,8 +1325,7 @@
>  		return;
>  
>  
> -	starget = scsi_alloc_target(parent, channel, id);
> -
> +	starget = scsi_alloc_target(parent, channel, id, transport_data);
>  	if (!starget)
>  		return;
>  
> @@ -1388,10 +1396,12 @@
>  				order_id = shost->max_id - id - 1;
>  			else
>  				order_id = id;
> -			scsi_scan_target(&shost->shost_gendev, channel, order_id, lun, rescan);
> +			scsi_scan_target(&shost->shost_gendev, channel,
> +					 order_id, lun, rescan, NULL);
>  		}
>  	else
> -		scsi_scan_target(&shost->shost_gendev, channel, id, lun, rescan);
> +		scsi_scan_target(&shost->shost_gendev, channel,
> +				 id, lun, rescan, NULL);
>  }
>  
>  int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
> @@ -1492,7 +1502,8 @@
>  	struct scsi_device *sdev;
>  	struct scsi_target *starget;
>  
> -	starget = scsi_alloc_target(&shost->shost_gendev, 0, shost->this_id);
> +	starget = scsi_alloc_target(&shost->shost_gendev, 0,
> +				    shost->this_id, NULL);
>  	if (!starget)
>  		return NULL;
>  
> Index: scsi-misc-2.6/drivers/scsi/scsi_transport_fc.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/scsi_transport_fc.c	2005-08-13 13:53:54.000000000 +0200
> +++ scsi-misc-2.6/drivers/scsi/scsi_transport_fc.c	2005-08-15 15:32:42.000000000 +0200
> @@ -1653,7 +1653,7 @@
>  	struct fc_rport *rport = (struct fc_rport *)data;
>  
>  	scsi_scan_target(&rport->dev, rport->channel, rport->scsi_target_id,
> -			SCAN_WILD_CARD, 1);
> +			SCAN_WILD_CARD, 1, NULL);
>  }
>  
>  
> Index: scsi-misc-2.6/include/scsi/scsi_device.h
> ===================================================================
> --- scsi-misc-2.6.orig/include/scsi/scsi_device.h	2005-08-13 13:54:07.000000000 +0200
> +++ scsi-misc-2.6/include/scsi/scsi_device.h	2005-08-15 15:32:42.000000000 +0200
> @@ -238,7 +238,8 @@
>  extern void scsi_target_quiesce(struct scsi_target *);
>  extern void scsi_target_resume(struct scsi_target *);
>  extern void scsi_scan_target(struct device *parent, unsigned int channel,
> -			     unsigned int id, unsigned int lun, int rescan);
> +			     unsigned int id, unsigned int lun, int rescan,
> +			     void *transport_data);
>  extern void scsi_target_reap(struct scsi_target *);
>  extern void scsi_target_block(struct device *);
>  extern void scsi_target_unblock(struct device *);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

