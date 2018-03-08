From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] aic7xxx/aic79xx: remove VLAs
Date: Thu, 8 Mar 2018 11:52:25 -0800
Message-ID: <CAGXu5jK=JhBFHBGpbWF46DC3-QMruiB0qqz1z+njcK2h7jVU9w@mail.gmail.com>
References: <20180308132225.13229-1-steve@sk2.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <kernel-hardening-return-12255-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Sender: keescook@google.com
In-Reply-To: <20180308132225.13229-1-steve@sk2.org>
To: Stephen Kitt <steve@sk2.org>
Cc: hare <hare@suse.com>, linux-scsi@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 8, 2018 at 5:22 AM, Stephen Kitt <steve@sk2.org> wrote:
> In preparation to enabling -Wvla, remove VLAs and replace them with
> fixed-length arrays instead.
>
> The arrays fixed here, using the number of constant sections, aren't
> really VLAs, but they appear so to the compiler. Since we know at
> build-time how many critical sections there are, we might as well use
> a pre-processor-level constant instead.
>
> This was prompted by https://lkml.org/lkml/2018/3/7/621
>
> Signed-off-by: Stephen Kitt <steve@sk2.org>
> ---
>  drivers/scsi/aic7xxx/aic79xx_core.c        | 8 ++++----
>  drivers/scsi/aic7xxx/aic79xx_seq.h_shipped | 3 +--
>  drivers/scsi/aic7xxx/aic7xxx_core.c        | 8 ++++----
>  drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped | 3 +--
>  drivers/scsi/aic7xxx/aicasm/aicasm.c       | 6 ++++--
>  5 files changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
> index b560f396ee99..034f4eebb160 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_core.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_core.c
> @@ -9338,9 +9338,9 @@ ahd_dumpseq(struct ahd_softc* ahd)
>  static void
>  ahd_loadseq(struct ahd_softc *ahd)
>  {
> -       struct  cs cs_table[num_critical_sections];
> -       u_int   begin_set[num_critical_sections];
> -       u_int   end_set[num_critical_sections];
> +       struct  cs cs_table[NUM_CRITICAL_SECTIONS];
> +       u_int   begin_set[NUM_CRITICAL_SECTIONS];
> +       u_int   end_set[NUM_CRITICAL_SECTIONS];
>         const struct patch *cur_patch;
>         u_int   cs_count;
>         u_int   cur_cs;
> @@ -9456,7 +9456,7 @@ ahd_loadseq(struct ahd_softc *ahd)
>                  * Move through the CS table until we find a CS
>                  * that might apply to this instruction.
>                  */
> -               for (; cur_cs < num_critical_sections; cur_cs++) {
> +               for (; cur_cs < NUM_CRITICAL_SECTIONS; cur_cs++) {
>                         if (critical_sections[cur_cs].end <= i) {
>                                 if (begin_set[cs_count] == TRUE
>                                  && end_set[cs_count] == FALSE) {
> diff --git a/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped b/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped
> index 4b51e232392f..20fb9ca9e271 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped
> +++ b/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped
> @@ -1186,5 +1186,4 @@ static const struct cs {
>         { 759, 763 }
>  };
>
> -static const int num_critical_sections = sizeof(critical_sections)
> -                                      / sizeof(*critical_sections);
> +#define NUM_CRITICAL_SECTIONS 14

The compiler doesn't treat "const" as a literal, hence the need to
change this. However, you can still use the sizeof (actually, this is
exactly ARRAY_SIZE()). Perhaps:

#define NUM_CRITICAL_SECTIONS ARRAY_SIZE(critical_sections)

?

Otherwise, looks great!

-Kees

-- 
Kees Cook
Pixel Security
