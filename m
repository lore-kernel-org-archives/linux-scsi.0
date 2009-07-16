From: "Abhijeet Joglekar (abjoglek)" <abjoglek@cisco.com>
Subject: RE: NULL check after starget_to_rport()?
Date: Thu, 16 Jul 2009 01:28:20 -0700
Message-ID: <9E88C8678BF34240A8C61D4078A3D25101A248E9@xmb-sjc-23e.amer.cisco.com>
References: <4A5E4648.5020006@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-2.cisco.com ([171.71.176.71]:2334 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbZGPI2V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2009 04:28:21 -0400
Content-class: urn:content-classes:message
In-Reply-To: <4A5E4648.5020006@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>, "Joe Eykholt (jeykholt)" <jeykholt@cisco.com>, linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Roel Kluin [mailto:roel.kluin@gmail.com] 
> Sent: Wednesday, July 15, 2009 2:13 PM
> To: Abhijeet Joglekar (abjoglek); Joe Eykholt (jeykholt); 
> linux-scsi@vger.kernel.org
> Subject: NULL check after starget_to_rport()?
> 
> // vi include/scsi/scsi_transport_fc.h +396
> #define starget_to_rport(s)			\
> 	scsi_is_fc_rport(s->dev.parent) ? 
> dev_to_rport(s->dev.parent) : NULL
> 
> So shouldn't we test for this NULL value (something like the 
> untested patch
> below?)

I think scsi_is_fc_rport(s->dev.parent) should always be true since the
discovered scsi targets are all fc remote ports created by
fc_remote_port_add(). So, NULL check should not be required on the
rport.

> Also I had two more questions concerning this file:
> 
> In fnic_clean_pending_aborts(), rport isn't used after the 
> starget_to_rport().
> is the rport needed?

No, it can be removed.
 
> Should fnic_block_error_handler() return an error value if 
> rport is NULL?

Same as above, it should not be NULL, since the target dev's parent
should be an fc rport.

thanks
-- abhijeet

> Roel
> 
> diff --git a/drivers/scsi/fnic/fnic_scsi.c 
> b/drivers/scsi/fnic/fnic_scsi.c index bfc9969..8a6bb3e 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -346,6 +346,9 @@ int fnic_queuecommand(struct scsi_cmnd 
> *sc, void (*done)(struct scsi_cmnd *))
>  	unsigned long ptr;
>  
>  	rport = starget_to_rport(scsi_target(sc->device));
> +	if (rport == NULL)
> +		return 0;
> +
>  	ret = fc_remote_port_chkready(rport);
>  	if (ret) {
>  		sc->result = ret;
> @@ -1230,6 +1233,9 @@ static void 
> fnic_block_error_handler(struct scsi_cmnd *sc)
>  	struct fc_rport *rport = 
> starget_to_rport(scsi_target(sc->device));
>  	unsigned long flags;
>  
> +	if (rport == NULL)
> +		return;
> +
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	while (rport->port_state == FC_PORTSTATE_BLOCKED) {
>  		spin_unlock_irqrestore(shost->host_lock, 
> flags); @@ -1265,11 +1271,12 @@ int fnic_abort_cmd(struct 
> scsi_cmnd *sc)
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
> +	if (rport != NULL)
> +		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> +				"Abort Cmd called FCID 0x%x, 
> LUN 0x%x TAG %d\n",
> +				rport->port_id, sc->device->lun,
> +				sc->request->tag);
>  
>  	if (lp->state != LPORT_ST_READY || !(lp->link_up)) {
>  		ret = FAILED;
> @@ -1319,6 +1326,9 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
>  	 * the IO. Else, just locally terminate the IO in the firmware
>  	 */
>  	rport = starget_to_rport(scsi_target(sc->device));
> +	if (rport == NULL)
> +		goto fnic_abort_cmd_end;
> +
>  	if (fc_remote_port_chkready(rport) == 0)
>  		task_req = FCPIO_ITMF_ABT_TASK;
>  	else
> @@ -1478,6 +1488,8 @@ static int 
> fnic_clean_pending_aborts(struct fnic *fnic,
>  		/* Now queue the abort command to firmware */
>  		int_to_scsilun(sc->device->lun, &fc_lun);
>  		rport = starget_to_rport(scsi_target(sc->device));
> +		if (rport == NULL)
> +			goto clean_pending_aborts_end;
>  
>  		if (fnic_queue_abort_io_req(fnic, tag,
>  					    FCPIO_ITMF_ABT_TASK_TERM,
> @@ -1547,19 +1559,19 @@ int fnic_device_reset(struct scsi_cmnd *sc)
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
> +	if (rport != NULL)
> +		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> +				"Device reset called FCID 0x%x, 
> LUN 0x%x\n",
> +				rport->port_id, sc->device->lun);
>  
>  	if (lp->state != LPORT_ST_READY || !(lp->link_up))
>  		goto fnic_device_reset_end;
>  
>  	/* Check if remote port up */
>  	rport = starget_to_rport(scsi_target(sc->device));
> -	if (fc_remote_port_chkready(rport))
> +	if (rport == NULL || fc_remote_port_chkready(rport))
>  		goto fnic_device_reset_end;
>  
>  	io_lock = fnic_io_lock_hash(fnic, sc);
> 
