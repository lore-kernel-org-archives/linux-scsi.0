From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH] sd: fix uninitialized variable access in error handling
Date: Fri, 21 Oct 2016 15:48:12 -0500
Message-ID: <CAJVOszB6TFE=kYS0KMO7baKmS6rt0Fk8MTWK+n26Xvtr=GSeFg@mail.gmail.com>
References: <20161021153246.3456962-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161021153246.3456962-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 21, 2016 at 10:32 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> If sd_zbc_report_zones fails, the check for 'zone_blocks =3D=3D 0'
> later in the function accesses uninitialized data:
>
> drivers/scsi/sd_zbc.c: In function =E2=80=98sd_zbc_read_zones=E2=80=99:
> drivers/scsi/sd_zbc.c:520:7: error: =E2=80=98zone_blocks=E2=80=99 may be =
used uninitialized in this function [-Werror=3Dmaybe-uninitialized]
>
> This sets it to zero, which has the desired effect of leaving
> the sd_zbc_read_zones successfully with sdkp->zone_blocks =3D 0.
>
> Fixes: 89d947561077 ("sd: Implement support for ZBC devices")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/scsi/sd_zbc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 16d3fa62d8ac..d5b3bd915d9e 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -455,8 +455,10 @@ static int sd_zbc_check_zone_size(struct scsi_disk *=
sdkp)
>
>         /* Do a report zone to get the same field */
>         ret =3D sd_zbc_report_zones(sdkp, buf, SD_ZBC_BUF_SIZE, 0);
> -       if (ret)
> +       if (ret) {
> +               zone_blocks =3D 0;
>                 goto out;
> +       }
>
>         same =3D buf[4] & 0x0f;
>         if (same > 0) {
> --
> 2.9.0
>

Reviewed-by: Shaun Tancheff <shaun.tancheff@seagate.com>
--=20
Shaun Tancheff
