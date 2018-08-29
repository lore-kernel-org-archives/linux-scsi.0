From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH] sym53c8xx: fix NULL pointer dereference panic in
 sym_int_sir() in sym_hipd.c
Date: Wed, 29 Aug 2018 19:56:22 +0300
Message-ID: <CAHp75Vc=Fg165nL+SFDXXDzBvtba+C7CLK24gyz3EaAb8QdjNQ@mail.gmail.com>
References: <1535557096-1324-1-git-send-email-george.kennedy@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1535557096-1324-1-git-send-email-george.kennedy@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: george.kennedy@oracle.com
Cc: matthew@wil.cx, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 29, 2018 at 6:42 PM George Kennedy
<george.kennedy@oracle.com> wrote:
>
> sym_int_sir() in sym_hipd.c does not check the command pointer for NULL
> before using it in debug message prints.
>
> Suggested-by: Matthew Wilcox <matthew.wilcox@oracle.com>
> Signed-off-by: George Kennedy <george.kennedy@oracle.com>
> Reviewed-by: Mark Kanda <mark.kanda@oracle.com>

> +#define sym_printk(lvl, tp, cp, fmt, v...) do { \

Since all users are KERN_WARNING level, perhaps

sym_pr_warn(tp, ...) ... \
... \
..._printk(KERN_WARNING ...

?

> +       if (cp)                                                 \
> +               scmd_printk(lvl, cp->cmd, fmt, ##v);            \
> +       else                                                    \
> +               starget_printk(lvl, tp->starget, fmt, ##v);     \
> +} while (0)
> +
>  /*
>   *  chip exception handler for programmed interrupts.
>   */
> @@ -4415,7 +4422,7 @@ static void sym_int_sir(struct sym_hcb *np)
>          *  been selected with ATN.  We do not want to handle that.
>          */
>         case SIR_SEL_ATN_NO_MSG_OUT:
> -               scmd_printk(KERN_WARNING, cp->cmd,
> +               sym_printk(KERN_WARNING, tp, cp,
>                                 "No MSG OUT phase after selection with ATN\n");
>                 goto out_stuck;
>         /*
> @@ -4423,7 +4430,7 @@ static void sym_int_sir(struct sym_hcb *np)
>          *  having reselected the initiator.
>          */
>         case SIR_RESEL_NO_MSG_IN:
> -               scmd_printk(KERN_WARNING, cp->cmd,
> +               sym_printk(KERN_WARNING, tp, cp,
>                                 "No MSG IN phase after reselection\n");
>                 goto out_stuck;
>         /*
> @@ -4431,7 +4438,7 @@ static void sym_int_sir(struct sym_hcb *np)
>          *  an IDENTIFY.
>          */
>         case SIR_RESEL_NO_IDENTIFY:
> -               scmd_printk(KERN_WARNING, cp->cmd,
> +               sym_printk(KERN_WARNING, tp, cp,
>                                 "No IDENTIFY after reselection\n");
>                 goto out_stuck;
>         /*
> @@ -4460,7 +4467,7 @@ static void sym_int_sir(struct sym_hcb *np)
>         case SIR_RESEL_ABORTED:
>                 np->lastmsg = np->msgout[0];
>                 np->msgout[0] = M_NOOP;
> -               scmd_printk(KERN_WARNING, cp->cmd,
> +               sym_printk(KERN_WARNING, tp, cp,
>                         "message %x sent on bad reselection\n", np->lastmsg);
>                 goto out;
>         /*
> --
> 1.8.3.1
>


-- 
With Best Regards,
Andy Shevchenko
