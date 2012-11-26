From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Mon, 26 Nov 2012 17:17:30 +0400
Message-ID: <1353935850.2523.52.camel@dabdike>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
	   <20121119145605.GC15971@htj.dyndns.org>
	   <1353337611.2444.32.camel@dabdike.int.hansenpartnership.com>
	   <35648985.61QNrr0Knq@vostro.rjw.lan> <1353906191.2523.25.camel@dabdike>
	  <50B2F96D.9080405@intel.com> <1353915142.2523.36.camel@dabdike>
	 <50B327FB.3020701@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <50B327FB.3020701@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-11-26 at 16:27 +0800, Aaron Lu wrote:
> Well, ZPREADY is not a power state that we can program the ODD to
> enter(figure 234 and table 323 of the SPEC), it servers more like an
> information provided by ODD to host so that host does not need to do TUR
> and then examine the sense code to decide if zero power ready status is
> satisfied but simply query ODD if its current power state is ZPREADY.
> So it's not that we program the device to go into ZPREADY power state
> and the ODD's power will be omitted.
> 
> The benefit of a ZPREADY capable ODD is that, when we need to decide if
> the ODD is in a zero power ready status, we can simply query the ODD by
> issuing a GET_EVENT_STATUS_NOTIFICATION and check the returned power
> class events, if it is in ZPREADY power state, then we can omit the
> power. To support ZPREADY, we just need some change to the zpready
> funtion, which currently uses sense code to check ZP ready status.
> 
> So this is my understanding of ZPREADY, and I don't see it as a total
> different thing with ZPODD, it just changes the way how host senses the
> zero power ready status. But if I was wrong, please kindly let me know,
> thanks.

My understanding is that a ZPREADY device may be capable of internal
power down, meaning it doesn't necessarily need the host to omit the
power.  It depends what the difference is between Sleep and Off is
(they're deliberately left as implementation defined in the standard, Ch
16, but the conditions of sleep are pretty onerous, so it sounds like
most of the mechanics are powered down).

However, if you want to work it similarly to ZPODD, then the timeouts
automatically transitions to ZPREADY, the device issues an event, we
trap the event at the low level and omit power.

I'm also curious about driving sleep from autopm, since mode page timers
don't control the sleep transition.

James


