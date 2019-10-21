Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1318CA9EAF
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 23:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65B5020882
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 23:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730515AbfJUXRg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 19:17:36 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:52580 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729606AbfJUXRf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Oct 2019 19:17:35 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 2C9AE29E53;
        Mon, 21 Oct 2019 19:17:31 -0400 (EDT)
Date:   Tue, 22 Oct 2019 10:17:28 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Hannes Reinecke <hare@suse.de>
cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 05/24] scsi: use standard SAM status codes
In-Reply-To: <20191021095322.137969-6-hare@suse.de>
Message-ID: <alpine.LNX.2.21.1910220956400.14@nippy.intranet>
References: <20191021095322.137969-1-hare@suse.de> <20191021095322.137969-6-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 21 Oct 2019, Hannes Reinecke wrote:

> Use standard SAM status codes and omit the explicit shift to convert
> to linus-specific ones.

"Linux-specific".

-- 

> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/ata/libata-scsi.c             |  2 +-
>  drivers/infiniband/ulp/srp/ib_srp.c   |  2 +-
>  drivers/scsi/3w-9xxx.c                |  5 +++--
>  drivers/scsi/3w-sas.c                 |  3 ++-
>  drivers/scsi/3w-xxxx.c                |  4 ++--
>  drivers/scsi/arcmsr/arcmsr_hba.c      |  4 ++--
>  drivers/scsi/bfa/bfad_im.c            |  2 +-
>  drivers/scsi/dc395x.c                 | 18 +++++-------------
>  drivers/scsi/dpt_i2o.c                |  2 +-
>  drivers/scsi/gdth.c                   | 12 ++++++------
>  drivers/scsi/megaraid.c               | 10 +++++-----
>  drivers/scsi/megaraid/megaraid_mbox.c | 12 ++++++------
>  12 files changed, 35 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 76d0f9de767b..b197d2fbe3f8 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -856,7 +856,7 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
>  		if (cmd->request->rq_flags & RQF_QUIET)
>  			qc->flags |= ATA_QCFLAG_QUIET;
>  	} else {
> -		cmd->result = (DID_OK << 16) | (QUEUE_FULL << 1);
> +		cmd->result = (DID_OK << 16) | SAM_STAT_TASK_SET_FULL;
>  		cmd->scsi_done(cmd);
>  	}
>  
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index b5960351bec0..4570e3c79ea5 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -2404,7 +2404,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
>  		 * to reduce queue depth temporarily.
>  		 */
>  		scmnd->result = len == -ENOMEM ?
> -			DID_OK << 16 | QUEUE_FULL << 1 : DID_ERROR << 16;
> +			DID_OK << 16 | SAM_STAT_TASK_SET_FULL : DID_ERROR << 16;
>  		goto err_iu;
>  	}
>  
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index 3337b1e80412..ada77c136f8b 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -1018,7 +1018,8 @@ static int twa_fill_sense(TW_Device_Extension *tw_dev, int request_id, int copy_
>  
>  	if (copy_sense) {
>  		memcpy(tw_dev->srb[request_id]->sense_buffer, full_command_packet->header.sense_data, TW_SENSE_DATA_LENGTH);
> -		tw_dev->srb[request_id]->result = (full_command_packet->command.newcommand.status << 1);
> +		tw_dev->srb[request_id]->result =
> +			full_command_packet->command.newcommand.status;
>  		retval = TW_ISR_DONT_RESULT;
>  		goto out;
>  	}
> @@ -1342,7 +1343,7 @@ static irqreturn_t twa_interrupt(int irq, void *dev_instance)
>  				/* If error, command failed */
>  				if (error == 1) {
>  					/* Ask for a host reset */
> -					cmd->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
> +					cmd->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
>  				}
>  
>  				/* Report residual bytes for single sgl */
> diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
> index dda6fa857709..d11f62c60877 100644
> --- a/drivers/scsi/3w-sas.c
> +++ b/drivers/scsi/3w-sas.c
> @@ -891,7 +891,8 @@ static int twl_fill_sense(TW_Device_Extension *tw_dev, int i, int request_id, in
>  
>  	if (copy_sense) {
>  		memcpy(tw_dev->srb[request_id]->sense_buffer, header->sense_data, TW_SENSE_DATA_LENGTH);
> -		tw_dev->srb[request_id]->result = (full_command_packet->command.newcommand.status << 1);
> +		tw_dev->srb[request_id]->result =
> +			full_command_packet->command.newcommand.status;
>  		goto out;
>  	}
>  out:
> diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
> index 2b1e0d503020..79eca8f1fd05 100644
> --- a/drivers/scsi/3w-xxxx.c
> +++ b/drivers/scsi/3w-xxxx.c
> @@ -429,7 +429,7 @@ static int tw_decode_sense(TW_Device_Extension *tw_dev, int request_id, int fill
>  					/* Additional sense code qualifier */
>  					tw_dev->srb[request_id]->sense_buffer[13] = tw_sense_table[i][3];
>  
> -					tw_dev->srb[request_id]->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
> +					tw_dev->srb[request_id]->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
>  					return TW_ISR_DONT_RESULT; /* Special case for isr to not over-write result */
>  				}
>  			}
> @@ -2164,7 +2164,7 @@ static irqreturn_t tw_interrupt(int irq, void *dev_instance)
>  				/* If error, command failed */
>  				if (error == 1) {
>  					/* Ask for a host reset */
> -					tw_dev->srb[request_id]->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
> +					tw_dev->srb[request_id]->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
>  				}
>  
>  				/* Now complete the io */
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> index 88053b15c363..89eda0c79349 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -1271,7 +1271,7 @@ static void arcmsr_report_sense_info(struct CommandControlBlock *ccb)
>  
>  	struct scsi_cmnd *pcmd = ccb->pcmd;
>  	struct SENSE_DATA *sensebuffer = (struct SENSE_DATA *)pcmd->sense_buffer;
> -	pcmd->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
> +	pcmd->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
>  	if (sensebuffer) {
>  		int sense_data_length =
>  			sizeof(struct SENSE_DATA) < SCSI_SENSE_BUFFERSIZE
> @@ -3110,7 +3110,7 @@ static int arcmsr_queue_command_lck(struct scsi_cmnd *cmd,
>  	if (!ccb)
>  		return SCSI_MLQUEUE_HOST_BUSY;
>  	if (arcmsr_build_ccb( acb, ccb, cmd ) == FAILED) {
> -		cmd->result = (DID_ERROR << 16) | (RESERVATION_CONFLICT << 1);
> +		cmd->result = (DID_ERROR << 16) | SAM_STAT_RESERVATION_CONFLICT;
>  		cmd->scsi_done(cmd);
>  		return 0;
>  	}
> diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
> index 6b5841b1c06e..e3cbe5d20aca 100644
> --- a/drivers/scsi/bfa/bfad_im.c
> +++ b/drivers/scsi/bfa/bfad_im.c
> @@ -150,7 +150,7 @@ bfa_cb_tskim_done(void *bfad, struct bfad_tskim_s *dtsk,
>  	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dtsk;
>  	wait_queue_head_t *wq;
>  
> -	cmnd->SCp.Status |= tsk_status << 1;
> +	cmnd->SCp.Status |= tsk_status;
>  	set_bit(IO_DONE_BIT, (unsigned long *)&cmnd->SCp.Status);
>  	wq = (wait_queue_head_t *) cmnd->SCp.ptr;
>  	cmnd->SCp.ptr = NULL;
> diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
> index 13fbb2eab842..a56893bc681e 100644
> --- a/drivers/scsi/dc395x.c
> +++ b/drivers/scsi/dc395x.c
> @@ -168,7 +168,6 @@
>  #define RES_DRV			0xFF000000	/* DRIVER_ codes */
>  
>  #define MK_RES(drv,did,msg,tgt) ((int)(drv)<<24 | (int)(did)<<16 | (int)(msg)<<8 | (int)(tgt))
> -#define MK_RES_LNX(drv,did,msg,tgt) ((int)(drv)<<24 | (int)(did)<<16 | (int)(msg)<<8 | (int)(tgt)<<1)
>  
>  #define SET_RES_TARGET(who,tgt) { who &= ~RES_TARGET; who |= (int)(tgt); }
>  #define SET_RES_TARGET_LNX(who,tgt) { who &= ~RES_TARGET_LNX; who |= (int)(tgt) << 1; }
> @@ -3228,7 +3227,7 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
>  		 */
>  		srb->flag &= ~AUTO_REQSENSE;
>  		srb->adapter_status = 0;
> -		srb->target_status = CHECK_CONDITION << 1;
> +		srb->target_status = SAM_STAT_CHECK_CONDITION;
>  		if (debug_enabled(DBG_1)) {
>  			switch (cmd->sense_buffer[2] & 0x0f) {
>  			case NOT_READY:
> @@ -3275,22 +3274,15 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
>  					*((unsigned int *)(cmd->sense_buffer + 3)));
>  		}
>  
> -		if (status == (CHECK_CONDITION << 1)) {
> +		if (status == SAM_STAT_CHECK_CONDITION) {
>  			cmd->result = DID_BAD_TARGET << 16;
>  			goto ckc_e;
>  		}
>  		dprintkdbg(DBG_0, "srb_done: AUTO_REQSENSE2\n");
>  
> -		if (srb->total_xfer_length
> -		    && srb->total_xfer_length >= cmd->underflow)
> -			cmd->result =
> -			    MK_RES_LNX(DRIVER_SENSE, DID_OK,
> -				       srb->end_message, CHECK_CONDITION);
> -		/*SET_RES_DID(cmd->result,DID_OK) */
> -		else
> -			cmd->result =
> -			    MK_RES_LNX(DRIVER_SENSE, DID_OK,
> -				       srb->end_message, CHECK_CONDITION);
> +		cmd->result =
> +		    MK_RES(DRIVER_SENSE, DID_OK,
> +			   srb->end_message, SAM_STAT_CHECK_CONDITION);
>  
>  		goto ckc_e;
>  	}
> diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
> index abc74fd474dc..83576fd694c4 100644
> --- a/drivers/scsi/dpt_i2o.c
> +++ b/drivers/scsi/dpt_i2o.c
> @@ -2656,7 +2656,7 @@ static void adpt_fail_posted_scbs(adpt_hba* pHba)
>  		unsigned long flags;
>  		spin_lock_irqsave(&d->list_lock, flags);
>  		list_for_each_entry(cmd, &d->cmd_list, list) {
> -			cmd->result = (DID_OK << 16) | (QUEUE_FULL <<1);
> +			cmd->result = (DID_OK << 16) | SAM_STAT_TASK_SET_FULL;
>  			cmd->scsi_done(cmd);
>  		}
>  		spin_unlock_irqrestore(&d->list_lock, flags);
> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> index fe03410268e6..d23e277c1b85 100644
> --- a/drivers/scsi/gdth.c
> +++ b/drivers/scsi/gdth.c
> @@ -1677,7 +1677,7 @@ static void gdth_next(gdth_ha_str *ha)
>                  memset((char*)nscp->sense_buffer,0,16);
>                  nscp->sense_buffer[0] = 0x70;
>                  nscp->sense_buffer[2] = NOT_READY;
> -                nscp->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
> +		nscp->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
>                  if (!nscp_cmndinfo->wait_for_completion)
>                      nscp_cmndinfo->wait_for_completion++;
>                  else
> @@ -1722,7 +1722,7 @@ static void gdth_next(gdth_ha_str *ha)
>                      memset((char*)nscp->sense_buffer,0,16);
>                      nscp->sense_buffer[0] = 0x70;
>                      nscp->sense_buffer[2] = UNIT_ATTENTION;
> -                    nscp->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
> +		    nscp->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
>                      if (!nscp_cmndinfo->wait_for_completion)
>                          nscp_cmndinfo->wait_for_completion++;
>                      else
> @@ -1774,7 +1774,7 @@ static void gdth_next(gdth_ha_str *ha)
>                      memset((char*)nscp->sense_buffer,0,16);
>                      nscp->sense_buffer[0] = 0x70;
>                      nscp->sense_buffer[2] = UNIT_ATTENTION;
> -                    nscp->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
> +		    nscp->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
>                      if (!nscp_cmndinfo->wait_for_completion)
>                          nscp_cmndinfo->wait_for_completion++;
>                      else
> @@ -2802,7 +2802,7 @@ static int gdth_sync_event(gdth_ha_str *ha, int service, u8 index,
>                  memset((char*)scp->sense_buffer,0,16);
>                  scp->sense_buffer[0] = 0x70;
>                  scp->sense_buffer[2] = NOT_READY;
> -                scp->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
> +		scp->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
>              } else if (service == CACHESERVICE) {
>                  if (ha->status == S_CACHE_UNKNOWN &&
>                      (ha->hdr[t].cluster_type & 
> @@ -2812,11 +2812,11 @@ static int gdth_sync_event(gdth_ha_str *ha, int service, u8 index,
>                  }
>                  memset((char*)scp->sense_buffer,0,16);
>                  if (ha->status == (u16)S_CACHE_RESERV) {
> -                    scp->result = (DID_OK << 16) | (RESERVATION_CONFLICT << 1);
> +                    scp->result = (DID_OK << 16) | SAM_STAT_RESERVATION_CONFLICT;
>                  } else {
>                      scp->sense_buffer[0] = 0x70;
>                      scp->sense_buffer[2] = NOT_READY;
> -                    scp->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
> +                    scp->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
>                  }
>                  if (!cmndinfo->internal_command) {
>                      ha->dvr.size = sizeof(ha->dvr.eu.sync);
> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> index ff6d4aa92421..21e190c38b97 100644
> --- a/drivers/scsi/megaraid.c
> +++ b/drivers/scsi/megaraid.c
> @@ -1581,7 +1581,7 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
>  
>  				cmd->result = (DRIVER_SENSE << 24) |
>  					(DID_OK << 16) |
> -					(CHECK_CONDITION << 1);
> +					SAM_STAT_CHECK_CONDITION;
>  			}
>  			else {
>  				if (mbox->m_out.cmd == MEGA_MBOXCMD_EXTPTHRU) {
> @@ -1591,11 +1591,11 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
>  
>  					cmd->result = (DRIVER_SENSE << 24) |
>  						(DID_OK << 16) |
> -						(CHECK_CONDITION << 1);
> +						SAM_STAT_CHECK_CONDITION;
>  				} else {
>  					cmd->sense_buffer[0] = 0x70;
>  					cmd->sense_buffer[2] = ABORTED_COMMAND;
> -					cmd->result |= (CHECK_CONDITION << 1);
> +					cmd->result |= SAM_STAT_CHECK_CONDITION;
>  				}
>  			}
>  			break;
> @@ -1613,7 +1613,7 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
>  			 */
>  			if( cmd->cmnd[0] == TEST_UNIT_READY ) {
>  				cmd->result |= (DID_ERROR << 16) |
> -					(RESERVATION_CONFLICT << 1);
> +					SAM_STAT_RESERVATION_CONFLICT;
>  			}
>  			else
>  			/*
> @@ -1625,7 +1625,7 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
>  					 cmd->cmnd[0] == RELEASE) ) {
>  
>  				cmd->result |= (DID_ERROR << 16) |
> -					(RESERVATION_CONFLICT << 1);
> +					SAM_STAT_RESERVATION_CONFLICT;
>  			}
>  			else
>  #endif
> diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
> index f6ac819e6e96..dc58c5ff31e4 100644
> --- a/drivers/scsi/megaraid/megaraid_mbox.c
> +++ b/drivers/scsi/megaraid/megaraid_mbox.c
> @@ -1577,7 +1577,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
>  				scp->sense_buffer[0] = 0x70;
>  				scp->sense_buffer[2] = ILLEGAL_REQUEST;
>  				scp->sense_buffer[12] = MEGA_INVALID_FIELD_IN_CDB;
> -				scp->result = CHECK_CONDITION << 1;
> +				scp->result = SAM_STAT_CHECK_CONDITION;
>  				return NULL;
>  			}
>  
> @@ -2302,7 +2302,7 @@ megaraid_mbox_dpc(unsigned long devp)
>  						14);
>  
>  				scp->result = DRIVER_SENSE << 24 |
> -					DID_OK << 16 | CHECK_CONDITION << 1;
> +					DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
>  			}
>  			else {
>  				if (mbox->cmd == MBOXCMD_EXTPTHRU) {
> @@ -2312,11 +2312,11 @@ megaraid_mbox_dpc(unsigned long devp)
>  
>  					scp->result = DRIVER_SENSE << 24 |
>  						DID_OK << 16 |
> -						CHECK_CONDITION << 1;
> +						SAM_STAT_CHECK_CONDITION;
>  				} else {
>  					scp->sense_buffer[0] = 0x70;
>  					scp->sense_buffer[2] = ABORTED_COMMAND;
> -					scp->result = CHECK_CONDITION << 1;
> +					scp->result = SAM_STAT_CHECK_CONDITION;
>  				}
>  			}
>  			break;
> @@ -2334,7 +2334,7 @@ megaraid_mbox_dpc(unsigned long devp)
>  			 */
>  			if (scp->cmnd[0] == TEST_UNIT_READY) {
>  				scp->result = DID_ERROR << 16 |
> -					RESERVATION_CONFLICT << 1;
> +					SAM_STAT_RESERVATION_CONFLICT;
>  			}
>  			else
>  			/*
> @@ -2345,7 +2345,7 @@ megaraid_mbox_dpc(unsigned long devp)
>  					 scp->cmnd[0] == RELEASE)) {
>  
>  				scp->result = DID_ERROR << 16 |
> -					RESERVATION_CONFLICT << 1;
> +					SAM_STAT_RESERVATION_CONFLICT;
>  			}
>  			else {
>  				scp->result = DID_BAD_TARGET << 16 | status;
> 
