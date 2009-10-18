From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: disk restart failure after suspend
Date: Sun, 18 Oct 2009 16:42:47 +0200
Message-ID: <4ADB2967.7000103@s5r6.in-berlin.de>
References: <20091006073926.GA5636@mac.home> <4ACB2B69.20008@s5r6.in-berlin.de>	<20091006115121.GA15517@mac.home>	<4ACB6940.5010905@s5r6.in-berlin.de>	<4ACB6BF2.5090409@s5r6.in-berlin.de>	<20091007051614.GA7527@mac.home>	<4ACC2ADC.4050307@s5r6.in-berlin.de>	<20091011202902.GA29604@x61.home>	<4AD25437.90609@s5r6.in-berlin.de> <20091016060320.GB30389@mac.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:58629 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbZJROq0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Oct 2009 10:46:26 -0400
In-Reply-To: <20091016060320.GB30389@mac.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tino Keitel <tino.keitel@tikei.de>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>, Alan Stern <stern@rowland.harvard.edu>

[Repost with corrected CCs, sorry for the mess.
Problem:  FireWire disk becomes inaccessible during resume because START
STOP UNIT failed.  http://marc.info/?t=125481515600002]

On 2009-10-16, Tino Keitel wrote at linux1394-user:
> On Sun, Oct 11, 2009 at 23:55:03 +0200, Stefan Richter wrote:
>> Tino Keitel wrote:
>>> I got another failure with the 0x20 workaround enabled. I
>>> suppose that it is a hardware issue. :-(
>> If you have access to a Windows PC, check whether there is a firmware
>> update for this disk.
>>
>> Besides, maybe the SCSI stack gives up too quickly if a command in the
>> resume path fails.  Just a guess; I never dealt with that kind of kernel
>> code myself.  I'll try to look it up when I have some time to kill...
> 
> This brought me to an idea: I just added a retry loop around the
> command to start the disk. This morning, it became effective for the
> first time:
> 
> sd 4:0:0:0: [sdb] Starting disk
> sd 4:0:0:0: [sdb] START_STOP FAILED, retrying.
> sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control both
> firewire_core: rediscovered device fw1
> sd 4:0:0:0: [sdb] START_STOP FAILED, retrying.
> firewire_sbp2: fw1.0: reconnected to LUN 0000 (0 retries)
> usb 4-1: reset full speed USB device using uhci_hcd and address 2
> usb 5-2: reset full speed USB device using uhci_hcd and address 3
> usb 5-1: reset full speed USB device using uhci_hcd and address 8
> Restarting tasks ... done.
> 
> So it actually worked.
> 
> The retries are sent with a 2 seconds inverval.
> 
> It seems to me that the restart always fails if the "rediscovered
> device fw1" resp.  "firewire_sbp2: fw1.0: reconnected to LUN 0000"
> message comes after the "[sdb] Starting disk" message.  That would
> sound like an actual bug to me.

It is not a bug.  IEEE 1394 rediscovery and SBP-2 reconnect can become
necessary anytime (and they do become necessary at /least/ once during
PM resume), in no particular order with respect to SCSI request
submission.  Our drivers (firewire-sbp2 mainly) need to be able to
handle any order of such events.

> I just checked my kernel logs and saw exactly that: at every failed
> resume, the "Starting disk" message came before the "rediscovered
> device fw1" message. I guess that there is no need to throw away the
> enclosure anymore. :-)
> 
> Regards,
> Tino

Interesting findings.

There are two independent places of the code that could possibly be
improved to fix this issue:

a.)  sd's PM resume method:

1.a)  sd_resume could gain this retry loop which you implemented.

1.b)  sd_resume (but probably not sd_suspend) could optimistically
ignore any error return from sd_start_stop_device.  If the motor cannot
be started immediately at resume, the SCSI core would try to start it
later on when the disk is normally accessed.

My assumption here is that an error return from sd_resume causes the
disk to become inaccessible (taken offline?).

2.)  firewire-sbp2's bus reset handling scheme (the reconnect thing):

The originally submitted incarnation of firewire-sbp2 had very weak bus
reset handling which lost contact to disks very easily.  I then ported
over drivers/ieee1394/sbp2.c's bus reset handling to drivers/firewire
although I was not satisfied with that implementation anymore either.
This scheme uses the SCSI core's host block/ unblock API to prevent
queuing of new commands after firewire-sbp2 detected that a reconnect
becomes necessary, until reconnect succeeded.

After reconnect, already pending requests (at most one request at the
moment because we currently don't support queue depth > 1 in
firewire-sbp2) will be aborted and the SCSI request completed with
DID_BUS_BUSY.  And this is what apparently happens in your case:
sd_resume issues START STOP UNIT, sbp2 reconnects at the earliest
opportunity but alas after sd's request went out, the request is
completed with busy status, and sd_resume returns an error.

Instead of this, firewire-sbp2 should rather keep requests which are
present at reconnect and submit them once more.  Whether this is
actually feasible I don't know yet, but I have hopes.  If this is
possible, we can also rip out all usages of the Scsi_Host block/ unblock
API in firewire-sbp2, which is a very delicate API with a high danger of
deadlocks.
-- 
Stefan Richter
-=====-==--= =-=- =--=-
http://arcgraph.de/sr/
