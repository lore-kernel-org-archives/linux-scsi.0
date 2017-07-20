From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: mpt3sas_scsih: remove unnecessary statics
Date: Wed, 19 Jul 2017 17:07:43 -0700
Message-ID: <1500509263.3701.39.camel@linux.vnet.ibm.com>
References: <20170719220636.GA8136@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170719220636.GA8136@embeddedgus>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-07-19 at 17:06 -0500, Gustavo A. R. Silva wrote:
> Remove unnecessary static on local variables raid_device.
> Such variables are initialized before being used, on
> every execution path throughout the functions. The
> static has no benefit and, removing it reduces the
> object file size.
> 
> This issue was detected using Coccinelle and the following semantic
> patch:
> 
> @bad exists@
> position p;
> identifier x;
> type T;
> @@
> 
> static T x@p;
> ...
> x = <+...x...+>
> 
> @@
> identifier x;
> expression e;
> type T;
> position p != bad.p;
> @@
> 
> -static
>  T x@p;
>  ... when != x
>      when strict
> ?x = e;
> 
> In the following log you can see a significant difference in the
> object file size. This log is the output of the size command, before
> and after the code change:
> 
> before:
>    text    data     bss     dec     hex filename
>  126304   30384    1280  157968   26910
> drivers/scsi/mpt3sas/mpt3sas_scsih.o
> 
> after:
>    text    data     bss     dec     hex filename
>  126292   30240    1152  157684   267f4
> drivers/scsi/mpt3sas/mpt3sas_scsih.o

I've got to say I'm deeply uneasy about using a data/bss size reduction
as the benchmark for saying something shouldn't be declared static.  In
this particular case the reduction is minimal, so it probably doesn't
matter; however, if the reduction were more significant, changing from
static to dynamic (i.e. on stack) allocation would increase the risk
that we'd blow the kernel stack.  Indeed one reason you might find
static declarations in functions is precisely to avoid blowing the
stack, so we wouldn't want to reverse them.

Other reasons for having static allocations instead of dynamic ones is
that you need to DMA to/from the structure (you can't DMA to stack) or
because you want to preserve values across function invocations.

There are definite reasons why statics in functions are a bad idea:
they prevent recursion and trip up code analysis, but in none of the
above cases would the fix be to remove the static qualifier.

James
