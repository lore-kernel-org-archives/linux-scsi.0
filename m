From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v8 2/3] scsi: ufs: add debugfs for ufs
Date: Wed, 29 Apr 2015 07:43:14 -0700
Message-ID: <1430318594.2189.11.camel@HansenPartnership.com>
References: <1429012281-24068-1-git-send-email-gbroner@codeaurora.org>
	 <1429012281-24068-3-git-send-email-gbroner@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1429012281-24068-3-git-send-email-gbroner@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Gilad Broner <gbroner@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Lee Susman <lsusman@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-04-14 at 14:51 +0300, Gilad Broner wrote:
> From: Lee Susman <lsusman@codeaurora.org>
>=20
> Adding debugfs capability for ufshcd.
>=20
> debugfs attributes introduced in this patch:
>  - View driver/controller runtime data
>  - Command tag statistics for performance analisis
>  - Dump device descriptor info
>  - Track recoverable errors statistics during runtime
>  - Change UFS power mode during runtime
>      entry a string in the format 'GGLLMM' where:
>          G - selected gear
>          L - number of lanes
>          M - power mode
>              (1=3Dfast mode, 2=3Dslow mode, 4=3Dfast-auto mode,
>               5=3Dslow-auto mode)
>      First letter is for RX, second is for TX.
>  - Get/set DME attributes
>=20
> Signed-off-by: Lee Susman <lsusman@codeaurora.org>
> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
> Signed-off-by: Raviv Shvili <rshvili@codeaurora.org>
> Signed-off-by: Gilad Broner <gbroner@codeaurora.org>

Bloody test your damn changes.  That means running them through a confi=
g
options permutation when you introduce config dependencies.

This is what happens with CONFIG_DEBUG_FS=3Dn:

        drivers/scsi/ufs/ufshcd.c:92:9: warning: =E2=80=98struct scsi_c=
md=E2=80=99
        declared inside parameter list [enabled by default]
          struct scsi_cmd *cmd)
                 ^
        drivers/scsi/ufs/ufshcd.c:92:9: warning: its scope is only this
        definition or declaration, which is probably not what you want
        [enabled by default]

That's a typo inside the other branch of the #ifdef ... apparently none
of your reviewers spotted it either.

        drivers/scsi/ufs/ufs-debugfs.c: In function
        =E2=80=98ufsdbg_tag_stats_show=E2=80=99:
        drivers/scsi/ufs/ufs-debugfs.c:60:18: error: =E2=80=98struct uf=
s_hba=E2=80=99
        has no member named =E2=80=98ufs_stats=E2=80=99
          ufs_stats =3D &hba->ufs_stats;
                          ^
        ...
       =20
This lot is obvious: ufs-debufs should not be compiled at all if
CONFIG_DEBUG_FS=3Dn

=46rom now on, I'm not taking your code unless it has an external revie=
wer
who makes sure I don't keep running across crap like this.

James
