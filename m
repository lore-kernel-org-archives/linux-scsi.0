From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH] libata-scsi: fix read-only bits checking in ata_mselect_*()
Date: Wed, 20 Jul 2016 06:59:04 +0800
Message-ID: <CAGnHSEkXbLxkZMusC0PGMOxsY3NcscTSPYREVpqHeB1RLZDBLw@mail.gmail.com>
References: <578e979d.d40c620a.f5800.0924@mx.google.com> <578eaead.0198620a.7cf53.28c1@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34944 "EHLO
	mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbcGSW7F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2016 18:59:05 -0400
In-Reply-To: <578eaead.0198620a.7cf53.28c1@mx.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.de>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>

Oops I put the wrong action under the opposite condition. Sending a v2.

On 20 July 2016 at 06:50,  <tom.ty89@gmail.com> wrote:
> From: Tom Yan <tom.ty89@gmail.com>
>
> Commit 7780081c1f04 ("libata-scsi: Set information sense field for
> invalid parameter") changed how ata_mselect_*() make sure read-only
> bits are not modified. The new implementation introduced a bug that
> the read-only bits in the byte that has a changeable bit will not
> be checked.
>
> Added the necessary check, with comments explaining the heuristic.
>
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
>
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 06afe63..005d186 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3617,8 +3617,18 @@ static int ata_mselect_caching(struct ata_queued_cmd *qc,
>          */
>         ata_msense_caching(dev->id, mpage, false);
>         for (i = 0; i < CACHE_MPAGE_LEN - 2; i++) {
> -               if (i == 0)
> -                       continue;
> +               /* Check the first byte */
> +               if (i == 0) {
> +                       /* except the WCE bit */
> +                       if (mpage[i + 2] & 0xfb != buf[i] & 0xfb) {
> +                               continue;
> +                       } else {
> +                               *fp = i;
> +                               return -EINVAL;
> +                       }
> +               }
> +
> +               /* Check the remaining bytes */
>                 if (mpage[i + 2] != buf[i]) {
>                         *fp = i;
>                         return -EINVAL;
> @@ -3672,8 +3682,18 @@ static int ata_mselect_control(struct ata_queued_cmd *qc,
>          */
>         ata_msense_control(dev, mpage, false);
>         for (i = 0; i < CONTROL_MPAGE_LEN - 2; i++) {
> -               if (i == 0)
> -                       continue;
> +               /* Check the first byte */
> +               if (i == 0) {
> +                       /* except the D_SENSE bit */
> +                       if (mpage[i + 2] & 0xfb != buf[i] & 0xfb) {
> +                               continue;
> +                       } else {
> +                               *fp = i;
> +                               return -EINVAL;
> +                       }
> +               }
> +
> +               /* Check the remaining bytes */
>                 if (mpage[2 + i] != buf[i]) {
>                         *fp = i;
>                         return -EINVAL;
> --
> 2.9.0
>
