From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2] be2iscsi: Fix bad WARN_ON
Date: Fri, 02 Oct 2015 09:31:50 +0200
Message-ID: <mqdr3ldlo9l.fsf@c203.arch.suse.de>
References: <1443749565-8438-1-git-send-email-joel@jms.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbbJBHbw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2015 03:31:52 -0400
In-Reply-To: <1443749565-8438-1-git-send-email-joel@jms.id.au> (Joel Stanley's
	message of "Fri, 2 Oct 2015 11:02:45 +0930")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joel Stanley <joel@jms.id.au>
Cc: jayamohan.kallickal@avagotech.com, JBottomley@odin.com, linux-scsi@vger.kernel.org

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
> Check that length is not zero (and not less than zero, but it's
> unsigned, so that will always be satisfied).
>
> Signed-off-by: Joel Stanley <joel@jms.id.au>
> ---
> v2: invert the check to lose the ! as suggested by Johannes
>
>  drivers/scsi/be2iscsi/be_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/=
be_main.c
> index 7a6dbfb..c6110cb 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -3184,7 +3184,7 @@ be_sgl_create_contiguous(void *virtual_address,
>  {
>  	WARN_ON(!virtual_address);
>  	WARN_ON(!physical_address);
> -	WARN_ON(!length > 0);
> +	WARN_ON(length <=3D 0);
>  	WARN_ON(!sgl);
> =20
>  	sgl->va =3D virtual_address;

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

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
