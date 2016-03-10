From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH 1/1] sd: fix lbprz discard granularity as expected
Date: Thu, 10 Mar 2016 17:15:12 +0800
Message-ID: <CAGnHSEkGybgU0KXGYg_RLvgbnKvAth4dyHuxMPsKzF7cQs7qgQ@mail.gmail.com>
References: <56e12d57.4b43620a.4c8c0.ffff9bc5@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:34172 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934335AbcCJJPN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2016 04:15:13 -0500
Received: by mail-yw0-f194.google.com with SMTP id f6so4016074ywa.1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2016 01:15:12 -0800 (PST)
In-Reply-To: <56e12d57.4b43620a.4c8c0.ffff9bc5@mx.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Tom Yan <tom.ty89@gmail.com>

Nevertheless, I don't really quite get the sense of the original commit anyway.

Isn't discard granularity the minimum size we can discard? In that
case why would it have anything to do with "read zeroes"?

Suppose we are handling a device reports a discard granularity of 4096
bytes, while logical block size and physical block size are both 512
bytes. For such a device, a single 512-byte discard request should
simply be rejected because it's not allowed by the device. When it's
rejected, it doesn't mean that "the 512-byte block does not read
zeroes after being discarded"; instead, it's just "we did not discard
the 512-byte block as per requested because it's not allowed".

On 10 March 2016 at 16:16,  <tom.ty89@gmail.com> wrote:
> From: Tom Yan <tom.ty89@gmail.com>
>
> According to its own comment, the discard granularity should
> fixed to the logical block size. However, the actual code has
> it hardcoded as 1 byte. Changing it to logical_block_size.
>
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index d749da7..5a5457a 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -648,7 +648,7 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
>          */
>         if (sdkp->lbprz) {
>                 q->limits.discard_alignment = 0;
> -               q->limits.discard_granularity = 1;
> +               q->limits.discard_granularity = logical_block_size;
>         } else {
>                 q->limits.discard_alignment = sdkp->unmap_alignment *
>                         logical_block_size;
> --
> 2.7.2
>
