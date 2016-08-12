From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: RE: [PATCH 02/28] be2iscsi: Replace _bh with _irqsave/irqrestore
Date: Fri, 12 Aug 2016 13:25:30 +0530
Message-ID: <6c0ae0e85a4ba32a23d70dd6ed99f179@mail.gmail.com>
References: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1469092085-14311-3-git-send-email-jitendra.bhivare@broadcom.com>
 <57A4DD34.4080000@redhat.com> <yq1popivjjk.fsf@sermon.lab.mkp.net>
 <2c0a32a2af7f12150da2818d0b0ec4d6@mail.gmail.com> <57AA1770.6010802@redhat.com>
 7ab48eaa301e671c8338a2161edd2097@mail.gmail.com 8ca3e0c5ced55749a0e242ddc6930421@mail.gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:35625 "EHLO
	mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbcHLI0f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2016 04:26:35 -0400
Received: by mail-ua0-f175.google.com with SMTP id n59so31486642uan.2
        for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2016 01:26:34 -0700 (PDT)
In-Reply-To: 8ca3e0c5ced55749a0e242ddc6930421@mail.gmail.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Jitendra Bhivare [mailto:jitendra.bhivare@broadcom.com]
> Sent: Thursday, August 11, 2016 11:12 AM
> To: 'Mike Christie'; 'Martin K. Petersen'
> Cc: 'linux-scsi@vger.kernel.org'
> Subject: RE: [PATCH 02/28] be2iscsi: Replace _bh with _irqsave/irqrestore
>
>
>
> > -----Original Message-----
> > From: Jitendra Bhivare [mailto:jitendra.bhivare@broadcom.com]
> > Sent: Wednesday, August 10, 2016 6:16 PM
> > To: 'Mike Christie'; 'Martin K. Petersen'
> > Cc: 'linux-scsi@vger.kernel.org'
> > Subject: RE: [PATCH 02/28] be2iscsi: Replace _bh with
> > _irqsave/irqrestore
> >
> > > -----Original Message-----
> > > From: Mike Christie [mailto:mchristi@redhat.com]
> > > Sent: Tuesday, August 09, 2016 11:19 PM
> > > To: Jitendra Bhivare; Martin K. Petersen
> > > Cc: linux-scsi@vger.kernel.org
> > > Subject: Re: [PATCH 02/28] be2iscsi: Replace _bh with
> > > _irqsave/irqrestore
> > >
> > > On 08/09/2016 03:29 AM, Jitendra Bhivare wrote:
> > > >> -----Original Message-----
> > > >> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> > > >> Sent: Tuesday, August 09, 2016 6:35 AM
> > > >> To: Mike Christie
> > > >> Cc: Jitendra Bhivare; linux-scsi@vger.kernel.org
> > > >> Subject: Re: [PATCH 02/28] be2iscsi: Replace _bh with
> > > > _irqsave/irqrestore
> > > >>
> > > >>>>>>> "Mike" == Mike Christie <mchristi@redhat.com> writes:
> > > >>
> > > >>>> In beiscsi_alloc_pdu, _bh versions of spin_lock are being used
> > > >>>> for protecting SGLs and WRBs. _bh versions are needed as the
> > > >>>> function gets invoked in process context and BLOCK_IOPOLL
> > > >>>> softirq.
> > > >>>>
> > > >>>> In spin_unlock_bh, after releasing the lock and enabling BH,
> > > >>>> do_softirq is called which executes till last SOFTIRQ.
> > > >>>>
> > > >>>> beiscsi_alloc_pdu is called under session lock. Through block
> > > >>>> layer, iSCSI stack in some cases send IOs with interrupts
> > > >>>> disabled.
> > > >>>> In such paths,
> > > >>
> > > >>
> > > >> Mike> What path is this? Is this with mq enabled or disabled?
> > > >>
> > > >> Jitendra?
> > > >>
> > > >> --
> > > >> Martin K. Petersen	Oracle Linux Engineering
> > > > [JB] Sorry for the delayed response, there was some issue with my
> > > > mail client.
> > > > There are paths block layer where IRQs are disabled with
> > > > request_queue queue_lock.
> > > > - blk_timeout_work : this triggers NOP-OUT thru'
> > > > iscsi_eh_cmd_timed_out.
> > > > - blk_execute_rq_nowait
> > >
> > > I am not sure I understand the problem/solution. Why does the patch
> > > only need to modify be2iscsi's locking? Why wouldn't you need to
> > > also change the libiscsi session lock locking? You don't need irqs
> > > to be running right? You are just doing this so the locking calls
> > > (irq vs bh) matches
> > up?
> > >
> > > Don't you also need to fix the non-mq IO path. scsi_request_fn needs
> > > a fix to use spin_lock_irqsave/spin_unlock_irqrestore because
> > > blk_execute_rq_nowait already disables them right?
> > >
> > [JB] The issue is hard lockup seen on a CPU which is waiting for
> > session lock taken by another CPU processing do_softirq. This
> > do_softirq is getting called from be2iscsi spin_unlock_bh.
> >
> > The contention gets easily exposed with be2iscsi as it data structures
> > are accessed in process context and IRQ_POLL softirq.
> >
> > iscsi_eh_cmd_timed_out gets saved because it is using base spin_lock
> > version for session lock (frwd and back).
> > iscsi_queuecommand is using _bh which is bit scary.
> >
> > Yes, that needs to be fixed too... and then this other path looks
> > buggy too - blk_run_queue (takes queue_lock with irqsave)
> > ->scsi_request_fn (unlocks it with
> > _irq)
> [JB] In this case, the other CPU executing do_softirq was too sending IO
> under
> session lock.
> When be2iscsi does spin_unlock_bh after getting resources for the IO,
> unlock_bh finds pending IRQ_POLL softirq.
>
> The issue is more to do with driver using _unlock_bh.
> It is causing a WARN_ON too in unlock_bh where ever used  for disabled
> IRQs.
[JB] My apologies. blk_execute_rq_nowait and the call trace shown is with
older kernel.
Only valid kernel trace with latest kernel is:
[  180.957062]  <IRQ>  [<ffffffff81603f36>] dump_stack+0x19/0x1b
[  180.957070]  [<ffffffff8106e28b>] warn_slowpath_common+0x6b/0xb0
[  180.957072]  [<ffffffff8106e3da>] warn_slowpath_null+0x1a/0x20
[  180.957073]  [<ffffffff81076d1a>] local_bh_enable_ip+0x7a/0xa0
[  180.957077]  [<ffffffff8160b0eb>] _raw_spin_unlock_bh+0x1b/0x40
[  180.957084]  [<ffffffffa037f753>] alloc_mgmt_sgl_handle+0x83/0xe0
[be2iscsi]
[  180.957089]  [<ffffffffa0388d9e>] beiscsi_alloc_pdu+0x21e/0x5d0
[be2iscsi]
[  180.957094]  [<ffffffffa01bec71>] __iscsi_conn_send_pdu+0x101/0x2e0
[libiscsi]
[  180.957099]  [<ffffffffa01bef78>] iscsi_send_nopout+0xb8/0x100 [libiscsi]
[  180.957104]  [<ffffffffa01bfca4>] iscsi_eh_cmd_timed_out+0x2a4/0x2d0
[libiscsi]
[  180.957107]  [<ffffffff813f56de>] scsi_times_out+0x5e/0x320
