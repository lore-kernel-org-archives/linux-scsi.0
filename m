From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 4/6] isci: hardware / topology event handling
Date: Fri, 25 Mar 2011 14:39:03 -0700
Message-ID: <AANLkTin-HGv1V7y8Jn8kJ=ZeaPoK4LL+=Tsoz8Ej3Yjw@mail.gmail.com>
References: <20110207003056.27040.89174.stgit@localhost6.localdomain6>
	<20110207003455.27040.94947.stgit@localhost6.localdomain6>
	<20110318161852.GA19008@infradead.org>
	<AANLkTi=dfZ5OtV0rY_y=9boMCAu_=47Bucz_-Jwu0d-6@mail.gmail.com>
	<20110323084054.GA11533@infradead.org>
	<AANLkTinS9xZ3Jhg1C+jWNO0wj+MYW3qvbqc_acvnsOLS@mail.gmail.com>
	<20110323090824.GA14536@infradead.org>
	<AANLkTinYmRZe9HRrNFWMby9FXZNWCdRUb6QBMgRtW28E@mail.gmail.com>
	<20110324062646.GA27051@infradead.org>
	<AANLkTik7DUF=Pim3JMjRmhdVJTCgfimiyhQ5x_CZ9BeU@mail.gmail.com>
	<20110325194530.GA593@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51577 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab1CYVjE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Mar 2011 17:39:04 -0400
Received: by fxm17 with SMTP id 17so1472499fxm.19
        for <linux-scsi@vger.kernel.org>; Fri, 25 Mar 2011 14:39:03 -0700 (PDT)
In-Reply-To: <20110325194530.GA593@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Fri, Mar 25, 2011 at 12:45 PM, Christoph Hellwig <hch@infradead.org>=
 wrote:
> On Thu, Mar 24, 2011 at 05:57:17PM -0700, Dan Williams wrote:
>> I have been waiting for this issue to be raised. =A0This was one of =
the
>> first items brought up in our internal reviews of the Linux driver.
>> Why does it still exist and what is the rationale for addressing it
>> incrementally?:
>>
>> Starting with simple locking and then scaling it is arguably easier
>> than unwinding a more complex locking scheme implemented too early i=
n
>> the design phase.
>
> I don't care about the lock scalability. =A0The problem with a global
> spinlock is that a lot of primitives that a driver needs need to bloc=
k,
> and with a global spinlock that's almost impossible to handle, as
> you'd need to drop the lock, and have very little chance to figure
> out what state it actually protects that now needs to be re-checked.

In that sense the scope of what scic_lock protects is limited to the
core/hardware state machines (essentially a controller firmware-like
context).  Anything that blocks or interfaces with an upper layer runs
unlocked in the lldd layer, and we don't play any games of dropping
the lock from the core.  Cancelling and flushing timed events is
really the only place where the lock gets in the way.  Having a
"timer_cancelled" flag for these few cases is the approach the core
took over dropping the lock, del_timer_sync, and re-validating state.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
