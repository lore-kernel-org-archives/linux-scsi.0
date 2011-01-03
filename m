From: Torsten Kaiser <just.for.lkml@googlemail.com>
Subject: Re: [PATCH] [SCSI] arcmsr: &/| confusion in arcmsr_build_ccb()
Date: Mon, 3 Jan 2011 06:22:49 +0100
Message-ID: <AANLkTingw6peu9g1bN53L9Jtd9XkM-GzrJoNEF-x9Zcu@mail.gmail.com>
References: <4D1F5A17.4010807@gmail.com>
	<20110101170854.GB32652@parisc-linux.org>
	<4D1F7517.7080803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D1F7517.7080803@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: roel kluin <roel.kluin@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, nick.cheng@areca.com.tw, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, James.Bottomley@suse.de, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 1, 2011 at 7:40 PM, roel kluin <roel.kluin@gmail.com> wrote=
:
> Make sure no other command which does a write, such as UNMAP and WRIT=
E_32, is missed.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> =A0drivers/scsi/arcmsr/arcmsr_hba.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> If you agree this is the right fix, please ack.
>
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/a=
rcmsr_hba.c
> index 17e3df4..a5acedc 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -1171,7 +1171,7 @@ static int arcmsr_build_ccb(struct AdapterContr=
olBlock *acb,
> =A0 =A0 =A0 =A0arcmsr_cdb->msgPages =3D arccdbsize/0x100 + (arccdbsiz=
e % 0x100 ? 1 : 0);
> =A0 =A0 =A0 =A0if ( arccdbsize > 256)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0arcmsr_cdb->Flags |=3D ARCMSR_CDB_FLAG=
_SGL_BSIZE;
> - =A0 =A0 =A0 if (pcmd->cmnd[0]|WRITE_6 || pcmd->cmnd[0]|WRITE_10 || =
pcmd->cmnd[0]|WRITE_12 ){
> + =A0 =A0 =A0 if (pcmd->sc_data_direction =3D=3D DMA_TO_DEVICE)

If you remove the { from the if, then ...

> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0arcmsr_cdb->Flags |=3D ARCMSR_CDB_FLAG=
_WRITE;
> =A0 =A0 =A0 =A0}

=2E.. you also need to remove this }. ;-)

> =A0 =A0 =A0 =A0ccb->arc_cdb_size =3D arccdbsize;
>
