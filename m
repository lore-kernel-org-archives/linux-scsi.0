From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: Re: [PATCH] scsi: match wait_for_completion_timeout return type
Date: Wed, 18 Mar 2015 10:33:40 -0700
Message-ID: <1426700020.9426.37.camel@vfc0>
References: <1426075056-27410-1-git-send-email-hofrat@osadl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426075056-27410-1-git-send-email-hofrat@osadl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Mc Guire <hofrat@osadl.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-03-11 at 07:57 -0400, Nicholas Mc Guire wrote:
> wait_for_completion_timeout returns unsigned long not int. As other
> instances of wait_for_completion_timeout in fc_fcp.c use ticks_left
> of appropriate type, this name is used here as well.
> 
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> ---
> 
> Patch was only compile tested with x86_64_defconfig + SCSI_LOWLEVEL=y
> CONFIG_SCSI_FC_ATTRS=m, CONFIG_LIBFC=m
> 
> Patch is against 4.0-rc3 (localversion-next is -next-20150310)
> 
>  drivers/scsi/libfc/fc_fcp.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
> index c679594..c94a518 100644
> --- a/drivers/scsi/libfc/fc_fcp.c
> +++ b/drivers/scsi/libfc/fc_fcp.c
> @@ -1261,7 +1261,7 @@ static void fc_lun_reset_send(unsigned long data)
>  static int fc_lun_reset(struct fc_lport *lport, struct fc_fcp_pkt *fsp,
>  			unsigned int id, unsigned int lun)
>  {
> -	int rc;
> +	unsigned long ticks_left;
>  
>  	fsp->cdb_cmd.fc_dl = htonl(fsp->data_len);
>  	fsp->cdb_cmd.fc_tm_flags = FCP_TMF_LUN_RESET;
> @@ -1276,7 +1276,8 @@ static int fc_lun_reset(struct fc_lport *lport, struct fc_fcp_pkt *fsp,
>  	 * wait for completion of reset
>  	 * after that make sure all commands are terminated
>  	 */
> -	rc = wait_for_completion_timeout(&fsp->tm_done, FC_SCSI_TM_TOV);
> +	ticks_left = wait_for_completion_timeout(&fsp->tm_done,
> +						 FC_SCSI_TM_TOV);
>  
>  	spin_lock_bh(&fsp->scsi_pkt_lock);
>  	fsp->state |= FC_SRB_COMPL;
> @@ -1292,7 +1293,7 @@ static int fc_lun_reset(struct fc_lport *lport, struct fc_fcp_pkt *fsp,
>  	fsp->wait_for_comp = 0;
>  	spin_unlock_bh(&fsp->scsi_pkt_lock);
>  
> -	if (!rc) {
> +	if (!ticks_left) {
>  		FC_SCSI_DBG(lport, "lun reset failed\n");
>  		return FAILED;
>  	}


Looks good.

Acked-by: Vasu Dev <vasu.dev@intel.com>
