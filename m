From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 5/5] Leftshift returned scsi_cmnd error code 16 bits
Date: Mon, 14 Mar 2016 16:17:09 -0400
Message-ID: <1457986629.4188.32.camel@localhost.localdomain>
References: <1457979262-26571-1-git-send-email-satishkh@cisco.com>
	 <1457979262-26571-5-git-send-email-satishkh@cisco.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171AbcCNURK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2016 16:17:10 -0400
In-Reply-To: <1457979262-26571-5-git-send-email-satishkh@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satish Kharat <satishkh@cisco.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2016-03-14 at 11:14 -0700, Satish Kharat wrote:
> The the scsi_cmnd error code is expected to be in the left 16 bits
> of the result field. Change is to correct this.
> 
> Signed-off-by: Satish Kharat <satishkh@cisco.com>
> ---
>  drivers/scsi/fnic/fnic.h      | 2 +-
>  drivers/scsi/fnic/fnic_scsi.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
> index 35264c7..e4e22f1 100644
> --- a/drivers/scsi/fnic/fnic.h
> +++ b/drivers/scsi/fnic/fnic.h
> @@ -39,7 +39,7 @@
>  
>  #define DRV_NAME		"fnic"
>  #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
> -#define DRV_VERSION		"1.6.0.22"
> +#define DRV_VERSION		"1.6.0.24"
>  #define PFX			DRV_NAME ": "
>  #define DFX                     DRV_NAME "%d: "
>  
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> index 8492143..92a4ca3 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -461,7 +461,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
>  			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
>  				"returning DID_NO_CONNECT for IO as rport is removed\n");
>  			atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
> -			sc->result = DID_NO_CONNECT;
> +			sc->result = DID_NO_CONNECT<<16;
>  			done(sc);
>  			return 0;
>  		}

Should just fix patch 3/5 instead.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


