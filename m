From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 2/5] Cleanup the I/O that has timed out and is used to
 issue LUN reset
Date: Mon, 14 Mar 2016 16:14:25 -0400
Message-ID: <1457986465.4188.28.camel@localhost.localdomain>
References: <1457979262-26571-1-git-send-email-satishkh@cisco.com>
	 <1457979262-26571-2-git-send-email-satishkh@cisco.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187AbcCNUO1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2016 16:14:27 -0400
In-Reply-To: <1457979262-26571-2-git-send-email-satishkh@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satish Kharat <satishkh@cisco.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2016-03-14 at 11:14 -0700, Satish Kharat wrote:
> In case of LUN reset, the device reset command is issued with one of
> the I/Os that has timed out on that LUN. The change is to also return
> this I/O with error status set to DID_RESET.
> Fnic driver version changed from 1.6.0.19 to 1.6.0.20
> 
> Signed-off-by: Satish Kharat <satishkh@cisco.com>
> ---
>  drivers/scsi/fnic/fnic.h      |  2 +-
>  drivers/scsi/fnic/fnic_scsi.c | 35 +++++++++++++++++++++++++++--------
>  2 files changed, 28 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
> index 52a53f8..1023eae 100644
> --- a/drivers/scsi/fnic/fnic.h
> +++ b/drivers/scsi/fnic/fnic.h
> @@ -39,7 +39,7 @@
>  
>  #define DRV_NAME		"fnic"
>  #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
> -#define DRV_VERSION		"1.6.0.19"
> +#define DRV_VERSION		"1.6.0.20"
>  #define PFX			DRV_NAME ": "
>  #define DFX                     DRV_NAME "%d: "
>  
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> index b9732b1..a3e0f69 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -2041,7 +2041,9 @@ lr_io_req_end:
>   * successfully aborted, 1 otherwise
>   */
>  static int fnic_clean_pending_aborts(struct fnic *fnic,
> -				     struct scsi_cmnd *lr_sc)
> +				     struct scsi_cmnd *lr_sc,
> +					 bool new_sc)
> +

I don't see that this or any of the subsequent patches do anything with
this argument except pass 0 to it.  So why add it?

>  {
>  	int tag, abt_tag;
>  	struct fnic_io_req *io_req;
> @@ -2059,10 +2061,10 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
>  		spin_lock_irqsave(io_lock, flags);
>  		sc = scsi_host_find_tag(fnic->lport->host, tag);
>  		/*
> -		 * ignore this lun reset cmd or cmds that do not belong to
> -		 * this lun
> +		 * ignore this lun reset cmd if issued using new SC
> +		 * or cmds that do not belong to this lun
>  		 */
> -		if (!sc || sc == lr_sc || sc->device != lun_dev) {
> +		if (!sc || ((sc == lr_sc) && new_sc) || sc->device != lun_dev) {
>  			spin_unlock_irqrestore(io_lock, flags);
>  			continue;
>  		}
> @@ -2168,11 +2170,27 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
>  			goto clean_pending_aborts_end;
>  		}
>  		CMD_STATE(sc) = FNIC_IOREQ_ABTS_COMPLETE;
> -		CMD_SP(sc) = NULL;
> +
> +		/* original sc used for lr is handled by dev reset code */
> +		if (sc != lr_sc)
> +			CMD_SP(sc) = NULL;
>  		spin_unlock_irqrestore(io_lock, flags);
>  
> -		fnic_release_ioreq_buf(fnic, io_req, sc);
> -		mempool_free(io_req, fnic->io_req_pool);
> +		/* original sc used for lr is handled by dev reset code */
> +		if (sc != lr_sc) {
> +			fnic_release_ioreq_buf(fnic, io_req, sc);
> +			mempool_free(io_req, fnic->io_req_pool);
> +		}
> +
> +		/*
> +		 * Any IO is returned during reset, it needs to call scsi_done
> +		 * to return the scsi_cmnd to upper layer.
> +		 */
> +		if (sc->scsi_done) {
> +			/* Set result to let upper SCSI layer retry */
> +			sc->result = DID_RESET << 16;
> +			sc->scsi_done(sc);
> +		}
>  	}
>  
>  	schedule_timeout(msecs_to_jiffies(2 * fnic->config.ed_tov));
> @@ -2266,6 +2284,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>  	int tag = 0;
>  	DECLARE_COMPLETION_ONSTACK(tm_done);
>  	int tag_gen_flag = 0;   /*to track tags allocated by fnic driver*/
> +	bool new_sc = 0;
>  
>  	/* Wait for rport to unblock */
>  	fc_block_scsi_eh(sc);
> @@ -2452,7 +2471,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>  	 * the lun reset cmd. If all cmds get cleaned, the lun reset
>  	 * succeeds
>  	 */
> -	if (fnic_clean_pending_aborts(fnic, sc)) {
> +	if (fnic_clean_pending_aborts(fnic, sc, new_sc)) {
>  		spin_lock_irqsave(io_lock, flags);
>  		io_req = (struct fnic_io_req *)CMD_SP(sc);
>  		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


