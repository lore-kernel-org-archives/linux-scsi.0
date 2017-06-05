From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH] qla2xxx: remove writeq/readq function definitions
Date: Mon, 5 Jun 2017 15:57:12 +0000
Message-ID: <DE09FD4F-E485-42E6-868D-2AE2FD1485BE@cavium.com>
References: <20170602113225.24816-1-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170602113225.24816-1-clabbe.montjoie@gmail.com>
Content-Language: en-US
Content-ID: <0E1271258F5E0441A274A4C157E58793@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> On Jun 2, 2017, at 4:32 AM, Corentin Labbe <clabbe.montjoie@gmail.com> wr=
ote:
>=20
> Instead of rewriting write/readq, use linux/io-64-nonatomic-lo-hi.h which
> already have them.
>=20
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> ---
> drivers/scsi/qla2xxx/qla_nx.h | 17 ++---------------
> 1 file changed, 2 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nx.h b/drivers/scsi/qla2xxx/qla_nx.=
h
> index 77624eac95a4..71a41093530e 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.h
> +++ b/drivers/scsi/qla2xxx/qla_nx.h
> @@ -7,6 +7,8 @@
> #ifndef __QLA_NX_H
> #define __QLA_NX_H
>=20
> +#include <linux/io-64-nonatomic-lo-hi.h>
> +
> /*
>  * Following are the states of the Phantom. Phantom will set them and
>  * Host will read to check if the fields are correct.
> @@ -819,21 +821,6 @@ struct qla82xx_uri_data_desc{
> #define MIU_TEST_AGT_WRDATA_UPPER_LO		(0x0b0)
> #define	MIU_TEST_AGT_WRDATA_UPPER_HI		(0x0b4)
>=20
> -#ifndef readq
> -static inline u64 readq(void __iomem *addr)
> -{
> -	return readl(addr) | (((u64) readl(addr + 4)) << 32LL);
> -}
> -#endif
> -
> -#ifndef writeq
> -static inline void writeq(u64 val, void __iomem *addr)
> -{
> -	writel(((u32) (val)), (addr));
> -	writel(((u32) (val >> 32)), (addr + 4));
> -}
> -#endif
> -
> /* Request and response queue size */
> #define REQUEST_ENTRY_CNT_82XX		128	/* Number of request entries. */
> #define RESPONSE_ENTRY_CNT_82XX		128	/* Number of response entries.*/
> --=20
> 2.13.0
>=20

Looks Good. Thanks=20

Acked-by: Himanshu Madhani <himanshu.madhani@cavium.com>


- Himanshu
