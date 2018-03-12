From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Subject: Re: [PATCH v2] scsi: eata: drop VLA in reorder()
Date: Mon, 12 Mar 2018 17:50:27 +0100
Message-ID: <CAJHCu1JDLJkF1Bhg0c-GeNYBKx23o3Jry7gwehrAb_yZfssJVw@mail.gmail.com>
References: <1520858937-3582-1-git-send-email-s.mesoraca16@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520858937-3582-1-git-send-email-s.mesoraca16@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Tobin C. Harding" <tobin@apporbit.com>, Dario Ballabio <ballabio_dario@emc.com>, Kees Cook <keescook@chromium.org>, Salvatore Mesoraca <s.mesoraca16@gmail.com>, valdis.kletnieks@vt.edu
List-Id: linux-scsi@vger.kernel.org

2018-03-12 13:48 GMT+01:00 Salvatore Mesoraca <s.mesoraca16@gmail.com>:
> Avoid 3 VLAs[1] by using a single dinamically allocated array
> and some helper variables: we don't need 3 arrays.
>
> [1] https://lkml.org/lkml/2018/3/7/621
>
> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
> ---
>  drivers/scsi/eata.c | 40 ++++++++++++++++++++++++++--------------
>  1 file changed, 26 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
> index 6501c33..8ba44b7 100644
> --- a/drivers/scsi/eata.c
> +++ b/drivers/scsi/eata.c
> @@ -2091,12 +2091,14 @@ static void sort(unsigned long sk[], unsigned int da[], unsigned int n,
>  static int reorder(struct hostdata *ha, unsigned long cursec,
>                    unsigned int ihdlr, unsigned int il[], unsigned int n_ready)
>  {
> +       int overlap;
>         struct scsi_cmnd *SCpnt;
>         struct mscp *cpp;
>         unsigned int k, n;
>         unsigned int rev = 0, s = 1, r = 1;
> -       unsigned int input_only = 1, overlap = 0;
> -       unsigned long sl[n_ready], pl[n_ready], ll[n_ready];
> +       unsigned int input_only = 1;
> +       unsigned long *sl;
> +       unsigned long sl_zero, sl_cur, sl_prev, ll_cur, ll_prev;
>         unsigned long maxsec = 0, minsec = ULONG_MAX, seek = 0, iseek = 0;
>         unsigned long ioseek = 0;
>
> @@ -2115,6 +2117,12 @@ static int reorder(struct hostdata *ha, unsigned long cursec,
>         if (n_ready <= 1)
>                 return 0;
>
> +       overlap = -ENOMEM;
> +       sl = kcalloc(n_ready, sizeof(*sl), GFP_ATOMIC);

I should have used kmalloc_array :/
Sending v3

> +       if (!sl)
> +               goto out;
> +       overlap = 0;
> +
>         for (n = 0; n < n_ready; n++) {
>                 k = il[n];
>                 cpp = &ha->cp[k];
> @@ -2164,31 +2172,33 @@ static int reorder(struct hostdata *ha, unsigned long cursec,
>         if (!((rev && r) || (!rev && s)))
>                 sort(sl, il, n_ready, rev);
>
> +       sl_zero = sl[0];
> +
>         if (!input_only)
>                 for (n = 0; n < n_ready; n++) {
>                         k = il[n];
>                         cpp = &ha->cp[k];
>                         SCpnt = cpp->SCpnt;
> -                       ll[n] = blk_rq_sectors(SCpnt->request);
> -                       pl[n] = SCpnt->serial_number;
> +                       ll_cur = blk_rq_sectors(SCpnt->request);
> +                       sl_cur = sl[n];
> +                       sl[n] = SCpnt->serial_number;
>
> -                       if (!n)
> -                               continue;
> -
> -                       if ((sl[n] == sl[n - 1])
> -                           || (!rev && ((sl[n - 1] + ll[n - 1]) > sl[n]))
> -                           || (rev && ((sl[n] + ll[n]) > sl[n - 1])))
> +                       if (n && ((sl_cur == sl_prev)
> +                                 || (!rev && ((sl_prev + ll_prev) > sl_cur))
> +                                 || (rev && ((sl_cur + ll_cur) > sl_prev))))
>                                 overlap = 1;
> +                       ll_prev = ll_cur;
> +                       sl_prev = sl_cur;
>                 }
>
>         if (overlap)
> -               sort(pl, il, n_ready, 0);
> +               sort(sl, il, n_ready, 0);
>
>         if (link_statistics) {
> -               if (cursec > sl[0])
> -                       iseek = cursec - sl[0];
> +               if (cursec > sl_zero)
> +                       iseek = cursec - sl_zero;
>                 else
> -                       iseek = sl[0] - cursec;
> +                       iseek = sl_zero - cursec;
>                 batchcount++;
>                 readycount += n_ready;
>                 seeknosort += seek / 1024;
> @@ -2225,6 +2235,8 @@ static int reorder(struct hostdata *ha, unsigned long cursec,
>                              YESNO(overlap), cpp->din);
>                 }
>  #endif
> +       kfree(sl);
> +out:
>         return overlap;
>  }
>
> --
> 1.9.1
>
