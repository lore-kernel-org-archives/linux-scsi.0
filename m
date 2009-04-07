From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: [PATCH 10/15] qla2xxx: Perform an implicit login to the
	Management Server.
Date: Tue, 7 Apr 2009 11:02:55 -0400
Message-ID: <20090407150255.GA29910@mars.virtualiron.com>
References: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com> <1239082431-19496-11-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host-216-57-134-2.customer.veroxity.net ([216.57.134.2]:51749
	"EHLO mars.virtualiron.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752834AbZDGPFh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 11:05:37 -0400
Content-Disposition: inline
In-Reply-To: <1239082431-19496-11-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Joe Carnuccio <joe.carnuccio@qlogic.com>

On Mon, Apr 06, 2009 at 10:33:46PM -0700, Andrew Vasquez wrote:
> From: Joe Carnuccio <joe.carnuccio@qlogic.com>
> 
> Set the conditional plogi option bit whenever logging in the
> fabric management server (if it is already logged in, it does not
> need an explicit login; an implicit login suffices).

How does one find out if it already has logged in? Obviously this routine
is used during the initialization for the driver, which implies that 
the firmware has done the job of logging already, right? Wouldn't the
management_server_logged_in flag be set somewhere by the login code, say
by the asynchronous updates?

> 
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_gs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
> index 557f58d..3dbb9e7 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -1107,7 +1107,7 @@ qla2x00_mgmt_svr_login(scsi_qla_host_t *vha)
>  		return ret;
>  
>  	ha->isp_ops->fabric_login(vha, vha->mgmt_svr_loop_id, 0xff, 0xff, 0xfa,
> -	    mb, BIT_1);
> +	    mb, BIT_1|BIT_0);
>  	if (mb[0] != MBS_COMMAND_COMPLETE) {
>  		DEBUG2_13(printk("%s(%ld): Failed MANAGEMENT_SERVER login: "
>  		    "loop_id=%x mb[0]=%x mb[1]=%x mb[2]=%x mb[6]=%x mb[7]=%x\n",
> -- 
> 1.6.2.2.404.ge96f3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
