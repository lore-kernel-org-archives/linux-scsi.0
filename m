From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 4/6] isci: hardware / topology event handling
Date: Tue, 29 Mar 2011 17:37:47 -0700
Message-ID: <AANLkTi=VOEJyNw6nUSAd84KU3h_T0u-aSwjPNUOsyRhC@mail.gmail.com>
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
	<AANLkTikVjnumgM0mXCg-krnLG+fc=cFn7Fi9EaVXmNXq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52780 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759Ab1C3Ahs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2011 20:37:48 -0400
Received: by fxm17 with SMTP id 17so666536fxm.19
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2011 17:37:47 -0700 (PDT)
In-Reply-To: <AANLkTikVjnumgM0mXCg-krnLG+fc=cFn7Fi9EaVXmNXq@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Mon, Mar 28, 2011 at 6:11 PM, Dan Williams <dan.j.williams@intel.com=
> wrote:
>> If the process context of delayed work items provices a significant
>> benefit to your execution model you can convert the timers to delaye=
d
>> work items now, and remove the irqsafe locking. =A0Given that the
>> isci code still does some non-trivial work from it's interrupt
>> handlers and tasklets I'm not sure it's going to buy you much, thoug=
h.
>
> The irqsafe locking is an external requirement imposed by libata,
> although we already drop the lock
>

<hit 'send' too early>

I was going to say we (and the other libsas drivers that call
task->done() or sas_task_abort() from lldd_execute_task_context)
already drop the lock in error conditions.  If that is a safe
operation then perhaps we could up level that lock drop or otherwise
move ata submission to an unlocked context to allow libsas drivers to
use sleeping locks and threaded interrupts.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
