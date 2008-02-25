From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid: READ_CAPACITY_16 shouldn't trust allocation
 length in cdb
Date: Mon, 25 Feb 2008 06:16:02 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F482A67CD3@ADPE2K703.adaptec.com>
References: <1203895523-4009-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:41409 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbYBYOQG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Feb 2008 09:16:06 -0500
In-Reply-To: <1203895523-4009-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "tomof@acm.org" <tomof@acm.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

ACK

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: fujita [mailto:tomof@acm.org] On Behalf Of FUJITA Tomonori
> Sent: Sunday, February 24, 2008 6:25 PM
> To: linux-scsi@vger.kernel.org
> Cc: tomof@acm.org; FUJITA Tomonori; Salyzyn, Mark; James Bottomley
> Subject: [PATCH] aacraid: READ_CAPACITY_16 shouldn't trust
> allocation length in cdb
>
> When aacraid spoofs READ_CAPACITY_16, it assumes that the data length
> in the sg list is equal to allocation length in cdb. But sg can put
> any value in scb so the driver needs to check both the data length in
> the sg list and allocation length in cdb.
>
> If allocation length is larger than the response length that the
> driver expects, it clears the data buffer in the sg list to zero but
> it doesn't need to do. Just setting resid is fine.
>
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  drivers/scsi/aacraid/aachba.c |   22 +++++++++++-----------
>  1 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/scsi/aacraid/aachba.c
> b/drivers/scsi/aacraid/aachba.c
> index c05092f..b9fc9b1 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -2047,6 +2047,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
>         {
>                 u64 capacity;
>                 char cp[13];
> +               unsigned int alloc_len;
>
>                 dprintk((KERN_DEBUG "READ CAPACITY_16 command.\n"));
>                 capacity = fsa_dev_ptr[cid].size - 1;
> @@ -2063,18 +2064,17 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
>                 cp[10] = 2;
>                 cp[11] = 0;
>                 cp[12] = 0;
> -               aac_internal_transfer(scsicmd, cp, 0,
> -                 min_t(size_t, scsicmd->cmnd[13], sizeof(cp)));
> -               if (sizeof(cp) < scsicmd->cmnd[13]) {
> -                       unsigned int len, offset = sizeof(cp);
>
> -                       memset(cp, 0, offset);
> -                       do {
> -                               len = min_t(size_t,
> scsicmd->cmnd[13] - offset,
> -                                               sizeof(cp));
> -
> aac_internal_transfer(scsicmd, cp, offset, len);
> -                       } while ((offset += len) < scsicmd->cmnd[13]);
> -               }
> +               alloc_len = ((scsicmd->cmnd[10] << 24)
> +                            + (scsicmd->cmnd[11] << 16)
> +                            + (scsicmd->cmnd[12] << 8) +
> scsicmd->cmnd[13]);
> +
> +               alloc_len = min_t(size_t, alloc_len, sizeof(cp));
> +               aac_internal_transfer(scsicmd, cp, 0, alloc_len);
> +
> +               if (alloc_len < scsi_bufflen(scsicmd))
> +                       scsi_set_resid(scsicmd,
> +                                      scsi_bufflen(scsicmd)
> - alloc_len);
>
>                 /* Do not cache partition table for arrays */
>                 scsicmd->device->removable = 1;
> --
> 1.5.3.7
>
>
