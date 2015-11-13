From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [patch] mvsas: don't allow negative timeouts
Date: Fri, 13 Nov 2015 16:20:01 +0100
Message-ID: <CAMGffEmnm0bL3SGo7Wv4VkF6tHxs61PS+8H5BV8+xGKQzj_g0A@mail.gmail.com>
References: <20151113142323.GB1445@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20151113142323.GB1445@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Hannes Reinecke <hare@suse.de>, Dan Williams <dan.j.williams@intel.com>, Bart Van Assche <bvanassche@acm.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 13, 2015 at 3:23 PM, Dan Carpenter <dan.carpenter@oracle.co=
m> wrote:
> There is a static checker warning here because "val" is controlled by
> the user and we have a upper bound on it but allow negative numbers.
> "val" appears to be a timeout in usec so this bug probably means we
> have a longer timeout than we should.  Let's fix this by changing "va=
l"
> to unsigned.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Checkpatch has several complaints about this code but I left it as-is=
=2E
>
> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_ini=
t.c
> index 90fdf0e..675e7fa 100644
> --- a/drivers/scsi/mvsas/mv_init.c
> +++ b/drivers/scsi/mvsas/mv_init.c
> @@ -758,7 +758,7 @@ mvs_store_interrupt_coalescing(struct device *cde=
v,
>                         struct device_attribute *attr,
>                         const char *buffer, size_t size)
>  {
> -       int val =3D 0;
> +       unsigned int val =3D 0;
>         struct mvs_info *mvi =3D NULL;
>         struct Scsi_Host *shost =3D class_to_shost(cdev);
>         struct sas_ha_struct *sha =3D SHOST_TO_SAS_HA(shost);
> @@ -766,7 +766,7 @@ mvs_store_interrupt_coalescing(struct device *cde=
v,
>         if (buffer =3D=3D NULL)
>                 return size;
>
> -       if (sscanf(buffer, "%d", &val) !=3D 1)
> +       if (sscanf(buffer, "%u", &val) !=3D 1)
>                 return -EINVAL;
>
>         if (val >=3D 0x10000) {

Looks good to me.
Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>

--=20
Mit freundlichen Gr=C3=BC=C3=9Fen,
Best Regards,

Jack Wang

Linux Kernel Developer Storage
ProfitBricks GmbH  The IaaS-Company.
--
To unsubscribe from this list: send the line "unsubscribe kernel-janito=
rs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
