From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: Re: [PATCH] scsi/pmcraid.c: Use dma_pool_zalloc
Date: Wed, 24 Oct 2018 09:06:59 +0530
Message-ID: <CAFqt6zYpU=2FBnMHQisdTrnKR5F7BY2+hWP-NZH6kRNaTT=NJg@mail.gmail.com>
References: <20181002052631.GA2853@jordon-HP-15-Notebook-PC> <CAFqt6zbnVTc2EHQR7Bc8LJjix+23o9k5_qYbJfiWmL3tz5+6=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFqt6zbnVTc2EHQR7Bc8LJjix+23o9k5_qYbJfiWmL3tz5+6=g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sabyasachi Gupta <sabyasachi.linux@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 8, 2018 at 9:58 PM Souptick Joarder <jrdr.linux@gmail.com> wrote:
>
> On Tue, Oct 2, 2018 at 10:53 AM Souptick Joarder <jrdr.linux@gmail.com> wrote:
> >
> > Replaced dma_pool_alloc + memset with dma_pool_zalloc.
> >
> > Signed-off-by: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
> > Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
>
> Any comment on this patch ?

Any comment on this patch ?

>
> > ---
> >  drivers/scsi/pmcraid.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> > index 4e86994..84a2734 100644
> > --- a/drivers/scsi/pmcraid.c
> > +++ b/drivers/scsi/pmcraid.c
> > @@ -4681,7 +4681,7 @@ static int pmcraid_allocate_control_blocks(struct pmcraid_instance *pinstance)
> >
> >         for (i = 0; i < PMCRAID_MAX_CMD; i++) {
> >                 pinstance->cmd_list[i]->ioa_cb =
> > -                       dma_pool_alloc(
> > +                       dma_pool_zalloc(
> >                                 pinstance->control_pool,
> >                                 GFP_KERNEL,
> >                                 &(pinstance->cmd_list[i]->ioa_cb_bus_addr));
> > @@ -4690,8 +4690,6 @@ static int pmcraid_allocate_control_blocks(struct pmcraid_instance *pinstance)
> >                         pmcraid_release_control_blocks(pinstance, i);
> >                         return -ENOMEM;
> >                 }
> > -               memset(pinstance->cmd_list[i]->ioa_cb, 0,
> > -                       sizeof(struct pmcraid_control_block));
> >         }
> >         return 0;
> >  }
> > --
> > 1.9.1
> >
