From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [usb-storage] Re: Make UAS work on HS for devices with and
 without command tagging support
Date: Fri, 16 Dec 2011 12:51:22 -0800
Message-ID: <20111216205122.GA5856@xanatos>
References: <1323888472-21035-1-git-send-email-bigeasy@linutronix.de>
 <20111214225331.GA5508@xanatos>
 <4EE9B375.4020606@linutronix.de>
 <20111215211201.GA6482@xanatos>
 <20111216144724.GC19563@linutronix.de>
 <20111216201236.GE19563@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57980 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932746Ab1LPUv0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2011 15:51:26 -0500
Content-Disposition: inline
In-Reply-To: <20111216201236.GE19563@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>

On Fri, Dec 16, 2011 at 09:12:36PM +0100, Sebastian Andrzej Siewior wrote:
> * Sebastian Andrzej Siewior | 2011-12-16 15:47:24 [+0100]:
> 
> >>If you want to take a stab at redoing your patch #2 to use only one
> >>status URB for USB 2.0 devices, I would appreciate it.  Then I can build
> >>the abort/reset synchronization on top of it.
> >Okay.
> 
> Just once things started to become easy....

Nothing with UAS is coming easy, it seems. :)

> So while I tried to have
> only one status urb which I always re-submit (as Matthew/ You suggested)
> I run into the problem that I don't have struct scsi_device yet.

You mean you don't have the scsi_device in the status completion
handler?  Or where don't you have it?  In the probe function?

> So I
> just created a device with two luns to see if this struct happens always
> to be same. Ofcourse it is not. 
> So if we re-submit the one status URB over and over again, we have to
> get the device right.
> The only thing that we have left to get our device in the status
> complete callback is the tag number which means we need a reverse lookup
> for that. To make it little more fun, those two devices have their own
> request queue so we can't use a 1:1 queue slot <-> tag number mapping
> because we have to distinguish between tag 0 for lun0 and tag 0 for
> lun1.

Does that mean the SCSI core will try to submit multiple untagged
commands for each SCSI device?  If the code is structured such that only
one untagged command can be outstanding at once, is the SCSI core going
to retry the command later if we return SCSI_MLQUEUE_DEVICE_BUSY for the
second untagged command?  If it reacts badly, we might need to allow one
untagged command per lun.

> I admit now that it was a bad idea to test lun support on high speed.
> The good news is that it worked on SS :)

I'm not so sure it will with every SS device, see my comment below.

> | scsi0 : uas
> | usbcore: registered new interface driver uas
> | scsi 0:0:0:0: Direct-Access     LIO-ORG  RAMDISK-MCP      4.0  PQ: 0 ANSI: 5
> | scsi 0:0:0:1: Direct-Access     LIO-ORG  FILEIO           4.0  PQ: 0 ANSI: 5
> | sd 0:0:0:0: [sda] 262144 512-byte logical blocks: (134 MB/128 MiB)
> | sd 0:0:0:1: [sdb] 61441 512-byte logical blocks: (31.4 MB/30.0 MiB)
> | sd 0:0:0:0: [sda] Write Protect is off
> | sd 0:0:0:0: [sda] Mode Sense: 2f 00 00 00
> | sd 0:0:0:1: [sdb] Write Protect is off
> | sd 0:0:0:1: [sdb] Mode Sense: 2f 00 00 00
> | sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> | sd 0:0:0:1: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> |  sda: unknown partition table
> |  sdb: sdb1
> | sd 0:0:0:1: [sdb] Attached SCSI disk
> | sd 0:0:0:0: [sda] Attached SCSI disk
> 
> Going through to my log I saw that I have sometimes two requests with
> the same tag on both luns more or less at the same time. So on SS both
> requests are enqueued on the same stream with the same tag number. This
> works because they are processed in order. This is not wrong but it
> would be more efficient if we would enqueue them on two streams.

I'm a bit concerned about the two status URBs queued to the stream
rings.  Say the SCSI core submits two commands, one for LUN 0 and one
for LUN 1, both on stream X.  The URB for LUN 0 is queued first, then
the URB for LUN 1.  The device recieves an ERDY on the command pipe,
retrieves the command for LUN 0, and then receives the ERDY on the
command pipe and retrieves the command for LUN 1.  If the device decides
to reorder those commands, it could return the data or status URB for
LUN 1 first, which may not work, because the URBs for LUN 0 are the
first URBs on the stream endpoint ring.

There's actually some wording in the UAS spec (section 4.2) that forbids
the same tag to be used across multiple LUNs:

"If a UAS target device performs tag checking and a UAS target port
calls SCSI Command Received () with a tag already in use by another
command (i.e., an overlapped command) in any logical unit, then the task
router and task manager(s) shall:
a) abort all task management functions received on that I_T nexus; and
b) respond to the overlapped command as defined in SAM-4."

So the UAS driver is going to have to make sure unique tags are used
across each LUN.  That means we can't just add one to the request tag in
the SCSI command, we need a tag map to keep track of unused tags.  We'll
also need to adjust the SCSI command queue length for each scsi_device
to make sure one LUN isn't starving another LUN by taking up all the
available streams the device or host can handle.  Possibly we could just
divide the stream ID address space evenly between all LUNs.

> So. Where do we start? What about this:
> Unique tag number => tag <-> device struct => one status urb for HS

Yes, I think we need unique tags for each scsi_device, and one status
URB per scsi_device for high speed devices.  Possibly the
uas_queuecmd_lck just needs to allocate a status URB for each device if
one isn't already allocated.  Then you could store the scsi_device
pointer from the scsi_cmd in the status URB.  The status URBs pointers
could be stored in an array in the devinfo structure (although it's hard
to figure out how big of an array until we know how many LUNs the device
has).

Sarah Sharp
