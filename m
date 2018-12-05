From: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
Subject: Re: [PATCH] drivers/scsi/snic/snic_trc.c: Use vzalloc
Date: Wed, 5 Dec 2018 10:03:19 +0530
Message-ID: <CAJr6mf2obk8MgPc3AO74EwsiXt66OZGni57Z8v3TgnePyACLmg@mail.gmail.com>
References: <5beda000.1c69fb81.e6599.d3d8@mx.google.com> <CAJr6mf0rawk6rDRB7NzsTUXyqvt0U5J4SUnVYck2_-jh6D6MoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJr6mf0rawk6rDRB7NzsTUXyqvt0U5J4SUnVYck2_-jh6D6MoQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kartilak@cisco.com, sebaddel@cisco.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Souptick Joarder <jrdr.linux@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Brajeswar Ghosh <brajeswar.linux@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 23, 2018 at 8:07 PM Sabyasachi Gupta
<sabyasachi.linux@gmail.com> wrote:
>
> On Thu, Nov 15, 2018 at 10:04 PM Sabyasachi Gupta
> <sabyasachi.linux@gmail.com> wrote:
> >
> > Replaced vmalloc + memset with vzalloc
> >
> > Signed-off-by: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
>
> Any comment on this patch?

Any comment on this patch?

>
> > ---
> >  drivers/scsi/snic/snic_trc.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/snic/snic_trc.c b/drivers/scsi/snic/snic_trc.c
> > index fc60c93..458eaba 100644
> > --- a/drivers/scsi/snic/snic_trc.c
> > +++ b/drivers/scsi/snic/snic_trc.c
> > @@ -126,7 +126,7 @@ snic_trc_init(void)
> >         int tbuf_sz = 0, ret;
> >
> >         tbuf_sz = (snic_trace_max_pages * PAGE_SIZE);
> > -       tbuf = vmalloc(tbuf_sz);
> > +       tbuf = vzalloc(tbuf_sz);
> >         if (!tbuf) {
> >                 SNIC_ERR("Failed to Allocate Trace Buffer Size. %d\n", tbuf_sz);
> >                 SNIC_ERR("Trace Facility not enabled.\n");
> > @@ -135,7 +135,6 @@ snic_trc_init(void)
> >                 return ret;
> >         }
> >
> > -       memset(tbuf, 0, tbuf_sz);
> >         trc->buf = (struct snic_trc_data *) tbuf;
> >         spin_lock_init(&trc->lock);
> >
> > --
> > 2.7.4
> >
