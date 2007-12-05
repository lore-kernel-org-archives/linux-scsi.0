From: Joe Eykholt <fcoe@eykholt.com>
Subject: Re: [OpenFCoE PATCH] Add a missing spin_unlock() found when a BLS
 frame	was mis-delivered.
Date: Tue, 04 Dec 2007 16:56:01 -0800
Message-ID: <4755F721.2070005@eykholt.com>
References: <20071205005112.25831.66010.stgit@mink.he.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eykholt.com ([72.52.117.41]:46661 "HELO eykholt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750813AbXLEAzx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 19:55:53 -0500
Received: from 67.91.200.194 ([67.91.200.194]) by eykholt.com for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2007 16:55:50 -0800
In-Reply-To: <20071205005112.25831.66010.stgit@mink.he.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Joe Eykholt wrote:
> Add a missing spin_unlock() found when a BLS frame was mis-delivered.

Please disregard this patch.  It got merged into the wrong function.  A better one is coming.

	Joe

> Signed-off-by: Joe Eykholt <fcoe@eykholt.com>
> 
> ---
>  drivers/scsi/ofc/openfc/openfc_scsi.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/ofc/openfc/openfc_scsi.c b/drivers/scsi/ofc/openfc/openfc_scsi.c
> index 86e6895..5fa0ad6 100644
> --- a/drivers/scsi/ofc/openfc/openfc_scsi.c
> +++ b/drivers/scsi/ofc/openfc/openfc_scsi.c
> @@ -548,6 +548,8 @@ void openfc_scsi_abort_iocontext(struct fc_scsi_pkt *fsp)
>  		fsp->status_code = OPENFC_ERROR;
>  		fsp->io_status = (SUGGEST_RETRY << 24);
>  		(*fsp->done) (fsp);
> +	} else {
> +		spin_unlock(&qp->scsi_pkt_lock);
>  	}
>  }
>  
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

