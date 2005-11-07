From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [RFC] raid class support for mptfusion
Date: Mon, 7 Nov 2005 13:25:00 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C04CDA442@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:36025 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S965125AbVKGUZZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2005 15:25:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: hch@lst.de

On Sunday, November 06, 2005 11:03 AM, James Bottomley wrote: 

NACK.

Adding Christoph Hellwig.  This patch breaks SAS device mapping,
and removes some SAS bits.  


> @@ -1289,6 +1230,7 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
>  	MPT_FRAME_HDR		*mf;
>  	SCSIIORequest_t		*pScsiReq;
>  	VirtDevice		*pTarget = SCpnt->device->hostdata;
> +	int	 target;
>  	int	 lun;
>  	u32	 datalen;
>  	u32	 scsictl;
> @@ -1298,9 +1240,12 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
>  	int	 ii;
>  
>  	hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata;
> +	target = SCpnt->device->id;
>  	lun = SCpnt->device->lun;
>  	SCpnt->scsi_done = done;
>  
> +	pTarget = mpt_target(hd, SCpnt->device->channel, target);
> +
>  	dmfprintk((MYIOC_s_INFO_FMT "qcmd: SCpnt=%p, done()=%p\n",
>  			(hd && hd->ioc) ? hd->ioc->name : 
> "ioc?", SCpnt, done));
>  
> @@ -1310,6 +1255,12 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
>  		return SCSI_MLQUEUE_HOST_BUSY;
>  	}
>  
> +	if (SCpnt->device->channel && 
> !mptscsih_is_raid_volume(hd, target)) {
> +		SCpnt->result = DID_NO_CONNECT << 16;
> +		done(SCpnt);
> +		return 0;
> +	}
> +

Christoph's SAS patches remaps all the remote phys to unique 
channels.  Meaning sc->device->id will always be zero, and 
sc->device->channel will always be non-zero.  Look at
mptsas_slave_alloc(), and the real f/w mapping is saved in 
pTarget->target_id and pTarget->bus_id.

Also - All our SAS controllers support Integrated RAID. 
Currently we support two volumes per ioc, and that number
could increase in future.  So hanging on the hidden disk 
on virtual channel = 1 is not going to work for SAS.  
Any ideas how you would like to support Raid transport
class for both SAS and SPI?


>  	/*
>  	 *  Put together a MPT SCSI request...
>  	 */
> @@ -1353,10 +1304,13 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
>  
>  	/* Use the above information to set up the message frame
>  	 */
> -	pScsiReq->TargetID = (u8) pTarget->target_id;
> -	pScsiReq->Bus = pTarget->bus_id;
> +	pScsiReq->TargetID = (u8) target;
> +	pScsiReq->Bus = 0;

Passing the target honored from the OS is going to break SAS.
We need to be sending the f/w mapped target ID; e.g.
pTarget->target_id.


> +static int 
> +mptscsih_is_raid_volume(MPT_SCSI_HOST *hd, uint id)
> +{
> +	int i;
> +
> +	if (!hd->ioc->raid_data.isRaid || !hd->ioc->raid_data.pIocPg3)
> +		return 0;
> +
> +	for (i = 0; i < hd->ioc->raid_data.pIocPg3->NumPhysDisks; i++) {
> +		if (id == 
> hd->ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskID)
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +

mptscsih_is_phys_disk() does the same thing.  
Can't this be deleted, and use mptscsih_is_phys_disk instead?


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
> -	/* Persistent table is full. */
> -	case MPI_EVENT_PERSISTENT_TABLE_FULL:
> -		INIT_WORK(&mptscsih_persistTask,
> -		    mptscsih_sas_persist_clear_table,(void *)ioc);
> -		schedule_work(&mptscsih_persistTask);
>  		break;
>  

This is persistency table full support, required for SAS.
This needs to be added back.


> +
> +static inline VirtDevice *mpt_target(MPT_SCSI_HOST *hd, int 
> channel, int id)
> +{
> +	return hd->Targets[id + (channel * hd->ioc->sh->max_id)];
> +}

Thank, I like this wrapper.  Ok, this is what I would like to do.
I plan to pull out all the mapping changes from this patch, and I will
provide a seperate patch that corrects all the mapping issues, to
include problems with that are there in todays 2.6.14-git10.

Have you looked at error handling? Its broke for SAS.
For abort task, target reset, and bus reset, the os honored 
device->id is being passed to the f/w.  It should be 
pTargets->target_id instead.

Also, mptctl.c will needs fixing.  IMO, the apps should only know
about the OS aware disks, ( and the hidden phys disk we supply to
the raid transport).  Right now the driver only works with f/w aware
addressing., so this needs to be fixed.

Eric Moore 



