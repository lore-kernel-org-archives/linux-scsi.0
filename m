From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH] aic94xx: set error code on an error path in aic94xx_init
Date: Thu, 31 May 2018 22:15:45 +0300
Message-ID: <CAHp75VdAWzAB1K3bGEAgM28ZZFYa-92JqERy=jKd1Fc_738eBg@mail.gmail.com>
References: <1527791294-21600-1-git-send-email-melnichenko@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527791294-21600-1-git-send-email-melnichenko@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Melnichenko <melnichenko@ispras.ru>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ldv-project@linuxtesting.org
List-Id: linux-scsi@vger.kernel.org

On Thu, May 31, 2018 at 9:28 PM, Peter Melnichenko
<melnichenko@ispras.ru> wrote:
> When sas_domain_attach_transport returns NULL, aic94xx_init
> frees acquired resources but returns err equal to 0, as
> assigned by a previous statement.
>
> The patch sets err to -ENOMEM before jumping to the error label.

Wouldn't be better to fix a callee to return proper error code and...

>         aic94xx_transport_template =
>                 sas_domain_attach_transport(&aic94xx_transport_functions);
> -       if (!aic94xx_transport_template)
> +       if (!aic94xx_transport_template) {
> +               err = -ENOMEM;
>                 goto out_destroy_caches;
> +       }

this becomes

err = _attach_();
if (err < 0)
 goto ;
_template = err;

?

-- 
With Best Regards,
Andy Shevchenko
