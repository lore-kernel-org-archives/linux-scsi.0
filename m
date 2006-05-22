From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH 1/6] mpt fusion - fibre channel target discovery	prematurely
 terminates
Date: Mon, 22 May 2006 13:40:39 -0500
Message-ID: <447205A7.2020600@sgi.com>
References: <664A4EBB07F29743873A87CF62C26D7011BBF2@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:10148 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1751037AbWEVSkr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 May 2006 14:40:47 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D7011BBF2@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>



Moore, Eric wrote:
> On Monday, May 22, 2006 12:06 PM,  Michael Reed wrote:
>>
>> Changing mpt_config() to sleep changes the behavior in that 
>> EAGAIN might no longer
>> be returned.  lan, ctl, sas, spi, and fc all make use of 
>> mpt_config().  This may be
>> non-trivial with regard to testing.  Or it may not.  And, as 
>> James points out,
>> we have to assure that the caller is in a context which can sleep.
>>
> 
> The caller context of mpt_config() *MUST* be able to sleep.   
> Towards this end of this function we call wait_event().  This is
> because we are waiting on the firmware reply.  If the fw reply
> doesn't come, then watchdog timer kicks in, then mpt_timer_expired 
> is called.
> 
> 
>> Can we leave the interface alone for the moment and accept the patch
>> as written?  Then, look at changing mpt_config() and the evaluate the
>> testing burden that the change might impose?
>>
> 
> James?
> 
>> My vested interest is in getting the functionality into certain
>> distros of interest.  I have no problem with rearchitecting the
>> patchset as described above.  I'm just concerned with the timing.
>> I suspect that the testing required will push the patch's acceptance
>> beyond my potential window of opportunity.  As written, the change
>> is confined to fibre channel so will not potentially introduce
>> regressions into the other drivers.
>>
> 
> How?
> 
> I doubt there would be regressions.  We would need to implement timeout
> on not receiving a mf, then return EAGAIN as we do today.

Then is there a reason to implement the change at all?  If the caller
can still receive EAGAIN, the caller still has to handle it.
Or just view it as an opaque error as callers do today.

Mike

> 
> Eric 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
