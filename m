From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 3/5] mpt fusion: Changes in mptscsih.c for logging support
Date: Tue, 24 Jul 2007 13:30:45 +0300
Message-ID: <46A5D4D5.1090402@panasas.com>
References: <20070724101534.GD1831@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:16365 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754275AbXGXKaw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2007 06:30:52 -0400
In-Reply-To: <20070724101534.GD1831@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <sathya.prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org, eric.moore@lsi.com

Prakash, Sathya wrote:
> This patch contains changes in mptscsih.c to support logging in MPT fusion
> drivers.
> 
> The changes are majorly in debug printks, the existing debugprintk are
> modified accroding to new debug macros defined in the file mptbdebug.h
> 
> A new sysfs attribute is added to retrieve and modify the debug level.
> 
> signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
> ---
> 
> 
> diff -Naurp b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
> --- b/drivers/message/fusion/mptscsih.c	2007-07-23 14:24:35.000000000 +0530
> +++ a/drivers/message/fusion/mptscsih.c	2007-07-23 18:06:42.000000000 +0530
> @@ -191,7 +191,7 @@ mptscsih_getFreeChainBuffer(MPT_ADAPTER 
>  	int rc;
>  	int chain_idx;
>  
> -	dsgprintk((MYIOC_s_INFO_FMT "getFreeChainBuffer called\n",
> +	dsgprintk(ioc, printk(MYIOC_s_DEBUG_FMT "getFreeChainBuffer called\n",
>  			ioc->name));
>  	spin_lock_irqsave(&ioc->FreeQlock, flags);
>  	if (!list_empty(&ioc->FreeChainQ)) {
> @@ -203,12 +203,12 @@ mptscsih_getFreeChainBuffer(MPT_ADAPTER 
>  		offset = (u8 *)chainBuf - (u8 *)ioc->ChainBuffer;
>  		chain_idx = offset / ioc->req_sz;
>  		rc = SUCCESS;
> -		dsgprintk((MYIOC_s_ERR_FMT "getFreeChainBuffer chainBuf=%p ChainBuffer=%p offset=%d chain_idx=%d\n",
> +		dsgprintk(ioc, printk(MYIOC_s_DEBUG_FMT "getFreeChainBuffer chainBuf=%p ChainBuffer=%p offset=%d chain_idx=%d\n",
>  			ioc->name, chainBuf, ioc->ChainBuffer, offset, chain_idx));
>  	} else {
>  		rc = FAILED;
>  		chain_idx = MPT_HOST_NO_CHAIN;
> -		dfailprintk((MYIOC_s_INFO_FMT "getFreeChainBuffer failed\n",
> +		dfailprintk(ioc, printk(MYIOC_s_DEBUG_FMT "getFreeChainBuffer failed\n",
>  			ioc->name));
>  	}
>  	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
> @@ -337,7 +337,7 @@ nextSGEset:
>  			 */
>  			pReq->ChainOffset = 0;
>  			RequestNB = (((sgeOffset - 1) >> ioc->NBShiftFactor)  + 1) & 0x03;
> -			dsgprintk((MYIOC_s_INFO_FMT
> +			dsgprintk(ioc, printk(MYIOC_s_DEBUG_FMT
>  			    "Single Buffer RequestNB=%x, sgeOffset=%d\n", ioc->name, RequestNB, sgeOffset));
>  			ioc->RequestNB[req_idx] = RequestNB;
>  		}
> @@ -353,7 +353,7 @@ nextSGEset:
>  		 * Loop until done.
>  		 */
>  
> -		dsgprintk((MYIOC_s_INFO_FMT "SG: Chain Required! sg done %d\n",
> +		dsgprintk(ioc, printk(MYIOC_s_DEBUG_FMT "SG: Chain Required! sg done %d\n",
>  				ioc->name, sg_done));
>  
>  		/* Set LAST_ELEMENT flag for last non-chain element
> @@ -386,7 +386,7 @@ nextSGEset:
>  			 */
>  			pReq->ChainOffset = (u8) (sgeOffset >> 2);
>  			RequestNB = (((sgeOffset - 1) >> ioc->NBShiftFactor)  + 1) & 0x03;
> -			dsgprintk((MYIOC_s_ERR_FMT "Chain Buffer Needed, RequestNB=%x sgeOffset=%d\n", ioc->name, RequestNB, sgeOffset));
> +			dsgprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Chain Buffer Needed, RequestNB=%x sgeOffset=%d\n", ioc->name, RequestNB, sgeOffset));
>  			ioc->RequestNB[req_idx] = RequestNB;
>  		}
>  
> @@ -397,7 +397,7 @@ nextSGEset:
>  		 * in current buffer. Get a chain buffer.
>  		 */
>  		if ((mptscsih_getFreeChainBuffer(ioc, &newIndex)) == FAILED) {
> -			dfailprintk((MYIOC_s_INFO_FMT
> +			dfailprintk(ioc, printk(MYIOC_s_DEBUG_FMT
>  			    "getFreeChainBuffer FAILED SCSI cmd=%02x (%p)\n",
>   			    ioc->name, pReq->CDB[0], SCpnt));
>  			return FAILED;
> @@ -419,7 +419,7 @@ nextSGEset:
>  		 *   out the Address and Flags fields.
>  		 */
>  		chainSge = (char *) psge;
> -		dsgprintk((KERN_INFO "  Current buff @ %p (index 0x%x)",
> +		dsgprintk(ioc, printk(KERN_DEBUG "  Current buff @ %p (index 0x%x)",
>  				psge, req_idx));
>  
>  		/* Start the SGE for the next buffer
> @@ -428,7 +428,7 @@ nextSGEset:
>  		sgeOffset = 0;
>  		sg_done = 0;
>  
> -		dsgprintk((KERN_INFO "  Chain buff @ %p (index 0x%x)\n",
> +		dsgprintk(ioc, printk(KERN_DEBUG "  Chain buff @ %p (index 0x%x)\n",
>  				psge, chain_idx));
>  
>  		/* Start the SGE for the next buffer
> @@ -456,7 +456,7 @@ mptscsih_issue_sep_command(MPT_ADAPTER *
>  		return;
>  
>  	if ((mf = mpt_get_msg_frame(ioc->InternalCtx, ioc)) == NULL) {
> -		dfailprintk((MYIOC_s_WARN_FMT "%s: no msg frames!!\n",
> +		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s: no msg frames!!\n",
>  		    ioc->name,__FUNCTION__));
>  		return;
>  	}
> @@ -467,93 +467,158 @@ mptscsih_issue_sep_command(MPT_ADAPTER *
>  	SEPMsg->TargetID = vtarget->id;
>  	SEPMsg->Action = MPI_SEP_REQ_ACTION_WRITE_STATUS;
>  	SEPMsg->SlotStatus = SlotStatus;
> -	devtverboseprintk((MYIOC_s_WARN_FMT
> +	devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT
>  	    "Sending SEP cmd=%x channel=%d id=%d\n",
>  	    ioc->name, SlotStatus, SEPMsg->Bus, SEPMsg->TargetID));
>  	mpt_put_msg_frame(ioc->DoneCtx, ioc, mf);
>  }
>  
> -#ifdef MPT_DEBUG_REPLY
> +#ifdef CONFIG_FUSION_LOGGING
>  /**
> - *	mptscsih_iocstatus_info_scsiio - IOCSTATUS information for SCSIIO
> + *	mptscsih_info_scsiio - debug print info on reply frame
>   *	@ioc: Pointer to MPT_ADAPTER structure
> - *	@ioc_status: U32 IOCStatus word from IOC
> - *	@scsi_status: U8 sam status from target
> - *	@scsi_state: U8 scsi state
>   *	@sc: original scsi cmnd pointer
> - *	@mf: Pointer to MPT request frame
> + *	@pScsiReply: Pointer to MPT reply frame
> + *
> + *	MPT_DEBUG_REPLY needs to be enabled to obtain this info
>   *
>   *	Refer to lsi/mpi.h.
>   **/
>  static void
> -mptscsih_iocstatus_info_scsiio(MPT_ADAPTER *ioc, u32 ioc_status,
> -    u8 scsi_status, u8 scsi_state, struct scsi_cmnd *sc)
> +mptscsih_info_scsiio(MPT_ADAPTER *ioc, struct scsi_cmnd *sc, SCSIIOReply_t * pScsiReply)
>  {
> -	char extend_desc[EVENT_DESCR_STR_SZ];
> -	char *desc = NULL;
> +	char	*desc = NULL;
> +	char	*desc1 = NULL;
> +	u16	ioc_status;
> +	u8	skey, asc, ascq;
> +
> +	ioc_status = le16_to_cpu(pScsiReply->IOCStatus) & MPI_IOCSTATUS_MASK;
>  
>  	switch (ioc_status) {
>  
> -	case MPI_IOCSTATUS_SCSI_INVALID_BUS: /* 0x0041 */
> -		desc = "SCSI Invalid Bus";
> +	case MPI_IOCSTATUS_SUCCESS:
> +		desc = "success";
>  		break;
> -
> -	case MPI_IOCSTATUS_SCSI_INVALID_TARGETID: /* 0x0042 */
> -		desc = "SCSI Invalid TargetID";
> +	case MPI_IOCSTATUS_SCSI_INVALID_BUS:
> +		desc = "invalid bus";
>  		break;
> -
> -	case MPI_IOCSTATUS_SCSI_DEVICE_NOT_THERE: /* 0x0043 */
> -		/*
> -		 * Inquiry is issued for device scanning
> -		 */
> -		if (sc->cmnd[0] != 0x12)
> -			desc = "SCSI Device Not There";
> +	case MPI_IOCSTATUS_SCSI_INVALID_TARGETID:
> +		desc = "invalid target_id";
>  		break;
> -
> -	case MPI_IOCSTATUS_SCSI_DATA_OVERRUN: /* 0x0044 */
> -		desc = "SCSI Data Overrun";
> +	case MPI_IOCSTATUS_SCSI_DEVICE_NOT_THERE:
> +		desc = "device not there";
>  		break;
> -
> -	case MPI_IOCSTATUS_SCSI_IO_DATA_ERROR: /* 0x0046 */
> -		desc = "SCSI I/O Data Error";
> +	case MPI_IOCSTATUS_SCSI_DATA_OVERRUN:
> +		desc = "data overrun";
>  		break;
> -
> -	case MPI_IOCSTATUS_SCSI_PROTOCOL_ERROR: /* 0x0047 */
> -		desc = "SCSI Protocol Error";
> +	case MPI_IOCSTATUS_SCSI_DATA_UNDERRUN:
> +		desc = "data underrun";
>  		break;
> -
> -	case MPI_IOCSTATUS_SCSI_TASK_TERMINATED: /* 0x0048 */
> -		desc = "SCSI Task Terminated";
> +	case MPI_IOCSTATUS_SCSI_IO_DATA_ERROR:
> +		desc = "I/O data error";
>  		break;
> -
> -	case MPI_IOCSTATUS_SCSI_RESIDUAL_MISMATCH: /* 0x0049 */
> -		desc = "SCSI Residual Mismatch";
> +	case MPI_IOCSTATUS_SCSI_PROTOCOL_ERROR:
> +		desc = "protocol error";
>  		break;
> -
> -	case MPI_IOCSTATUS_SCSI_TASK_MGMT_FAILED: /* 0x004A */
> -		desc = "SCSI Task Management Failed";
> +	case MPI_IOCSTATUS_SCSI_TASK_TERMINATED:
> +		desc = "task terminated";
>  		break;
> -
> -	case MPI_IOCSTATUS_SCSI_IOC_TERMINATED: /* 0x004B */
> -		desc = "SCSI IOC Terminated";
> +	case MPI_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:
> +		desc = "residual mismatch";
>  		break;
> -
> -	case MPI_IOCSTATUS_SCSI_EXT_TERMINATED: /* 0x004C */
> -		desc = "SCSI Ext Terminated";
> +	case MPI_IOCSTATUS_SCSI_TASK_MGMT_FAILED:
> +		desc = "task management failed";
> +		break;
> +	case MPI_IOCSTATUS_SCSI_IOC_TERMINATED:
> +		desc = "IOC terminated";
> +		break;
> +	case MPI_IOCSTATUS_SCSI_EXT_TERMINATED:
> +		desc = "ext terminated";
> +		break;
> +	default:
> +		desc = "";
>  		break;
>  	}
>  
> -	if (!desc)
> -		return;
> +	switch (pScsiReply->SCSIStatus)
> +	{
>  
> -	snprintf(extend_desc, EVENT_DESCR_STR_SZ,
> -	    "[%d:%d:%d:%d] cmd=%02Xh, sam_status=%02Xh state=%02Xh",
> -		sc->device->host->host_no,
> -		sc->device->channel, sc->device->id, sc->device->lun,
> -		sc->cmnd[0], scsi_status, scsi_state);
> +	case MPI_SCSI_STATUS_SUCCESS:
> +		desc1 = "success";
> +		break;
> +	case MPI_SCSI_STATUS_CHECK_CONDITION:
> +		desc1 = "check condition";
> +		break;
> +	case MPI_SCSI_STATUS_CONDITION_MET:
> +		desc1 = "condition met";
> +		break;
> +	case MPI_SCSI_STATUS_BUSY:
> +		desc1 = "busy";
> +		break;
> +	case MPI_SCSI_STATUS_INTERMEDIATE:
> +		desc1 = "intermediate";
> +		break;
> +	case MPI_SCSI_STATUS_INTERMEDIATE_CONDMET:
> +		desc1 = "intermediate condmet";
> +		break;
> +	case MPI_SCSI_STATUS_RESERVATION_CONFLICT:
> +		desc1 = "reservation conflict";
> +		break;
> +	case MPI_SCSI_STATUS_COMMAND_TERMINATED:
> +		desc1 = "command terminated";
> +		break;
> +	case MPI_SCSI_STATUS_TASK_SET_FULL:
> +		desc1 = "task set full";
> +		break;
> +	case MPI_SCSI_STATUS_ACA_ACTIVE:
> +		desc1 = "aca active";
> +		break;
> +	case MPI_SCSI_STATUS_FCPEXT_DEVICE_LOGGED_OUT:
> +		desc1 = "fcpext device logged out";
> +		break;
> +	case MPI_SCSI_STATUS_FCPEXT_NO_LINK:
> +		desc1 = "fcpext no link";
> +		break;
> +	case MPI_SCSI_STATUS_FCPEXT_UNASSIGNED:
> +		desc1 = "fcpext unassigned";
> +		break;
> +	default:
> +		desc1 = "";
> +		break;
> +	}
> +
> +	scsi_print_command(sc);
> +	printk(KERN_DEBUG "\tfw_channel = %d, fw_id = %d\n",
> +	    pScsiReply->Bus, pScsiReply->TargetID);
> +	printk(KERN_DEBUG "\trequest_len = %d, underflow = %d, resid = %d\n",
> +	    sc->request_bufflen, sc->underflow, sc->resid);

+	printk(KERN_DEBUG "\trequest_len = %d, underflow = %d, resid = %d\n",
+	    scsi_bufflen(sc), sc->underflow, scsi_get_resid(sc));

> +	printk(KERN_DEBUG "\ttag = %d, transfer_count = %d, sc->result = %08X\n",
> +	    le16_to_cpu(pScsiReply->TaskTag),
> +	    le32_to_cpu(pScsiReply->TransferCount), sc->result);
> +
> +	printk(KERN_DEBUG "\tiocstatus = %s (0x%04x), "
> +	    "scsi_status = %s (0x%02x), scsi_state = (0x%02x)\n",
> +	    desc, ioc_status,
> +	    desc1, pScsiReply->SCSIStatus,
> +	    pScsiReply->SCSIState);
> +
> +	if (pScsiReply->SCSIState & MPI_SCSI_STATE_AUTOSENSE_VALID) {
> +		skey = sc->sense_buffer[2] & 0x0F;
> +		asc = sc->sense_buffer[12];
> +		ascq = sc->sense_buffer[13];
> +
> +		printk(KERN_DEBUG "\t[sense_key,asc,ascq]: "
> +		    "[0x%02x,0x%02x,0x%02x]\n",
> +		    skey, asc, ascq);
> +	}
>  
> -	printk(MYIOC_s_INFO_FMT "IOCStatus(0x%04X): %s: %s\n",
> -	    ioc->name, ioc_status, desc, extend_desc);
> +	/*
> +	 *  Look for + dump FCP ResponseInfo[]!
> +	 */
> +	if (pScsiReply->SCSIState & MPI_SCSI_STATE_RESPONSE_INFO_VALID &&
> +	    pScsiReply->ResponseInfo)
> +		printk(KERN_DEBUG "response_info = %08xh\n",
> +		    le32_to_cpu(pScsiReply->ResponseInfo));
>  }
>  #endif
>  
> @@ -627,11 +692,11 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
>  	pScsiReply = (SCSIIOReply_t *) mr;
>  
>  	if((ioc->facts.MsgVersion >= MPI_VERSION_01_05) && pScsiReply){
> -		dmfprintk((MYIOC_s_INFO_FMT
> +		dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT
>  			"ScsiDone (mf=%p,mr=%p,sc=%p,idx=%d,task-tag=%d)\n",
>  			ioc->name, mf, mr, sc, req_idx, pScsiReply->TaskTag));
>  	}else{
> -		dmfprintk((MYIOC_s_INFO_FMT
> +		dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT
>  			"ScsiDone (mf=%p,mr=%p,sc=%p,idx=%d)\n",
>  			ioc->name, mf, mr, sc, req_idx));
>  	}
> @@ -759,7 +824,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
>  				sc->result=DID_SOFT_ERROR << 16;
>  			else /* Sufficient data transfer occurred */
>  				sc->result = (DID_OK << 16) | scsi_status;
> -			dreplyprintk((KERN_NOTICE
> +			dreplyprintk(ioc, printk(KERN_DEBUG
>  			    "RESIDUAL_MISMATCH: result=%x on channel=%d id=%d\n",
>  			    sc->result, sc->device->channel, sc->device->id));
>  			break;
> @@ -792,9 +857,11 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
>  				}
>  			}
>  
> -			dreplyprintk((KERN_NOTICE "  sc->underflow={report ERR if < %02xh bytes xfer'd}\n",
> +
> +			dreplyprintk(ioc, printk(KERN_DEBUG "  sc->underflow={report ERR if < %02xh bytes xfer'd}\n",
>  					sc->underflow));
> -			dreplyprintk((KERN_NOTICE "  ActBytesXferd=%02xh\n", xfer_cnt));
> +			dreplyprintk(ioc, printk(KERN_DEBUG "  ActBytesXferd=%02xh\n", xfer_cnt));
> +
>  			/* Report Queue Full
>  			 */
>  			if (scsi_status == MPI_SCSI_STATUS_TASK_SET_FULL)
> @@ -871,27 +938,9 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
>  
>  		}	/* switch(status) */
>  
> -#ifdef MPT_DEBUG_REPLY
> -		if (sc->result) {
> -
> -			mptscsih_iocstatus_info_scsiio(ioc, status,
> -			    scsi_status, scsi_state, sc);
> -
> -			dreplyprintk(("%s: [%d:%d:%d:%d] cmd=0x%02x "
> -			    "result=0x%08x\n\tiocstatus=0x%04X "
> -			    "scsi_state=0x%02X scsi_status=0x%02X "
> -			    "loginfo=0x%08X\n", __FUNCTION__,
> -			    sc->device->host->host_no, sc->device->channel, sc->device->id,
> -			    sc->device->lun, sc->cmnd[0], sc->result, status,
> -			    scsi_state, scsi_status, log_info));
> -
> -			dreplyprintk(("%s: [%d:%d:%d:%d] resid=%d "
> -				      "bufflen=%d xfer_cnt=%d\n", __FUNCTION__,
> -				      sc->device->host->host_no,
> -				      sc->device->channel, sc->device->id,
> -				      sc->device->lun, scsi_get_resid(sc),
> -				      scsi_bufflen(sc), xfer_cnt));
> -		}
> +#ifdef CONFIG_FUSION_LOGGING
> +		if (sc->result && (ioc->debug_level & MPT_DEBUG_REPLY))
> +			mptscsih_info_scsiio(ioc, sc, pScsiReply);
>  #endif
>  
>  	} /* end of address reply case */
> @@ -925,7 +974,7 @@ mptscsih_flush_running_cmds(MPT_SCSI_HOS
>  	int		 ii;
>  	int		 max = ioc->req_depth;
>  
> -	dprintk((KERN_INFO MYNAM ": flush_ScsiLookup called\n"));
> +	dprintk(ioc, printk(KERN_DEBUG MYNAM ": flush_ScsiLookup called\n"));
>  	for (ii= 0; ii < max; ii++) {
>  		if ((SCpnt = hd->ScsiLookup[ii]) != NULL) {
>  
> @@ -937,7 +986,7 @@ mptscsih_flush_running_cmds(MPT_SCSI_HOS
>  			hd->ScsiLookup[ii] = NULL;
>  
>  			mf = MPT_INDEX_2_MFPTR(ioc, ii);
> -			dmfprintk(( "flush: ScsiDone (mf=%p,sc=%p)\n",
> +			dmfprintk(ioc, printk(KERN_DEBUG MYNAM ": flush: ScsiDone (mf=%p,sc=%p)\n",
>  					mf, SCpnt));
>  
>  			/* Free Chain buffers */
> @@ -987,7 +1036,7 @@ mptscsih_search_running_cmds(MPT_SCSI_HO
>  	struct scsi_cmnd *sc;
>  	struct scsi_lun  lun;
>  
> -	dsprintk((KERN_INFO MYNAM ": search_running channel %d id %d lun %d max %d\n",
> +	dsprintk(hd->ioc, printk(KERN_DEBUG MYNAM ": search_running channel %d id %d lun %d max %d\n",
>  	    vdevice->vtarget->channel, vdevice->vtarget->id, vdevice->lun, max));
>  
>  	for (ii=0; ii < max; ii++) {
> @@ -1020,9 +1069,9 @@ mptscsih_search_running_cmds(MPT_SCSI_HO
>  			scsi_dma_unmap(sc);
>  			sc->host_scribble = NULL;
>  			sc->result = DID_NO_CONNECT << 16;
> -			dsprintk(( "search_running: found (sc=%p, mf = %p) "
> -			    "channel %d id %d, lun %d \n", sc, mf,
> -			    vdevice->vtarget->channel, vdevice->vtarget->id, vdevice->lun));
> +			sdev_printk(KERN_INFO, sc->device, "completing cmds: fw_channel %d,"
> +			   "fw_id %d, sc=%p, mf = %p, idx=%x\n", vdevice->vtarget->channel,
> +			   vdevice->vtarget->id, sc, mf, ii);
>  			sc->scsi_done(sc);
>  		}
>  	}
> @@ -1057,7 +1106,7 @@ mptscsih_report_queue_full(struct scsi_c
>  		return;
>  
>  	if (time - hd->last_queue_full > 10 * HZ) {
> -		dprintk((MYIOC_s_WARN_FMT "Device (%d:%d:%d) reported QUEUE_FULL!\n",
> +		dprintk(hd->ioc, printk(MYIOC_s_WARN_FMT "Device (%d:%d:%d) reported QUEUE_FULL!\n",
>  				hd->ioc->name, 0, sc->device->id, sc->device->lun));
>  		hd->last_queue_full = time;
>  	}
> @@ -1098,7 +1147,7 @@ mptscsih_remove(struct pci_dev *pdev)
>  		hd->ScsiLookup = NULL;
>  	}
>  
> -	dprintk((MYIOC_s_INFO_FMT
> +	dprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT
>  	    "Free'd ScsiLookup (%d) memory\n",
>  	    hd->ioc->name, sz1));
>  
> @@ -1317,17 +1366,19 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
>  	u32	 cmd_len;
>  	int	 my_idx;
>  	int	 ii;
> +	MPT_ADAPTER *ioc;
>  
>  	hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata;
> +	ioc = hd->ioc;
>  	lun = SCpnt->device->lun;
>  	SCpnt->scsi_done = done;
>  
> -	dmfprintk((MYIOC_s_INFO_FMT "qcmd: SCpnt=%p, done()=%p\n",
> -			(hd && hd->ioc) ? hd->ioc->name : "ioc?", SCpnt, done));
> +	dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT "qcmd: SCpnt=%p, done()=%p\n",
> +		ioc->name, SCpnt, done));
>  
>  	if (hd->resetPending) {
> -		dtmprintk((MYIOC_s_WARN_FMT "qcmd: SCpnt=%p timeout + 60HZ\n",
> -			(hd && hd->ioc) ? hd->ioc->name : "ioc?", SCpnt));
> +		dtmprintk(ioc, printk(MYIOC_s_WARN_FMT "qcmd: SCpnt=%p timeout + 60HZ\n",
> +			ioc->name, SCpnt));
>  		return SCSI_MLQUEUE_HOST_BUSY;
>  	}
>  
> @@ -1335,8 +1386,8 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
>  	 *  Put together a MPT SCSI request...
>  	 */
>  	if ((mf = mpt_get_msg_frame(hd->ioc->DoneCtx, hd->ioc)) == NULL) {
> -		dprintk((MYIOC_s_WARN_FMT "QueueCmd, no msg frames!!\n",
> -				hd->ioc->name));
> +		dprintk(ioc, printk(MYIOC_s_WARN_FMT "QueueCmd, no msg frames!!\n",
> +				ioc->name));
>  		return SCSI_MLQUEUE_HOST_BUSY;
>  	}
>  
> @@ -1422,9 +1473,9 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
>  	hd->ScsiLookup[my_idx] = SCpnt;
>  
>  	mpt_put_msg_frame(hd->ioc->DoneCtx, hd->ioc, mf);
> -	dmfprintk((MYIOC_s_INFO_FMT "Issued SCSI cmd (%p) mf=%p idx=%d\n",
> -			hd->ioc->name, SCpnt, mf, my_idx));
> -	DBG_DUMP_REQUEST_FRAME(mf)
> +	dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Issued SCSI cmd (%p) mf=%p idx=%d\n",
> +			ioc->name, SCpnt, mf, my_idx));
> +	DBG_DUMP_REQUEST_FRAME(ioc, (u32 *)mf)
>  	return 0;
>  
>   fail:
> @@ -1475,7 +1526,7 @@ mptscsih_freeChainBuffers(MPT_ADAPTER *i
>  		list_add_tail(&chain->u.frame.linkage.list, &ioc->FreeChainQ);
>  		spin_unlock_irqrestore(&ioc->FreeQlock, flags);
>  
> -		dmfprintk((MYIOC_s_INFO_FMT "FreeChainBuffers (index %d)\n",
> +		dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT "FreeChainBuffers (index %d)\n",
>  				ioc->name, chain_idx));
>  
>  		/* handle next */
> @@ -1519,7 +1570,7 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
>  	unsigned long	 flags;
>  
>  	ioc = hd->ioc;
> -	dtmprintk((MYIOC_s_INFO_FMT "TMHandler Entered!\n", ioc->name));
> +	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TMHandler Entered!\n", ioc->name));
>  
>  	// SJR - CHECKME - Can we avoid this here?
>  	// (mpt_HardResetHandler has this check...)
> @@ -1539,20 +1590,20 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
>  	 */
>  	if (mptscsih_tm_pending_wait(hd) == FAILED) {
>  		if (type == MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK) {
> -			dtmprintk((KERN_INFO MYNAM ": %s: TMHandler abort: "
> +			dtmprintk(ioc, printk(KERN_DEBUG MYNAM ": %s: TMHandler abort: "
>  			   "Timed out waiting for last TM (%d) to complete! \n",
> -			   hd->ioc->name, hd->tmPending));
> +			   ioc->name, hd->tmPending));
>  			return FAILED;
>  		} else if (type == MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET) {
> -			dtmprintk((KERN_INFO MYNAM ": %s: TMHandler target "
> +			dtmprintk(ioc, printk(KERN_DEBUG MYNAM ": %s: TMHandler target "
>  				"reset: Timed out waiting for last TM (%d) "
> -				"to complete! \n", hd->ioc->name,
> +				"to complete! \n", ioc->name,
>  				hd->tmPending));
>  			return FAILED;
>  		} else if (type == MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS) {
> -			dtmprintk((KERN_INFO MYNAM ": %s: TMHandler bus reset: "
> +			dtmprintk(ioc, printk(KERN_DEBUG MYNAM ": %s: TMHandler bus reset: "
>  			   "Timed out waiting for last TM (%d) to complete! \n",
> -			   hd->ioc->name, hd->tmPending));
> +			  ioc->name, hd->tmPending));
>  			return FAILED;
>  		}
>  	} else {
> @@ -1591,12 +1642,13 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
>  	    ctx2abort, timeout);
>  	if (rc)
>  		printk(MYIOC_s_INFO_FMT "Issue of TaskMgmt failed!\n",
> -		       hd->ioc->name);
> +		       ioc->name);
>  	else
> -		dtmprintk((MYIOC_s_INFO_FMT "Issue of TaskMgmt Successful!\n",
> -			   hd->ioc->name));
> +		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Issue of TaskMgmt Successful!\n",
> +			   ioc->name));
>  
> -	dtmprintk((MYIOC_s_INFO_FMT "TMHandler rc = %d!\n", hd->ioc->name, rc));
> +	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
> +			"TMHandler rc = %d!\n", ioc->name, rc));
>  
>  	return rc;
>  }
> @@ -1632,11 +1684,11 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd
>  	/* Return Fail to calling function if no message frames available.
>  	 */
>  	if ((mf = mpt_get_msg_frame(hd->ioc->TaskCtx, hd->ioc)) == NULL) {
> -		dfailprintk((MYIOC_s_ERR_FMT "IssueTaskMgmt, no msg frames!!\n",
> +		dfailprintk(hd->ioc, printk(MYIOC_s_ERR_FMT "IssueTaskMgmt, no msg frames!!\n",
>  				hd->ioc->name));
>  		return FAILED;
>  	}
> -	dtmprintk((MYIOC_s_INFO_FMT "IssueTaskMgmt request @ %p\n",
> +	dtmprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT "IssueTaskMgmt request @ %p\n",
>  			hd->ioc->name, mf));
>  
>  	/* Format the Request
> @@ -1660,27 +1712,27 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd
>  
>  	pScsiTm->TaskMsgContext = ctx2abort;
>  
> -	dtmprintk((MYIOC_s_INFO_FMT "IssueTaskMgmt: ctx2abort (0x%08x) "
> +	dtmprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT "IssueTaskMgmt: ctx2abort (0x%08x) "
>  		"type=%d\n", hd->ioc->name, ctx2abort, type));
>  
> -	DBG_DUMP_TM_REQUEST_FRAME((u32 *)pScsiTm);
> +	DBG_DUMP_TM_REQUEST_FRAME(ioc, (u32 *)pScsiTm);
>  
>  	if ((retval = mpt_send_handshake_request(hd->ioc->TaskCtx, hd->ioc,
>  		sizeof(SCSITaskMgmt_t), (u32*)pScsiTm, CAN_SLEEP)) != 0) {
> -		dfailprintk((MYIOC_s_ERR_FMT "send_handshake FAILED!"
> +		dfailprintk(hd->ioc, printk(MYIOC_s_ERR_FMT "send_handshake FAILED!"
>  			" (hd %p, ioc %p, mf %p, rc=%d) \n", hd->ioc->name, hd,
>  			hd->ioc, mf, retval));
>  		goto fail_out;
>  	}
>  
>  	if(mptscsih_tm_wait_for_completion(hd, timeout) == FAILED) {
> -		dfailprintk((MYIOC_s_ERR_FMT "task management request TIMED OUT!"
> +		dfailprintk(hd->ioc, printk(MYIOC_s_ERR_FMT "task management request TIMED OUT!"
>  			" (hd %p, ioc %p, mf %p) \n", hd->ioc->name, hd,
>  			hd->ioc, mf));
> -		dtmprintk((MYIOC_s_INFO_FMT "Calling HardReset! \n",
> +		dtmprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT "Calling HardReset! \n",
>  			 hd->ioc->name));
>  		retval = mpt_HardResetHandler(hd->ioc, CAN_SLEEP);
> -		dtmprintk((MYIOC_s_INFO_FMT "rc=%d \n",
> +		dtmprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT "rc=%d \n",
>  			 hd->ioc->name, retval));
>  		goto fail_out;
>  	}
> @@ -1748,8 +1800,8 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
>  	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL) {
>  		SCpnt->result = DID_RESET << 16;
>  		SCpnt->scsi_done(SCpnt);
> -		dfailprintk((KERN_INFO MYNAM ": mptscsih_abort: Can't locate "
> -		    "host! (sc=%p)\n", SCpnt));
> +		printk(KERN_DEBUG MYNAM ": mptscsih_abort: Can't locate "
> +		    "host! (sc=%p)\n", SCpnt);
>  		return FAILED;
>  	}
>  
> @@ -1760,7 +1812,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
>  
>  	vdevice = SCpnt->device->hostdata;
>  	if (!vdevice || !vdevice->vtarget) {
> -		dtmprintk((MYIOC_s_DEBUG_FMT "task abort: device has been "
> +		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "task abort: device has been "
>  		    "deleted (sc=%p)\n", ioc->name, SCpnt));
>  		SCpnt->result = DID_NO_CONNECT << 16;
>  		SCpnt->scsi_done(SCpnt);
> @@ -1771,7 +1823,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
>  	/* Task aborts are not supported for hidden raid components.
>  	 */
>  	if (vdevice->vtarget->tflags & MPT_TARGET_FLAGS_RAID_COMPONENT) {
> -		dtmprintk((MYIOC_s_DEBUG_FMT "task abort: hidden raid "
> +		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "task abort: hidden raid "
>  		    "component (sc=%p)\n", ioc->name, SCpnt));
>  		SCpnt->result = DID_RESET << 16;
>  		retval = FAILED;
> @@ -1785,7 +1837,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
>  		 * Do OS callback.
>  		 */
>  		SCpnt->result = DID_RESET << 16;
> -		dtmprintk((KERN_INFO MYNAM ": %s: mptscsih_abort: "
> +		dtmprintk(ioc, printk(KERN_DEBUG MYNAM ": %s: mptscsih_abort: "
>  		   "Command not in the active list! (sc=%p)\n", ioc->name,
>  		   SCpnt));
>  		retval = 0;
> @@ -1850,8 +1902,8 @@ mptscsih_dev_reset(struct scsi_cmnd * SC
>  	/* If we can't locate our host adapter structure, return FAILED status.
>  	 */
>  	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL){
> -		dtmprintk((KERN_INFO MYNAM ": mptscsih_dev_reset: Can't "
> -		    "locate host! (sc=%p)\n", SCpnt));
> +		printk(KERN_DEBUG MYNAM ": mptscsih_dev_reset: Can't "
> +		    "locate host! (sc=%p)\n", SCpnt);
>  		return FAILED;
>  	}
>  
> @@ -1913,8 +1965,8 @@ mptscsih_bus_reset(struct scsi_cmnd * SC
>  	/* If we can't locate our host adapter structure, return FAILED status.
>  	 */
>  	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL){
> -		dtmprintk((KERN_INFO MYNAM ": mptscsih_bus_reset: Can't "
> -		    "locate host! (sc=%p)\n", SCpnt ));
> +		printk(KERN_DEBUG MYNAM ": mptscsih_bus_reset: Can't "
> +		    "locate host! (sc=%p)\n", SCpnt );
>  		return FAILED;
>  	}
>  
> @@ -1957,8 +2009,8 @@ mptscsih_host_reset(struct scsi_cmnd *SC
>  
>  	/*  If we can't locate the host to reset, then we failed. */
>  	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL){
> -		dtmprintk( ( KERN_INFO MYNAM ": mptscsih_host_reset: Can't "
> -		    "locate host! (sc=%p)\n", SCpnt));
> +		printk( KERN_DEBUG MYNAM ": mptscsih_host_reset: Can't "
> +		    "locate host! (sc=%p)\n", SCpnt);
>  		return FAILED;
>  	}
>  
> @@ -2106,16 +2158,16 @@ mptscsih_taskmgmt_complete(MPT_ADAPTER *
>  	u8			 tmType;
>  	u32			 termination_count;
>  
> -	dtmprintk((MYIOC_s_WARN_FMT "TaskMgmt completed (mf=%p,mr=%p)\n",
> +	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TaskMgmt completed (mf=%p,mr=%p)\n",
>  	    ioc->name, mf, mr));
>  	if (!ioc->sh) {
> -		dtmprintk((MYIOC_s_WARN_FMT
> +		dtmprintk(ioc, printk(MYIOC_s_WARN_FMT
>  		    "TaskMgmt Complete: NULL Scsi Host Ptr\n", ioc->name));
>  		return 1;
>  	}
>  
>  	if (mr == NULL) {
> -		dtmprintk((MYIOC_s_WARN_FMT
> +		dtmprintk(ioc, printk(MYIOC_s_WARN_FMT
>  		    "ERROR! TaskMgmt Reply: NULL Request %p\n", ioc->name, mf));
>  		return 1;
>  	}
> @@ -2131,19 +2183,21 @@ mptscsih_taskmgmt_complete(MPT_ADAPTER *
>  	    pScsiTmReply->ResponseCode)
>  		mptscsih_taskmgmt_response_code(ioc,
>  		    pScsiTmReply->ResponseCode);
> -	DBG_DUMP_TM_REPLY_FRAME((u32 *)pScsiTmReply);
> +	DBG_DUMP_TM_REPLY_FRAME(ioc, (u32 *)pScsiTmReply);
>  
> -#if defined(MPT_DEBUG_REPLY) || defined(MPT_DEBUG_TM)
> -	printk("%s: ha=%d [%d:%d:0] task_type=0x%02X "
> -	    "iocstatus=0x%04X\n\tloginfo=0x%08X response_code=0x%02X "
> -	    "term_cmnds=%d\n", __FUNCTION__, ioc->id, pScsiTmReply->Bus,
> -	    pScsiTmReply->TargetID, pScsiTmReq->TaskType,
> -	    le16_to_cpu(pScsiTmReply->IOCStatus),
> -	    le32_to_cpu(pScsiTmReply->IOCLogInfo),pScsiTmReply->ResponseCode,
> -	    le32_to_cpu(pScsiTmReply->TerminationCount));
> +#ifdef CONFIG_FUSION_LOGGING
> +	if ((ioc->debug_level & MPT_DEBUG_REPLY) || 
> +				(ioc->debug_level & MPT_DEBUG_TM ))
> +		printk("%s: ha=%d [%d:%d:0] task_type=0x%02X "
> +	    		"iocstatus=0x%04X\n\tloginfo=0x%08X response_code=0x%02X "
> +	    		"term_cmnds=%d\n", __FUNCTION__, ioc->id, pScsiTmReply->Bus,
> +	   		 pScsiTmReply->TargetID, pScsiTmReq->TaskType,
> +	    		le16_to_cpu(pScsiTmReply->IOCStatus),
> +	    		le32_to_cpu(pScsiTmReply->IOCLogInfo),pScsiTmReply->ResponseCode,
> +	    		le32_to_cpu(pScsiTmReply->TerminationCount));
>  #endif
>  	if (!iocstatus) {
> -		dtmprintk((MYIOC_s_WARN_FMT " TaskMgmt SUCCESS\n", ioc->name));
> +		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT " TaskMgmt SUCCESS\n", ioc->name));
>  			hd->abortSCpnt = NULL;
>  		goto out;
>  	}
> @@ -2224,10 +2278,6 @@ mptscsih_bios_param(struct scsi_device *
>  	geom[1] = sectors;
>  	geom[2] = cylinders;
>  
> -	dprintk((KERN_NOTICE
> -		": bios_param: Id=%i Lun=%i Channel=%i CHS=%i/%i/%i\n",
> -		sdev->id, sdev->lun, sdev->channel, (int)cylinders, heads, sectors));
> -
>  	return 0;
>  }
>  
> @@ -2393,11 +2443,11 @@ mptscsih_slave_configure(struct scsi_dev
>  	vtarget = starget->hostdata;
>  	vdevice = sdev->hostdata;
>  
> -	dsprintk((MYIOC_s_INFO_FMT
> +	dsprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT
>  		"device @ %p, channel=%d, id=%d, lun=%d\n",
>  		hd->ioc->name, sdev, sdev->channel, sdev->id, sdev->lun));
>  	if (hd->ioc->bus_type == SPI)
> -		dsprintk((MYIOC_s_INFO_FMT
> +		dsprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT
>  		    "sdtr %d wdtr %d ppr %d inq length=%d\n",
>  		    hd->ioc->name, sdev->sdtr, sdev->wdtr,
>  		    sdev->ppr, sdev->inquiry_len));
> @@ -2411,19 +2461,19 @@ mptscsih_slave_configure(struct scsi_dev
>  	vdevice->configured_lun = 1;
>  	mptscsih_change_queue_depth(sdev, MPT_SCSI_CMD_PER_DEV_HIGH);
>  
> -	dsprintk((MYIOC_s_INFO_FMT
> +	dsprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT
>  		"Queue depth=%d, tflags=%x\n",
>  		hd->ioc->name, sdev->queue_depth, vtarget->tflags));
>  
>  	if (hd->ioc->bus_type == SPI)
> -		dsprintk((MYIOC_s_INFO_FMT
> +		dsprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT
>  		    "negoFlags=%x, maxOffset=%x, SyncFactor=%x\n",
>  		    hd->ioc->name, vtarget->negoFlags, vtarget->maxOffset,
>  		    vtarget->minSyncFactor));
>  
>  slave_configure_exit:
>  
> -	dsprintk((MYIOC_s_INFO_FMT
> +	dsprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT
>  		"tagged %d, simple %d, ordered %d\n",
>  		hd->ioc->name,sdev->tagged_supported, sdev->simple_tags,
>  		sdev->ordered_tags));
> @@ -2490,7 +2540,7 @@ mptscsih_copy_sense_data(struct scsi_cmn
>  			}
>  		}
>  	} else {
> -		dprintk((MYIOC_s_INFO_FMT "Hmmm... SenseData len=0! (?)\n",
> +		dprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT "Hmmm... SenseData len=0! (?)\n",
>  				hd->ioc->name));
>  	}
>  }
> @@ -2520,7 +2570,7 @@ mptscsih_ioc_reset(MPT_ADAPTER *ioc, int
>  	unsigned long	 flags;
>  	int 		ii;
>  
> -	dtmprintk((KERN_WARNING MYNAM
> +	dtmprintk(ioc, printk(KERN_DEBUG MYNAM
>  			": IOC %s_reset routed to SCSI host driver!\n",
>  			reset_phase==MPT_IOC_SETUP_RESET ? "setup" : (
>  			reset_phase==MPT_IOC_PRE_RESET ? "pre" : "post")));
> @@ -2535,7 +2585,7 @@ mptscsih_ioc_reset(MPT_ADAPTER *ioc, int
>  		hd = (MPT_SCSI_HOST *) ioc->sh->hostdata;
>  
>  	if (reset_phase == MPT_IOC_SETUP_RESET) {
> -		dtmprintk((MYIOC_s_WARN_FMT "Setup-Diag Reset\n", ioc->name));
> +		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Setup-Diag Reset\n", ioc->name));
>  
>  		/* Clean Up:
>  		 * 1. Set Hard Reset Pending Flag
> @@ -2544,7 +2594,7 @@ mptscsih_ioc_reset(MPT_ADAPTER *ioc, int
>  		hd->resetPending = 1;
>  
>  	} else if (reset_phase == MPT_IOC_PRE_RESET) {
> -		dtmprintk((MYIOC_s_WARN_FMT "Pre-Diag Reset\n", ioc->name));
> +		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Pre-Diag Reset\n", ioc->name));
>  
>  		/* 2. Flush running commands
>  		 *	Clean ScsiLookup (and associated memory)
> @@ -2564,10 +2614,10 @@ mptscsih_ioc_reset(MPT_ADAPTER *ioc, int
>  			mpt_free_msg_frame(ioc, hd->cmdPtr);
>  		}
>  
> -		dtmprintk((MYIOC_s_WARN_FMT "Pre-Reset complete.\n", ioc->name));
> +		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Pre-Reset complete.\n", ioc->name));
>  
>  	} else {
> -		dtmprintk((MYIOC_s_WARN_FMT "Post-Diag Reset\n", ioc->name));
> +		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Post-Diag Reset\n", ioc->name));
>  
>  		/* Once a FW reload begins, all new OS commands are
>  		 * redirected to the doneQ w/ a reset status.
> @@ -2607,7 +2657,7 @@ mptscsih_ioc_reset(MPT_ADAPTER *ioc, int
>  			hd->cmdPtr = NULL;
>  		}
>  
> -		dtmprintk((MYIOC_s_WARN_FMT "Post-Reset complete.\n", ioc->name));
> +		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Post-Reset complete.\n", ioc->name));
>  
>  	}
>  
> @@ -2621,7 +2671,7 @@ mptscsih_event_process(MPT_ADAPTER *ioc,
>  	MPT_SCSI_HOST *hd;
>  	u8 event = le32_to_cpu(pEvReply->Event) & 0xFF;
>  
> -	devtverboseprintk((MYIOC_s_INFO_FMT "MPT event (=%02Xh) routed to SCSI host driver!\n",
> +	devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT "MPT event (=%02Xh) routed to SCSI host driver!\n",
>  			ioc->name, event));
>  
>  	if (ioc->sh == NULL ||
> @@ -2663,7 +2713,7 @@ mptscsih_event_process(MPT_ADAPTER *ioc,
>  	case MPI_EVENT_STATE_CHANGE:			/* 02 */
>  	case MPI_EVENT_EVENT_CHANGE:			/* 0A */
>  	default:
> -		dprintk((KERN_INFO "  Ignoring event (=%02Xh)\n", event));
> +		dprintk(ioc, printk(KERN_DEBUG MYNAM ": Ignoring event (=%02Xh)\n", event));
>  		break;
>  	}
>  
> @@ -2724,7 +2774,7 @@ mptscsih_scandv_complete(MPT_ADAPTER *io
>  	}
>  	hd->cmdPtr = NULL;
>  
> -	ddvprintk((MYIOC_s_INFO_FMT "ScanDvComplete (mf=%p,mr=%p,idx=%d)\n",
> +	ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ScanDvComplete (mf=%p,mr=%p,idx=%d)\n",
>  			hd->ioc->name, mf, mr, req_idx));
>  
>  	hd->pLocal = &hd->localReply;
> @@ -2744,9 +2794,6 @@ mptscsih_scandv_complete(MPT_ADAPTER *io
>  		status = le16_to_cpu(pReply->IOCStatus) & MPI_IOCSTATUS_MASK;
>  		scsi_status = pReply->SCSIStatus;
>  
> -		ddvtprintk((KERN_NOTICE "  IOCStatus=%04xh, SCSIState=%02xh, SCSIStatus=%02xh, IOCLogInfo=%08xh\n",
> -			     status, pReply->SCSIState, scsi_status,
> -			     le32_to_cpu(pReply->IOCLogInfo)));
>  
>  		switch(status) {
>  
> @@ -2799,7 +2846,7 @@ mptscsih_scandv_complete(MPT_ADAPTER *io
>  							SCSI_STD_SENSE_BYTES);
>  				memcpy(hd->pLocal->sense, sense_data, sz);
>  
> -				ddvprintk((KERN_NOTICE "  Check Condition, sense ptr %p\n",
> +				ddvprintk(ioc, printk(KERN_DEBUG "  Check Condition, sense ptr %p\n",
>  						sense_data));
>  			} else if (pReply->SCSIState & MPI_SCSI_STATE_AUTOSENSE_FAILED) {
>  				if (pReq->CDB[0] == INQUIRY)
> @@ -2830,8 +2877,6 @@ mptscsih_scandv_complete(MPT_ADAPTER *io
>  
>  		}	/* switch(status) */
>  
> -		ddvtprintk((KERN_NOTICE "  completionCode set to %08xh\n",
> -				completionCode));
>  	} /* end of address reply case */
>  
>  	hd->pLocal->completion = completionCode;
> @@ -2862,7 +2907,7 @@ mptscsih_timer_expired(unsigned long dat
>  {
>  	MPT_SCSI_HOST *hd = (MPT_SCSI_HOST *) data;
>  
> -	ddvprintk((MYIOC_s_WARN_FMT "Timer Expired! Cmd %p\n", hd->ioc->name, hd->cmdPtr));
> +	ddvprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT "Timer Expired! Cmd %p\n", hd->ioc->name, hd->cmdPtr));
>  
>  	if (hd->cmdPtr) {
>  		MPIHeader_t *cmd = (MPIHeader_t *)hd->cmdPtr;
> @@ -2874,7 +2919,6 @@ mptscsih_timer_expired(unsigned long dat
>  			 * If new eh code, do nothing. Wait for OS cmd timeout
>  			 *	for bus reset.
>  			 */
> -			ddvtprintk((MYIOC_s_NOTE_FMT "DV Cmd Timeout: NoOp\n", hd->ioc->name));
>  		} else {
>  			/* Perform a FW reload */
>  			if (mpt_HardResetHandler(hd->ioc, NO_SLEEP) < 0) {
> @@ -2891,7 +2935,7 @@ mptscsih_timer_expired(unsigned long dat
>  	 * The FW will reply to all outstanding commands, callback will finish cleanup.
>  	 * Hard reset clean-up will free all resources.
>  	 */
> -	ddvprintk((MYIOC_s_WARN_FMT "Timer Expired Complete!\n", hd->ioc->name));
> +	ddvprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT "Timer Expired Complete!\n", hd->ioc->name));
>  
>  	return;
>  }
> @@ -2932,7 +2976,7 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
>  
>  	in_isr = in_interrupt();
>  	if (in_isr) {
> -		dprintk((MYIOC_s_WARN_FMT "Internal SCSI IO request not allowed in ISR context!\n",
> +		dprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT "Internal SCSI IO request not allowed in ISR context!\n",
>         				hd->ioc->name));
>  		return -EPERM;
>  	}
> @@ -3035,7 +3079,7 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
>  	/* Get and Populate a free Frame
>  	 */
>  	if ((mf = mpt_get_msg_frame(hd->ioc->InternalCtx, hd->ioc)) == NULL) {
> -		ddvprintk((MYIOC_s_WARN_FMT "No msg frames!\n",
> +		ddvprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT "No msg frames!\n",
>  					hd->ioc->name));
>  		return -EBUSY;
>  	}
> @@ -3075,7 +3119,7 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
>  
>  	if (cmd == REQUEST_SENSE) {
>  		pScsiReq->Control = cpu_to_le32(dir | MPI_SCSIIO_CONTROL_UNTAGGED);
> -		ddvprintk((MYIOC_s_INFO_FMT "Untagged! 0x%2x\n",
> +		ddvprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT "Untagged! 0x%2x\n",
>  			hd->ioc->name, cmd));
>  	}
>  
> @@ -3086,7 +3130,7 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
>  	pScsiReq->SenseBufferLowAddr = cpu_to_le32(hd->ioc->sense_buf_low_dma
>  					   + (my_idx * MPT_SENSE_BUFFER_ALLOC));
>  
> -	ddvprintk((MYIOC_s_INFO_FMT "Sending Command 0x%x for (%d:%d:%d)\n",
> +	ddvprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT "Sending Command 0x%x for (%d:%d:%d)\n",
>  			hd->ioc->name, cmd, io->channel, io->id, io->lun));
>  
>  	if (dir == MPI_SCSIIO_CONTROL_READ) {
> @@ -3138,7 +3182,7 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
>  	} else {
>  		rc = -EFAULT;
>  		/* This should never happen. */
> -		ddvprintk((MYIOC_s_INFO_FMT "_do_cmd: Null pLocal!!!\n",
> +		ddvprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT "_do_cmd: Null pLocal!!!\n",
>  				hd->ioc->name));
>  	}
>  
> @@ -3324,6 +3368,35 @@ mptscsih_device_delay_show(struct class_
>  static CLASS_DEVICE_ATTR(device_delay, S_IRUGO,
>      mptscsih_device_delay_show, NULL);
>  
> +static ssize_t
> +mptscsih_debug_level_show(struct class_device *cdev, char *buf)
> +{
> +	struct Scsi_Host *host = class_to_shost(cdev);
> +	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
> +	MPT_ADAPTER *ioc = hd->ioc;
> +
> +	return snprintf(buf, PAGE_SIZE, "%08xh\n", ioc->debug_level);
> +}
> +static ssize_t
> +mptscsih_debug_level_store(struct class_device *cdev, const char *buf,
> +								size_t count)
> +{
> +	struct Scsi_Host *host = class_to_shost(cdev);
> +	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
> +	MPT_ADAPTER *ioc = hd->ioc;
> +	int val = 0;
> +
> +	if (sscanf(buf, "%x", &val) != 1)
> +		return -EINVAL;
> +
> +	ioc->debug_level = val;
> +	printk(MYIOC_s_INFO_FMT "debug_level=%08xh\n",
> +				ioc->name, ioc->debug_level);
> +	return strlen(buf);
> +}
> +static CLASS_DEVICE_ATTR(debug_level, S_IRUGO | S_IWUSR,
> +    mptscsih_debug_level_show, mptscsih_debug_level_store);
> +
>  struct class_device_attribute *mptscsih_host_attrs[] = {
>  	&class_device_attr_version_fw,
>  	&class_device_attr_version_bios,
> @@ -3336,6 +3409,7 @@ struct class_device_attribute *mptscsih_
>  	&class_device_attr_board_tracer,
>  	&class_device_attr_io_delay,
>  	&class_device_attr_device_delay,
> +	&class_device_attr_debug_level,
>  	NULL,
>  };
>  EXPORT_SYMBOL(mptscsih_host_attrs);
> -

NACK
This driver was already converted to accessors please
don't use old (going a way soon) scsi_cmnd members
directly

Boaz

