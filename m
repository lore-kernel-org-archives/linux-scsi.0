From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi/be2iscsi: Fix logical-not-parentheses compilation warning
Date: Tue, 04 Aug 2015 09:42:45 +0200
Message-ID: <mqdy4hrts7e.fsf@c203.arch.suse.de>
References: <1438641357-25588-1-git-send-email-barletz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438641357-25588-1-git-send-email-barletz@gmail.com> (Tomer
	Barletz's message of "Mon, 3 Aug 2015 15:35:57 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Tomer Barletz <barletz@gmail.com>
Cc: jayamohan.kallickal@avagotech.com, minh.tran@avagotech.com, sony.john-n@avagotech.com, JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Ok, it has cost me quite some time to figure out what "!length > 0" is
actually doing, but looks ok to me.


Tomer Barletz <barletz@gmail.com> writes:

> This fixes the following warning seen with GCC v5.1:
> warning: logical not is only applied to the left hand side of
> comparison [-Wlogical-not-parentheses].
>
> Signed-off-by: Tomer Barletz <barletz@gmail.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/=
be_main.c
> index 7a6dbfb..ff8d40e 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -3184,7 +3184,7 @@ be_sgl_create_contiguous(void *virtual_address,
>  {
>  	WARN_ON(!virtual_address);
>  	WARN_ON(!physical_address);
> -	WARN_ON(!length > 0);
> +	WARN_ON(0 =3D=3D length);

Please write WARN_ON(length =3D=3D 0);

>  	WARN_ON(!sgl);
> =20
>  	sgl->va =3D virtual_address;


Given the above is swapped:
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                           Storage
jthumshirn@suse.de                                 +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600  D0D0 0393 969D 2D76 0850
