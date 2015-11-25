From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] target: use offset_in_page macro
Date: Wed, 25 Nov 2015 15:00:36 +0100
Message-ID: <1448460036.2877.80.camel@suse.de>
References: <a4523a15b2ebf30e6eec6d04ab851a2c8d8bf041.1448459290.git.geliangtang@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a4523a15b2ebf30e6eec6d04ab851a2c8d8bf041.1448459290.git.geliangtang@163.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geliang Tang <geliangtang@163.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Dan Carpenter <dan.carpenter@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-11-25 at 21:49 +0800, Geliang Tang wrote:
> Use offset_in_page macro instead of (addr & ~PAGE_MASK).
>=20
> Signed-off-by: Geliang Tang <geliangtang@163.com>
> ---
> =C2=A0drivers/target/target_core_user.c | 2 +-
> =C2=A0drivers/target/tcm_fc/tfc_io.c=C2=A0=C2=A0=C2=A0=C2=A0| 8 ++++-=
---
> =C2=A02 files changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/target/target_core_user.c
> b/drivers/target/target_core_user.c
> index 937cebf..d5477c0 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -194,7 +194,7 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_=
cmd
> *se_cmd)
> =C2=A0
> =C2=A0static inline void tcmu_flush_dcache_range(void *vaddr, size_t =
size)
> =C2=A0{
> -	unsigned long offset =3D (unsigned long) vaddr & ~PAGE_MASK;
> +	unsigned long offset =3D offset_in_page(vaddr);
> =C2=A0
> =C2=A0	size =3D round_up(size+offset, PAGE_SIZE);
> =C2=A0	vaddr -=3D offset;
> diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/t=
fc_io.c
> index 847c1aa..6f7c65a 100644
> --- a/drivers/target/tcm_fc/tfc_io.c
> +++ b/drivers/target/tcm_fc/tfc_io.c
> @@ -154,9 +154,9 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
> =C2=A0			BUG_ON(!page);
> =C2=A0			from =3D kmap_atomic(page + (mem_off >> PAGE_SHIFT));
> =C2=A0			page_addr =3D from;
> -			from +=3D mem_off & ~PAGE_MASK;
> +			from +=3D offset_in_page(mem_off);
> =C2=A0			tlen =3D min(tlen, (size_t)(PAGE_SIZE -
> -						(mem_off & ~PAGE_MASK)));
> +						offset_in_page(mem_off)));
> =C2=A0			memcpy(to, from, tlen);
> =C2=A0			kunmap_atomic(page_addr);
> =C2=A0			to +=3D tlen;
> @@ -314,9 +314,9 @@ void ft_recv_write_data(struct ft_cmd *cmd, struc=
t
> fc_frame *fp)
> =C2=A0
> =C2=A0		to =3D kmap_atomic(page + (mem_off >> PAGE_SHIFT));
> =C2=A0		page_addr =3D to;
> -		to +=3D mem_off & ~PAGE_MASK;
> +		to +=3D offset_in_page(mem_off);
> =C2=A0		tlen =3D min(tlen, (size_t)(PAGE_SIZE -
> -					=C2=A0=C2=A0(mem_off & ~PAGE_MASK)));
> +					=C2=A0=C2=A0offset_in_page(mem_off)));
> =C2=A0		memcpy(to, from, tlen);
> =C2=A0		kunmap_atomic(page_addr);
> =C2=A0

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
