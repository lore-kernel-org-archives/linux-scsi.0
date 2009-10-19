From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: disk restart failure after suspend
Date: Mon, 19 Oct 2009 09:42:04 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0910181642390.18952-100000@netrider.rowland.org>
References: <4ADB2967.7000103@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:40061 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756113AbZJSNmA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2009 09:42:00 -0400
In-Reply-To: <4ADB2967.7000103@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Tino Keitel <tino.keitel@tikei.de>, linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>

On Sun, 18 Oct 2009, Stefan Richter wrote:

> > It seems to me that the restart always fails if the "rediscovered
> > device fw1" resp.  "firewire_sbp2: fw1.0: reconnected to LUN 0000"
> > message comes after the "[sdb] Starting disk" message.  That would
> > sound like an actual bug to me.
> 
> It is not a bug.  IEEE 1394 rediscovery and SBP-2 reconnect can become
> necessary anytime (and they do become necessary at /least/ once during
> PM resume), in no particular order with respect to SCSI request
> submission.  Our drivers (firewire-sbp2 mainly) need to be able to
> handle any order of such events.

Is it possible to delay returning from the device resume routine until
the rediscovery/reconnect has completed?  This is more or less how the
USB stack works.

> Interesting findings.
> 
> There are two independent places of the code that could possibly be
> improved to fix this issue:
> 
> a.)  sd's PM resume method:
> 
> 1.a)  sd_resume could gain this retry loop which you implemented.

This wouldn't be necessary if the transport was working before 
sd_resume got called.

> 1.b)  sd_resume (but probably not sd_suspend) could optimistically
> ignore any error return from sd_start_stop_device.  If the motor cannot
> be started immediately at resume, the SCSI core would try to start it
> later on when the disk is normally accessed.

This is probably a worthwhile idea in any case.

> My assumption here is that an error return from sd_resume causes the
> disk to become inaccessible (taken offline?).

No.  All it does is cause an error message to be printed in the system 
log.  But it's possible that a failure lower down in the SCSI stack has 
this effect.

Alan Stern

