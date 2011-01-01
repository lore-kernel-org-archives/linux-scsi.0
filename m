From: Torsten Kaiser <just.for.lkml@googlemail.com>
Subject: Re: [PATCH] [SCSI] arcmsr: &/| confusion in arcmsr_build_ccb()
Date: Sat, 1 Jan 2011 18:12:00 +0100
Message-ID: <AANLkTikD-E5-XzvgWSJOY518A7ERpuYNwNcYCgKKn91K@mail.gmail.com>
References: <4D1F5A17.4010807@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56495 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab1AARMC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Jan 2011 12:12:02 -0500
In-Reply-To: <4D1F5A17.4010807@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: roel kluin <roel.kluin@gmail.com>
Cc: nick.cheng@areca.com.tw, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, James.Bottomley@suse.de, linux-scsi@vger.kernel.org

On Sat, Jan 1, 2011 at 5:45 PM, roel kluin <roel.kluin@gmail.com> wrote=
:
> The WRITE_{6,10,12} are defined numbers, so the branch was always tak=
en.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> =A0drivers/scsi/arcmsr/arcmsr_hba.c | =A0 =A03 ++-
> =A01 files changed, 2 insertions(+), 1 deletions(-)
>
> See include/scsi/scsi.h:58-123 for
> #define WRITE_6 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0x0a
> #define WRITE_10 =A0 =A0 =A0 =A0 =A0 =A0 =A00x2a
> #define WRITE_12 =A0 =A0 =A0 =A0 =A0 =A0 =A00xaa
>
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/a=
rcmsr_hba.c
> index 17e3df4..a6e5222 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -1171,7 +1171,8 @@ static int arcmsr_build_ccb(struct AdapterContr=
olBlock *acb,
> =A0 =A0 =A0 =A0arcmsr_cdb->msgPages =3D arccdbsize/0x100 + (arccdbsiz=
e % 0x100 ? 1 : 0);
> =A0 =A0 =A0 =A0if ( arccdbsize > 256)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0arcmsr_cdb->Flags |=3D ARCMSR_CDB_FLAG=
_SGL_BSIZE;
> - =A0 =A0 =A0 if (pcmd->cmnd[0]|WRITE_6 || pcmd->cmnd[0]|WRITE_10 || =
pcmd->cmnd[0]|WRITE_12 ){
> + =A0 =A0 =A0 if (pcmd->cmnd[0] & WRITE_6 || pcmd->cmnd[0] & WRITE_10=
 ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pcmd->cmnd[0] & WRITE_1=
2 ){

I'm not sure, if the compiler will optimize this anyway, but would it
look better this way:
if (pcmd->cmnd[0] & (WRITE_6 | WRITE_10 | WRITE_12)){

And that would open the question what really was meant, as that will
be equal to:
if (pcmd->cmnd[0] & WRITE_12){

(if you look at the constants, you can skip WRITE_6 and _10 as there
bits are already included in WRITE_12)


> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0arcmsr_cdb->Flags |=3D ARCMSR_CDB_FLAG=
_WRITE;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0ccb->arc_cdb_size =3D arccdbsize;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
