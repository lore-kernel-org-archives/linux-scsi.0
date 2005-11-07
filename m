From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [RFC] raid class support for mptfusion
Date: Mon, 7 Nov 2005 14:50:21 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C04CDA56F@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:44226 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S965179AbVKGVup (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2005 16:50:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: hch@lst.de

> On Sunday, November 06, 2005 11:03 AM, James Bottomley wrote: 
> 


> @@ -2598,24 +2544,6 @@ mptscsih_event_process(MPT_ADAPTER *ioc,
>  		break;
>  
>  	case MPI_EVENT_INTEGRATED_RAID:			/* 0B */
> -	{
> -		pMpiEventDataRaid_t pRaidEventData =
> -		    (pMpiEventDataRaid_t) pEvReply->Data;
> -#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
> -		/* Domain Validation Needed */
> -		if (ioc->bus_type == SCSI &&
> -		    pRaidEventData->ReasonCode ==
> -		    MPI_EVENT_RAID_RC_DOMAIN_VAL_NEEDED)
> -			mptscsih_set_dvflags_raid(hd, 
> pRaidEventData->PhysDiskNum);
> -#endif
> -		break;
> -	}
> -


I forgot to mention in previous email, we can't just delete
the handling of MPI_EVENT_RAID_RC_DOMAIN_VAL_NEEDED asyn event.

Someone that has a degraded fault tolerant array, such as RAID1 or
RAID1E, will have poor performance(asyn narrow) once they replace the failed
drive with an optimal drive.  This event is needed so when the new
drive is added, we can perform domain validation on the hidden disk.
Thus James, can you handle notifying the spi transport layer of this new
disk?

Eric Moore



