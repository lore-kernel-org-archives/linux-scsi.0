From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: question on detecting a media change
Date: Sat, 13 Feb 2010 17:42:21 +0100
Message-ID: <4B76D66D.9050602@interlog.com>
References: <201002122301.31366.oliver@neukum.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:44196 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756954Ab0BMQm0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Feb 2010 11:42:26 -0500
In-Reply-To: <201002122301.31366.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-scsi@vger.kernel.org

Oliver Neukum wrote:
> Hi,
> 
> how can I find out a medium has been actually changed?
> I find ASC 0x28 ASCQ 0x00 NOT READY TO READY CHANGE, MEDIUM MAY HAVE CHANGED
> in the tables but my card reader emits this when it wakes up from runtime
> suspension. How do you find out whether the medium has actually been
> changed?

Oliver,
What you see is what you get ... In the absence of
Asynchronous Notifications (with USB, forget it)
a SCSI target is passive. It knows the media might
have changed but does not know if the same media
has been put back in (or if something else caused the
READY->NOT_READY->READY transitions).

So the next SCSI command sent to the device gets ignored
and a Unit Attention (sense key) is issued with an
additional sense code like the one you have shown.
[At least that is what should happen.]
If you are lucky the SCSI subsystem does not swallow
this deferred notification (a real pain for pass-throughs).

To detect the media has changed something at a higher
level needed to get a unique key associated with the
media before the Unit attention then generate another
unique key from the media after the Unit attention.
The comparison tells you the answer.

Doug Gilbert

