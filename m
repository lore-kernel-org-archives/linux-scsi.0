From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: scsi-mq V2
Date: Thu, 10 Jul 2014 00:53:36 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B9628B@G9W0745.americas.hpqcorp.net>
References: <1403715121-1201-1-git-send-email-hch@lst.de>
 <20140708144829.GA5539@infradead.org> <53BD7041.5010300@interlog.com>
 <53BD9A24.7010203@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53BD9A24.7010203@kernel.dk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, "dgilbert@interlog.com" <dgilbert@interlog.com>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bvanassche@fusionio.com>, Benjamin LaHaise <bcrl@kvack.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Wednesday, 09 July, 2014 2:38 PM
> To: dgilbert@interlog.com; Christoph Hellwig; James Bottomley; Bart Van
> Assche; Elliott, Robert (Server Storage); linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: scsi-mq V2
> 
> On 2014-07-09 18:39, Douglas Gilbert wrote:
> > On 14-07-08 10:48 AM, Christoph Hellwig wrote:
> >> On Wed, Jun 25, 2014 at 06:51:47PM +0200, Christoph Hellwig wrote:
> >>> Changes from V1:
> >>>   - rebased on top of the core-for-3.17 branch, most notable the
> >>>     scsi logging changes
> >>>   - fixed handling of cmd_list to prevent crashes for some heavy
> >>>     workloads
> >>>   - fixed incorrect handling of !target->can_queue
> >>>   - avoid scheduling a workqueue on I/O completions when no queues
> >>>     are congested
> >>>
> >>> In addition to the patches in this thread there also is a git
> >>> available at:
> >>>
> >>>     git://git.infradead.org/users/hch/scsi.git scsi-mq.2
> >>
> >>
> >> I've pushed out a new scsi-mq.3 branch, which has been rebased on the
> >> latest core-for-3.17 tree + the "RFC: clean up command setup" series
> >> from June 29th.  Robert Elliot found a problem with not fully zeroed
> >> out UNMAP CDBs, which is fixed by the saner discard handling in that
> >> series.
> >>
> >> There is a new patch to factor the code from the above series for
> >> blk-mq use, which I've attached below.  Besides that the only changes
> >> are minor merge fixups in the main blk-mq usage patch.
> >
> > Be warned: both Rob Elliott and I can easily break
> > the scsi-mq.3 branch. It seems as though a regression
> > has slipped in. I notice that Christoph has added a
> > new branch called "scsi-mq.3-no-rebase".
> 
> Rob/Doug, those issues look very much like problems in the aio code. Can
> either/both of you try with:
> 
> f8567a3845ac05bb28f3c1b478ef752762bd39ef
> edfbbf388f293d70bf4b7c0bc38774d05e6f711a
> 
> reverted (in that order) and see if that changes anything.
> 
> 
> --
> Jens Axboe

scsi-mq.3-no-rebase, which has all the scsi updates from scsi-mq.3
but is based on 3.16.0-rc2 rather than 3.16.0-rc4, works fine:
* ^C exits fio cleanly with scsi_debug devices
* ^C exits fio cleanly with mpt3sas devices
* fio hits 1M IOPS with 16 hpsa devices
* fio hits 700K IOPS with 6 mpt3sas devices
* 38 device test to mpt3sas, hpsa, and scsi_debug devices runs OK


With:
* scsi-mq-3, which is based on 3.16.0-rc4
* [PATCH] x86-64: fix vDSO build from https://lkml.org/lkml/2014/7/3/738
* those two aio patches reverted

the problem still occurs - fio results in low or 0 IOPS, with perf top 
reporting unusual amounts of time spent in do_io_submit and io_submit.

perf top:
 14.38%  [kernel]              [k] do_io_submit
 13.71%  libaio.so.1.0.1       [.] io_submit
 13.32%  [kernel]              [k] system_call
 11.60%  [kernel]              [k] system_call_after_swapgs
  8.88%  [kernel]              [k] lookup_ioctx
  8.78%  [kernel]              [k] copy_user_generic_string
  7.78%  [kernel]              [k] io_submit_one
  5.97%  [kernel]              [k] blk_flush_plug_list
  2.73%  fio                   [.] fio_libaio_commit
  2.70%  [kernel]              [k] sysret_check
  2.68%  [kernel]              [k] blk_finish_plug
  1.98%  [kernel]              [k] blk_start_plug
  1.17%  [kernel]              [k] SyS_io_submit
  1.17%  [kernel]              [k] __get_user_4
  0.99%  fio                   [.] io_submit@plt
  0.85%  [kernel]              [k] _copy_from_user
  0.79%  [kernel]              [k] system_call_fastpath

Repeating some of last night's investigation details for the lists:

ftrace of one of the CPUs for all functions shows these 
are repeatedly being called:
 
           <...>-34508 [004] ....  6360.790714: io_submit_one <-do_io_submit
           <...>-34508 [004] ....  6360.790714: blk_finish_plug <-do_io_submit
           <...>-34508 [004] ....  6360.790714: blk_flush_plug_list <-blk_finish_plug
           <...>-34508 [004] ....  6360.790714: SyS_io_submit <-system_call_fastpath
           <...>-34508 [004] ....  6360.790715: do_io_submit <-SyS_io_submit
           <...>-34508 [004] ....  6360.790715: lookup_ioctx <-do_io_submit
           <...>-34508 [004] ....  6360.790715: blk_start_plug <-do_io_submit
           <...>-34508 [004] ....  6360.790715: io_submit_one <-do_io_submit
           <...>-34508 [004] ....  6360.790715: blk_finish_plug <-do_io_submit
           <...>-34508 [004] ....  6360.790715: blk_flush_plug_list <-blk_finish_plug
           <...>-34508 [004] ....  6360.790715: SyS_io_submit <-system_call_fastpath
           <...>-34508 [004] ....  6360.790715: do_io_submit <-SyS_io_submit
           <...>-34508 [004] ....  6360.790715: lookup_ioctx <-do_io_submit
           <...>-34508 [004] ....  6360.790716: blk_start_plug <-do_io_submit
           <...>-34508 [004] ....  6360.790716: io_submit_one <-do_io_submit
           <...>-34508 [004] ....  6360.790716: blk_finish_plug <-do_io_submit
           <...>-34508 [004] ....  6360.790716: blk_flush_plug_list <-blk_finish_plug
           <...>-34508 [004] ....  6360.790716: SyS_io_submit <-system_call_fastpath
           <...>-34508 [004] ....  6360.790716: do_io_submit <-SyS_io_submit
           <...>-34508 [004] ....  6360.790716: lookup_ioctx <-do_io_submit
           <...>-34508 [004] ....  6360.790716: blk_start_plug <-do_io_submit
           <...>-34508 [004] ....  6360.790717: io_submit_one <-do_io_submit
           <...>-34508 [004] ....  6360.790717: blk_finish_plug <-do_io_submit
           <...>-34508 [004] ....  6360.790717: blk_flush_plug_list <-blk_finish_plug
           <...>-34508 [004] ....  6360.790717: SyS_io_submit <-system_call_fastpath
           <...>-34508 [004] ....  6360.790717: do_io_submit <-SyS_io_submit

fs/aio.c do_io_submit is apparently completing (many times) - it's not
stuck in the for loop:
        blk_start_plug(&plug);

        /*
         * AKPM: should this return a partial result if some of the IOs were
         * successfully submitted?
         */
        for (i=0; i<nr; i++) {
                struct iocb __user *user_iocb;
                struct iocb tmp;

                if (unlikely(__get_user(user_iocb, iocbpp + i))) {
                        ret = -EFAULT;
                        break;
                }

                if (unlikely(copy_from_user(&tmp, user_iocb, sizeof(tmp)))) {
                        ret = -EFAULT;
                        break;
                }

                ret = io_submit_one(ctx, user_iocb, &tmp, compat);
                if (ret)
                        break;
        }
        blk_finish_plug(&plug);


fs/aio.c io_submit_one is not getting to fget, which is traceable:
        /* enforce forwards compatibility on users */
        if (unlikely(iocb->aio_reserved1 || iocb->aio_reserved2)) {
                pr_debug("EINVAL: reserve field set\n");
                return -EINVAL;
        }

        /* prevent overflows */
        if (unlikely(
            (iocb->aio_buf != (unsigned long)iocb->aio_buf) ||
            (iocb->aio_nbytes != (size_t)iocb->aio_nbytes) ||
            ((ssize_t)iocb->aio_nbytes < 0)
           )) {
                pr_debug("EINVAL: io_submit: overflow check\n");
                return -EINVAL;
        }

        req = aio_get_req(ctx);
        if (unlikely(!req))
                return -EAGAIN;

        req->ki_filp = fget(iocb->aio_fildes);

I don't have that file compiled with -DDEBUG so the pr_debug
prints are unavailable.  The -EAGAIN seems most likely to lead 
to a hang like this.

aio_get_req is not getting to kmem_cache_alloc, which is
traceable:
        if (!get_reqs_available(ctx))
                return NULL;

        req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);

get_reqs_available is probably returning false because not
enough reqs are available compared to req_batch:

        struct kioctx_cpu *kcpu;
        bool ret = false;

        preempt_disable();
        kcpu = this_cpu_ptr(ctx->cpu);

        if (!kcpu->reqs_available) {
                int old, avail = atomic_read(&ctx->reqs_available);

                do {
                        if (avail < ctx->req_batch)
                                goto out;

                        old = avail;
                        avail = atomic_cmpxchg(&ctx->reqs_available,
                                               avail, avail - ctx->req_batch);
                } while (avail != old);

                kcpu->reqs_available += ctx->req_batch;
        }

        ret = true;
        kcpu->reqs_available--;
out:
        preempt_enable();
        return ret;


---
Rob Elliott    HP Server Storage
