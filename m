From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [SCSI] sd: make error handling more robust (v2)
Date: Fri, 1 Feb 2008 12:13:18 -0800 (PST)
Message-ID: <794098.69073.qm@web31807.mail.mud.yahoo.com>
References: <47A350DF.5020404@cybernetics.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31807.mail.mud.yahoo.com ([68.142.207.70]:36460 "HELO
	web31807.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756070AbYBAUNT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2008 15:13:19 -0500
In-Reply-To: <47A350DF.5020404@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tony Battersby <tonyb@cybernetics.com>
Cc: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>

--- On Fri, 2/1/08, Tony Battersby <tonyb@cybernetics.com> wrote:

> From: Tony Battersby <tonyb@cybernetics.com>
> Subject: [PATCH] [SCSI] sd: make error handling more robust (v2)
> To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: "Luben Tuikov" <ltuikov@yahoo.com>, "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
> Date: Friday, February 1, 2008, 9:03 AM
> This patch fixes a problem with some out-of-spec SCSI disks
> that report
> hardware or medium errors incorrectly.  Without the patch,
> the kernel
> may silently ignore a failed write command or return
> corrupted data on a
> failed read command.
> 
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>

Acked-by: Luben Tuikov <ltuikov@yahoo.com>

> ---
> 
> This is a simplified version of the original patch that

Very simplified. ;-)

> fixes just the
> problem at hand, without trying to handle other theoretical
> out-of-spec
> cases.

Yes, it is chunk #2 of the patch I sent to you to
try on your hardware.

> 
> Applies to kernels 2.6.18 - 2.6.24-git10+.
> 
> --- linux-2.6.24-git10/drivers/scsi/sd.c.orig	2008-02-01
> 11:24:37.000000000 -0500
> +++ linux-2.6.24-git10/drivers/scsi/sd.c	2008-02-01
> 11:26:12.000000000 -0500
> @@ -990,6 +990,8 @@ static int sd_done(struct scsi_cmnd
> *SCp
>  		/* This computation should always be done in terms of
>  		 * the resolution of the device's medium.
>  		 */
> +		if (bad_lba < start_lba)
> +			goto out;
>  		good_bytes = (bad_lba -
> start_lba)*SCpnt->device->sector_size;
>  		break;
>  	case RECOVERED_ERROR:
> 
> 
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
