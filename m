From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v1.3 10/11] arcmsr: Fixed coding style errors and white
 space change
Date: Fri, 21 Feb 2014 11:19:33 +0300
Message-ID: <20140221081933.GH26776@mwanda>
References: <CAKiknE-FJg9y7CTMbvow277mr=H+oKkBLjDc1qDYjhHtpfBdZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKiknE-FJg9y7CTMbvow277mr=H+oKkBLjDc1qDYjhHtpfBdZA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fengguang.wu@intel.com, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 21, 2014 at 12:35:58PM +0800, =E9=BB=83=E6=B8=85=E9=9A=86 w=
rote:
> From: Ching <ching2048@areca.com.tw>
>=20
> Fixed coding style errors and white space change.
>=20

This doesn't *just* do that.  It also has code changes.

> -static void arcmsr_hbaC_flush_cache(struct AdapterControlBlock *pACB=
)
> +static void
> +arcmsr_hbaC_flush_cache(struct AdapterControlBlock *pACB)
>  {
>         struct MessageUnit_C __iomem *reg =3D pACB->pmuC;
> -       int retry_count =3D 30;/* enlarge wait flush adapter cache ti=
me:
> 10 minute */
> +       int retry_count =3D 6;
> +
>         writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgadd=
r0);
>         writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_d=
oorbell);
> +       readl(&reg->inbound_doorbell);
> +       readl(&reg->inbound_msgaddr0);


We also change the printed driver string and there are other code
changes as well.

regards,
dan carpenter
