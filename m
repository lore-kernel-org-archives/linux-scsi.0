From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Suspending SCSI devices and buses
Date: Fri, 20 Aug 2004 09:35:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4125FE3B.7070608@adaptec.com>
References: <Pine.LNX.4.44L0.0408191647170.2106-100000@ida.rowland.org> <4125EEE4.50102@optonline.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:44478 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267301AbUHTNf6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2004 09:35:58 -0400
In-Reply-To: <4125EEE4.50102@optonline.net>
List-Id: linux-scsi@vger.kernel.org
To: Nathan Bryant <nbryant@optonline.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

Nathan Bryant wrote:
> Alan Stern wrote:
> 
>  >Thanks.  Looking at your patch, I have a question.  It doesn't look like
>  >the resume path is careful to check for Unit Attention with Power On or
>  >Medium May Have Changed sense.  What happens if somebody changes the
>  >medium while the drive is suspended?  Or am I missing something?
>  >
> You're not missing anything. :(
> 
> Thanks for the feedback, looks like you've found a real problem with the
> patch: that is, due to the unconditonal spinup call on resume, we clear
> any UNIT ATTENTION state before any of the upper layers ever see it, so
> nobody will notice a possible media change.

If UA exists for the initiator port, commands other INQURY, REPORT LUNS
and REPORT SENSE, get terminated and UA reported (CHECK CONDITION with
sense data).  So spinup (TUR + START STOP UNIT) could report the media
change (on TUR).

> 
> Unfortunately, I think that the current media change detection code in
> the Linux kernel can not distinguish power-on events from media change
> events. I'm not sure doing so is even possible for SCSI devices.

It would really depend on the device (if it kept state over power failures).
But it is true that the code should be able to handle it.  (Also UAs could
be queued by the device server--the code could use this.)

> (Comments on that?) Proposed solutions:
> 
> Approach #1:
> * Continue to do the unconditional spinup, but only for devices that are
> already mounted.
> This may miss some media change events, but if we really can't
> distinguish power-on from media change, maybe that's somebody else's
> problem if the device was already mounted. (Changing mounted media is
> the user's fault.)
> 
> (Hmm, what about devices that are opened for read/write but not mounted?)
> 
> Approach #2:
> * Test for UNIT_ATTENTION before spinning up and report this as a media
> change.
> Safer, but may report "false positive" media change events if the device
> was only powered down/up.

UA can tell you when "removable medium may have changed" (SAM3r13, 5.9.7, b)
and "LU inventory has been changed" (same, g).

But it is true -- I can imagine media being changed without the device
knowing it (old enclosure + power off + screw-driver :-) ).

		Luben


