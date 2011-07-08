From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Fri, 8 Jul 2011 15:37:42 +0200
Message-ID: <20110708153742.17121fa8@stein>
References: <1309609482.2554.8.camel@mulgrave>
	<Pine.LNX.4.44L0.1107021320180.14703-100000@netrider.rowland.org>
	<20110703223757.0e2b5ee0@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:33265 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab1GHNia (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2011 09:38:30 -0400
In-Reply-To: <20110703223757.0e2b5ee0@stein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, axboe@kernel.dk, James Bottomley <James.Bottomley@HansenPartnership.com>, Andi Kleen <andi@firstfloor.org>, Dave Jones <davej@redhat.com>, Kernel development list <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, USB list <linux-usb@vger.kernel.org>

On Jul 03 Stefan Richter wrote:
> On Jul 02 Alan Stern wrote:
> > Also, I have no idea why this shows up with USB drives but not other 
> > SCSI transports.  A fluke of timing?
> 
> A while ago I frequently observed oopses at removal of a FireWire
> CompactFlash card reader (an sd device which exposes itself as device with
> removable medium).  At that time I wasn't motivated to track down whether
> the bug resided in the block or SCSI or firewire subsystem.  The bug was
> apparently triggered because hald was polling the device like crazy for
> media changes, and that polling coincided with device hot unplug.
> 
> Furthermore, FireWire CD-ROM removal never has been an exactly glitch-free
> experience because the SCSI stack occasionally went on to issue command
> retries for many minutes after device removal a.k.a. DID_NO_CONNECT.  I
> don't remember crashes during FireWire CD-ROM removal, but it has been a
> while that I last used CD-ROM drives.
> 
> I might test the card reader and a CD-ROM later next week on 3.0-rc6 if I
> find the time and the issue hadn't been resolved by then.  I don't have
> hald anymore, but there are certainly other ways to force accesses during
> device shutdown.

I have not tested FireWire CD-ROMs or card reader yet.

But today I did get the following crash on 3.0-rc6-71-g4dd1b49 x86-64 plus
Alan's "USB: additional regression fix for device removal" when I powered
down an USB hub with an empty USB card reader attached (or when I powered
it up, impossible for me to say):

general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC

PID: 8299, comm: kworker/0:0 Not tainted
RIP: [...] elv_put_request+0xb/0x1b
[...]
Call Trace:
__blk_put_request
? blk_put_request
blk_put_request
scsi_execute
scsi_execute_req
? sd_check_events
scsi_test_unit_ready
? kmem_cache_alloc
? sd_check_events
sd_check_events
disk_events_workfn
[...]

After this trace, the following messages were logged:
generic-usb 0003:046D:C51.0059: can't reset device, 0000:00:12.2-3.1.3/input/0, status -71
usb 1-3.1: clear tt 1 (0530) error -19
BUG: unable to handle kernel paging request at fffffffffffffff8
IP: [...] kthread_data+0xb/0x11
Pid: 8299, comm: kworker/0:0 Tainted: G D
RIP: 0010:[<ffffffff8104aa8f>]

I can upload a screenshot of this crash if desired.

The 2.6.39 and 3.0 block and/or SCSI layer are in a really sad state.
-- 
Stefan Richter
-=====-==-== -=== -=---
http://arcgraph.de/sr/
