From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v2] [SCSI] scsi_debug: silence GCC warning
Date: Wed, 17 Jul 2013 00:21:38 +0900
Message-ID: <CAC5umyj2bOyU_z0HVawXL7k4FmF9oHh1yZfHExbKn9ck85RsUQ@mail.gmail.com>
References: <1373879920.2591.13.camel@x61.thuisdomein>
	<1373914081.2591.40.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1373914081.2591.40.camel@x61.thuisdomein>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

2013/7/16 Paul Bolle <pebolle@tiscali.nl>:
> Building scsi_debug.o triggers a GCC warning:
>     drivers/scsi/scsi_debug.c: In function =91dif_verify=92:
>     drivers/scsi/scsi_debug.c:1755:3: warning: =91csum=92 may be used=
 uninitialized in this function [-Wmaybe-uninitialized]
>
> This is a false positive. But if we transform the switch statement in
> dif_compute_csum() to a straightforward if/else statement we supply G=
CC
> with enough information to determine that csum will not be used
> uninitialized.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) v2 because I started to worry whether v1 would change an interface
> (ie, the way the "guard" module parameter behaves). This patch is muc=
h
> simpler, and doesn't change any behavior.
>
> 1) Still only compile tested.

This one looks good to me.  It would be much better if this commit
log had a reference to the commit that introduced this warning as
you described after '---' in v1 patch.

>  drivers/scsi/scsi_debug.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index cb4fefa..7565ec5 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -1735,14 +1735,11 @@ static u16 dif_compute_csum(const void *buf, =
int len)
>  {
>         u16 csum;
>
> -       switch (scsi_debug_guard) {
> -       case 1:
> +       if (scsi_debug_guard =3D=3D 1)
>                 csum =3D ip_compute_csum(buf, len);
> -               break;
> -       case 0:
> +       else
>                 csum =3D cpu_to_be16(crc_t10dif(buf, len));
> -               break;
> -       }
> +
>         return csum;
>  }
>
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
