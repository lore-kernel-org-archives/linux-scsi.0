From: Torsten Kaiser <just.for.lkml@googlemail.com>
Subject: Re: [PATCH] [SCSI] arcmsr: &/| confusion in arcmsr_build_ccb()
Date: Sat, 1 Jan 2011 18:28:34 +0100
Message-ID: <AANLkTikxhKXmnmCKr_HUW3dg3=O3qxNK+ThQEr37zEnC@mail.gmail.com>
References: <4D1F5A17.4010807@gmail.com>
	<20110101170854.GB32652@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51747 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab1AAR2g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Jan 2011 12:28:36 -0500
In-Reply-To: <20110101170854.GB32652@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: roel kluin <roel.kluin@gmail.com>, nick.cheng@areca.com.tw, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, James.Bottomley@suse.de, linux-scsi@vger.kernel.org

On Sat, Jan 1, 2011 at 6:08 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Sat, Jan 01, 2011 at 05:45:11PM +0100, roel kluin wrote:
>> The WRITE_{6,10,12} are defined numbers, so the branch was always ta=
ken.
>
> You're right, but even this will basically always set the write flag,
> since some bits will be set the same, even for reads. =A0Eg:
>
> #define READ_10 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0x28
> #define WRITE_10 =A0 =A0 =A0 =A0 =A0 =A0 =A00x2a
>
> It should instead be:
>
>> + =A0 =A0 if (pcmd->cmnd[0] =3D=3D WRITE_6 || pcmd->cmnd[0] =3D=3D W=
RITE_10 ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pcmd->cmnd[0] =3D=3D WRITE=
_12 ){
>
> That will of course miss other commands which do writes, such as UNMA=
P
> and WRITE_32. =A0So we should do it properly:
>
> =A0 =A0 =A0 =A0if (pcmd->sc_data_direction =3D=3D DMA_TO_DEVICE)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0arcmsr_cdb->Flags |=3D ARCMSR_CDB_FLAG=
_WRITE;
>

<http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
commitdiff;h=3Dae52e7f09ff509df11cd408eabe90132b6be1231;hp=3Df034260db3=
30bb3ffc815fcb682b1c84aca09591#patch2>
@@ -1034,10 +1075,10 @@ static int arcmsr_build_ccb(struct
AdapterControlBlock *acb,
                }
                arcmsr_cdb->sgcount =3D (uint8_t)cdb_sgcount;
                arcmsr_cdb->DataLength =3D scsi_bufflen(pcmd);
+       arcmsr_cdb->msgPages =3D arccdbsize/0x100 + (arccdbsize % 0x100=
 ? 1 : 0);
                if ( arccdbsize > 256)
                        arcmsr_cdb->Flags |=3D ARCMSR_CDB_FLAG_SGL_BSIZ=
E;
-       }
-       if (pcmd->sc_data_direction =3D=3D DMA_TO_DEVICE ) {
+       if (pcmd->cmnd[0]|WRITE_6 || pcmd->cmnd[0] | WRITE_10 ||
pcmd->cmnd[0]|WRITE_12) {
                arcmsr_cdb->Flags |=3D ARCMSR_CDB_FLAG_WRITE;
                ccb->ccb_flags |=3D CCB_FLAG_WRITE;
        }

Until June 2010 it was that way...
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
