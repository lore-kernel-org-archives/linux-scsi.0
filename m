From: Yang Bai <hamo.by@gmail.com>
Subject: Re: [PATCH] scsi: if sd card is removed, do not revalidate it
Date: Tue, 14 Feb 2012 12:13:18 +0800
Message-ID: <CAO_0yfOyrK_no3KDS7mX1uaFszKWtMtkkRxUKgb+8xrDQANzew@mail.gmail.com>
References: <1329192654-11284-1-git-send-email-hamo.by@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62666 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab2BNENi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2012 23:13:38 -0500
In-Reply-To: <1329192654-11284-1-git-send-email-hamo.by@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Yang Bai <hamo.by@gmail.com>

On Tue, Feb 14, 2012 at 12:10 PM, Yang Bai <hamo.by@gmail.com> wrote:
> During revalidating, if sd card is removed, scsi_device
> will be NULL, so we should not revalidate or it will cause
> a panic.
> This problem is report at:
> http://comments.gmane.org/gmane.linux.kernel/1250235
>
> Signed-off-by: Yang Bai <hamo.by@gmail.com>
> ---
> =C2=A0drivers/scsi/sd.c | =C2=A0 =C2=A04 ++--
> =C2=A01 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index c691fb5..470339c 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2370,10 +2370,10 @@ static int sd_revalidate_disk(struct gendisk =
*disk)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"sd_reva=
lidate_disk\n"));
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0* If the device is offline, don't try an=
d read capacity or any
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* If the device is removed or offline, d=
on't try and read capacity or any
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * of the other niceties.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> - =C2=A0 =C2=A0 =C2=A0 if (!scsi_device_online(sdp))
> + =C2=A0 =C2=A0 =C2=A0 if (!sdp || !scsi_device_online(sdp))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0buffer =3D kmalloc(SD_BUF_SIZE, GFP_KERNEL=
);
> --
> 1.7.9
>

Is this the right way to solve this problem? Or should we add
a lock to this struct to protect it?

--=20
=C2=A0 =C2=A0 """
=C2=A0 =C2=A0 Keep It Simple,Stupid.
=C2=A0 =C2=A0 """

Chinese Name: =E7=99=BD=E6=9D=A8
Nick Name: Hamo
Homepage: http://hamobai.com/
GPG KEY ID: 0xA4691A33
Key fingerprint =3D 09D5 2D78 8E2B 0995 CF8E=C2=A0 4331 33C4 3D24 A469 =
1A33
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
