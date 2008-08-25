From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC][PATCH 2/6] fnic: add fnic_scsi.c and fnic_io.h.
Date: Mon, 25 Aug 2008 13:22:56 -0500
Message-ID: <48B2F880.7080108@cs.wisc.edu>
References: <20080823024949.13569.94133.stgit@feynman.nuovasystems.com> <20080823025222.13569.37765.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35611 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbYHYSXF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2008 14:23:05 -0400
In-Reply-To: <20080823025222.13569.37765.stgit@feynman.nuovasystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeykholt@cisco.com
Cc: linux-scsi@vger.kernel.org, jre@nuovasystems.com, ajoglekar@nuovasystems.com

jeykholt@cisco.com wrote:
> fnic: add fnic_scsi.c and fnic_io.h.
> 
> fnic_scsi.c contains the FCP SCSI handling as well as firmware reset
> and FLOGI registration handling.
> 

I just looked at this one function, because I was fixing the same code 
in fcoe.ko/libfc:fc_fcp.c


> +int fnic_reset(struct Scsi_Host *shost)
> +{
> +	struct fc_lport *lp;
> +	struct fnic *fnic;
> +	unsigned long flags;
> +	int ret = SUCCESS;
> +	enum fnic_state old_state;
> +	DECLARE_COMPLETION_ONSTACK(reset_wait);
> +
> +	lp = shost_priv(shost);
> +	fnic = lp->drv_priv;
> +
> +	printk(KERN_DEBUG DFX "fnic_reset called\n", fnic->fnic_no);
> +
> +	/* Issue firmware reset */
> +	spin_lock_irqsave(&fnic->fnic_lock, flags);
> +	fnic->reset_wait = &reset_wait;
> +	old_state = fnic->state;
> +	fnic->state = FNIC_IN_FC_TRANS_ETH_MODE;
> +	vnic_dev_del_addr(fnic->vdev, fnic->data_src_addr);
> +	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +
> +	if (fnic_fw_reset_handler(fnic)) {
> +		spin_lock_irqsave(&fnic->fnic_lock, flags);
> +		ret = FAILED;
> +		if (fnic->state == FNIC_IN_FC_TRANS_ETH_MODE)
> +			fnic->state = old_state;
> +		fnic->reset_wait = NULL;
> +		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +		goto fnic_reset_end;
> +	}
> +
> +	/* fw reset is issued, now wait for it to complete */
> +	wait_for_completion_timeout(&reset_wait,
> +				    msecs_to_jiffies(FNIC_HOST_RESET_TIMEOUT));
> +
> +	/* Check for status */
> +	spin_lock_irqsave(&fnic->fnic_lock, flags);
> +	fnic->reset_wait = NULL;
> +	ret = (fnic->state == FNIC_IN_ETH_MODE) ? SUCCESS : FAILED;
> +	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +
> +	/* Now reset local port, this will clean up libFC exchanges,
> +	 * reset remote port sessions, and if link is up, begin flogi
> +	 */
> +	fc_lport_lock(lp);
> +	if (lp->tt.lport_reset(lp))
> +		ret = FAILED;


The problem here is that this only starts the login. When fnic_reset 
returns for the scsi eh path, scsi-ml is going to send a TUR to make 
sure that we are ready to go. If we are not the devices will be 
offlined. So unless it is a really quick relogin we are going to offline 
the devices by accident.

For fc_fcp.c I added a hokey loop and wait like some other drivers. We 
could instead have libfc notify any waiters of a state change here. We 
could also do a rport blocked timedout helper, convert the fc drivers 
and use it here so we only wait for the login to complete or for the 
port block to fail.




> +	fc_lport_unlock(lp);
> +
> +fnic_reset_end:
> +	printk(KERN_DEBUG DFX "Returning from fnic reset %s\n",
> +	       fnic->fnic_no, (ret == SUCCESS) ? "SUCCESS" : "FAILED");
> +
> +	return ret;
> +}
> +
> +/* SCSI Error handling calls driver's eh_host_reset if all prior
> + * error handling levels return FAILED. If host reset completes
> + * successfully, and if link is up, then Fabric login begins.
> + *
> + * Host Reset is the highest level of error recovery. If this fails, then
> + * host is offlined by SCSI.
> + *
> + */
> +int fnic_host_reset(struct scsi_cmnd *sc)
> +{
> +	return fnic_reset(sc->device->host);
> +}
> +
> +/*
> + * This fxn is called from libFC when host is removed
> + */
> +void fnic_scsi_abort_io(struct fc_lport *lp)
> +{
> +	int err = 0;
> +	unsigned long flags;
> +	enum fnic_state old_state;
> +	struct fnic *fnic = lp->drv_priv;
> +	DECLARE_COMPLETION_ONSTACK(remove_wait);
> +
> +	/* Issue firmware reset for fnic, wait for reset to complete */
> +	spin_lock_irqsave(&fnic->fnic_lock, flags);
> +	fnic->remove_wait = &remove_wait;
> +	old_state = fnic->state;
> +	fnic->state = FNIC_IN_FC_TRANS_ETH_MODE;
> +	vnic_dev_del_addr(fnic->vdev, fnic->data_src_addr);
> +	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +
> +	err = fnic_fw_reset_handler(fnic);
> +	if (err) {
> +		spin_lock_irqsave(&fnic->fnic_lock, flags);
> +		if (fnic->state == FNIC_IN_FC_TRANS_ETH_MODE)
> +			fnic->state = old_state;
> +		fnic->remove_wait = NULL;
> +		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +		goto abort_io_end;
> +	}
> +
> +	/* Wait for firmware reset to complete */
> +	wait_for_completion_timeout(&remove_wait,
> +				    msecs_to_jiffies(FNIC_RMDEVICE_TIMEOUT));
> +
> +	spin_lock_irqsave(&fnic->fnic_lock, flags);
> +	fnic->remove_wait = NULL;
> +	printk(KERN_DEBUG DFX "fnic_scsi_abort_io %s\n", fnic->fnic_no,
> +	       (fnic->state == FNIC_IN_ETH_MODE) ? "SUCCESS" : "FAILED");
> +	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +
> +abort_io_end:
> +	return;
> +}
> +
> +/*
> + * This fxn called from libFC to clean up driver IO state on link down
> + */
> +void fnic_scsi_cleanup(struct fc_lport *lp)
> +{
> +	unsigned long flags;
> +	enum fnic_state old_state;
> +	struct fnic *fnic = lp->drv_priv;
> +
> +	/* issue fw reset */
> +	spin_lock_irqsave(&fnic->fnic_lock, flags);
> +	old_state = fnic->state;
> +	fnic->state = FNIC_IN_FC_TRANS_ETH_MODE;
> +	vnic_dev_del_addr(fnic->vdev, fnic->data_src_addr);
> +	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +
> +	if (fnic_fw_reset_handler(fnic)) {
> +		spin_lock_irqsave(&fnic->fnic_lock, flags);
> +		if (fnic->state == FNIC_IN_FC_TRANS_ETH_MODE)
> +			fnic->state = old_state;
> +		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +	}
> +
> +}
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

