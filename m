From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] bfa: remove VLA
Date: Thu, 8 Mar 2018 13:43:07 -0800
Message-ID: <CAGXu5j+_DvU4jNESxO2zBvP_VrTxOwVzh_NXqdw+S5amQukNjg@mail.gmail.com>
References: <20180308213841.13807-1-steve@sk2.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180308213841.13807-1-steve@sk2.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Kitt <steve@sk2.org>
Cc: hare <hare@suse.com>, linux-scsi@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 8, 2018 at 1:38 PM, Stephen Kitt <steve@sk2.org> wrote:
> In preparation to enabling -Wvla, remove VLAs and replace them with
> fixed-length arrays instead.
>
> bfad_bsg.c uses a variable-length array declaration to measure the
> size of a putative array; this can be replaced by the product of the
> size of an element and the number of elements, avoiding the VLA
> altogether.
>
> This was prompted by https://lkml.org/lkml/2018/3/7/621
>
> Signed-off-by: Stephen Kitt <steve@sk2.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/scsi/bfa/bfad_bsg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
> index 3976e787ba64..7c884f881180 100644
> --- a/drivers/scsi/bfa/bfad_bsg.c
> +++ b/drivers/scsi/bfa/bfad_bsg.c
> @@ -891,7 +891,7 @@ bfad_iocmd_fabric_get_lports(struct bfad_s *bfad, void *cmd,
>
>         if (bfad_chk_iocmd_sz(payload_len,
>                 sizeof(struct bfa_bsg_fabric_get_lports_s),
> -               sizeof(wwn_t[iocmd->nports])) != BFA_STATUS_OK) {
> +               sizeof(wwn_t) * iocmd->nports) != BFA_STATUS_OK) {
>                 iocmd->status = BFA_STATUS_VERSION_FAIL;
>                 goto out;
>         }
> --
> 2.11.0
>



-- 
Kees Cook
Pixel Security
