From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: STANDBY IMMEDIATE failed on NVIDIA MCP5x controllers when
 system suspend
Date: Mon, 11 Mar 2013 14:34:22 +0000
Message-ID: <1363012462.2395.57.camel@dabdike.int.hansenpartnership.com>
References: <513D52BE.7040307@intel.com>
	 <1362991742.2395.9.camel@dabdike.int.hansenpartnership.com>
	 <513DE176.7050405@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37074 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750872Ab3CKOe1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Mar 2013 10:34:27 -0400
In-Reply-To: <513DE176.7050405@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lwe@gmail.com>
Cc: Aaron Lu <aaron.lu@intel.com>, bladud@gmail.com, Joe Sapp <nixphoeni+kernel@gmail.com>, Alberto Mattea <support.intranet@libero.it>, Peter Dons Tychsen <donpedro@tdcadsl.dk>, Robert Hancock <hancockrwd@gmail.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

On Mon, 2013-03-11 at 21:51 +0800, Aaron Lu wrote:
> On 2013-03-11 16:49, James Bottomley wrote:
> > On Mon, 2013-03-11 at 11:42 +0800, Aaron Lu wrote:
> >> Hi all,
> >>
> >> I've seen some reports on STANDBY IMMEDIATE failed on NVIDIA MCP5x
> >> controllers when system goes to suspend(this command is sent by scsi sd
> >> driver on system suspend as a SCSI STOP command, which is translated to
> >> STANDBY IMMEDIATE ATA command). I've no idea of why this happened, so
> >> I wrote this email in hope of getting some new idea.
> >>
> >> The related bug report:
> >> https://bugzilla.kernel.org/show_bug.cgi?id=48951
> >>
> >> And google search showed that Peter reported a similar problem here:
> >> http://marc.info/?l=linux-ide&m=133534061316338&w=2
> >>
> >> And bladud has found that, disable asyn suspend for the scsi target
> >> device can work around this problem.
> >>
> >> Please feel free to suggest what can possibly be the cause, thanks.
> >
> > You really need to discriminate better between conditions we should and
> > shouldn't care about for suspend.  so in sd_suspend, we definitely care
> > if we can't flush the cache of a write back device because the power off
> > could lose data.  We don't really care if the disk says I can't stop, so
> > this is probably the correct fix.
> 
> Yes, this will make suspend succeed, but the problem is still there -
> the drive does not respond to this command, while it will if async
> suspend for the target device is disabled. I don't think scsi code has
> any fault here, it feels more like a chip bug to me.
> 
> And if we solve it this way, affected user may complain about long
> delay when suspending or uncomfortable with the error messages in dmesg,
> since that command would eventually timeout. So I hope we can nderstand
> what is going wrong here and perhaps do something to avoid it.

Oh, that seems to be the suspend order isn't careful enough.
__device_suspend() waits for its children, but the host disk are too far
separated in the device tree.  If the immediate children of the host are
all sync, that wait never actually waits for anything.

James
 

