From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [SCSI] aacraid: silence two GCC warnings
Date: Wed, 20 Feb 2013 10:40:23 +0000
Message-ID: <1361356823.2581.43.camel@dabdike.int.hansenpartnership.com>
References: <1360440561.1350.27.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1360440561.1350.27.camel@x61.thuisdomein>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2013-02-09 at 21:09 +0100, Paul Bolle wrote:
> Compiling src.o for a 32 bit system triggers two GCC warnings:
>     drivers/scsi/aacraid/src.c: In function =E2=80=98aac_src_deliver_=
message=E2=80=99:
>     drivers/scsi/aacraid/src.c:410:3: warning: right shift count >=3D=
 width of type [enabled by default]
>     drivers/scsi/aacraid/src.c:434:2: warning: right shift count >=3D=
 width of type [enabled by default]
>=20
> Silence these warnings by casting the 'address' variable (of type
> dma_addr_t) to u64 on those two lines.
>=20
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Compile tested only.
>=20
> 1) Changing '0L' to 'OUL' might be a bit of cargo cult programming. I
> doubt it's necessary. Members of that cult might also change
> '0xffffffff' to '0xffffffffUL', but I didn't.
>=20
>  drivers/scsi/aacraid/src.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
> index 3b021ec..dfa8a37 100644
> --- a/drivers/scsi/aacraid/src.c
> +++ b/drivers/scsi/aacraid/src.c
> @@ -407,7 +407,7 @@ static int aac_src_deliver_message(struct fib *fi=
b)
>  		fib->hw_fib_va->header.StructType =3D FIB_MAGIC2;
>  		fib->hw_fib_va->header.SenderFibAddress =3D (u32)address;
>  		fib->hw_fib_va->header.u.TimeStamp =3D 0;
> -		BUG_ON((u32)(address >> 32) !=3D 0L);
> +		BUG_ON(((u64)address >> 32) !=3D 0UL);

Actually, this isn't the right way to do this.  The correct way would b=
e
address >> 16 >> 16, but no-one is expected to remember this, so we hav=
e
it macroised in kernel.h as upper_32_bits().

So this should become

BUG_ON(upper_32_bits(address) !=3D 0L);

and a similar change for the below.

James

>  		address |=3D fibsize;
>  	} else {
>  		/* Calculate the amount to the fibsize bits */
> @@ -431,7 +431,7 @@ static int aac_src_deliver_message(struct fib *fi=
b)
>  		address |=3D fibsize;
>  	}
> =20
> -	src_writel(dev, MUnit.IQ_H, (address >> 32) & 0xffffffff);
> +	src_writel(dev, MUnit.IQ_H, ((u64)address >> 32) & 0xffffffff);
>  	src_writel(dev, MUnit.IQ_L, address & 0xffffffff);
> =20
>  	return 0;
