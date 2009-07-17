From: "Abhijeet Joglekar (abjoglek)" <abjoglek@cisco.com>
Subject: RE: [PATCH] fnic: clean up
Date: Fri, 17 Jul 2009 10:14:14 -0700
Message-ID: <9E88C8678BF34240A8C61D4078A3D25101A2500A@xmb-sjc-23e.amer.cisco.com>
References: <4A5E4648.5020006@gmail.com> <4A5F0DAE.5010800@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:61591 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934773AbZGQROP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2009 13:14:15 -0400
Content-class: urn:content-classes:message
In-Reply-To: <4A5F0DAE.5010800@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Cc: "Joe Eykholt (jeykholt)" <jeykholt@cisco.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

> -----Original Message-----
> From: Roel Kluin [mailto:roel.kluin@gmail.com] 
> Sent: Thursday, July 16, 2009 4:23 AM
> To: Abhijeet Joglekar (abjoglek)
> Cc: Joe Eykholt (jeykholt); linux-scsi@vger.kernel.org; Andrew Morton
> Subject: [PATCH] fnic: clean up
> 
> In fnic_abort_cmd() and  fnic_device_reset() assign `rport' 
> earlier to make FNIC_SCSI_DBG() calls cleaner.
> 
> In fnic_clean_pending_aborts() `rport' is not used.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> thanks abhijeet, is this ackable?


Yes, this looks good. 

thanks
-- abhijeet

 
> diff --git a/drivers/scsi/fnic/fnic_scsi.c 
> b/drivers/scsi/fnic/fnic_scsi.c index bfc9969..c04b7e8 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -1265,11 +1265,10 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
>  	lp = shost_priv(sc->device->host);
>  
>  	fnic = lport_priv(lp);
> -	FNIC_SCSI_DBG(KERN_DEBUG,
> -		      fnic->lport->host,
> -		      "Abort Cmd called FCID 0x%x, LUN 0x%x TAG %d\n",
> -		      
> (starget_to_rport(scsi_target(sc->device)))->port_id,
> -		      sc->device->lun, sc->request->tag);
> +	rport = starget_to_rport(scsi_target(sc->device));
> +	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> +			"Abort Cmd called FCID 0x%x, LUN 0x%x TAG %d\n",
> +			rport->port_id, sc->device->lun, 
> sc->request->tag);
>  
>  	if (lp->state != LPORT_ST_READY || !(lp->link_up)) {
>  		ret = FAILED;
> @@ -1318,7 +1317,6 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
>  	 * port is up, then send abts to the remote port to terminate
>  	 * the IO. Else, just locally terminate the IO in the firmware
>  	 */
> -	rport = starget_to_rport(scsi_target(sc->device));
>  	if (fc_remote_port_chkready(rport) == 0)
>  		task_req = FCPIO_ITMF_ABT_TASK;
>  	else
> @@ -1437,7 +1435,6 @@ static int 
> fnic_clean_pending_aborts(struct fnic *fnic,
>  	unsigned long flags;
>  	int ret = 0;
>  	struct scsi_cmnd *sc;
> -	struct fc_rport *rport;
>  	struct scsi_lun fc_lun;
>  	struct scsi_device *lun_dev = lr_sc->device;
>  	DECLARE_COMPLETION_ONSTACK(tm_done);
> @@ -1477,7 +1474,6 @@ static int 
> fnic_clean_pending_aborts(struct fnic *fnic,
>  
>  		/* Now queue the abort command to firmware */
>  		int_to_scsilun(sc->device->lun, &fc_lun);
> -		rport = starget_to_rport(scsi_target(sc->device));
>  
>  		if (fnic_queue_abort_io_req(fnic, tag,
>  					    FCPIO_ITMF_ABT_TASK_TERM,
> @@ -1547,18 +1543,16 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>  	lp = shost_priv(sc->device->host);
>  
>  	fnic = lport_priv(lp);
> -	FNIC_SCSI_DBG(KERN_DEBUG,
> -		      fnic->lport->host,
> -		      "Device reset called FCID 0x%x, LUN 0x%x\n",
> -		      
> (starget_to_rport(scsi_target(sc->device)))->port_id,
> -		      sc->device->lun);
>  
> +	rport = starget_to_rport(scsi_target(sc->device));
> +	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> +			"Device reset called FCID 0x%x, LUN 0x%x\n",
> +			rport->port_id, sc->device->lun);
>  
>  	if (lp->state != LPORT_ST_READY || !(lp->link_up))
>  		goto fnic_device_reset_end;
>  
>  	/* Check if remote port up */
> -	rport = starget_to_rport(scsi_target(sc->device));
>  	if (fc_remote_port_chkready(rport))
>  		goto fnic_device_reset_end;
>  
> 
