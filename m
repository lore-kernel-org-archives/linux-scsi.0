From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: disk restart failure after suspend
Date: Mon, 19 Oct 2009 22:24:43 +0200
Message-ID: <4ADCCB0B.6060005@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0910181642390.18952-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:41727 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbZJSUZ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2009 16:25:58 -0400
In-Reply-To: <Pine.LNX.4.44L0.0910181642390.18952-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tino Keitel <tino.keitel@tikei.de>, linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>

Alan Stern wrote:
> On Sun, 18 Oct 2009, Stefan Richter wrote:
>> IEEE 1394 rediscovery and SBP-2 reconnect can become
>> necessary anytime (and they do become necessary at /least/ once during
>> PM resume), in no particular order with respect to SCSI request
>> submission.  Our drivers (firewire-sbp2 mainly) need to be able to
>> handle any order of such events.
> 
> Is it possible to delay returning from the device resume routine until
> the rediscovery/reconnect has completed?  This is more or less how the
> USB stack works.

Hmm.  FireWire isn't deterministic in this regard; it's partly bus,
partly network.  The transport protocol SBP-2 is kind of a network
protocol with remote DMA.  Rediscovery and reconnect at PM resume are
rather stochastic processes
  - if the target went through a low power state too,
  - if other nodes besides the Linux SBP-2 initiator and the SBP-2
    target are on the bus,
  - not to mention if those other nodes went through a low power
    cycle as well.

I could add .suspend and .resume methods to firewire-sbp2's struct
device_driver (or just .resume if the PM core accepts that... I have to
check the API), and the .resume method could contain a
wait_for_completion_timeout which is unblocked when a reconnect
happened.  However, this could still go wrong if for some reason (e.g.
see above) multiple reconnects to the target happen in a row.

So I tend to think firewire-sbp2 should learn to resubmit requests that
were queued by SCSI midlayer after the SBP-2 connection broke & before
reconnect happened, i.e. hide all this from SCSI midlayer rather than
quitting this request with DID_BUS_BUSY.

>> There are two independent places of the code that could possibly be
>> improved to fix this issue:
>>
>> a.)  sd's PM resume method:
>>
>> 1.a)  sd_resume could gain this retry loop which you implemented.
> 
> This wouldn't be necessary if the transport was working before 
> sd_resume got called.

Technically the transport does "work" at this time:  It might have
blocked the Scsi_Host though, or it might return "bus busy" status for
one request and then block the host.  But apparently that's not liked by
upper layers during resume.

Anyway, I'd say it this way:

This wouldn't be necessary if the transport just hid this reconnection
phase from SCSI core and everything above it.

Then we only need to rely on the reconnect (or possibly series of
reconnects, see above) to finish before timeout, minus time for the
actual execution of the request.  That should fit comfortably into the
30 seconds SD_TIMEOUT.

>> 1.b)  sd_resume (but probably not sd_suspend) could optimistically
>> ignore any error return from sd_start_stop_device.  If the motor cannot
>> be started immediately at resume, the SCSI core would try to start it
>> later on when the disk is normally accessed.
> 
> This is probably a worthwhile idea in any case.
> 
>> My assumption here is that an error return from sd_resume causes the
>> disk to become inaccessible (taken offline?).
> 
> No.  All it does is cause an error message to be printed in the system 
> log.  But it's possible that a failure lower down in the SCSI stack has 
> this effect.

I wonder what this might be.
-- 
Stefan Richter
-=====-==--= =-=- =--==
http://arcgraph.de/sr/
