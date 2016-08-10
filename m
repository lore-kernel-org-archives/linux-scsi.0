From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: RE: [PATCH 02/28] be2iscsi: Replace _bh with _irqsave/irqrestore
Date: Wed, 10 Aug 2016 18:16:12 +0530
Message-ID: <7ab48eaa301e671c8338a2161edd2097@mail.gmail.com>
References: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1469092085-14311-3-git-send-email-jitendra.bhivare@broadcom.com>
 <57A4DD34.4080000@redhat.com> <yq1popivjjk.fsf@sermon.lab.mkp.net>
 <2c0a32a2af7f12150da2818d0b0ec4d6@mail.gmail.com> <57AA1770.6010802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:34920 "EHLO
	mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933088AbcHJS04 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Aug 2016 14:26:56 -0400
Received: by mail-ua0-f169.google.com with SMTP id n59so82549238uan.2
        for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2016 11:26:56 -0700 (PDT)
In-Reply-To: <57AA1770.6010802@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Mike Christie [mailto:mchristi@redhat.com]
> Sent: Tuesday, August 09, 2016 11:19 PM
> To: Jitendra Bhivare; Martin K. Petersen
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 02/28] be2iscsi: Replace _bh with _irqsave/irqrestore
>
> On 08/09/2016 03:29 AM, Jitendra Bhivare wrote:
> >> -----Original Message-----
> >> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> >> Sent: Tuesday, August 09, 2016 6:35 AM
> >> To: Mike Christie
> >> Cc: Jitendra Bhivare; linux-scsi@vger.kernel.org
> >> Subject: Re: [PATCH 02/28] be2iscsi: Replace _bh with
> > _irqsave/irqrestore
> >>
> >>>>>>> "Mike" == Mike Christie <mchristi@redhat.com> writes:
> >>
> >>>> In beiscsi_alloc_pdu, _bh versions of spin_lock are being used for
> >>>> protecting SGLs and WRBs. _bh versions are needed as the function
> >>>> gets invoked in process context and BLOCK_IOPOLL softirq.
> >>>>
> >>>> In spin_unlock_bh, after releasing the lock and enabling BH,
> >>>> do_softirq is called which executes till last SOFTIRQ.
> >>>>
> >>>> beiscsi_alloc_pdu is called under session lock. Through block
> >>>> layer, iSCSI stack in some cases send IOs with interrupts disabled.
> >>>> In such paths,
> >>
> >>
> >> Mike> What path is this? Is this with mq enabled or disabled?
> >>
> >> Jitendra?
> >>
> >> --
> >> Martin K. Petersen	Oracle Linux Engineering
> > [JB] Sorry for the delayed response, there was some issue with my mail
> > client.
> > There are paths block layer where IRQs are disabled with request_queue
> > queue_lock.
> > - blk_timeout_work : this triggers NOP-OUT thru' iscsi_eh_cmd_timed_out.
> > - blk_execute_rq_nowait
>
> I am not sure I understand the problem/solution. Why does the patch only
> need
> to modify be2iscsi's locking? Why wouldn't you need to also change the
> libiscsi
> session lock locking? You don't need irqs to be running right? You are
> just doing
> this so the locking calls (irq vs bh) matches up?
>
> Don't you also need to fix the non-mq IO path. scsi_request_fn needs a fix
> to use
> spin_lock_irqsave/spin_unlock_irqrestore because blk_execute_rq_nowait
> already disables them right?
>
[JB] The issue is hard lockup seen on a CPU which is waiting for session
lock taken by another
CPU processing do_softirq. This do_softirq is getting called from be2iscsi
spin_unlock_bh.

The contention gets easily exposed with be2iscsi as it data structures are
accessed in process context
and IRQ_POLL softirq.

iscsi_eh_cmd_timed_out gets saved because it is using base spin_lock version
for session lock (frwd and back).
iscsi_queuecommand is using _bh which is bit scary.

Yes, that needs to be fixed too... and then this other path looks buggy
too -
blk_run_queue (takes queue_lock with irqsave) ->scsi_request_fn (unlocks it
with _irq)
