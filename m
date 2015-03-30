From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 11/16] scsi_dh_alua: multipath failover fails with error
 15
Date: Mon, 30 Mar 2015 14:30:04 +0200
Message-ID: <551941CC.8010908@sandisk.com>
References: <1391160600-19652-1-git-send-email-hare@suse.de>
 <1391160600-19652-12-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0068.outbound.protection.outlook.com ([65.55.169.68]:31040
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752478AbbC3MaP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Mar 2015 08:30:15 -0400
In-Reply-To: <1391160600-19652-12-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 01/31/14 10:29, Hannes Reinecke wrote:
> When a path is already optimized multipath failover will fail
> with the message
> Could not failover device X:Y: Handler scsi_dh_alua Error 15
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index a1c69bb..8ea35a9 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -851,6 +851,8 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  		return SCSI_DH_RETRY;
>  	}
>  	switch (pg->state) {
> +	case TPGS_STATE_OPTIMIZED:
> +		return SCSI_DH_OK;
>  	case TPGS_STATE_NONOPTIMIZED:
>  		if ((pg->flags & ALUA_OPTIMIZE_STPG) &&
>  		    (!pg->pref) &&
> @@ -865,10 +867,11 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  		break;
>  	case TPGS_STATE_TRANSITIONING:
>  		return SCSI_DH_RETRY;
> -		break;
>  	default:
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: stpg failed, unhandled TPGS state %d",
> +			    ALUA_DH_NAME, pg->state);
>  		return SCSI_DH_NOSYS;
> -		break;
>  	}
>  	/* Set state to transitioning */
>  	pg->state = TPGS_STATE_TRANSITIONING;

(replying to an e-mail of last year)

Hello Hannes,

Our Q.A. team started to run into the issue that is fixed by this patch.
Do you have the time to resend this patch series or would you rather
prefer that I split out this patch, test it and post it with a "Cc:
stable" tag ?

Thanks,

Bart.


