From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] BNX2I: register given device with cnic if shost != NULL
 in ep_connect()
Date: Thu, 09 Jul 2009 01:21:11 -0500
Message-ID: <4A558C57.30606@cs.wisc.edu>
References: <1245805860.9829.50.camel@anilgv-desktop> <1247102461.9829.438.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58606 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbZGIGVW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jul 2009 02:21:22 -0400
In-Reply-To: <1247102461.9829.438.camel@anilgv-desktop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Veerabhadrappa <anilgv@broadcom.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, mchan@broadcom.com

Anil Veerabhadrappa wrote:
>     * When using iface, bnx2i was unable to offload further connections after
>       all active sessions are logged out. bnx2i will unregister the device from
>       cnic when the last connection is torn down. Next call to ep_connect()
>       will fail because the device is not registered. This issue is not seen
>       if shost == NULL is passed to ep_connect() call because in that case bnx2i
>       will registers all known devices with cnic before doing a route look-up.
>       When shost != NULL, bnx2i knows the device on which to offload the
>       connection and has to register this device before attempting to offload
>       the connection
> 
> Signed-off-by: Anil Veerabhadrappa <anilgv@broadcom.com>
> Reviewed-by: Michael Chan <mchan@broadcom.com>
> ---
>  drivers/scsi/bnx2i/bnx2i_init.c  |    7 +++++--
>  drivers/scsi/bnx2i/bnx2i_iscsi.c |    7 +++++--
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
> index fd78540..0c4210d 100644
> --- a/drivers/scsi/bnx2i/bnx2i_init.c
> +++ b/drivers/scsi/bnx2i/bnx2i_init.c
> @@ -185,14 +185,17 @@ void bnx2i_stop(void *handle)
>   */
>  void bnx2i_register_device(struct bnx2i_hba *hba)
>  {
> +	int rc;
> +
>  	if (test_bit(ADAPTER_STATE_GOING_DOWN, &hba->adapter_state) ||
>  	    test_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic)) {
>  		return;
>  	}
>  
> -	hba->cnic->register_device(hba->cnic, CNIC_ULP_ISCSI, hba);
> +	rc = hba->cnic->register_device(hba->cnic, CNIC_ULP_ISCSI, hba);
>  
> -	set_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic);
> +	if (!rc)
> +		set_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic);
>  }
>  
>  
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> index f741219..98148f3 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -1653,15 +1653,18 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
>  	struct iscsi_endpoint *ep;
>  	int rc = 0;
>  
> -	if (shost)
> +	if (shost) {
>  		/* driver is given scsi host to work with */
>  		hba = iscsi_host_priv(shost);
> -	else
> +		/* Register the device with cnic if not already done so */
> +		bnx2i_register_device(hba);
> +	} else
>  		/*
>  		 * check if the given destination can be reached through
>  		 * a iscsi capable NetXtreme2 device
>  		 */
>  		hba = bnx2i_check_route(dst_addr);
> +
>  	if (!hba) {
>  		rc = -ENOMEM;
>  		goto check_busy;

Do you want to do the test_bit(BNX2I_CNIC_REGISTERED, 
&hba->reg_with_cnic) test here instead of down below. If it failed then 
you might try to do a cm_create on a cnic that is not properly registered.
