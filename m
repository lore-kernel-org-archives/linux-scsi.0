From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH 1/6] mpt fusion - fibre channel target discovery	prematurely
 terminates
Date: Mon, 22 May 2006 13:05:34 -0500
Message-ID: <4471FD6E.70302@sgi.com>
References: <664A4EBB07F29743873A87CF62C26D7011BBDE@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:31643 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1751106AbWEVSFk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 May 2006 14:05:40 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D7011BBDE@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>



Moore, Eric wrote:
> 
> On Monday, May 22, 2006 11:35 AM,  Michael Reed wrote:
>>> It's not so transient during reset processing.  I've measured 10 to
>>> 15 seconds of elapsed time.  But, it always eventually succeeds.
>> Well, I should have said that the event occurs with some regularity
>> during reset processing.  And that the duration of the EAGAIN response
>> is 10 to 15 seconds.  I'd rather reschedule than msleep.
>>
> 
> Why?
> 
> Anyways ... if were going to sleep, I'd rather the sleeping/waiting be
> done
> from mpt_config when were are calling mpt_get_msg_frame(), instead
> of the calling functions. Perhaps mpt_get_msg_frame triggering a signal
> or something when its having a freed mf.


Changing mpt_config() to sleep changes the behavior in that EAGAIN might no longer
be returned.  lan, ctl, sas, spi, and fc all make use of mpt_config().  This may be
non-trivial with regard to testing.  Or it may not.  And, as James points out,
we have to assure that the caller is in a context which can sleep.

Can we leave the interface alone for the moment and accept the patch
as written?  Then, look at changing mpt_config() and the evaluate the
testing burden that the change might impose?

My vested interest is in getting the functionality into certain
distros of interest.  I have no problem with rearchitecting the
patchset as described above.  I'm just concerned with the timing.
I suspect that the testing required will push the patch's acceptance
beyond my potential window of opportunity.  As written, the change
is confined to fibre channel so will not potentially introduce
regressions into the other drivers.

Thanks,
 Mike

> 
> Eric 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
