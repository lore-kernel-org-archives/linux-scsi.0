From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH v2 4/7] megaraid_sas: Send SYNCHRONIZE_CACHE command to firmware
Date: Fri, 21 Oct 2016 17:38:56 +0530
Message-ID: <4bc9319fb76ad1a7b80df01beef33710@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: James Bottomley [mailto:jejb@linux.vnet.ibm.com]
> Sent: Friday, October 21, 2016 4:32 PM
> To: Sumit Saxena; linux-scsi@vger.kernel.org
> Cc: martin.petersen@oracle.com; thenzl@redhat.com;
> kashyap.desai@broadcom.com; stable@vger.kernel.org
> Subject: Re: [PATCH v2 4/7] megaraid_sas: Send SYNCHRONIZE_CACHE
> command to firmware
>
> On Thu, 2016-10-20 at 02:05 -0700, Sumit Saxena wrote:
> > From previous patch we have below changes in v2 - 1.  Updated change
> > log.  Provided more detail in change log.
> > 2.  Agreed to remove module parameter. If we remove module parameter,
> > we
> >     can ask customer to disable WCE on drive to get similar impact.
> > 3.  Always Send SYNCHRONIZE_CACHE  for JBOD (non Raid) Device to
> > Firmware.
> >
> > Current megaraid_sas driver returns SYNCHRONIZE_CACHE(related to Drive
> > Cache)  command  back to SCSI layer without sending it down to
> > firmware as firmware supposed to take care of flushing disk cache for
> > all drives belongs to Virtual Disk at the time of system
> > reboot/shutdown.
> >
> > We evaluate and understood that for Raid Volume, why driver should not
> > send SYNC_CACHE command to the Firmware.
> > There may be a some reason in past, but now it looks to be not
> > required and we have fixed this issue as part of this patch.
> >
> > Commit- " 02b01e0 [SCSI] megaraid_sas: return sync cache call with
> > success"
> > added the code in driver to return SYNCHRONIZE_CACHE without sending
> > it to firmware back in 2007. Earlier MR was mainly for Virtual Disk,
> > so same code continue for JBOD as well whenever JBOD support was added
> > and it introduced bug that SYNCHRONIZE_CACHE is not passed to FW for
> > JBOD (non Raid disk).
> >
> > But our recent analysis indicates that, From Day-1 MR Firmware always
> > expect Driver to forward SYNCHRONIZE_CACHE for JBOD (non Raid disk) to
> > the Firmware.
> > We have fixed this as part of this patch.
> >
> >  - Additional background -
> > There are some instance of MegaRaid FW (E.a Gen2 and Gen2.5 FW) set
> > WCE bit for Virtual Disk but firmware does not reply correct status
> > for SYNCH_CACHE.
> > It is very difficult to find out which Device ID and firmware has
> > capability to manage SYNC_CACHE, so we managed to figure out which are
> > the new firmware (canHandleSyncCache is set in scratch pad register at
> > 0xB4) and use that interface for correct behavior as explained above.
> >
> > E.g Liberator/Thunderbolt MegaRaid FW returns SYNC_CACHE as
> > Unsupported command (this is a firmware bug) and eventually command
> > will be failed to SML.
> > This will cause File system to go Read-only.
> >
> >  - New behavior described -
> >
> > IF application requests SYNCH_CACHE
> >    IF 'JBOD'
> >               Driver sends SYNCH_CACHE command to the FW
> >                FW sends SYNCH_CACHE to drive
> >                FW obtains status from drive and returns same status
> > back to driver
> >    ELSEIF 'VirtualDisk'
> >                IF any FW which supports new API bit called
> > canHandleSyncCache
> >                               Driver sends SYNCH_CACHE command to the
> > FW
> >                               FW does not send SYNCH_CACHE to drives
> >                               FW returns SUCCESS
> >                ELSE
> >                               Driver does not send SYNCH_CACHE command
> > to the FW.
> >                               Driver return SUCCESS for that command.
> >                ENDIF
> >     ENDIF
> > ENDIF
> >
> > CC: stable@vger.kernel.org
>
> Can you please split this into two, so we can backport the bug fix without
> any of
> the feature addition junk?

James  - I am sending new patch making two logical fix as you requested.
JBOD fix will be marked for CC:stable and for Virtual disk I will post only
for head (not for stable). Let me know if resending complete series is good
or resending this patch is better.

>
> > Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> > Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> > ---
> >  drivers/scsi/megaraid/megaraid_sas.h        |  3 +++
> >  drivers/scsi/megaraid/megaraid_sas_base.c   | 10 ++--------
> >  drivers/scsi/megaraid/megaraid_sas_fusion.c |  5 +++++
> >  3 files changed, 10 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_sas.h
> > b/drivers/scsi/megaraid/megaraid_sas.h
> > index ca86c88..43fd14f 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas.h
> > +++ b/drivers/scsi/megaraid/megaraid_sas.h
> > @@ -1429,6 +1429,8 @@ enum FW_BOOT_CONTEXT {
> >  #define MR_MAX_REPLY_QUEUES_EXT_OFFSET_SHIFT    14
> >  #define MR_MAX_MSIX_REG_ARRAY                   16
> >  #define MR_RDPQ_MODE_OFFSET			0X00800000
> > +#define MR_CAN_HANDLE_SYNC_CACHE_OFFSET		0X01000000
> > +
> >  /*
> >  * register set for both 1068 and 1078 controllers
> >  * structure extended for 1078 registers @@ -2140,6 +2142,7 @@ struct
> > megasas_instance {
> >  	u8 is_imr;
> >  	u8 is_rdpq;
> >  	bool dev_handle;
> > +	bool fw_sync_cache_support;
> >  };
> >  struct MR_LD_VF_MAP {
> >  	u32 size;
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> > b/drivers/scsi/megaraid/megaraid_sas_base.c
> > index 3236632..f7a2ab1 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> > @@ -1700,16 +1700,10 @@ inline int megasas_cmd_type(struct scsi_cmnd
> > *cmd)
> >  		goto out_done;
> >  	}
> >
> > -	switch (scmd->cmnd[0]) {
> > -	case SYNCHRONIZE_CACHE:
> > -		/*
> > -		 * FW takes care of flush cache on its own
> > -		 * No need to send it down
> > -		 */
> > +	if (MEGASAS_IS_LOGICAL(scmd) && (scmd->cmnd[0] ==
> > SYNCHRONIZE_CACHE) &&
> > +		(!instance->fw_sync_cache_support)) {
> >  		scmd->result = DID_OK << 16;
> >  		goto out_done;
>
> This, minus the  "&& (!instance->fw_sync_cache_support)" is all we need
> for the
> bug fix, correct?
Yes.   I will be sending patch for the same. It need only below check for
JBOD fix.
       if ((scmd->cmnd[0] == SYNCHRONIZE_CACHE) && MEGASAS_IS_LOGICAL(scmd))
{

>
> James
>
> > -	default:
> > -		break;
> >  	}
> >
> >  	return instance->instancet->build_and_issue_cmd(instance,
> > scmd);
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > index 2159f6a..2e61306 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > @@ -748,6 +748,11 @@ static int megasas_create_sg_sense_fusion(struct
> > megasas_instance *instance)
> >  		goto fail_fw_init;
> >  	}
> >
> > +	instance->fw_sync_cache_support = (scratch_pad_2 &
> > +		MR_CAN_HANDLE_SYNC_CACHE_OFFSET) ? 1 : 0;
> > +	dev_info(&instance->pdev->dev, "FW supports sync cache\t:
> > %s\n",
> > +		 instance->fw_sync_cache_support ? "Yes" : "No");
> > +
> >  	IOCInitMessage =
> >  	  dma_alloc_coherent(&instance->pdev->dev,
> >  			     sizeof(struct MPI2_IOC_INIT_REQUEST),
