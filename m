From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH] scsi: gdth: Only call dma_free_coherent when buf is not
 NULL in ioc_general
Date: Fri, 22 Mar 2019 08:26:53 -0700
Message-ID: <20190322152653.GB21978@archlinux-ryzen>
References: <20190307231839.3330-1-natechancellor@gmail.com>
 <CAKwvOd=PZUW1U0KiBgn8z8ReHeRX=s8xEtS7Gebf9-AXxguNNQ@mail.gmail.com>
 <CAK8P3a0w=6kk8bkyKi0rU-8Fxmh0XqjqACadUJviMzkp67myOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a0w=6kk8bkyKi0rU-8Fxmh0XqjqACadUJviMzkp67myOw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nick Desaulniers <ndesaulniers@google.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Achim Leubner <achim_leubner@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, clang-built-linux@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 22, 2019 at 03:30:08PM +0100, Arnd Bergmann wrote:
> On Fri, Mar 8, 2019 at 10:14 PM 'Nick Desaulniers' via Clang Built
> Linux <clang-built-linux@googlegroups.com> wrote:
> >
> > On Thu, Mar 7, 2019 at 3:19 PM Nathan Chancellor
> > <natechancellor@gmail.com> wrote:
> > >
> > > When building with -Wsometimes-uninitialized, Clang warns:
> > >
> > > drivers/scsi/gdth.c:3662:6: warning: variable 'paddr' is used
> > > uninitialized whenever 'if' condition is false
> > > [-Wsometimes-uninitialized]
> > >
> > > Don't attempt to call dma_free_coherent when buf is NULL (meaning that
> > > we never called dma_alloc_coherent and initialized paddr), which avoids
> > > this warning.
> > >
> > > Link: https://github.com/ClangBuiltLinux/linux/issues/402
> > > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > > ---
> > >  drivers/scsi/gdth.c | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> > > index e7f1dd4f3b66..0ca9b4393770 100644
> > > --- a/drivers/scsi/gdth.c
> > > +++ b/drivers/scsi/gdth.c
> > > @@ -3697,8 +3697,9 @@ static int ioc_general(void __user *arg, char *cmnd)
> > >
> > >         rval = 0;
> > >  out_free_buf:
> > > -       dma_free_coherent(&ha->pdev->dev, gen.data_len + gen.sense_len, buf,
> > > -                       paddr);
> > > +       if (buf)
> > > +               dma_free_coherent(&ha->pdev->dev, gen.data_len + gen.sense_len,
> > > +                                 buf, paddr);
> > >         return rval;
> > >  }
> 
> I came up with a different fix for this, but I think yours is better
> 
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> 
> For reference, this was my version:

This is also what I had initially but I felt this was more future proof
and matches how the rest of the tree handles calls to dma_free_coherent.

Thanks for the review!
Nathan

> 
> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> index e7f1dd4f3b66..c01f243902e1 100644
> --- a/drivers/scsi/gdth.c
> +++ b/drivers/scsi/gdth.c
> @@ -3697,8 +3697,9 @@ static int ioc_general(void __user *arg, char *cmnd)
> 
>         rval = 0;
>  out_free_buf:
> -       dma_free_coherent(&ha->pdev->dev, gen.data_len + gen.sense_len, buf,
> -                       paddr);
> +       if (gen.data_len + gen.sense_len > 0)
> +               dma_free_coherent(&ha->pdev->dev, gen.data_len +
> gen.sense_len, buf,
> +                               paddr);
>         return rval;
>  }
> 
> 
> > Alternatively, paddr is a dma_addr_t defined in include/linux/types.h:
> >
> > #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
> > typedef u64 dma_addr_t;
> > #else
> > typedef u32 dma_addr_t;
> > #endif
> >
> > Just initializing it to zero might be simpler than complicating the
> > control flow of this function further. Thoughts?
> 
> No, blindly shutting up warnings is almost never the
> right solution, even when they are false positives. The code
> might change in the future and the bogus initialization would
> then prevent the compiler from warning about a new bug.
> 
>       Arnd
