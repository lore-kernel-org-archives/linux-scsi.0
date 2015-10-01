From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] be2iscsi: Fix bad WARN_ON
Date: Thu, 01 Oct 2015 10:31:50 +0200
Message-ID: <mqdh9mbm1l5.fsf@c203.arch.suse.de>
References: <1443686578-13030-1-git-send-email-joel@jms.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53794 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701AbbJAIbx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2015 04:31:53 -0400
In-Reply-To: <1443686578-13030-1-git-send-email-joel@jms.id.au> (Joel
	Stanley's message of "Thu, 1 Oct 2015 17:32:58 +0930")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joel Stanley <joel@jms.id.au>
Cc: jayamohan.kallickal@avagotech.com, minh.tran@avagotech.com, sony.john-n@avagotech.com, JBottomley@odin.com, linux-scsi@vger.kernel.org

Joel Stanley <joel@jms.id.au> writes:

> GCC 5 helpfully warns us that the WARN_ON check may be buggy:
>
> drivers/scsi/be2iscsi/be_main.c: In function =E2=80=98be_sgl_create_c=
ontiguous=E2=80=99:
> drivers/scsi/be2iscsi/be_main.c:3187:18: warning: logical not is only
> applied to the left hand side of comparison [-Wlogical-not-parenthese=
s]
>   WARN_ON(!length > 0);
>                     ^
>
> Add the brackets that the check was was looking for.
>
> Signed-off-by: Joel Stanley <joel@jms.id.au>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/=
be_main.c
> index 7a6dbfb..0b87abb 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -3184,7 +3184,7 @@ be_sgl_create_contiguous(void *virtual_address,
>  {
>  	WARN_ON(!virtual_address);
>  	WARN_ON(!physical_address);
> -	WARN_ON(!length > 0);
> +	WARN_ON(!(length > 0));

Why aren't you doing WARN_ON(length <=3D 0); it's much nicer to read IM=
HO

>  	WARN_ON(!sgl);
> =20
>  	sgl->va =3D virtual_address;

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
