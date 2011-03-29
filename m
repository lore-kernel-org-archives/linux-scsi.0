From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 4/6] isci: hardware / topology event handling
Date: Mon, 28 Mar 2011 18:11:42 -0700
Message-ID: <AANLkTikVjnumgM0mXCg-krnLG+fc=cFn7Fi9EaVXmNXq@mail.gmail.com>
References: <20110323084054.GA11533@infradead.org>
	<AANLkTinS9xZ3Jhg1C+jWNO0wj+MYW3qvbqc_acvnsOLS@mail.gmail.com>
	<20110323090824.GA14536@infradead.org>
	<AANLkTinYmRZe9HRrNFWMby9FXZNWCdRUb6QBMgRtW28E@mail.gmail.com>
	<20110324062646.GA27051@infradead.org>
	<AANLkTik7DUF=Pim3JMjRmhdVJTCgfimiyhQ5x_CZ9BeU@mail.gmail.com>
	<20110325194530.GA593@infradead.org>
	<AANLkTin-HGv1V7y8Jn8kJ=ZeaPoK4LL+=Tsoz8Ej3Yjw@mail.gmail.com>
	<20110325220706.GA9535@infradead.org>
	<AANLkTimu_jM8wRuURNXrGmD1tJbXeVsJ7Qga9fLC7MJr@mail.gmail.com>
	<20110327222854.GA7487@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48641 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1C2BLn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Mar 2011 21:11:43 -0400
Received: by fxm17 with SMTP id 17so3112527fxm.19
        for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2011 18:11:42 -0700 (PDT)
In-Reply-To: <20110327222854.GA7487@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Sun, Mar 27, 2011 at 3:28 PM, Christoph Hellwig <hch@infradead.org> =
wrote:
> On Fri, Mar 25, 2011 at 03:34:39PM -0700, Dan Williams wrote:
>> Ok, so that's why I went all the way to recommending a switch to
>> delayed_workqueue. =A0We can bring down the core and ensure all even=
ts
>> have seen a cancellation. =A0None of these containing objects are
>> dynamically destroyed outside of driver exit, nor would they care
>> about the switch from timer callback to process context. =A0That fin=
al
>> flush is the only elusive bit that is covered by flush_workqueue.
>
> This seems like a really nasy hack to me. =A0Right now there are 9
> callers of isci_timer_create, of those
>
> =A05 operate on struct scic_sds_controller
> =A02 operate on struct scic_sds_phy
> =A01 operates on struct scic_sds_port
> =A01 operates on struct isci_request
>
> of these at least the request has completely different life time rule=
s
> than the scic_sds_controller, so both the existing code and the
> flush_workqueue variant would be incorrect.

Indeed. isci_request is the only usage of this "timer-api" outside of
the core and should have used the raw Linux api from the beginning.

> I'd suggest that as a first step you remove the dynamic allocation of
> the timers with a structure embedded into the containing structure
> and replace isci_timer_list_destroy with a calls to
> del_timer_sync when the containing structure is freed.

Ok, I was making this more difficult than it needed to be, all of
these objects can be reached when stopping the core and we can just
del_timer_sync once we know everything has been cancelled and the core
is known to be quiesced.

> After that you can trivial remove the wrappers and just opencode the
> Linux timer calls, which should lead to much simpler and easier to
> understand code.
>
> If the process context of delayed work items provices a significant
> benefit to your execution model you can convert the timers to delayed
> work items now, and remove the irqsafe locking. =A0Given that the
> isci code still does some non-trivial work from it's interrupt
> handlers and tasklets I'm not sure it's going to buy you much, though=
=2E

The irqsafe locking is an external requirement imposed by libata,
although we already drop the lock

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
