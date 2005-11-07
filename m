From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [RFC] raid class support for mptfusion
Date: Mon, 07 Nov 2005 17:02:36 -0500
Message-ID: <1131400957.3333.3.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C04CDA56F@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:13514 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965237AbVKGWCk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Nov 2005 17:02:40 -0500
In-Reply-To: <91888D455306F94EBD4D168954A9457C04CDA56F@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, hch@lst.de

On Mon, 2005-11-07 at 14:50 -0700, Moore, Eric Dean wrote:
> > On Sunday, November 06, 2005 11:03 AM, James Bottomley wrote: 
> > 
> 
> 
> > @@ -2598,24 +2544,6 @@ mptscsih_event_process(MPT_ADAPTER *ioc,
> >  		break;
> >  
> >  	case MPI_EVENT_INTEGRATED_RAID:			/* 0B */
> > -	{
> > -		pMpiEventDataRaid_t pRaidEventData =
> > -		    (pMpiEventDataRaid_t) pEvReply->Data;
> > -#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
> > -		/* Domain Validation Needed */
> > -		if (ioc->bus_type == SCSI &&
> > -		    pRaidEventData->ReasonCode ==
> > -		    MPI_EVENT_RAID_RC_DOMAIN_VAL_NEEDED)
> > -			mptscsih_set_dvflags_raid(hd, 
> > pRaidEventData->PhysDiskNum);
> > -#endif
> > -		break;
> > -	}
> > -
> 
> 
> I forgot to mention in previous email, we can't just delete
> the handling of MPI_EVENT_RAID_RC_DOMAIN_VAL_NEEDED asyn event.
> 
> Someone that has a degraded fault tolerant array, such as RAID1 or
> RAID1E, will have poor performance(asyn narrow) once they replace the failed
> drive with an optimal drive.  This event is needed so when the new
> drive is added, we can perform domain validation on the hidden disk.
> Thus James, can you handle notifying the spi transport layer of this new
> disk?

Yes, easily ... this looks like some type of mismerge, since I was sure
I had the integrated raid DV even hooked directly into domain
validation.  I can add it, though.

James


