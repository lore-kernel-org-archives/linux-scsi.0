From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Tue, 27 Nov 2012 09:41:40 +0800
Message-ID: <50B41A54.8020905@intel.com>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>    <20121119145605.GC15971@htj.dyndns.org>    <1353337611.2444.32.camel@dabdike.int.hansenpartnership.com>    <35648985.61QNrr0Knq@vostro.rjw.lan> <1353906191.2523.25.camel@dabdike>   <50B2F96D.9080405@intel.com> <1353915142.2523.36.camel@dabdike>  <50B327FB.3020701@intel.com> <1353935850.2523.52.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53493 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755614Ab2K0Blb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Nov 2012 20:41:31 -0500
In-Reply-To: <1353935850.2523.52.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

On 11/26/2012 09:17 PM, James Bottomley wrote:
> On Mon, 2012-11-26 at 16:27 +0800, Aaron Lu wrote:
>> Well, ZPREADY is not a power state that we can program the ODD to
>> enter(figure 234 and table 323 of the SPEC), it servers more like an
>> information provided by ODD to host so that host does not need to do TUR
>> and then examine the sense code to decide if zero power ready status is
>> satisfied but simply query ODD if its current power state is ZPREADY.
>> So it's not that we program the device to go into ZPREADY power state
>> and the ODD's power will be omitted.
>>
>> The benefit of a ZPREADY capable ODD is that, when we need to decide if
>> the ODD is in a zero power ready status, we can simply query the ODD by
>> issuing a GET_EVENT_STATUS_NOTIFICATION and check the returned power
>> class events, if it is in ZPREADY power state, then we can omit the
>> power. To support ZPREADY, we just need some change to the zpready
>> funtion, which currently uses sense code to check ZP ready status.
>>
>> So this is my understanding of ZPREADY, and I don't see it as a total
>> different thing with ZPODD, it just changes the way how host senses the
>> zero power ready status. But if I was wrong, please kindly let me know,
>> thanks.
> 
> My understanding is that a ZPREADY device may be capable of internal
> power down, meaning it doesn't necessarily need the host to omit the
> power.  It depends what the difference is between Sleep and Off is
> (they're deliberately left as implementation defined in the standard, Ch
> 16, but the conditions of sleep are pretty onerous, so it sounds like
> most of the mechanics are powered down).

I Agree that when the ODD is put to Sleep state, it may power down most
of the mechanics, good for power saving. The problem is, we have the 2
seconds poll, and since Sleep state can not process any command, we will
need to bring the ODD out of Sleep state every 2 seconds, is this
feasible? Please note that leaving Sleep state needs full initialization
of the ODD.

ZPODD system(ODD+platform) solves this problem with ACPI, when the ODD
is powered off and any event that may induce a media change event will
generate an ACPI interrupt, so we can stop the poll(though in whatever
way is still in discussion).

So I suppose we need to find a proper way to implement Sleep.

> 
> However, if you want to work it similarly to ZPODD, then the timeouts
> automatically transitions to ZPREADY, the device issues an event, we
> trap the event at the low level and omit power.

Yeah, I can do this. Except that I don't quite understand how the device
issues the event to host, by interrupt? My understanding is that, it
will issue this event to itself...and host still needs to use command
GET_EVENT_STATUS_NOTIFICATION to fetch the event, much the same way like
the media related events it emits.

> 
> I'm also curious about driving sleep from autopm, since mode page timers
> don't control the sleep transition.

I see. But we will need to work out a sensible way to put the ODD into
that power state, if at all possible.

Thanks,
Aaron

