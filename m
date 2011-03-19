From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [GIT PULL] First round of SCSI updates for 2.6.38 merge window
Date: Sat, 19 Mar 2011 21:00:50 +0100
Message-ID: <AANLkTinvwKzYiy5M=Eoae_ViRQwVBF-TgedKspP0qagE@mail.gmail.com>
References: <1300392635.17266.5.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1300392635.17266.5.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 17, 2011 at 21:10, James Bottomley <James.Bottomley@suse.de=
> wrote:
> This represents the usual round of driver updates (fcoe, lpfc, qla2xx=
x,
> zfcp, bnx2i, mpt2sas, megaraid_sas, iscsi, cxgbi and hpsa) plus one n=
ew
> driver (bnx2fc) and as a bonus we move libsas from the old libata eh =
to
> the new one paving the way for junking the old one (once we can get i=
pr
> converted).

> Martin K. Petersen (3):
> =C2=A0 =C2=A0 =C2=A0sd: Logical Block Provisioning update

drivers/scsi/sd.c: In function =E2=80=98sd_prep_fn=E2=80=99:
drivers/scsi/sd.c:544: warning: =E2=80=98ret=E2=80=99 may be used unini=
tialized in this function

Actually it's in scsi_setup_discard_cmnd(), which is inlined:

        int ret;

        [...]

        switch (sdkp->provisioning_mode) {

                [...]

        default:
                goto out;
        }

        [...]

        ret =3D scsi_setup_blk_pc_cmnd(sdp, rq);
        rq->buffer =3D page_address(page);

out:
        if (ret !=3D BLKPREP_OK) {

Gr{oetje,eeting}s,

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org

In personal conversations with technical people, I call myself a hacker=
=2E But
when I'm talking to journalists I just say "programmer" or something li=
ke that.
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =C2=A0=C2=A0 -- Linus Torvalds
