From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 4/9] qla2xxx: Validate mid-layer 'underflow' during	check-condition handling.
Date: Sun, 22 Jul 2007 17:27:38 -0700
Message-ID: <20070723002738.GA5859@plap.qlogic.org>
References: <20070719220456.GK4015@plap.qlogic.org> <11848827641168-git-send-email-andrew.vasquez@qlogic.com> <46A3366D.9070807@panasas.com> <1185111751.3431.3.camel@localhost.localdomain> <46A369A7.2000401@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:33400 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765582AbXGWA1q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jul 2007 20:27:46 -0400
Content-Disposition: inline
In-Reply-To: <46A369A7.2000401@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Seokmann Ju <seokmann.ju@qlogic.com>

On Sun, 22 Jul 2007, Boaz Harrosh wrote:

> From: Boaz Harrosh <bharrosh@panasas.com>
> Date: Sun, 22 Jul 2007 17:24:18 +0300
> Subject: [PATCH] qla2xxx: Data accessors Cleanup of last merge
> 
>     - Left overs from last code merges of qla2xxx
> 
> Sign-off-by: Boaz Harrosh <bharrosh@panasas.com>

Thanks for catching that.  If need be:

Acked-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

> ---
>  drivers/scsi/qla2xxx/qla_isr.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index b8f226a..50539da 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1068,7 +1068,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
>  			 * values.
>  			 */
>  			if (resid &&
> -			    ((unsigned)(cp->request_bufflen - resid) <
> +			    ((unsigned)(scsi_bufflen(cp) - resid) <
>  			     cp->underflow)) {
>  				DEBUG2(qla_printk(KERN_INFO, ha,
>  				    "scsi(%ld:%d:%d:%d): Mid-layer underflow "
> @@ -1076,7 +1076,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
>  				    "error status.\n", ha->host_no,
>  				    cp->device->channel, cp->device->id,
>  				    cp->device->lun, resid,
> -				    cp->request_bufflen));
> +				    scsi_bufflen(cp)));
>  
>  				cp->result = DID_ERROR << 16 | lscsi_status;
>  			}
> -- 
> 1.5.2.2.249.g45fd
