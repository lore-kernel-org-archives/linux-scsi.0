From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] scsi: mptfusion: Remove unnecessary parentheses and
 simplify null checks
Date: Mon, 17 Sep 2018 10:29:50 -0700
Message-ID: <CAKwvOdmi3CxLNRGH7bWgNR5eK3p5eB_U4OsDwLPkuaDgA74JtA@mail.gmail.com>
References: <20180915063645.31295-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180915063645.31295-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 14, 2018 at 11:36 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns when multiple pairs of parentheses are used for a single
> conditional statement.
>
> drivers/message/fusion/mptbase.c:338:11: warning: equality comparison
> with extraneous parentheses [-Wparentheses-equality]
>         if ((ioc == NULL))
>              ~~~~^~~~~~~
> drivers/message/fusion/mptbase.c:338:11: note: remove extraneous
> parentheses around the comparison to silence this warning
>         if ((ioc == NULL))
>             ~    ^      ~
> drivers/message/fusion/mptbase.c:338:11: note: use '=' to turn this
> equality comparison into an assignment
>         if ((ioc == NULL))
>                  ^~
>                  =
> drivers/message/fusion/mptbase.c:342:12: warning: equality comparison
> with extraneous parentheses [-Wparentheses-equality]
>         if ((pdev == NULL))
>              ~~~~~^~~~~~~
> drivers/message/fusion/mptbase.c:342:12: note: remove extraneous
> parentheses around the comparison to silence this warning
>         if ((pdev == NULL))
>             ~     ^      ~
> drivers/message/fusion/mptbase.c:342:12: note: use '=' to turn this
> equality comparison into an assignment
>         if ((pdev == NULL))
>                   ^~
>                   =
> 2 warnings generated.
>
> Remove them and while we're at it, simplify the NULL checks as '!var' is
> used more than 'var == NULL'.
>
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Nathan,
Thanks for this patch.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/message/fusion/mptbase.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index dc1e43a02599..ba551d8dfba4 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -335,11 +335,11 @@ static int mpt_remove_dead_ioc_func(void *arg)
>         MPT_ADAPTER *ioc = (MPT_ADAPTER *)arg;
>         struct pci_dev *pdev;
>
> -       if ((ioc == NULL))
> +       if (!ioc)
>                 return -1;
>
>         pdev = ioc->pcidev;
> -       if ((pdev == NULL))
> +       if (!pdev)
>                 return -1;
>
>         pci_stop_and_remove_bus_device_locked(pdev);
> --
> 2.18.0
>


-- 
Thanks,
~Nick Desaulniers
