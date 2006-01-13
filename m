From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] Make scsi error recovery play nice with devices	blocked
 by transport
Date: Fri, 13 Jan 2006 13:29:56 -0600
Message-ID: <43C7FFB4.5000801@sgi.com>
References: <43A35498.6030903@sgi.com> <43B2B77B.20602@emulex.com>	 <43BEE23E.8040707@sgi.com>  <43C27ABC.2020504@emulex.com> <1136821157.3364.11.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:10192 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1422849AbWAMTaF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 14:30:05 -0500
In-Reply-To: <1136821157.3364.11.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>

I'm planning on working on this once the fusion fc_transport code finally
makes it in.  What do you see as a deadline for code addressing this problem?

Perhaps someone else already has something to address this in progress?
It's a significant issue with our fibre channel customers.

James Bottomley wrote:
> On Mon, 2006-01-09 at 10:01 -0500, James Smart wrote:
>>>I think letting the harder resets happen is a good thing (or at least
>>>not a bad thing) as long as recovery waits for the driver to report that
>>>the drive is gone (offline).
>>Well, in thinking through this further after my initial reply...
>>
>>I think we really do want to leave scsi_eh_ready_devs() logic with the bigger
>>hammer steps alone. Ultimately, they are trying to regain the resources for an
>>i/o that is trying to be killed but the LLDD (or device) isn't cooperating.
>>I still believe in not resetting everyone just because a device is temporarily
>>blocked. However, we need to intercept it at a earlier point... Ultimately,
>>to reach this path, it starts with an i/o timing out, and the eh_abort handler
>>failing. In Emulex's case, we are planning on never failing the eh_abort
>>handler if we're in this temporarily blocked state, even at the expense of a
>>long wait. This is actually too much to ask of an LLDD - and is hokey. The
>>logic really should be to intercept the timeout handler, note that the device
>>is blocked, and delay the abort request until the device has been given a
>>chance to return (e.g. just restart the i/o abort timer for the amount of 
>>devloss_tmo that remains). Otherwise, we're always guaranteeing a failure from
>>the abort handlers (for i/o and device) as there's no device to talk to.
>>
>>This should remove the need for your if-blocked test in scsi_error.c,
>>replacing it with the logic in the i/o timeout handler.

This makes sense.  While there are times when the big hammer might
have results, properly operating firmware should in make that the exception.

> 
> Actually, there is another thing you can do even earlier:  implement
> scsi_eh_timer_return() in the host template (probably with a generic
> routine from the fc class).  This would allow you to hold off the
> timeout at least for the length of the user specified timeout and all
> the retries.  Probably the routine would simply check to see if the
> device is in a devloss timeout and if it is return EH_RESET_TIMER;
> otherwise return EH_NOT_HANDLED.

We have to be able to handle the case that error recovery gets started
before the device is blocked by the transport as well as the other way
around.  Not being fluent in the timeout / error handling code, do you
see this suggestion being able to handle both cases?  SMOP?

Other ideas?

Thanks,
 Mike


> 
> James
> 
> 
