From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: Re: [PATCH] scsi/aic94xx/aic94xx_hwi.c: Use dma_pool_zalloc
Date: Fri, 2 Nov 2018 11:24:03 +0530
Message-ID: <CAFqt6zbfizXX8myKgE_5k6X2gDrQGJmhWJDubgqiTL2r62gb_Q@mail.gmail.com>
References: <20181101041909.GA3241@jordon-HP-15-Notebook-PC> <CAGXu5jLYaT7LtUS+t98GjMjjzz2kbs6JZ_WJRYnWo7iZ9nOFKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jLYaT7LtUS+t98GjMjjzz2kbs6JZ_WJRYnWo7iZ9nOFKQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, Brajeswar Ghosh <brajeswar.linux@gmail.com>, Sabyasachi Gupta <sabyasachi.linux@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 2, 2018 at 2:25 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Wed, Oct 31, 2018 at 9:19 PM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
> > Replaced dma_pool_alloc + memset with dma_pool_zalloc
> >
> > Signed-off-by: Brajeswar Ghosh <brajeswar.linux@gmail.com>
> > Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks Kees.
>
> -Kees
>
> > ---
> >  drivers/scsi/aic94xx/aic94xx_hwi.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.c b/drivers/scsi/aic94xx/aic94xx_hwi.c
> > index 3b8ad55e59de..2bc7615193bd 100644
> > --- a/drivers/scsi/aic94xx/aic94xx_hwi.c
> > +++ b/drivers/scsi/aic94xx/aic94xx_hwi.c
> > @@ -1057,14 +1057,13 @@ static struct asd_ascb *asd_ascb_alloc(struct asd_ha_struct *asd_ha,
> >
> >         if (ascb) {
> >                 ascb->dma_scb.size = sizeof(struct scb);
> > -               ascb->dma_scb.vaddr = dma_pool_alloc(asd_ha->scb_pool,
> > +               ascb->dma_scb.vaddr = dma_pool_zalloc(asd_ha->scb_pool,
> >                                                      gfp_flags,
> >                                                     &ascb->dma_scb.dma_handle);
> >                 if (!ascb->dma_scb.vaddr) {
> >                         kmem_cache_free(asd_ascb_cache, ascb);
> >                         return NULL;
> >                 }
> > -               memset(ascb->dma_scb.vaddr, 0, sizeof(struct scb));
> >                 asd_init_ascb(asd_ha, ascb);
> >
> >                 spin_lock_irqsave(&seq->tc_index_lock, flags);
> > --
> > 2.17.1
> >
>
>
>
> --
> Kees Cook
