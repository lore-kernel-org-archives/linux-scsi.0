From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 4/9] qla2xxx: Validate mid-layer 'underflow' during
	check-condition handling.
Date: Sun, 22 Jul 2007 08:42:31 -0500
Message-ID: <1185111751.3431.3.camel@localhost.localdomain>
References: <20070719220456.GK4015@plap.qlogic.org>
	 <11848827641168-git-send-email-andrew.vasquez@qlogic.com>
	 <46A3366D.9070807@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:58662 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750816AbXGVNmd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jul 2007 09:42:33 -0400
In-Reply-To: <46A3366D.9070807@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Seokmann Ju <seokmann.ju@qlogic.com>

On Sun, 2007-07-22 at 13:50 +0300, Boaz Harrosh wrote:
> NACK. Breaks data buffers accessors patch. (385d70b4e2659ae525a00e46a9f97146949cfc14)
> should be:

This isn't bad enough to eject the entire qla enhancement from the tree
on the day the merge window closes to force a rewrite.

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index fa21cd8..4a50b93 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1062,6 +1062,25 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
>  			    cp->device->id, cp->device->lun, cp,
>  			    cp->serial_number));
>  
> +			/*
> +			 * In case of a Underrun condition, set both the lscsi
> +			 * status and the completion status to appropriate
> +			 * values.
> +			 */
> +			if (resid &&
> +			    ((unsigned)(scsi_bufflen(cp) - resid) <
> +			     cp->underflow)) {
> +				DEBUG2(qla_printk(KERN_INFO, ha,
> +				    "scsi(%ld:%d:%d:%d): Mid-layer underflow "
> +				    "detected (%x of %x bytes)...returning "
> +				    "error status.\n", ha->host_no,
> +				    cp->device->channel, cp->device->id,
> +				    cp->device->lun, resid,
> +				    scsi_bufflen(cp)));
> +
> +				cp->result = DID_ERROR << 16 | lscsi_status;
> +			}
> +
>  			if (sense_len)
>  				DEBUG5(qla2x00_dump_buffer(cp->sense_buffer,
>  				    CMD_ACTUAL_SNSLEN(cp)));

Could you respin an update against scsi-misc for -rc1?

Thanks,

James


