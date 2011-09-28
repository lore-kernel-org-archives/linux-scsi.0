From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: bnx2i kthread madness
Date: Wed, 28 Sep 2011 19:33:14 +0200
Message-ID: <CAO+b5-r68WC7_noWohbRKyCsrzEpdXxHmhD4s1pT4bJ685Gs9Q@mail.gmail.com>
References: <1317222318.24040.46.camel@twins> <1317230982.3678.1000.camel@ltirv-waie-lx1>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57968 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab1I1Rdh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2011 13:33:37 -0400
Received: by wwf22 with SMTP id 22so9264969wwf.1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2011 10:33:36 -0700 (PDT)
In-Reply-To: <1317230982.3678.1000.camel@ltirv-waie-lx1>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Sep 28, 2011 at 7:29 PM, Eddie Wai <eddie.wai@broadcom.com> wro=
te:
> On Wed, 2011-09-28 at 08:05 -0700, Peter Zijlstra wrote:
> > I accidentally looked at all kthreads in existence on my system and
> > found I had:
> >
> > [iscsi_eh]
> > [bnx2i_thread/0]
> > [bnx2i_thread/1]
> > [bnx2i_thread/2]
> > [bnx2i_thread/3]
> > [bnx2i_thread/4]
> > [bnx2i_thread/5]
> > [bnx2i_thread/6]
> > [bnx2i_thread/7]
> > [bnx2i_thread/8]
> > [bnx2i_thread/9]
> > [bnx2i_thread/10]
> > [bnx2i_thread/11]
> > [bnx2i_thread/12]
> > [bnx2i_thread/13]
> > [bnx2i_thread/14]
> > [bnx2i_thread/15]
> > [bnx2i_thread/16]
> > [bnx2i_thread/17]
> > [bnx2i_thread/18]
> > [bnx2i_thread/19]
> > [bnx2i_thread/20]
> > [bnx2i_thread/21]
> > [bnx2i_thread/22]
> > [bnx2i_thread/23]
> >
> > This left me wondering why, because I most certainly am not using i=
SCSI.
> > I don't even know why its enabled in my .config (and it won't be lo=
ng).
> >
> > Please fix this muck to not create useless threads.
>
> Point noted. =A0In the current bnx2i driver, one kthread is created p=
er
> cpu core upon module init (and destroyed upon module exit). =A0The
> kthreads are meant only to improve I/O performance when iSCSI is
> employed. =A0Otherwise, I agree that they should not exist.

Why doesn't bnx2i use one of the system work queues defined in
<linux/workqueue.h> ?

$ git grep system include/linux/workqueue.h|cat
include/linux/workqueue.h: * system_wq is the one used by
schedule[_delayed]_work[_on]().
include/linux/workqueue.h: * system_long_wq is similar to system_wq
but may host long running
include/linux/workqueue.h: * system_nrt_wq is non-reentrant and
guarantees that any given work
include/linux/workqueue.h: * system_unbound_wq is unbound workqueue.
Workers are not bound to
include/linux/workqueue.h: * system_freezable_wq is equivalent to
system_wq except that it's
include/linux/workqueue.h:extern struct workqueue_struct *system_wq;
include/linux/workqueue.h:extern struct workqueue_struct *system_long_w=
q;
include/linux/workqueue.h:extern struct workqueue_struct *system_nrt_wq=
;
include/linux/workqueue.h:extern struct workqueue_struct *system_unboun=
d_wq;
include/linux/workqueue.h:extern struct workqueue_struct *system_freeza=
ble_wq;

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
