From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] [SCSI] arcmsr: &/| confusion in arcmsr_build_ccb()
Date: Mon, 03 Jan 2011 10:43:30 -0600
Message-ID: <1294073011.4721.7.camel@mulgrave.site>
References: <4D1F5A17.4010807@gmail.com>
	 <20110101170854.GB32652@parisc-linux.org>  <4D1F7517.7080803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D1F7517.7080803@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: roel kluin <roel.kluin@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, just.for.lkml@googlemail.com, nick.cheng@areca.com.tw, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2011-01-01 at 19:40 +0100, roel kluin wrote:
> Make sure no other command which does a write, such as UNMAP and WRIT=
E_32, is missed.
>=20
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/scsi/arcmsr/arcmsr_hba.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> If you agree this is the right fix, please ack.
>=20
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/a=
rcmsr_hba.c
> index 17e3df4..a5acedc 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -1171,7 +1171,7 @@ static int arcmsr_build_ccb(struct AdapterContr=
olBlock *acb,
>  	arcmsr_cdb->msgPages =3D arccdbsize/0x100 + (arccdbsize % 0x100 ? 1=
 : 0);
>  	if ( arccdbsize > 256)
>  		arcmsr_cdb->Flags |=3D ARCMSR_CDB_FLAG_SGL_BSIZE;
> -	if (pcmd->cmnd[0]|WRITE_6 || pcmd->cmnd[0]|WRITE_10 || pcmd->cmnd[0=
]|WRITE_12 ){
> +	if (pcmd->sc_data_direction =3D=3D DMA_TO_DEVICE)
>  		arcmsr_cdb->Flags |=3D ARCMSR_CDB_FLAG_WRITE;
>  	}
>  	ccb->arc_cdb_size =3D arccdbsize;

Compile checking patches you send in next time would be most welcome:

  CC [M]  drivers/scsi/arcmsr/arcmsr_hba.o
drivers/scsi/arcmsr/arcmsr_hba.c:1177:5: error: expected =E2=80=98=3D=E2=
=80=99, =E2=80=98,=E2=80=99, =E2=80=98;=E2=80=99,
=E2=80=98asm=E2=80=99 or =E2=80=98__attribute__=E2=80=99 before =E2=80=98=
->=E2=80=99 token
drivers/scsi/arcmsr/arcmsr_hba.c:1178:2: error: expected identifier or
=E2=80=98(=E2=80=99 before =E2=80=98return=E2=80=99
drivers/scsi/arcmsr/arcmsr_hba.c:1179:1: error: expected identifier or
=E2=80=98(=E2=80=99 before =E2=80=98}=E2=80=99 token
drivers/scsi/arcmsr/arcmsr_hba.c: In function =E2=80=98arcmsr_build_ccb=
=E2=80=99:
drivers/scsi/arcmsr/arcmsr_hba.c:1176:2: warning: control reaches end o=
f
non-void function

James
