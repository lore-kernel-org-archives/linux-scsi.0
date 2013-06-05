From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH] sg: atomize check and set sdp->exclude in sg_open
Date: Wed, 5 Jun 2013 09:27:46 -0400
Message-ID: <20130605132746.GA1690@logfs.org>
References: <51AF0269.9070900@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51AF0269.9070900@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vaughan <vaughan.cao@oracle.com>
Cc: dgilbert@interlog.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, xitao.cao@gmail.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 5 June 2013 17:18:33 +0800, vaughan wrote:
>=20
> Check and set sdp->exclude should be atomic when set in sg_open().

The patch is line-wrapped.  More importantly, it doesn't seem to do
what your description indicates it should do.  And lastly, does this
fix a bug, possibly even one you have a testcase for, or was it found
by code inspection?

> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
> ---
>  drivers/scsi/sg.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 25b5455..0ede08f 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -245,6 +245,21 @@ static int set_exclude(Sg_device *sdp, char val)
>      return val;
>  }
>=20
> +/* Check if we can set exclude and then set, return 1 if success */
> +static int try_set_exclude(Sg_device *sdp)
> +{
> +    unsigned long flags;
> +
> +    spin_lock_irqsave(&sg_open_exclusive_lock, flags);
> +    if (sdp->exclude) {
> +        spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
> +        return 0;
> +    }
> +    sdp->exclude =3D 1;
> +    spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
> +    return 1;
> +}
> +
>  static int sfds_list_empty(Sg_device *sdp)
>  {
>      unsigned long flags;
> @@ -303,7 +318,7 @@ sg_open(struct inode *inode, struct file *filp)
>              goto error_out;
>          }
>          res =3D wait_event_interruptible(sdp->o_excl_wait,
> -                       ((!sfds_list_empty(sdp) || get_exclude(sdp))
> ? 0 : set_exclude(sdp, 1)));
> +            ((!sfds_list_empty(sdp) || get_exclude(sdp)) ? 0 :
> try_set_exclude(sdp)));
>          if (res) {
>              retval =3D res;    /* -ERESTARTSYS because signal hit pr=
ocess */
>              goto error_out;
> --=20
> 1.7.11.7
>=20

J=C3=B6rn

--
=46antasy is more important than knowledge. Knowledge is limited,
while fantasy embraces the whole world.
-- Albert Einstein
