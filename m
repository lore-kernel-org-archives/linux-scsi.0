From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 1/6] mpt fusion - fibre channel target discovery	prematurely terminates
Date: Mon, 22 May 2006 12:15:03 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7011BBF2@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:57247 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751110AbWEVSPJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 May 2006 14:15:09 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Monday, May 22, 2006 12:06 PM,  Michael Reed wrote:
> 
> 
> Changing mpt_config() to sleep changes the behavior in that 
> EAGAIN might no longer
> be returned.  lan, ctl, sas, spi, and fc all make use of 
> mpt_config().  This may be
> non-trivial with regard to testing.  Or it may not.  And, as 
> James points out,
> we have to assure that the caller is in a context which can sleep.
> 

The caller context of mpt_config() *MUST* be able to sleep.   
Towards this end of this function we call wait_event().  This is
because we are waiting on the firmware reply.  If the fw reply
doesn't come, then watchdog timer kicks in, then mpt_timer_expired 
is called.


> Can we leave the interface alone for the moment and accept the patch
> as written?  Then, look at changing mpt_config() and the evaluate the
> testing burden that the change might impose?
> 

James?

> My vested interest is in getting the functionality into certain
> distros of interest.  I have no problem with rearchitecting the
> patchset as described above.  I'm just concerned with the timing.
> I suspect that the testing required will push the patch's acceptance
> beyond my potential window of opportunity.  As written, the change
> is confined to fibre channel so will not potentially introduce
> regressions into the other drivers.
> 

How?

I doubt there would be regressions.  We would need to implement timeout
on not receiving a mf, then return EAGAIN as we do today.

Eric 


