From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: Scsi error handler strategy question
Date: Sun, 4 Jan 2004 18:42:09 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10401041839400.31033-100000@master.linux-ide.org>
References: <20040104232425.GM4339@linnie.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astound-64-85-224-253.ca.astound.net ([64.85.224.253]:64774
	"EHLO master.linux-ide.org") by vger.kernel.org with ESMTP
	id S265849AbUAECpF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Jan 2004 21:45:05 -0500
In-Reply-To: <20040104232425.GM4339@linnie.riede.org>
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <wrlk@riede.org>
Cc: linux-scsi@vger.kernel.org


Willem,

You are free to actually deploy an entire independent eh_strategy series
of functions.  I never got around to doing it but one of the goals was to
remove the mid-layer timer and manage it in ide-scsi.

There is much more that can be done, I just do not have my notes handy.

Cheers,

Andre Hedrick
LAD Storage Consulting Group

On Sun, 4 Jan 2004, Willem Riede wrote:

> While testing the ide-scsi error handling, I observed that my ATAPI
> device gets offlined too easily.
> 
> At some point, the host + device are getting reset. That's desired.
> The error handler is programmed to then expect a "CC/UA" (check
> condition / unit attention) when it does TUR (test unit ready)
> following reset. That's appropriate.
> 
> But here is my first question: is there typically any need to wait 
> some time between doing the host/bus/device reset and the first TUR?
> Is there a standard that governs how fast devices have to be done
> resetting to the point that they can respond to commands (if only to
> say they're not ready?
> 
> When the first TUR completes, the CC/UA expected flag takes care of
> the reported sense 06:29:00 (power on reset or device reset occurred).
> So far so good. Second TUR issued. That one typically gets 02:04:01
> (not ready - in the process of becoming ready) reported. The error
> handler is programmed to retry TUR once if it sees this.
> 
> Second question: if the device firmware takes some time to re-initiate
> the device, this code can be returned multiple times. So am I allowed
> to submit a patch to increase that retry count? What would be a good
> number? Hard to say in general, as this depends on what devices you
> have and how fast commands get executed :-(
> 
> Finally, at least my device, the OnStream DI-30, will eventually want 
> to report 06:28:00 (not ready to ready transition, medium may have
> changed). The error handler considers that an error, and is guaranteed
> to take the device offline, just as it came back to life :-(
> 
> Am I allowed to submit a patch that will also retry on that condition?
> 
> Thanks, Willem Riede.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


