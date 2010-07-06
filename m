From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] enclosure: fix lost return
Date: Tue, 06 Jul 2010 10:39:19 -0500
Message-ID: <1278430759.2854.80.camel@mulgrave.site>
References: <1278430088-9761-1-git-send-email-segooon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:58828 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab0GFPjZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jul 2010 11:39:25 -0400
In-Reply-To: <1278430088-9761-1-git-send-email-segooon@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>, Tejun Heo <tj@kernel.org>, David Brownell <dbrownell@users.sourceforge.net>, Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2010-07-06 at 19:28 +0400, Kulikov Vasiliy wrote:
> Useless statement must be return with argument.
>=20
> This patch silences a compiler warning:
> drivers/misc/enclosure.c: In function =E2=80=98enclosure_component_re=
gister=E2=80=99:
> drivers/misc/enclosure.c:289: warning: ignoring return value of =E2=80=
=98ERR_PTR=E2=80=99, declared with attribute warn_unused_result
>=20
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/misc/enclosure.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
> index 48c84a5..9ae7bef 100644
> --- a/drivers/misc/enclosure.c
> +++ b/drivers/misc/enclosure.c
> @@ -286,7 +286,7 @@ enclosure_component_register(struct enclosure_dev=
ice *edev,
> =20
>  	err =3D device_register(cdev);
>  	if (err)
> -		ERR_PTR(err);
> +		return ERR_PTR(err);

Well, the patch isn't quite correct, but I think I win a prize for
working out what the correct patch was and then forgetting to apply it:

http://marc.info/?l=3Dlinux-scsi&m=3D126843630320666

I've actually put it in my tree this time ...

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
