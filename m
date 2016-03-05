From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] cxgbit: fix dma_addr_t printk format
Date: Fri, 04 Mar 2016 16:25:07 -0800
Message-ID: <1457137507.4044.143.camel@perches.com>
References: <1457136294-2229829-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1457136294-2229829-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Varun Prakash <varun@chelsio.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2016-03-05 at 01:04 +0100, Arnd Bergmann wrote:
> The newly added driver prints a dma_addr_t using the %llx format stri=
ng,
> but that is wrong on most 32-bit architectures:
>=20
> drivers/target/iscsi/cxgbit/cxgbit_ddp.c: In function 'cxgbit_dump_sg=
l':
> drivers/target/iscsi/cxgbit/cxgbit_ddp.c:180:10: error: format '%llx'=
 expects argument of type 'long long unsigned int', but argument 8 has =
type 'dma_addr_t {aka unsigned int}' [-Werror=3Dformat=3D]
> =A0=A0=A0pr_info("\t%d/%u, 0x%p: len %u, off %u, pg 0x%p, dma 0x%llx,=
 %u\n",
>=20
> Unfortunately, we can't use the %pad format string here because
> we are not printing an lvalue, so we have to add a cast to u64, which
> matches the format string on all architectures.
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: c49aa56e556d ("cxgbit: add cxgbit_ddp.c")
> ---
> =A0drivers/target/iscsi/cxgbit/cxgbit_ddp.c | 2 +-
> =A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c b/drivers/targe=
t/iscsi/cxgbit/cxgbit_ddp.c
> index 07e2bc86d0df..d667bc88e21d 100644
> --- a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
> +++ b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
> @@ -179,7 +179,7 @@ cxgbit_dump_sgl(const char *cap, struct scatterli=
st *sgl, int nents)
> =A0	for_each_sg(sgl, sg, nents, i)
> =A0		pr_info("\t%d/%u, 0x%p: len %u, off %u, pg 0x%p, dma 0x%llx, %u\=
n",
> =A0			i, nents, sg, sg->length, sg->offset, sg_page(sg),
> -			sg_dma_address(sg), sg_dma_len(sg));
> +			(u64)sg_dma_address(sg), sg_dma_len(sg));
> =A0}
> =A0
> =A0static int cxgbit_ddp_sgl_check(struct scatterlist *sgl, int nents=
)

You could create a temporary:

=A0	for_each_sg(sgl, sg, nents, i) {
		dma_addr_t addr =3D sg_dma_address(sg);

		pr_info("\t%d/%u, 0x%p: len %u, off %u, pg 0x%p, dma %pad, %u\n",
			i, nents, sg, sg->length, sg->offset, sg_page(sg),
			&addr, sg_dma_len(sg));
	}

>=20
