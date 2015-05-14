From: "vasu.dev@linux.intel.com" <vasu.dev@linux.intel.com>
Subject: Re: [Open-FCoE] [PATCH] scsi: match wait_for_completion_timeout
 return type
Date: Thu, 14 May 2015 15:40:19 -0700
Message-ID: <1431643219.4358.3.camel@lin-nd1-054.jf.intel.com>
References: <1431627154-12695-1-git-send-email-hofrat@osadl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431627154-12695-1-git-send-email-hofrat@osadl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Mc Guire <hofrat@osadl.org>
Cc: Vasu Dev <vasu.dev@intel.com>, fcoe-devel@open-fcoe.org, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-05-14 at 20:12 +0200, Nicholas Mc Guire wrote:
> Return type of wait_for_completion_timeout is unsigned long not int.
> An appropriately named unsigned long is added, and the assignments
> as well as error checking fixed up.
> 
> API conformance testing for completions with coccinelle spatches are being
> used to locate API usage inconsistencies:
> ./drivers/scsi/libfc/fc_fcp.c:1279
>         int return assigned to unsigned long
> 
> Patch was compile tested with x86_64_defconfig + SCSI_LOWLEVEL=y,
> CONFIG_SCSI_FC_ATTRS=m, CONFIG_LIBFC=m
> 
> Patch is against 4.1-rc3 (localversion-next is -next-20150514)
> 
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> ---
>  drivers/scsi/libfc/fc_fcp.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
> index c679594..c438b81 100644
> --- a/drivers/scsi/libfc/fc_fcp.c
> +++ b/drivers/scsi/libfc/fc_fcp.c
> @@ -1261,7 +1261,7 @@ static void fc_lun_reset_send(unsigned long data)
>  static int fc_lun_reset(struct fc_lport *lport, struct fc_fcp_pkt *fsp,
>  			unsigned int id, unsigned int lun)
>  {
> -	int rc;
> +	unsigned long time_left;
>  
>  	fsp->cdb_cmd.fc_dl = htonl(fsp->data_len);
>  	fsp->cdb_cmd.fc_tm_flags = FCP_TMF_LUN_RESET;
> @@ -1276,7 +1276,7 @@ static int fc_lun_reset(struct fc_lport *lport, struct fc_fcp_pkt *fsp,
>  	 * wait for completion of reset
>  	 * after that make sure all commands are terminated
>  	 */
> -	rc = wait_for_completion_timeout(&fsp->tm_done, FC_SCSI_TM_TOV);
> +	time_left = wait_for_completion_timeout(&fsp->tm_done, FC_SCSI_TM_TOV);
>  
>  	spin_lock_bh(&fsp->scsi_pkt_lock);
>  	fsp->state |= FC_SRB_COMPL;
> @@ -1292,7 +1292,7 @@ static int fc_lun_reset(struct fc_lport *lport, struct fc_fcp_pkt *fsp,
>  	fsp->wait_for_comp = 0;
>  	spin_unlock_bh(&fsp->scsi_pkt_lock);
>  
> -	if (!rc) {
> +	if (!time_left) {
>  		FC_SCSI_DBG(lport, "lun reset failed\n");
>  		return FAILED;
>  	}


Looks good, Thx

Acked-by: Vasu Dev <vasu.dev@intel.com>
