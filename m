From: Nathan Bryant <nbryant@optonline.net>
Subject: Re: Suspending SCSI devices and buses
Date: Fri, 20 Aug 2004 08:30:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4125EEE4.50102@optonline.net>
References: <Pine.LNX.4.44L0.0408191647170.2106-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta8.srv.hcvlny.cv.net ([167.206.5.75]:51380 "EHLO
	mta8.srv.hcvlny.cv.net") by vger.kernel.org with ESMTP
	id S267175AbUHTMa7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2004 08:30:59 -0400
Received: from [67.86.72.128] (ool-43564880.dyn.optonline.net [67.86.72.128])
 by mta8.srv.hcvlny.cv.net
 (iPlanet Messaging Server 5.2 HotFix 1.25 (built Mar  3 2004))
 with ESMTP id <0I2Q0054QW2SB5@mta8.srv.hcvlny.cv.net> for
 linux-scsi@vger.kernel.org; Fri, 20 Aug 2004 08:30:28 -0400 (EDT)
In-reply-to: <Pine.LNX.4.44L0.0408191647170.2106-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:

>Thanks.  Looking at your patch, I have a question.  It doesn't look like
>the resume path is careful to check for Unit Attention with Power On or
>Medium May Have Changed sense.  What happens if somebody changes the
>medium while the drive is suspended?  Or am I missing something?
>
You're not missing anything. :(

Thanks for the feedback, looks like you've found a real problem with the 
patch: that is, due to the unconditonal spinup call on resume, we clear 
any UNIT ATTENTION state before any of the upper layers ever see it, so 
nobody will notice a possible media change.

Unfortunately, I think that the current media change detection code in 
the Linux kernel can not distinguish power-on events from media change 
events. I'm not sure doing so is even possible for SCSI devices. 
(Comments on that?) Proposed solutions:

Approach #1:
* Continue to do the unconditional spinup, but only for devices that are 
already mounted.
This may miss some media change events, but if we really can't 
distinguish power-on from media change, maybe that's somebody else's 
problem if the device was already mounted. (Changing mounted media is 
the user's fault.)

(Hmm, what about devices that are opened for read/write but not mounted?)

Approach #2:
* Test for UNIT_ATTENTION before spinning up and report this as a media 
change.
Safer, but may report "false positive" media change events if the device 
was only powered down/up.


Nathan
