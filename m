From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [usb-storage] Re: Make UAS work on HS for devices with and
 without command tagging support
Date: Fri, 16 Dec 2011 21:12:36 +0100
Message-ID: <20111216201236.GE19563@linutronix.de>
References: <1323888472-21035-1-git-send-email-bigeasy@linutronix.de>
 <20111214225331.GA5508@xanatos>
 <4EE9B375.4020606@linutronix.de>
 <20111215211201.GA6482@xanatos>
 <20111216144724.GC19563@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:42591 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932658Ab1LPUMi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Dec 2011 15:12:38 -0500
Content-Disposition: inline
In-Reply-To: <20111216144724.GC19563@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>

* Sebastian Andrzej Siewior | 2011-12-16 15:47:24 [+0100]:

>>If you want to take a stab at redoing your patch #2 to use only one
>>status URB for USB 2.0 devices, I would appreciate it.  Then I can build
>>the abort/reset synchronization on top of it.
>Okay.

Just once things started to become easy.... So while I tried to have
only one status urb which I always re-submit (as Matthew/ You suggested)
I run into the problem that I don't have struct scsi_device yet. So I
just created a device with two luns to see if this struct happens always
to be same. Ofcourse it is not. 
So if we re-submit the one status URB over and over again, we have to
get the device right.
The only thing that we have left to get our device in the status
complete callback is the tag number which means we need a reverse lookup
for that. To make it little more fun, those two devices have their own
request queue so we can't use a 1:1 queue slot <-> tag number mapping
because we have to distinguish between tag 0 for lun0 and tag 0 for
lun1.
I admit now that it was a bad idea to test lun support on high speed.
The good news is that it worked on SS :)

| scsi0 : uas
| usbcore: registered new interface driver uas
| scsi 0:0:0:0: Direct-Access     LIO-ORG  RAMDISK-MCP      4.0  PQ: 0 ANSI: 5
| scsi 0:0:0:1: Direct-Access     LIO-ORG  FILEIO           4.0  PQ: 0 ANSI: 5
| sd 0:0:0:0: [sda] 262144 512-byte logical blocks: (134 MB/128 MiB)
| sd 0:0:0:1: [sdb] 61441 512-byte logical blocks: (31.4 MB/30.0 MiB)
| sd 0:0:0:0: [sda] Write Protect is off
| sd 0:0:0:0: [sda] Mode Sense: 2f 00 00 00
| sd 0:0:0:1: [sdb] Write Protect is off
| sd 0:0:0:1: [sdb] Mode Sense: 2f 00 00 00
| sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
| sd 0:0:0:1: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
|  sda: unknown partition table
|  sdb: sdb1
| sd 0:0:0:1: [sdb] Attached SCSI disk
| sd 0:0:0:0: [sda] Attached SCSI disk

Going through to my log I saw that I have sometimes two requests with
the same tag on both luns more or less at the same time. So on SS both
requests are enqueued on the same stream with the same tag number. This
works because they are processed in order. This is not wrong but it
would be more efficient if we would enqueue them on two streams.

So. Where do we start? What about this:
Unique tag number => tag <-> device struct => one status urb for HS

>>Sarah Sharp

Sebastian
