From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH] scsi: qla2xxx: fix printk format string warning on 32-bit
Date: Fri, 9 Jun 2017 14:09:22 +0000
Message-ID: <BD5813D3-84B4-4C6B-A0E5-270349A77571@cavium.com>
References: <20170609104711.3471894-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170609104711.3471894-1-arnd@arndb.de>
Content-Language: en-US
Content-ID: <C33649677400414AAEEBF0712EDF1707@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Tran, Quinn" <Quinn.Tran@cavium.com>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Arnd,=20

> On Jun 9, 2017, at 3:46 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>=20
> On 32-bit architectures, we using %lx to print a size_t causes a harmless
> warning:
>=20
> qla2xxx/qla_init.c: In function 'qla24xx_load_risc_flash':
> qla2xxx/qla_init.c:6407:7: error: format '%lx' expects argument of type '=
long unsigned int', but argument 5 has type 'unsigned int' [-Werror=3Dforma=
t=3D]
> qla2xxx/qla_init.c: In function 'qla24xx_load_risc_blob':
> qla2xxx/qla_init.c:6709:7: error: format '%lx' expects argument of type '=
long unsigned int', but argument 5 has type 'unsigned int' [-Werror=3Dforma=
t=3D]
>=20
> The correct format string is %zx.
>=20
> Fixes: 0f110b54d157 ("scsi: qla2xxx: Retain loop test for fwdump length e=
xceeding buffer length")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> drivers/scsi/qla2xxx/qla_init.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 436968ad4484..730e7fe4344a 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -6404,7 +6404,7 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint3=
2_t *srisc_addr,
> 	    "-> template size %x bytes\n", dlen);
> 	if (dlen > risc_size * sizeof(*dcode)) {
> 		ql_log(ql_log_warn, vha, 0x0167,
> -		    "Failed fwdump template exceeds array by %lx bytes\n",
> +		    "Failed fwdump template exceeds array by %zx bytes\n",
> 		    (size_t)(dlen - risc_size * sizeof(*dcode)));
> 		goto default_template;
> 	}
> @@ -6706,7 +6706,7 @@ qla24xx_load_risc_blob(scsi_qla_host_t *vha, uint32=
_t *srisc_addr)
> 	    "-> template size %x bytes\n", dlen);
> 	if (dlen > risc_size * sizeof(*fwcode)) {
> 		ql_log(ql_log_warn, vha, 0x0177,
> -		    "Failed fwdump template exceeds array by %lx bytes\n",
> +		    "Failed fwdump template exceeds array by %zx bytes\n",
> 		    (size_t)(dlen - risc_size * sizeof(*fwcode)));
> 		goto default_template;
> 	}
> --=20
> 2.9.0
>=20

I had posted patch already to fix this https://patchwork.kernel.org/patch/9=
769981/

Thanks,
- Himanshu
