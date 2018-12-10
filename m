From: James Bottomley <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: qla2xxx: fix unused function warning
Date: Mon, 10 Dec 2018 13:31:15 -0800
Message-ID: <1544477475.2753.26.camel@linux.ibm.com>
References: <20181210205215.2703138-1-arnd@arndb.de>
         <1544475666.185366.378.camel@acm.org>
         <CAK8P3a0MShhjPMUdNs=CTqOJ-ovDPczYiQFL9c2M2dOUQ4yK7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a0MShhjPMUdNs=CTqOJ-ovDPczYiQFL9c2M2dOUQ4yK7w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, bvanassche@acm.org
Cc: qla2xxx-upstream@qlogic.com, "Martin K. Petersen" <martin.petersen@oracle.com>, loberman@redhat.com, Himanshu Madhani <himanshu.madhani@cavium.com>, Stephen Rothwell <sfr@canb.auug.org.au>, hmadhani@marvell.com, quinn.tran@cavium.com, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, darren.trapp@cavium.com, William.Kuzeja@stratus.com, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-12-10 at 22:28 +0100, Arnd Bergmann wrote:
> On Mon, Dec 10, 2018 at 10:01 PM Bart Van Assche <bvanassche@acm.org>
> wrote:
> > 
> > On Mon, 2018-12-10 at 21:51 +0100, Arnd Bergmann wrote:
> > > In what seems to be a mismatch between the scsi-fixes branch and
> > > the scsi-mkp/for-next branch, a newly introduced variable from
> > > one patch got obsoleted in another one:
> > > 
> > > drivers/scsi/qla2xxx/qla_os.c: In function
> > > '__qla2x00_abort_all_cmds':
> > > drivers/scsi/qla2xxx/qla_os.c:1791:11: error: unused variable
> > > 'status' [-Werror=unused-variable]
> > > 
> > > Remove the variable again.
> > > 
> > > Fixes: c4e521b654e1 ("scsi: qla2xxx: Split the
> > > __qla2x00_abort_all_cmds() function")
> > > Fixes: f2ffd4e5bc7b ("scsi: qla2xxx: Timeouts occur on surprise
> > > removal of QLogic adapter")
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > ---
> > > Maybe check carefully that the merge in linux-next is otherwise
> > > correct
> > > ---
> > >  drivers/scsi/qla2xxx/qla_os.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/scsi/qla2xxx/qla_os.c
> > > b/drivers/scsi/qla2xxx/qla_os.c
> > > index 63c47bc7ae59..db331cb5ba3c 100644
> > > --- a/drivers/scsi/qla2xxx/qla_os.c
> > > +++ b/drivers/scsi/qla2xxx/qla_os.c
> > > @@ -1788,7 +1788,7 @@ static void qla2x00_abort_srb(struct
> > > qla_qpair *qp, srb_t *sp, const int res,
> > >  static void
> > >  __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
> > >  {
> > > -     int cnt, status;
> > > +     int cnt;
> > >       unsigned long flags;
> > >       srb_t *sp;
> > >       scsi_qla_host_t *vha = qp->vha;
> > 
> > When I prepared commit c4e521b654e1 I verified that my patch did
> > not produce any
> > warnings when building with W=1. So something must be wrong at your
> > side. Did you
> > perhaps start from linux-next to prepare this patch? If so, please
> > submit this
> > patch to Stephen Rothwell.
> 
> Yes, I tried to make clear that the two branches are fine by
> themselves, sorry if I was still ambiguous. The patch is currently
> only needed on linux-next as far as I can tell, but we should avoid
> getting the same error when the branches are merged in mainline.

It should be fixed in linux-next as of the next release.  It was just a
problem with the original merge which I fixed when I did my version of
it.

James
