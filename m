From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 1/4] mpt3sas: Added print to notify cable running at
 a degraded speed.
Date: Fri, 20 Jan 2017 09:55:14 -0800
Message-ID: <1484934914.12563.4.camel@perches.com>
References: <1484923333-8509-1-git-send-email-chaitra.basappa@broadcom.com>
         <1484923333-8509-2-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484923333-8509-2-git-send-email-chaitra.basappa@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chaitra P B <chaitra.basappa@broadcom.com>, JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 2017-01-20 at 20:12 +0530, Chaitra P B wrote:
> Driver processes the event MPI26_EVENT_ACTIVE_CABLE_DEGRADED
> when a cable is present and is running at a degraded speed
> (below the SAS3 12 Gb/s rate). Prints added
> to inform the user that the cable is not running at
> optimal speed.
[]
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
[]
> @@ -8028,15 +8028,23 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
>  	case MPI2_EVENT_ACTIVE_CABLE_EXCEPTION:
>  		ActiveCableEventData =
>  		    (Mpi26EventDataActiveCableExcept_t *) mpi_reply->EventData;
> -		if (ActiveCableEventData->ReasonCode ==
> -				MPI26_EVENT_ACTIVE_CABLE_INSUFFICIENT_POWER) {
> -			pr_info(MPT3SAS_FMT "Currently an active cable with ReceptacleID %d",
> +		switch (ActiveCableEventData->ReasonCode) {
> +		case MPI26_EVENT_ACTIVE_CABLE_INSUFFICIENT_POWER:
> +			pr_info(MPT3SAS_FMT "Currently an active cable with ReceptacleID %d\n",
>  			    ioc->name, ActiveCableEventData->ReceptacleID);
> -			pr_info("cannot be powered and devices connected to this active cable");
> -			pr_info("will not be seen. This active cable");
> -			pr_info("requires %d mW of power",
> +			pr_info(" cannot be powered and devices connected to\n");
> +			pr_info(" this active cable will not be seen. This\n");
> +			pr_info(" cable requires %d mW of power\n",

Can you please use more intelligible logging
where sentences are not broken across multiple
lines of output?  Something like:

			pr_notice(MPT3SAS_FMT "Receptacle ID %d: This active cable requires %d mW of power\n",
				  ioc->name, ActiveCableEventData->ReceptacleID,
				  ActiveCableEventData->ActiveCablePowerRequirement);
			pr_notice(MPT3SAS_FMT "Receptacle ID %d: Devices connected to this active cable will not be seen\n",
				  ioc->name, ActiveCableEventData->ReceptacleID);

I believe MPT3SAS_FMT is unnecessary obfuscation and
it should just be replaced by "%s: " everywhere.
