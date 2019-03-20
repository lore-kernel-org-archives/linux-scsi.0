From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] scsi: ufs-mediatek: Avoid using ret uninitialized in ufs_mtk_setup_clocks
Date: Wed, 20 Mar 2019 15:23:44 -0700
Message-ID: <CAKwvOdn0fcGSsX7XQD2v9iV=FMM6z5shqN4=Zjkkyyrd+y8rWw@mail.gmail.com>
References: <20190320180340.25795-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190320180340.25795-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stanley Chu <stanley.chu@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, linux-mediatek@lists.infradead.org, clang-built-linux@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 20, 2019 at 11:06 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> When building with -Wsometimes-uninitialized, Clang warns:
>
> drivers/scsi/ufs/ufs-mediatek.c:112:7: warning: variable 'ret' is used
> uninitialized whenever 'if' condition is false
> [-Wsometimes-uninitialized]
>                 if (on)
>                     ^~
> drivers/scsi/ufs/ufs-mediatek.c:120:9: note: uninitialized use occurs
> here
>         return ret;
>                ^~~
> drivers/scsi/ufs/ufs-mediatek.c:112:3: note: remove the 'if' if its
> condition is always true
>                 if (on)
>                 ^~~~~~~
> drivers/scsi/ufs/ufs-mediatek.c:108:7: warning: variable 'ret' is used
> uninitialized whenever 'if' condition is false
> [-Wsometimes-uninitialized]
>                 if (!on)
>                     ^~~
> drivers/scsi/ufs/ufs-mediatek.c:120:9: note: uninitialized use occurs
> here
>         return ret;
>                ^~~
> drivers/scsi/ufs/ufs-mediatek.c:108:3: note: remove the 'if' if its
> condition is always true
>                 if (!on)
>                 ^~~~~~~~
> drivers/scsi/ufs/ufs-mediatek.c:96:9: note: initialize the variable
> 'ret' to silence this warning
>         int ret;
>                ^
>                 = 0
> 2 warnings generated.
>
> Remove the default case and initialize ret to -EINVAL to properly fix
> this warning.
>
> Fixes: ddd90623ce26 ("scsi: ufs-mediatek: Add UFS support for Mediatek SoC chips")
> Link: https://github.com/ClangBuiltLinux/linux/issues/426
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/scsi/ufs/ufs-mediatek.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
> index c3b78fc83d3f..34aecad04468 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -93,7 +93,7 @@ static int ufs_mtk_setup_clocks(struct ufs_hba *hba, bool on,
>                                 enum ufs_notify_change_status status)
>  {
>         struct ufs_mtk_host *host = ufshcd_get_variant(hba);
> -       int ret;
> +       int ret = -EINVAL;
>
>         /*
>          * In case ufs_mtk_init() is not yet done, simply ignore.
> @@ -112,9 +112,6 @@ static int ufs_mtk_setup_clocks(struct ufs_hba *hba, bool on,
>                 if (on)
>                         ret = phy_power_on(host->mphy);
>                 break;
> -       default:
> -               ret = -EINVAL;
> -               break;
>         }
>
>         return ret;
> --
> 2.21.0
>

The enum being switched on (enum ufs_notify_change_status) only has 2
values; so the default case is impossible.  A switch is probably
overkill, but this change is fine as is.  Thanks for sending it.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
-- 
Thanks,
~Nick Desaulniers
