From: scameron@beardog.cce.hp.com
Subject: Question about seemingly extraneous i/o's
Date: Thu, 10 May 2012 13:56:14 -0500
Message-ID: <20120510185614.GY11309@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:1706 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab2EJS4Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 May 2012 14:56:16 -0400
Received: from g5t0029.atlanta.hp.com (g5t0029.atlanta.hp.com [16.228.8.141])
	by g6t0186.atlanta.hp.com (Postfix) with ESMTP id 41D012C380
	for <linux-scsi@vger.kernel.org>; Thu, 10 May 2012 18:56:15 +0000 (UTC)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mike.miller@hp.com


I have this script, which just cranks up the scsi logging level
a bit, then writes 1 block out to a disk, sleeps a bit, then 
cranks the logging back down.  There's no other i/o going
to the disk (not mounted, no filesystem)

-----8<---- -----8<---- -----8<---- -----8<---- -----8<----
#!/bin/sh

logger vvvvvv==============================================================vvvvvv
LOGGING_LEVEL=14683648

sysctl -w dev.scsi.logging_level=$LOGGING_LEVEL
dd if=/dev/zero of=/dev/sdb count=1 bs=512 seek=5000 oflag=direct
sleep 1
sysctl -w dev.scsi.logging_level=0
logger ^^^^^^==============================================================^^^^^^
-----8<---- -----8<---- -----8<---- -----8<---- -----8<----


This script produces the log below.  It does the write, as
expected, but then it also does a test unit ready, then inquiries and a bunch of reads.

Where are these coming from?

Changing the readahead doesn't seem to affect it, and it happens
each time I run the dd.

Doing the same thing with a block driver (e.g. cciss) results in
the single write i/o and nothing more (we observed this from the
hardware side -- from within HP smart array firmware -- and initially
noticed the "extra" i/o's from the hardware side as well, but found
we can see them with linux scsi logging as well.

Just wondering where they're coming from and under what circumstances
they are elicited and what can be done to avoid this behavior.  Initially
I suspected readahead, but a) when I turn it off, the mystery i/o's are
still present, and b) if it were read-ahead, I'd expect it would do the
read ahead once and then subsequent trials would not do the readahead 
since those blocks should be in the buffer cache except for c) I'm using
direct i/o, so no buffer cache involved.

-- steve


May 10 13:49:47 localhost scameron: vvvvvv==============================================================vvvvvv
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] sd_open
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] sd_prep_fn: block=5000, count=1
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] block=5000
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] writing 1/1 512 byte blocks.
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] Send: 0xffff88013c3ed0c0 
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 00 13 88 00 00 01 00
May 10 13:49:47 localhost kernel: buffer = 0xffff88019644fb80, bufflen = 512, queuecommand 0xffffffffa0058160
May 10 13:49:47 localhost kernel: leaving scsi_dispatch_cmnd()
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] sd_check_events
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] sd_release
May 10 13:49:47 localhost kernel: sd 1:0:0:0: Send: 0xffff88013c3ed3c0 
May 10 13:49:47 localhost kernel: sd 1:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
May 10 13:49:47 localhost kernel: buffer = 0x          (null), bufflen = 0, queuecommand 0xffffffffa0058160
May 10 13:49:47 localhost kernel: leaving scsi_dispatch_cmnd()
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] sd_open
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] Send: 0xffff88013b55eec0 
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] CDB: Inquiry: 12 00 00 00 fe 00
May 10 13:49:47 localhost kernel: buffer = 0xffff88013b51eec0, bufflen = 254, queuecommand 0xffffffffa0058160
May 10 13:49:47 localhost kernel: leaving scsi_dispatch_cmnd()
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] sd_check_events
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] sd_release
May 10 13:49:47 localhost kernel: sd 1:0:0:0: Send: 0xffff88013b55edc0 
May 10 13:49:47 localhost kernel: sd 1:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
May 10 13:49:47 localhost kernel: buffer = 0x          (null), bufflen = 0, queuecommand 0xffffffffa0058160
May 10 13:49:47 localhost kernel: leaving scsi_dispatch_cmnd()
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] sd_open
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] Send: 0xffff88013c3edbc0 
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] CDB: Inquiry: 12 01 00 00 fe 00
May 10 13:49:47 localhost kernel: buffer = 0xffff88019644f480, bufflen = 254, queuecommand 0xffffffffa0058160
May 10 13:49:47 localhost kernel: leaving scsi_dispatch_cmnd()
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] Send: 0xffff88013c3edcc0 
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] CDB: Inquiry: 12 01 80 00 fe 00
May 10 13:49:47 localhost kernel: buffer = 0xffff88019644fc80, bufflen = 254, queuecommand 0xffffffffa0058160
May 10 13:49:47 localhost kernel: leaving scsi_dispatch_cmnd()
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] Send: 0xffff88013c3eddc0 
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] CDB: Inquiry: 12 01 83 00 fe 00
May 10 13:49:47 localhost kernel: buffer = 0xffff88019644f680, bufflen = 254, queuecommand 0xffffffffa0058160
May 10 13:49:47 localhost kernel: leaving scsi_dispatch_cmnd()
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] sd_check_events
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] sd_release
May 10 13:49:47 localhost kernel: sd 1:0:0:0: Send: 0xffff880193ef81c0 
May 10 13:49:47 localhost kernel: sd 1:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
May 10 13:49:47 localhost kernel: buffer = 0x          (null), bufflen = 0, queuecommand 0xffffffffa0058160
May 10 13:49:47 localhost kernel: leaving scsi_dispatch_cmnd()
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] sd_open
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] sd_prep_fn: block=879032192, count=8
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] block=879032192
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] reading 8/8 512 byte blocks.
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] Send: 0xffff880101213e80 
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] CDB: Read(10): 28 00 34 64 f7 80 00 00 08 00
May 10 13:49:47 localhost kernel: buffer = 0xffff88014ce86e80, bufflen = 4096, queuecommand 0xffffffffa0058160
May 10 13:49:47 localhost kernel: leaving scsi_dispatch_cmnd()
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] sd_prep_fn: block=879032304, count=8
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] block=879032304
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] reading 8/8 512 byte blocks.
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] Send: 0xffff880101213e80 
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] CDB: Read(10): 28 00 34 64 f7 f0 00 00 08 00
May 10 13:49:47 localhost kernel: buffer = 0xffff88014ce86e80, bufflen = 4096, queuecommand 0xffffffffa0058160
May 10 13:49:47 localhost kernel: leaving scsi_dispatch_cmnd()
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] sd_prep_fn: block=0, count=8
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] block=0
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] reading 8/8 512 byte blocks.
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] Send: 0xffff8801012baec0 
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
May 10 13:49:47 localhost kernel: buffer = 0xffff8801012bbec0, bufflen = 4096, queuecommand 0xffffffffa0058160
May 10 13:49:47 localhost kernel: leaving scsi_dispatch_cmnd()
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] sd_prep_fn: block=8, count=8
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] block=8
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] reading 8/8 512 byte blocks.
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] Send: 0xffff8801012baec0 
May 10 13:49:47 localhost kernel: sd 1:0:0:0: [sdb] CDB: Read(10): 28 00 00 00 00 08 00 00 08 00
May 10 13:49:47 localhost kernel: buffer = 0xffff8801012bbec0, bufflen = 4096, queuecommand 0xffffffffa0058160
May 10 13:49:47 localhost kernel: leaving scsi_dispatch_cmnd()
May 10 13:49:47 localhost kernel: sd 0:0:0:0: [sda] sd_prep_fn: block=185752968, count=8
May 10 13:49:47 localhost kernel: sd 0:0:0:0: [sda] block=185752968
May 10 13:49:47 localhost kernel: sd 0:0:0:0: [sda] writing 8/8 512 byte blocks.
May 10 13:49:47 localhost kernel: sd 0:0:0:0: [sda] Send: 0xffff880101213d80 
May 10 13:49:47 localhost kernel: sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 0b 12 5d 88 00 00 08 00
May 10 13:49:47 localhost kernel: buffer = 0xffff88014ce86d80, bufflen = 4096, queuecommand 0xffffffffa0058160
May 10 13:49:47 localhost kernel: leaving scsi_dispatch_cmnd()
May 10 13:49:48 localhost kernel: sd 0:0:0:0: [sda] sd_prep_fn: block=185752960, count=8
May 10 13:49:48 localhost kernel: sd 0:0:0:0: [sda] block=185752960
May 10 13:49:48 localhost kernel: sd 0:0:0:0: [sda] writing 8/8 512 byte blocks.
May 10 13:49:48 localhost kernel: sd 0:0:0:0: [sda] Send: 0xffff880101213c80 
May 10 13:49:48 localhost kernel: sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 0b 12 5d 80 00 00 08 00
May 10 13:49:48 localhost kernel: buffer = 0xffff88014ce86c80, bufflen = 4096, queuecommand 0xffffffffa0058160
May 10 13:49:48 localhost kernel: leaving scsi_dispatch_cmnd()
May 10 13:49:48 localhost kernel: sd 0:0:0:0: [sda] sd_prep_fn: block=2193216, count=8
May 10 13:49:48 localhost kernel: sd 0:0:0:0: [sda] block=2193216
May 10 13:49:48 localhost kernel: sd 0:0:0:0: [sda] writing 8/8 512 byte blocks.
May 10 13:49:48 localhost kernel: sd 0:0:0:0: [sda] Send: 0xffff880101213b80 
May 10 13:49:48 localhost kernel: sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 00 21 77 40 00 00 08 00
May 10 13:49:48 localhost kernel: buffer = 0xffff88014ce86b80, bufflen = 4096, queuecommand 0xffffffffa0058160
May 10 13:49:48 localhost kernel: leaving scsi_dispatch_cmnd()
May 10 13:49:48 localhost kernel: sd 0:0:0:0: [sda] sd_prep_fn: block=140890712, count=80
May 10 13:49:48 localhost kernel: sd 0:0:0:0: [sda] block=140890712
May 10 13:49:48 localhost kernel: sd 0:0:0:0: [sda] writing 80/80 512 byte blocks.
May 10 13:49:48 localhost kernel: sd 0:0:0:0: [sda] Send: 0xffff880101213a80 
May 10 13:49:48 localhost kernel: sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 08 65 d2 58 00 00 50 00
May 10 13:49:48 localhost kernel: buffer = 0xffff880196451800, bufflen = 40960, queuecommand 0xffffffffa0058160
May 10 13:49:48 localhost kernel: leaving scsi_dispatch_cmnd()
May 10 13:49:48 localhost kernel: sd 0:0:0:0: [sda] sd_prep_fn: block=140890792, count=8
May 10 13:49:48 localhost kernel: sd 0:0:0:0: [sda] block=140890792
May 10 13:49:48 localhost kernel: sd 0:0:0:0: [sda] writing 8/8 512 byte blocks.
May 10 13:49:48 localhost kernel: sd 0:0:0:0: [sda] Send: 0xffff880101213a80 
May 10 13:49:48 localhost kernel: sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 08 65 d2 a8 00 00 08 00
May 10 13:49:48 localhost kernel: buffer = 0xffff88014ce86b80, bufflen = 4096, queuecommand 0xffffffffa0058160
May 10 13:49:48 localhost kernel: leaving scsi_dispatch_cmnd()
May 10 13:49:48 localhost scameron: ^^^^^^==============================================================^^^^^^
