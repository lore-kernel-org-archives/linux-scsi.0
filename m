From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH resend 2/5] libata-scsi: fix read-only bits checking in ata_mselect_*()
Date: Fri, 22 Jul 2016 07:20:02 +0800
Message-ID: <CAGnHSE=-upJ7_Wj-mpaa_tfZ6vxAbx5xaGqe0eRjFrw6Rw+ttA@mail.gmail.com>
References: <af84a796696f2f366d330595d1a818e8daeb86d8.1469126217.git.tom.ty89@gmail.com>
 <b2ae6752649bc02641d38fee75ee35a59e8466d8.1469126217.git.tom.ty89@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <b2ae6752649bc02641d38fee75ee35a59e8466d8.1469126217.git.tom.ty89@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.de>, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This is actually a bit clumsy. Sending a rewritten version.

On 22 July 2016 at 02:41,  <tom.ty89@gmail.com> wrote:
> From: Tom Yan <tom.ty89@gmail.com>
>
> Commit 7780081c1f04 ("libata-scsi: Set information sense field for
> invalid parameter") changed how ata_mselect_*() make sure read-only
> bits are not modified. The new implementation introduced a bug that
> the read-only bits in the byte that has a changeable bit will not
> be checked.
>
> Added the necessary check, with comments explaining the heuristic.
>
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
>
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index eb5e8ff..ac90676 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3631,8 +3631,18 @@ static int ata_mselect_caching(struct ata_queued_cmd *qc,
>          */
>         ata_msense_caching(dev->id, mpage, false);
>         for (i = 0; i < CACHE_MPAGE_LEN - 2; i++) {
> -               if (i == 0)
> -                       continue;
> +               /* Check the first byte */
> +               if (i == 0) {
> +                       /* except the WCE bit */
> +                       if ((mpage[i + 2] & 0xfb) != (buf[i] & 0xfb)) {
> +                               *fp = i;
> +                               return -EINVAL;
> +                       } else {
> +                               continue;
> +                       }
> +               }
> +
> +               /* Check the remaining bytes */
>                 if (mpage[i + 2] != buf[i]) {
>                         *fp = i;
>                         return -EINVAL;
> @@ -3686,8 +3696,18 @@ static int ata_mselect_control(struct ata_queued_cmd *qc,
>          */
>         ata_msense_control(dev, mpage, false);
>         for (i = 0; i < CONTROL_MPAGE_LEN - 2; i++) {
> -               if (i == 0)
> -                       continue;
> +               /* Check the first byte */
> +               if (i == 0) {
> +                       /* except the D_SENSE bit */
> +                       if ((mpage[i + 2] & 0xfb) != (buf[i] & 0xfb)) {
> +                               *fp = i;
> +                               return -EINVAL;
> +                       } else {
> +                               continue;
> +                       }
> +               }
> +
> +               /* Check the remaining bytes */
>                 if (mpage[2 + i] != buf[i]) {
>                         *fp = i;
>                         return -EINVAL;
> --
> 2.9.0
>
