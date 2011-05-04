From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH 1/3] libsas: flush initial device discovery before completing->scan_finished()
Date: Wed, 4 May 2011 09:14:23 +0800
Message-ID: <4BAC18F2A8BB490295DE9637E1C70577@usish.com.cn>
References: <20110503183526.21471.84735.stgit@localhost6.localdomain6> <20110503183622.21471.54135.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:34339 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab1EDBZK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2011 21:25:10 -0400
In-Reply-To: <20110503183622.21471.54135.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Williams' <dan.j.williams@intel.com>, james.bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, 'David Milburn' <dmilburn@redhat.com>, lindar_liu@usish.com, linux-ide@vger.kernel.org, 'Srinivas' <satyasrinivasp@hcl.in>

Acked-by: Jack Wang <jack_wang@usish.com>
Thanks!

> 
> During initial scan libsas drivers start their phys and notify libsas
> with PORTE_BYTES_DMAED events as port links are established.  This
> notification in turn causes libsas to post DISCE_DISCOVER_DOMAIN events
> to the queue.  Calling scsi_flush_work() at the end of scan_finished
> guarantees that all preceding PORTE_BYTES_DMAED events have been
> registered in the queue, but it does not guarantee that the resulting
> DISCE_DISCOVER_DOMAIN events have been processed because
> flush_workqueue() explicitly avoids live-locking with incoming work.
> 
> Introduce sas_flush_discovery() to guarantee that all initial discovery
> events have completed.  It is called after the driver determines all
> initial PORTE_BYTES_DMAED events have had a chance to enter the queue.
> This does not cover BCNs that are generated during expander bring up,
> only the initial sas_discover_domain() event.
> 
> Cc: David Milburn <dmilburn@redhat.com>
> Cc: Srinivas <satyasrinivasp@hcl.in>
> Cc: jack_wang@usish.com
> Cc: lindar_liu@usish.com
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/scsi/aic94xx/aic94xx_init.c |    2 +-
>  drivers/scsi/mvsas/mv_sas.c         |    2 +-
>  drivers/scsi/pm8001/pm8001_sas.c    |    2 +-
>  include/scsi/libsas.h               |   13 +++++++++++++
>  4 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/aic94xx/aic94xx_init.c
> b/drivers/scsi/aic94xx/aic94xx_init.c
> index 3b7e83d..f763daa 100644
> --- a/drivers/scsi/aic94xx/aic94xx_init.c
> +++ b/drivers/scsi/aic94xx/aic94xx_init.c
> @@ -972,7 +972,7 @@ static int asd_scan_finished(struct Scsi_Host *shost,
> unsigned long time)
>  	if (time < HZ)
>  		return 0;
>  	/* Wait for discovery to finish */
> -	scsi_flush_work(shost);
> +	sas_flush_discovery(shost);
>  	return 1;
>  }
> 
> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
> index adedaa9..e34c378 100644
> --- a/drivers/scsi/mvsas/mv_sas.c
> +++ b/drivers/scsi/mvsas/mv_sas.c
> @@ -440,7 +440,7 @@ int mvs_scan_finished(struct Scsi_Host *shost,
unsigned
> long time)
>  	if (time < HZ)
>  		return 0;
>  	/* Wait for discovery to finish */
> -	scsi_flush_work(shost);
> +	sas_flush_discovery(shost);
>  	return 1;
>  }
> 
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c
> b/drivers/scsi/pm8001/pm8001_sas.c
> index 6ae059e..997cf59 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -253,7 +253,7 @@ int pm8001_scan_finished(struct Scsi_Host *shost,
unsigned
> long time)
>  	if (time < HZ)
>  		return 0;
>  	/* Wait for discovery to finish */
> -	scsi_flush_work(shost);
> +	sas_flush_discovery(shost);
>  	return 1;
>  }
> 
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index 5173bba..d4ada3b 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -405,6 +405,19 @@ static inline void sas_phy_disconnected(struct
> asd_sas_phy *phy)
>  	phy->linkrate = SAS_LINK_RATE_UNKNOWN;
>  }
> 
> +/* Before returning from ->scan_finished() an LLDD calls this routine to
> + * ensure that all port notifications have been promoted to domain
> + * discovery events, and that initial domain discovery has completed
> + */
> +static inline void sas_flush_discovery(struct Scsi_Host *shost)
> +{
> +	/* flush port events */
> +	scsi_flush_work(shost);
> +
> +	/* flush domain discovery events queued by the port events */
> +	scsi_flush_work(shost);
> +}
> +
>  /* ---------- Tasks ---------- */
>  /*
>        service_response |  SAS_TASK_COMPLETE  |  SAS_TASK_UNDELIVERED |
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

