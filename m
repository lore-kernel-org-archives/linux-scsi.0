From: "Ju, Seokmann" <Seokmann.Ju@engenio.com>
Subject: RE: [PATCH] megaraid (legacy): remove scsi_assign_lock usage
Date: Mon, 31 Oct 2005 14:49:40 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703662BDF@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:15850 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S964812AbVJaTtt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Oct 2005 14:49:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@lst.de>, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

On Monday, October 31, 2005 2:12 PM, Christoph Hellwig wrote:
> just take the adapter lock in megaraid_queue.  Additional benefit is
> that we can get rid of the awkward conditional locking in
> mega_internal_command.
Thank you for the changes. It looks good for me.


> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@lst.de] 
> Sent: Monday, October 31, 2005 2:12 PM
> To: jejb@steeleye.com
> Cc: linux-scsi@vger.kernel.org
> Subject: [PATCH] megaraid (legacy): remove scsi_assign_lock usage
> 
> just take the adapter lock in megaraid_queue.  Additional benefit is
> that we can get rid of the awkward conditional locking in
> mega_internal_command.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/drivers/scsi/megaraid.c
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/megaraid.c	2005-10-31 
> 03:05:16.000000000 +0100
> +++ linux-2.6/drivers/scsi/megaraid.c	2005-10-31 
> 10:33:44.000000000 +0100
> @@ -362,6 +362,7 @@
>  	adapter_t	*adapter;
>  	scb_t	*scb;
>  	int	busy=0;
> +	unsigned long flags;
>  
>  	adapter = (adapter_t *)scmd->device->host->hostdata;
>  
> @@ -377,6 +378,7 @@
>  	 * return 0 in that case.
>  	 */
>  
> +	spin_lock_irqsave(&adapter->lock, flags);
>  	scb = mega_build_cmd(adapter, scmd, &busy);
>  
>  	if(scb) {
> @@ -393,6 +395,7 @@
>  		}
>  		return 0;
>  	}
> +	spin_unlock_irqrestore(&adapter->lock, flags);
>  
>  	return busy;
>  }
> @@ -1981,7 +1984,7 @@
>  	mc.cmd = MEGA_CLUSTER_CMD;
>  	mc.opcode = MEGA_RESET_RESERVATIONS;
>  
> -	if( mega_internal_command(adapter, LOCK_INT, &mc, NULL) != 0 ) {
> +	if( mega_internal_command(adapter, &mc, NULL) != 0 ) {
>  		printk(KERN_WARNING
>  				"megaraid: reservation reset 
> failed.\n");
>  	}
> @@ -3011,7 +3014,7 @@
>  		mc.cmd = FC_NEW_CONFIG;
>  		mc.opcode = OP_DCMD_READ_CONFIG;
>  
> -		if( mega_internal_command(adapter, LOCK_INT, 
> &mc, NULL) ) {
> +		if( mega_internal_command(adapter, &mc, NULL) ) {
>  
>  			len = sprintf(page, "40LD read config 
> failed.\n");
>  
> @@ -3029,11 +3032,11 @@
>  	else {
>  		mc.cmd = NEW_READ_CONFIG_8LD;
>  
> -		if( mega_internal_command(adapter, LOCK_INT, 
> &mc, NULL) ) {
> +		if( mega_internal_command(adapter, &mc, NULL) ) {
>  
>  			mc.cmd = READ_CONFIG_8LD;
>  
> -			if( mega_internal_command(adapter, 
> LOCK_INT, &mc,
> +			if( mega_internal_command(adapter, &mc,
>  						NULL) ){
>  
>  				len = sprintf(page,
> @@ -3632,7 +3635,7 @@
>  			/*
>  			 * Issue the command
>  			 */
> -			mega_internal_command(adapter, 
> LOCK_INT, &mc, pthru);
> +			mega_internal_command(adapter, &mc, pthru);
>  
>  			rval = mega_n_to_m((void __user *)arg, &mc);
>  
> @@ -3715,7 +3718,7 @@
>  			/*
>  			 * Issue the command
>  			 */
> -			mega_internal_command(adapter, 
> LOCK_INT, &mc, NULL);
> +			mega_internal_command(adapter, &mc, NULL);
>  
>  			rval = mega_n_to_m((void __user *)arg, &mc);
>  
> @@ -4234,7 +4237,7 @@
>  	mc.opcode = OP_DEL_LOGDRV;
>  	mc.subopcode = logdrv;
>  
> -	rval = mega_internal_command(adapter, LOCK_INT, &mc, NULL);
> +	rval = mega_internal_command(adapter, &mc, NULL);
>  
>  	/* log this event */
>  	if(rval) {
> @@ -4367,7 +4370,7 @@
>  
>  	mc.xferaddr = (u32)dma_handle;
>  
> -	if ( mega_internal_command(adapter, LOCK_INT, &mc, 
> NULL) != 0 ) {
> +	if ( mega_internal_command(adapter, &mc, NULL) != 0 ) {
>  		return -1;
>  	}
>  
> @@ -4435,7 +4438,7 @@
>  	mc.cmd = MEGA_MBOXCMD_PASSTHRU;
>  	mc.xferaddr = (u32)pthru_dma_handle;
>  
> -	rval = mega_internal_command(adapter, LOCK_INT, &mc, pthru);
> +	rval = mega_internal_command(adapter, &mc, pthru);
>  
>  	pci_free_consistent(pdev, sizeof(mega_passthru), pthru,
>  			pthru_dma_handle);
> @@ -4449,7 +4452,6 @@
>  /**
>   * mega_internal_command()
>   * @adapter - pointer to our soft state
> - * @ls - the scope of the exclusion lock.
>   * @mc - the mailbox command
>   * @pthru - Passthru structure for DCDB commands
>   *
> @@ -4463,8 +4465,7 @@
>   * Note: parameter 'pthru' is null for non-passthru commands.
>   */
>  static int
> -mega_internal_command(adapter_t *adapter, lockscope_t ls, 
> megacmd_t *mc,
> -		mega_passthru *pthru )
> +mega_internal_command(adapter_t *adapter, megacmd_t *mc, 
> mega_passthru *pthru)
>  {
>  	Scsi_Cmnd	*scmd;
>  	struct	scsi_device *sdev;
> @@ -4508,15 +4509,8 @@
>  
>  	scb->idx = CMDID_INT_CMDS;
>  
> -	/*
> -	 * Get the lock only if the caller has not acquired it already
> -	 */
> -	if( ls == LOCK_INT ) spin_lock_irqsave(&adapter->lock, flags);
> -
>  	megaraid_queue(scmd, mega_internal_done);
>  
> -	if( ls == LOCK_INT ) 
> spin_unlock_irqrestore(&adapter->lock, flags);
> -
>  	wait_for_completion(&adapter->int_waitq);
>  
>  	rval = scmd->result;
> Index: linux-2.6/drivers/scsi/megaraid.h
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/megaraid.h	2005-08-11 
> 16:46:00.000000000 +0200
> +++ linux-2.6/drivers/scsi/megaraid.h	2005-10-31 
> 10:32:22.000000000 +0100
> @@ -926,13 +926,6 @@
>  #define MEGA_SGLIST			0x0002
>  
>  /*
> - * lockscope definitions, callers can specify the lock scope 
> with this data
> - * type. LOCK_INT would mean the caller has not acquired the 
> lock before
> - * making the call and LOCK_EXT would mean otherwise.
> - */
> -typedef enum { LOCK_INT, LOCK_EXT } lockscope_t;
> -
> -/*
>   * Parameters for the io-mapped controllers
>   */
>  
> @@ -1062,8 +1055,7 @@
>  static int mega_del_logdrv(adapter_t *, int);
>  static int mega_do_del_logdrv(adapter_t *, int);
>  static void mega_get_max_sgl(adapter_t *);
> -static int mega_internal_command(adapter_t *, lockscope_t, 
> megacmd_t *,
> -		mega_passthru *);
> +static int mega_internal_command(adapter_t *, megacmd_t *, 
> mega_passthru *);
>  static void mega_internal_done(Scsi_Cmnd *);
>  static int mega_support_cluster(adapter_t *);
>  #endif
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
