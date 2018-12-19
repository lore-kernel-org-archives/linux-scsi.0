From: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
Subject: Re: [PATCH] scsi/dpt_i2o.c: Use dma_zalloc_coherent
Date: Wed, 19 Dec 2018 18:41:03 +0530
Message-ID: <CAJr6mf0ste8SLahS5Sy2aL9RidxJ_nf5hqeYFriDGtYpB2FUyg@mail.gmail.com>
References: <5bf00de4.1c69fb81.7dd65.5785@mx.google.com> <CAJr6mf2Kvj0FJb2zf9FZUNEkyQtYZVbFNBwG+dH_LyhSDU92wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJr6mf2Kvj0FJb2zf9FZUNEkyQtYZVbFNBwG+dH_LyhSDU92wg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: aacraid@microsemi.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Souptick Joarder <jrdr.linux@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Brajeswar Ghosh <brajeswar.linux@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Dec 1, 2018 at 6:45 PM Sabyasachi Gupta
<sabyasachi.linux@gmail.com> wrote:
>
> On Sat, Nov 17, 2018 at 6:17 PM Sabyasachi Gupta
> <sabyasachi.linux@gmail.com> wrote:
> >
> > Replaced dma_alloc_coherent + memset with dma_zalloc_coherent
> >
> > Signed-off-by: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
>
> Any comment on this patch?

Any comment on this patch?

>
> > ---
> >  drivers/scsi/dpt_i2o.c | 12 ++++--------
> >  1 file changed, 4 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
> > index 37de8fb..056383a 100644
> > --- a/drivers/scsi/dpt_i2o.c
> > +++ b/drivers/scsi/dpt_i2o.c
> > @@ -1370,13 +1370,12 @@ static s32 adpt_i2o_reset_hba(adpt_hba* pHba)
> >                 schedule_timeout_uninterruptible(1);
> >         } while (m == EMPTY_QUEUE);
> >
> > -       status = dma_alloc_coherent(&pHba->pDev->dev, 4, &addr, GFP_KERNEL);
> > +       status = dma_zalloc_coherent(&pHba->pDev->dev, 4, &addr, GFP_KERNEL);
> >         if(status == NULL) {
> >                 adpt_send_nop(pHba, m);
> >                 printk(KERN_ERR"IOP reset failed - no free memory.\n");
> >                 return -ENOMEM;
> >         }
> > -       memset(status,0,4);
> >
> >         msg[0]=EIGHT_WORD_MSG_SIZE|SGL_OFFSET_0;
> >         msg[1]=I2O_CMD_ADAPTER_RESET<<24|HOST_TID<<12|ADAPTER_TID;
> > @@ -2836,14 +2835,13 @@ static s32 adpt_i2o_init_outbound_q(adpt_hba* pHba)
> >
> >         msg=(u32 __iomem *)(pHba->msg_addr_virt+m);
> >
> > -       status = dma_alloc_coherent(&pHba->pDev->dev, 4, &addr, GFP_KERNEL);
> > +       status = dma_zalloc_coherent(&pHba->pDev->dev, 4, &addr, GFP_KERNEL);
> >         if (!status) {
> >                 adpt_send_nop(pHba, m);
> >                 printk(KERN_WARNING"%s: IOP reset failed - no free memory.\n",
> >                         pHba->name);
> >                 return -ENOMEM;
> >         }
> > -       memset(status, 0, 4);
> >
> >         writel(EIGHT_WORD_MSG_SIZE| SGL_OFFSET_6, &msg[0]);
> >         writel(I2O_CMD_OUTBOUND_INIT<<24 | HOST_TID<<12 | ADAPTER_TID, &msg[1]);
> > @@ -2890,14 +2888,13 @@ static s32 adpt_i2o_init_outbound_q(adpt_hba* pHba)
> >                         pHba->reply_pool, pHba->reply_pool_pa);
> >         }
> >
> > -       pHba->reply_pool = dma_alloc_coherent(&pHba->pDev->dev,
> > +       pHba->reply_pool = dma_zalloc_coherent(&pHba->pDev->dev,
> >                                 pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4,
> >                                 &pHba->reply_pool_pa, GFP_KERNEL);
> >         if (!pHba->reply_pool) {
> >                 printk(KERN_ERR "%s: Could not allocate reply pool\n", pHba->name);
> >                 return -ENOMEM;
> >         }
> > -       memset(pHba->reply_pool, 0 , pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4);
> >
> >         for(i = 0; i < pHba->reply_fifo_size; i++) {
> >                 writel(pHba->reply_pool_pa + (i * REPLY_FRAME_SIZE * 4),
> > @@ -3126,13 +3123,12 @@ static int adpt_i2o_build_sys_table(void)
> >         sys_tbl_len = sizeof(struct i2o_sys_tbl) +      // Header + IOPs
> >                                 (hba_count) * sizeof(struct i2o_sys_tbl_entry);
> >
> > -       sys_tbl = dma_alloc_coherent(&pHba->pDev->dev,
> > +       sys_tbl = dma_zalloc_coherent(&pHba->pDev->dev,
> >                                 sys_tbl_len, &sys_tbl_pa, GFP_KERNEL);
> >         if (!sys_tbl) {
> >                 printk(KERN_WARNING "SysTab Set failed. Out of memory.\n");
> >                 return -ENOMEM;
> >         }
> > -       memset(sys_tbl, 0, sys_tbl_len);
> >
> >         sys_tbl->num_entries = hba_count;
> >         sys_tbl->version = I2OVERSION;
> > --
> > 2.7.4
> >
