From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 4/6] isci: hardware / topology event handling
Date: Fri, 25 Mar 2011 15:34:39 -0700
Message-ID: <AANLkTimu_jM8wRuURNXrGmD1tJbXeVsJ7Qga9fLC7MJr@mail.gmail.com>
References: <20110318161852.GA19008@infradead.org>
	<AANLkTi=dfZ5OtV0rY_y=9boMCAu_=47Bucz_-Jwu0d-6@mail.gmail.com>
	<20110323084054.GA11533@infradead.org>
	<AANLkTinS9xZ3Jhg1C+jWNO0wj+MYW3qvbqc_acvnsOLS@mail.gmail.com>
	<20110323090824.GA14536@infradead.org>
	<AANLkTinYmRZe9HRrNFWMby9FXZNWCdRUb6QBMgRtW28E@mail.gmail.com>
	<20110324062646.GA27051@infradead.org>
	<AANLkTik7DUF=Pim3JMjRmhdVJTCgfimiyhQ5x_CZ9BeU@mail.gmail.com>
	<20110325194530.GA593@infradead.org>
	<AANLkTin-HGv1V7y8Jn8kJ=ZeaPoK4LL+=Tsoz8Ej3Yjw@mail.gmail.com>
	<20110325220706.GA9535@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41317 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab1CYWek convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Mar 2011 18:34:40 -0400
Received: by fxm17 with SMTP id 17so1494722fxm.19
        for <linux-scsi@vger.kernel.org>; Fri, 25 Mar 2011 15:34:39 -0700 (PDT)
In-Reply-To: <20110325220706.GA9535@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Fri, Mar 25, 2011 at 3:07 PM, Christoph Hellwig <hch@infradead.org> =
wrote:
> On Fri, Mar 25, 2011 at 02:39:03PM -0700, Dan Williams wrote:
>> In that sense the scope of what scic_lock protects is limited to the
>> core/hardware state machines (essentially a controller firmware-like
>> context). =A0Anything that blocks or interfaces with an upper layer =
runs
>> unlocked in the lldd layer, and we don't play any games of dropping
>> the lock from the core. =A0Cancelling and flushing timed events is
>> really the only place where the lock gets in the way. =A0Having a
>> "timer_cancelled" flag for these few cases is the approach the core
>> took over dropping the lock, del_timer_sync, and re-validating state=
=2E
>
> If you just want to deactivate a handler and not wait for it to finis=
h
> you can simply use del_timer instead of del_timer_sync. =A0But it's s=
till
> up to you to make sure all timer handlers have finished before freein=
g
> their containing structures or any other resource that they use, whic=
h
> tends to be rather complicated, and hard to maintain in the long run.

Ok, so that's why I went all the way to recommending a switch to
delayed_workqueue.  We can bring down the core and ensure all events
have seen a cancellation.  None of these containing objects are
dynamically destroyed outside of driver exit, nor would they care
about the switch from timer callback to process context.  That final
flush is the only elusive bit that is covered by flush_workqueue.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
