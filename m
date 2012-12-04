From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH] megaraid_sas: fix memory leak if SGL has zero length entries
Date: Mon, 3 Dec 2012 17:49:23 -0800
Message-ID: <CAHtARFF0jGrd-7a5Jh16GK60SYBCP7f5Fg2=c8bb7K13aMneRQ@mail.gmail.com>
References: <1353488088-10684-1-git-send-email-bjorn@mork.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1353488088-10684-1-git-send-email-bjorn@mork.no>
Sender: stable-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 21, 2012 at 12:54 AM, Bj=F8rn Mork <bjorn@mork.no> wrote:
> commit 98cb7e44 ([SCSI] megaraid_sas: Sanity check user
> supplied length before passing it to dma_alloc_coherent())
> introduced a memory leak.  Memory allocated for entries
> following zero length SGL entries will not be freed.
>
> Reference: http://bugs.debian.org/688198
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Bj=F8rn Mork <bjorn@mork.no>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi=
/megaraid/megaraid_sas_base.c
> index d2c5366..12b6be4 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -4854,10 +4854,12 @@ megasas_mgmt_fw_ioctl(struct megasas_instance=
 *instance,
>                                     sense, sense_handle);
>         }
>
> -       for (i =3D 0; i < ioc->sge_count && kbuff_arr[i]; i++) {
> -               dma_free_coherent(&instance->pdev->dev,
> -                                   kern_sge32[i].length,
> -                                   kbuff_arr[i], kern_sge32[i].phys_=
addr);
> +       for (i =3D 0; i < ioc->sge_count; i++) {
> +               if (kbuff_arr[i])
> +                       dma_free_coherent(&instance->pdev->dev,
> +                                         kern_sge32[i].length,
> +                                         kbuff_arr[i],
> +                                         kern_sge32[i].phys_addr);
>         }
>
>         megasas_return_cmd(instance, cmd);

Acked-by: Adam Radford <aradford@gmail.com>
