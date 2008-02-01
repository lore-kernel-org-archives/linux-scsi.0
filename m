From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: RE: [PATCH] [SCSI] sd: make error handling more robust (v2)
Date: Fri, 1 Feb 2008 12:47:48 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F43976569D@ADPE2K703.adaptec.com>
References: <47A350DF.5020404@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:54064 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760272AbYBAUru convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2008 15:47:50 -0500
In-Reply-To: <47A350DF.5020404@cybernetics.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>, Mike Snitzer <snitzer@gmail.com>, Greg KH <greg@kroah.com>

ACK

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

Mike Snitzer tested this also in conjunction with the aacraid driver and it resolved the error propagation problem he experienced with MD on a 2.6.22.16 kernel, recommend that this also be added to any stabilization for these other kernels. By his permission:

Signed-off-by: Mike Snitzer <snitzer@gmail.com>

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Tony Battersby [mailto:tonyb@cybernetics.com]
> Sent: Friday, February 01, 2008 12:03 PM
> To: linux-scsi@vger.kernel.org; James Bottomley
> Cc: Luben Tuikov; Salyzyn, Mark
> Subject: [PATCH] [SCSI] sd: make error handling more robust (v2)
>
> This patch fixes a problem with some out-of-spec SCSI disks
> that report
> hardware or medium errors incorrectly.  Without the patch, the kernel
> may silently ignore a failed write command or return
> corrupted data on a
> failed read command.
>
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> ---
>
> This is a simplified version of the original patch that fixes just the
> problem at hand, without trying to handle other theoretical
> out-of-spec
> cases.
>
> Applies to kernels 2.6.18 - 2.6.24-git10+.
>
> --- linux-2.6.24-git10/drivers/scsi/sd.c.orig   2008-02-01
> 11:24:37.000000000 -0500
> +++ linux-2.6.24-git10/drivers/scsi/sd.c        2008-02-01
> 11:26:12.000000000 -0500
> @@ -990,6 +990,8 @@ static int sd_done(struct scsi_cmnd *SCp
>                 /* This computation should always be done in terms of
>                  * the resolution of the device's medium.
>                  */
> +               if (bad_lba < start_lba)
> +                       goto out;
>                 good_bytes = (bad_lba -
> start_lba)*SCpnt->device->sector_size;
>                 break;
>         case RECOVERED_ERROR:
>
>
>
