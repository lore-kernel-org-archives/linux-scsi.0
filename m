From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 3/14] lpfc 8.3.0 :  Add kernel-doc headers to lpfc_scsi.c
Date: Fri, 05 Dec 2008 08:31:59 -0800
Message-ID: <4939577F.1030804@oracle.com>
References: <1228448342.19053.39.camel@ogier>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet13.oracle.com ([148.87.113.125]:40921 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbYLEQcK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 11:32:10 -0500
In-Reply-To: <1228448342.19053.39.camel@ogier>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@emulex.com
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
> lpfc 8.3.0 : Add kernel-doc function headers to lpfc_scsi.c
> 
> Add kernel-doc function headers to lpfc_scsi.c
> 

Hi James,

kernel-doc is a small language, with a small bit of syntax. It's documented
in Documentation/kernel-doc-nano-HOWTO.txt.

I say this because all of the first lines (function name/short description)
use : instead of - to separate the name from the description.
Please fix those.

Also, the function name/short description can only be one line, so either make
it > 80 characters if needed, or use this format:

/**
 * lpfc_snaz - do some snazzy stuff
 * @hba: the target hba
 *
 * lpfc_snaz does some cool stuff and some hot stuff, such as-
 * - system snapshot to hba memory
 * - system check for infections and intrusions
 * - starts the coffee maker
 **/


> 
> Signed-off-by: James Smart <James.Smart@emulex.com>
> 
> ---
> 
>  drivers/scsi/lpfc/lpfc_scsi.c |  287 +++++++++++++++++++++++++++++++++++++++--
>  1 files changed, 274 insertions(+), 13 deletions(-)
> 
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -92,7 +92,6 @@ lpfc_update_stats(struct lpfc_hba *phba, struct  lpfc_scsi_buf *lpfc_cmd)
>  	spin_unlock_irqrestore(shost->host_lock, flags);
>  }
>  
> -
>  /**
>   * lpfc_send_sdev_queuedepth_change_event: Posts a queuedepth change
>   *                   event.
> @@ -148,10 +147,17 @@ lpfc_send_sdev_queuedepth_change_event(struct lpfc_hba *phba,
>  	return;
>  }
>  
> -/*
> - * This function is called with no lock held when there is a resource
> - * error in driver or in firmware.
> - */
> +/**
> + * lpfc_adjust_queue_depth: Post RAMP_DOWN_QUEUE event for worker thread.
> + * @phba: The Hba for which this call is being executed.
> + *
> + * This routine is called when there is resource error in driver or firmware.
> + * This routine posts WORKER_RAMP_DOWN_QUEUE event for @phba. This routine
> + * posts at most 1 event each second. This routine wakes up worker thread of
> + * @phba to process WORKER_RAM_DOWN_EVENT event.
> + *
> + * This routine should be called with no lock held.
> + **/
>  void
>  lpfc_adjust_queue_depth(struct lpfc_hba *phba)
>  {
> @@ -182,10 +188,17 @@ lpfc_adjust_queue_depth(struct lpfc_hba *phba)
>  	return;
>  }
>  
> -/*
> - * This function is called with no lock held when there is a successful
> - * SCSI command completion.
> - */
> +/**
> + * lpfc_rampup_queue_depth: Post RAMP_UP_QUEUE event for worker thread.
> + * @phba: The Hba for which this call is being executed.
> + *
> + * This routine post WORKER_RAMP_UP_QUEUE event for @phba vport. This routine
> + * post at most 1 event every 5 minute after last_ramp_up_time or
> + * last_rsrc_error_time.  This routine wakes up worker thread of @phba
> + * to process WORKER_RAM_DOWN_EVENT event.
> + *
> + * This routine should be called with no lock held.
> + **/
>  static inline void
>  lpfc_rampup_queue_depth(struct lpfc_vport  *vport,
>  			struct scsi_device *sdev)
> @@ -217,6 +230,14 @@ lpfc_rampup_queue_depth(struct lpfc_vport  *vport,
>  	return;
>  }
>  
> +/**
> + * lpfc_ramp_down_queue_handler: WORKER_RAMP_DOWN_QUEUE event handler.
> + * @phba: The Hba for which this call is being executed.
> + *
> + * This routine is called to  process WORKER_RAMP_DOWN_QUEUE event for worker
> + * thread.This routine reduces queue depth for all scsi device on each vport
> + * associated with @phba.
> + **/
>  void
>  lpfc_ramp_down_queue_handler(struct lpfc_hba *phba)
>  {
> @@ -267,6 +288,15 @@ lpfc_ramp_down_queue_handler(struct lpfc_hba *phba)
>  	atomic_set(&phba->num_cmd_success, 0);
>  }
>  
> +/**
> + * lpfc_ramp_up_queue_handler: WORKER_RAMP_UP_QUEUE event handler.
> + * @phba: The Hba for which this call is being executed.
> + *
> + * This routine is called to  process WORKER_RAMP_UP_QUEUE event for worker
> + * thread.This routine increases queue depth for all scsi device on each vport
> + * associated with @phba by 1. This routine also sets @phba num_rsrc_err and
> + * num_cmd_success to zero.
> + **/
>  void
>  lpfc_ramp_up_queue_handler(struct lpfc_hba *phba)
>  {
> @@ -336,14 +366,21 @@ lpfc_scsi_dev_block(struct lpfc_hba *phba)
>  	lpfc_destroy_vport_work_array(phba, vports);
>  }
>  
> -/*
> +/**
> + * lpfc_new_scsi_buf: Scsi buffer allocator.
> + * @vport: The virtual port for which this call being executed.
> + *
>   * This routine allocates a scsi buffer, which contains all the necessary
>   * information needed to initiate a SCSI I/O.  The non-DMAable buffer region
>   * contains information to build the IOCB.  The DMAable region contains
> - * memory for the FCP CMND, FCP RSP, and the inital BPL.  In addition to
> - * allocating memeory, the FCP CMND and FCP RSP BDEs are setup in the BPL
> + * memory for the FCP CMND, FCP RSP, and the initial BPL.  In addition to
> + * allocating memory, the FCP CMND and FCP RSP BDEs are setup in the BPL
>   * and the BPL BDE is setup in the IOCB.
> - */
> + *
> + * Return codes:
> + *   NULL - Error
> + *   Pointer to lpfc_scsi_buf data structure - Success
> + **/
>  static struct lpfc_scsi_buf *
>  lpfc_new_scsi_buf(struct lpfc_vport *vport)
>  {
> @@ -452,6 +489,17 @@ lpfc_new_scsi_buf(struct lpfc_vport *vport)
>  	return psb;
>  }
>  
> +/**
> + * lpfc_get_scsi_buf: Get a scsi buffer from lpfc_scsi_buf_list list of Hba.
> + * @phba: The Hba for which this call is being executed.
> + *
> + * This routine removes a scsi buffer from head of @phba lpfc_scsi_buf_list list
> + * and returns to caller.
> + *
> + * Return codes:
> + *   NULL - Error
> + *   Pointer to lpfc_scsi_buf - Success
> + **/
>  static struct lpfc_scsi_buf*
>  lpfc_get_scsi_buf(struct lpfc_hba * phba)
>  {
> @@ -469,6 +517,14 @@ lpfc_get_scsi_buf(struct lpfc_hba * phba)
>  	return  lpfc_cmd;
>  }
>  
> +/**
> + * lpfc_release_scsi_buf: Return a scsi buffer back to hba lpfc_scsi_buf_list list.
> + * @phba: The Hba for which this call is being executed.
> + * @psb: The scsi buffer which is being released.
> + *
> + * This routine releases @psb scsi buffer by adding it to tail of @phba
> + * lpfc_scsi_buf_list list.
> + **/
>  static void
>  lpfc_release_scsi_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
>  {
> @@ -480,6 +536,20 @@ lpfc_release_scsi_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
>  	spin_unlock_irqrestore(&phba->scsi_buf_list_lock, iflag);
>  }
>  
> +/**
> + * lpfc_scsi_prep_dma_buf: Routine to do DMA mapping for scsi buffer.
> + * @phba: The Hba for which this call is being executed.
> + * @lpfc_cmd: The scsi buffer which is going to be mapped.
> + *
> + * This routine does the pci dma mapping for scatter-gather list of scsi cmnd
> + * field of @lpfc_cmd. This routine scans through sg elements and format the
> + * bdea. This routine also initializes all IOCB fields which are dependent on
> + * scsi command request buffer.
> + *
> + * Return codes:
> + *   1 - Error
> + *   0 - Success
> + **/
>  static int
>  lpfc_scsi_prep_dma_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
>  {
> @@ -681,6 +751,15 @@ lpfc_send_scsi_error_event(struct lpfc_hba *phba, struct lpfc_vport *vport,
>  	lpfc_worker_wake_up(phba);
>  	return;
>  }
> +
> +/**
> + * lpfc_scsi_unprep_dma_buf: Routine to un-map DMA mapping of scatter gather.
> + * @phba: The Hba for which this call is being executed.
> + * @psb: The scsi buffer which is going to be un-mapped.
> + *
> + * This routine does DMA un-mapping of scatter gather list of scsi command
> + * field of @lpfc_cmd.
> + **/
>  static void
>  lpfc_scsi_unprep_dma_buf(struct lpfc_hba * phba, struct lpfc_scsi_buf * psb)
>  {
> @@ -694,6 +773,16 @@ lpfc_scsi_unprep_dma_buf(struct lpfc_hba * phba, struct lpfc_scsi_buf * psb)
>  		scsi_dma_unmap(psb->pCmd);
>  }
>  
> +/**
> + * lpfc_handler_fcp_err: FCP response handler.
> + * @vport: The virtual port for which this call is being executed.
> + * @lpfc_cmd: Pointer to lpfc_scsi_buf data structure.
> + * @rsp_iocb: The response IOCB which contains FCP error.
> + *
> + * This routine is called to process response IOCB with status field
> + * IOSTAT_FCP_RSP_ERROR. This routine sets result field of scsi command
> + * based upon SCSI and FCP error.
> + **/
>  static void
>  lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
>  		    struct lpfc_iocbq *rsp_iocb)
> @@ -828,6 +917,16 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
>  	lpfc_send_scsi_error_event(vport->phba, vport, lpfc_cmd, rsp_iocb);
>  }
>  
> +/**
> + * lpfc_scsi_cmd_iocb_cmpl: Scsi cmnd IOCB completion routine.
> + * @phba: The Hba for which this call is being executed.
> + * @pIocbIn: The command IOCBQ for the scsi cmnd.
> + * @pIocbOut: The response IOCBQ for the scsi cmnd .
> + *
> + * This routine assigns scsi command result by looking into response IOCB
> + * status field appropriately. This routine handles QUEUE FULL condition as
> + * well by ramping down device queue depth.
> + **/
>  static void
>  lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
>  			struct lpfc_iocbq *pIocbOut)
> @@ -1067,6 +1166,15 @@ lpfc_fcpcmd_to_iocb(uint8_t *data, struct fcp_cmnd *fcp_cmnd)
>  	}
>  }
>  
> +/**
> + * lpfc_scsi_prep_cmnd:  Routine to convert scsi cmnd to FCP information unit.
> + * @vport: The virtual port for which this call is being executed.
> + * @lpfc_cmd: The scsi command which needs to send.
> + * @pnode: Pointer to lpfc_nodelist.
> + *
> + * This routine initializes fcp_cmnd and iocb data structure from scsi command
> + * to transfer.
> + **/
>  static void
>  lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
>  		    struct lpfc_nodelist *pnode)
> @@ -1152,6 +1260,19 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
>  	piocbq->vport = vport;
>  }
>  
> +/**
> + * lpfc_scsi_prep_task_mgmt_cmnd: Convert scsi TM cmnd to FCP information unit.
> + * @vport: The virtual port for which this call is being executed.
> + * @lpfc_cmd: Pointer to lpfc_scsi_buf data structure.
> + * @lun: Logical unit number.
> + * @task_mgmt_cmd: SCSI task management command.
> + *
> + * This routine creates FCP information unit corresponding to @task_mgmt_cmd.
> + *
> + * Return codes:
> + *   0 - Error
> + *   1 - Success
> + **/
>  static int
>  lpfc_scsi_prep_task_mgmt_cmd(struct lpfc_vport *vport,
>  			     struct lpfc_scsi_buf *lpfc_cmd,
> @@ -1201,6 +1322,15 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc_vport *vport,
>  	return 1;
>  }
>  
> +/**
> + * lpc_taskmgmt_def_cmpl: IOCB completion routine for task management command.
> + * @phba: The Hba for which this call is being executed.
> + * @cmdiocbq: Pointer to lpfc_iocbq data structure.
> + * @rspiocbq: Pointer to lpfc_iocbq data structure.
> + *
> + * This routine is IOCB completion routine for device reset and target reset
> + * routine. This routine release scsi buffer associated with lpfc_cmd.
> + **/
>  static void
>  lpfc_tskmgmt_def_cmpl(struct lpfc_hba *phba,
>  			struct lpfc_iocbq *cmdiocbq,
> @@ -1213,6 +1343,20 @@ lpfc_tskmgmt_def_cmpl(struct lpfc_hba *phba,
>  	return;
>  }
>  
> +/**
> + * lpfc_scsi_tgt_reset: Target reset handler.
> + * @lpfc_cmd: Pointer to lpfc_scsi_buf data structure
> + * @vport: The virtual port for which this call is being executed.
> + * @tgt_id: Target ID.
> + * @lun: Lun number.
> + * @rdata: Pointer to lpfc_rport_data.
> + *
> + * This routine issues a TARGET RESET iocb to reset a target with @tgt_id ID.
> + *
> + * Return Code:
> + *   0x2003 - Error
> + *   0x2002 - Success.
> + **/
>  static int
>  lpfc_scsi_tgt_reset(struct lpfc_scsi_buf *lpfc_cmd, struct lpfc_vport *vport,
>  		    unsigned  tgt_id, unsigned int lun,
> @@ -1266,6 +1410,15 @@ lpfc_scsi_tgt_reset(struct lpfc_scsi_buf *lpfc_cmd, struct lpfc_vport *vport,
>  	return ret;
>  }
>  
> +/**
> + * lpfc_info: Info entry point of scsi_host_template data structure.
> + * @host: The scsi host for which this call is being executed.
> + *
> + * This routine provides module information about hba.
> + *
> + * Reutrn code:
> + *   Pointer to char - Success.
> + **/
>  const char *
>  lpfc_info(struct Scsi_Host *host)
>  {
> @@ -1295,6 +1448,13 @@ lpfc_info(struct Scsi_Host *host)
>  	return lpfcinfobuf;
>  }
>  
> +/**
> + * lpfc_poll_rearm_time: Routine to modify fcp_poll timer of hba.
> + * @phba: The Hba for which this call is being executed.
> + *
> + * This routine modifies fcp_poll_timer  field of @phba by cfg_poll_tmo.
> + * The default value of cfg_poll_tmo is 10 milliseconds.
> + **/
>  static __inline__ void lpfc_poll_rearm_timer(struct lpfc_hba * phba)
>  {
>  	unsigned long  poll_tmo_expires =
> @@ -1305,11 +1465,25 @@ static __inline__ void lpfc_poll_rearm_timer(struct lpfc_hba * phba)
>  			  poll_tmo_expires);
>  }
>  
> +/**
> + * lpfc_poll_start_timer: Routine to start fcp_poll_timer of HBA.
> + * @phba: The Hba for which this call is being executed.
> + *
> + * This routine starts the fcp_poll_timer of @phba.
> + **/
>  void lpfc_poll_start_timer(struct lpfc_hba * phba)
>  {
>  	lpfc_poll_rearm_timer(phba);
>  }
>  
> +/**
> + * lpfc_poll_timeout: Restart polling timer.
> + * @ptr: Map to lpfc_hba data structure pointer.
> + *
> + * This routine restarts fcp_poll timer, when FCP ring  polling is enable
> + * and FCP Ring interrupt is disable.
> + **/
> +
>  void lpfc_poll_timeout(unsigned long ptr)
>  {
>  	struct lpfc_hba *phba = (struct lpfc_hba *) ptr;
> @@ -1321,6 +1495,20 @@ void lpfc_poll_timeout(unsigned long ptr)
>  	}
>  }
>  
> +/**
> + * lpfc_queuecommand: Queuecommand entry point of Scsi Host Templater data
> + * structure.
> + * @cmnd: Pointer to scsi_cmnd data structure.
> + * @done: Pointer to done routine.
> + *
> + * Driver registers this routine to scsi midlayer to submit a @cmd to process.
> + * This routine prepares an IOCB from scsi command and provides to firmware.
> + * The @done callback is invoked after driver finished processing the command.
> + *
> + * Return value :
> + *   0 - Success
> + *   SCSI_MLQUEUE_HOST_BUSY - Block all devices served by this host temporarily.
> + **/
>  static int
>  lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
>  {
> @@ -1405,6 +1593,12 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
>  	return 0;
>  }
>  
> +/**
> + * lpfc_block_error_handler: Routine to block error  handler.
> + * @cmnd: Pointer to scsi_cmnd data structure.
> + *
> + *  This routine blocks execution till fc_rport state is not FC_PORSTAT_BLCOEKD.
> + **/
>  static void
>  lpfc_block_error_handler(struct scsi_cmnd *cmnd)
>  {
> @@ -1421,6 +1615,17 @@ lpfc_block_error_handler(struct scsi_cmnd *cmnd)
>  	return;
>  }
>  
> +/**
> + * lpfc_abort_handler: Eh_abort_handler entry point of Scsi Host Template data
> + *structure.
> + * @cmnd: Pointer to scsi_cmnd data structure.
> + *
> + * This routine aborts @cmnd pending in base driver.
> + *
> + * Return code :
> + *   0x2003 - Error
> + *   0x2002 - Success
> + **/
>  static int
>  lpfc_abort_handler(struct scsi_cmnd *cmnd)
>  {
> @@ -1516,6 +1721,18 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
>  	return ret;
>  }
>  
> +/**
> + * lpfc_device_reset_handler: eh_device_reset entry point of Scsi Host Template
> + *data structure.
> + * @cmnd: Pointer to scsi_cmnd data structure.
> + *
> + * This routine does a device reset by sending a TARGET_RESET task management
> + * command.
> + *
> + * Return code :
> + *  0x2003 - Error
> + *  0ex2002 - Success
> + **/
>  static int
>  lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
>  {
> @@ -1633,6 +1850,17 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
>  	return ret;
>  }
>  
> +/**
> + * lpfc_bus_reset_handler: eh_bus_reset_handler entry point of Scsi Host
> + * Template data structure.
> + * @cmnd: Pointer to scsi_cmnd data structure.
> + *
> + * This routine does target reset to all target on @cmnd->device->host.
> + *
> + * Return Code:
> + *   0x2003 - Error
> + *   0x2002 - Success
> + **/
>  static int
>  lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
>  {
> @@ -1723,6 +1951,20 @@ lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
>  	return ret;
>  }
>  
> +/**
> + * lpfc_slave_alloc: slave_alloc entry point of Scsi Host Template data
> + * structure.
> + * @sdev: Pointer to scsi_device.
> + *
> + * This routine populates the cmds_per_lun count + 2 scsi_bufs into  this host's
> + * globally available list of scsi buffers. This routine also makes sure scsi
> + * buffer is not allocated more than HBA limit conveyed to midlayer. This list
> + * of scsi buffer exists for the lifetime of the driver.
> + *
> + * Return codes:
> + *   non-0 - Error
> + *   0 - Success
> + **/
>  static int
>  lpfc_slave_alloc(struct scsi_device *sdev)
>  {
> @@ -1784,6 +2026,19 @@ lpfc_slave_alloc(struct scsi_device *sdev)
>  	return 0;
>  }
>  
> +/**
> + * lpfc_slave_configure: slave_configure entry point of Scsi Host Templater data
> + *  structure.
> + * @sdev: Pointer to scsi_device.
> + *
> + * This routine configures following items
> + *   - Tag command queuing support for @sdev if supported.
> + *   - Dev loss time out value of fc_rport.
> + *   - Enable SLI polling for fcp ring if ENABLE_FCP_RING_POLLING flag is set.
> + *
> + * Return codes:
> + *   0 - Success
> + **/
>  static int
>  lpfc_slave_configure(struct scsi_device *sdev)
>  {
> @@ -1813,6 +2068,12 @@ lpfc_slave_configure(struct scsi_device *sdev)
>  	return 0;
>  }
>  
> +/**
> + * lpfc_slave_destroy: slave_destroy entry point of SHT data structure.
> + * @sdev: Pointer to scsi_device.
> + *
> + * This routine sets @sdev hostatdata filed to null.
> + **/
>  static void
>  lpfc_slave_destroy(struct scsi_device *sdev)
>  {

