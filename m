From: Dmitri Katchalov <dmitrik@users.sourceforge.net>
Subject: Re: [usb-storage] mode sense blacklist how
Date: Fri, 21 Nov 2003 01:06:27 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069337187.3fbcca6395f44@webmail.netregistry.net>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>  <1068767049.2851.166.camel@patrh9>  <1068768796.3fb41e1c8d075@webmail.netregistry.net>  <1068775834.2851.321.camel@patrh9>  <20031113181945.I30194@one-eyed-alien.net>  <1068777510.2851.359.camel@patrh9>  <1068779468.3fb447ccc6e60@webmail.netregistry.net>  <1068838908.2852.34.camel@patrh9>  <1069246502.3fbb6826955dd@webmail.netregistry.net> <1069261377.2867.37.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from webmail.netregistry.net ([203.202.16.21]:4662 "EHLO
	webmail.netregistry.net") by vger.kernel.org with ESMTP
	id S261863AbTKTOGb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2003 09:06:31 -0500
In-Reply-To: <1069261377.2867.37.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Quoting Pat LaVarre <p.lavarre@ieee.org>:

> >  MODE SENSE (10): plscsi hangs and sits there in 
> >  usb_stor_bulk_transfer_buf until the device is 
> >  physically unplugged. kill -9 has no effect.
> 
> Yes why `kill -9` has no effect on SG_IO in progress remains an open
> question here at linux-scsi.
> 
> Meanwhile people have suggested the plscsi workaround: -X time 5 0. 
> Does that work for you?  

Yes, it does, thanks. Still, when plscsi comes back after a timeout the device
no longer responds and must be unplugged:

Nov 21 08:54:21 box kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Nov 21 08:54:21 box kernel: usb-storage:  5a 00 00 00 00 00 00 00 c0 00
Nov 21 08:54:21 box kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21
value=0000 index=00 len=10
Nov 21 08:54:21 box kernel: usb-storage: Status code 0; transferred 10/10
Nov 21 08:54:21 box kernel: usb-storage: -- transfer complete
Nov 21 08:54:21 box kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Nov 21 08:54:21 box kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 192 bytes

<note the delay here>

Nov 21 08:54:31 box kernel: usb-storage: command_abort called
Nov 21 08:54:31 box kernel: usb-storage: usb_stor_stop_transport called
Nov 21 08:54:31 box kernel: usb-storage: -- cancelling URB
Nov 21 08:54:31 box kernel: usb-storage: Status code -104; transferred 0/192
Nov 21 08:54:31 box kernel: usb-storage: -- transfer cancelled
Nov 21 08:54:31 box kernel: usb-storage: CB data stage result is 0x4
Nov 21 08:54:31 box kernel: usb-storage: -- command was aborted
Nov 21 08:54:31 box kernel: usb-storage: scsi command aborted
Nov 21 08:54:31 box kernel: usb-storage: *** thread sleeping.
Nov 21 08:54:31 box kernel: usb-storage: queuecommand called
Nov 21 08:54:31 box kernel: usb-storage: *** thread awakened.
Nov 21 08:54:31 box kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Nov 21 08:54:31 box kernel: usb-storage:  00 00 00 00 00 00
Nov 21 08:54:31 box kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21
value=0000 index=00 len=6
Nov 21 08:54:31 box kernel: usb-storage: Status code 0; transferred 6/6
Nov 21 08:54:31 box kernel: usb-storage: -- transfer complete
Nov 21 08:54:31 box kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Nov 21 08:54:31 box kernel: usb-storage: -- CB transport device requiring auto-sense
Nov 21 08:54:31 box kernel: usb-storage: Issuing auto-REQUEST_SENSE
Nov 21 08:54:31 box kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21
value=0000 index=00 len=6
Nov 21 08:54:31 box kernel: usb-storage: Status code 0; transferred 6/6
Nov 21 08:54:31 box kernel: usb-storage: -- transfer complete
Nov 21 08:54:31 box kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Nov 21 08:54:31 box kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Nov 21 08:54:41 box kernel: usb-storage: command_abort called
Nov 21 08:54:41 box kernel: usb-storage: usb_stor_stop_transport called
Nov 21 08:54:41 box kernel: usb-storage: -- cancelling URB
Nov 21 08:54:41 box kernel: usb-storage: Status code -104; transferred 0/18
Nov 21 08:54:41 box kernel: usb-storage: -- transfer cancelled
Nov 21 08:54:41 box kernel: usb-storage: CB data stage result is 0x4
Nov 21 08:54:41 box kernel: usb-storage: -- auto-sense aborted
Nov 21 08:54:41 box kernel: usb-storage: scsi command aborted
Nov 21 08:54:41 box kernel: usb-storage: *** thread sleeping.
Nov 21 08:54:41 box kernel: usb-storage: device_reset called
Nov 21 08:54:41 box kernel: usb-storage: usb_stor_CB_reset called
Nov 21 08:54:41 box kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21
value=0000 index=00 len=12
Nov 21 08:54:41 box kernel: usb-storage: Soft reset failed: -32
Nov 21 08:54:41 box kernel: usb-storage: bus_reset called
Nov 21 08:54:41 box kernel: hub 2-0:1.0: port 2 enable change, status 110
Nov 21 08:54:42 box kernel: usb-storage: usb_reset_device returns 0
Nov 21 08:54:52 box kernel: usb-storage: queuecommand called
Nov 21 08:54:52 box kernel: usb-storage: *** thread awakened.
Nov 21 08:54:52 box kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Nov 21 08:54:52 box kernel: usb-storage:  00 00 00 00 00 00
Nov 21 08:54:52 box kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21
value=0000 index=00 len=6
Nov 21 08:54:52 box kernel: usb-storage: Status code 0; transferred 6/6
Nov 21 08:54:52 box kernel: usb-storage: -- transfer complete
Nov 21 08:54:52 box kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Nov 21 08:54:52 box kernel: usb-storage: -- CB transport device requiring auto-sense
Nov 21 08:54:52 box kernel: usb-storage: Issuing auto-REQUEST_SENSE
Nov 21 08:54:52 box kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21
value=0000 index=00 len=6
Nov 21 08:54:52 box kernel: usb-storage: Status code 0; transferred 6/6
Nov 21 08:54:52 box kernel: usb-storage: -- transfer complete
Nov 21 08:54:52 box kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Nov 21 08:54:52 box kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Nov 21 08:54:52 box kernel: usb-storage: Status code -19; transferred 0/18
Nov 21 08:54:52 box kernel: usb-storage: -- unknown error
Nov 21 08:54:52 box kernel: usb-storage: CB data stage result is 0x4
Nov 21 08:54:52 box kernel: usb-storage: -- auto-sense failure
Nov 21 08:54:52 box kernel: usb-storage: usb_stor_CB_reset called
Nov 21 08:54:52 box kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21
value=0000 index=00 len=12
Nov 21 08:54:52 box kernel: usb-storage: Soft reset failed: -32
Nov 21 08:54:52 box kernel: usb-storage: scsi cmd done, result=0x70000
Nov 21 08:54:52 box kernel: usb-storage: *** thread sleeping.
Nov 21 08:54:52 box kernel: scsi: Device offlined - not ready after error
recovery: host 13 channel 0 id 0 lun 0

Using the timeout flag I was able to try more MODE SENSE(10) commands
and I finally found some that work:

./plscsi /dev/sg1 -v -p -X time 10 0 -i xC0 -x "5A 00 3F 00 00 00 00 00 C0 00"
produces the following output:

x 00000000 5A 00 3F:00:00:00 00 00:C0 00 .. .. .. .. .. .. "Z@?@@@@@@@"
x 00000000 00:32:00:00 00:00:00:00 05:1E:00:12 04:20:02:00 "@2@@@@@@E^@RD B@"
x 00000010 01:00:00:00 00:00:00:00 00:00:00:00 00:00:00:00 "A@@@@@@@@@@@@@@@"
x 00000020 00:00:00:00 00:B4:00:00 1B:0A:C0:00 00:00:00:00 "@@@@@4@@[J@@@@@@"
x 00000030 00:00:00:00 00:00:00:00 00:00:00:00 00:00:00:00 "@@@@@@@@@@@@@@@@"
...
x 000000B0 00:00:00:00 00:00:00:00 00:00:00:00 00:00:00:00 "@@@@@@@@@@@@@@@@"
// 0 = plscsi.main exit int

It looks like the device does support MODE SENSE(10) for pages 5 and 1B only.
"5A 00 05 00 00 00 00 00 C0 00" and "5A 00 1B 00 00 00 00 00 C0 00" also work.

There is not much useful info on those 2 pages, what was the point 
of implementing them I wonder?

> Have you tried `modprobe -r usb-storage`?
"Module in use"
Not entirely unexpected since plscsi holds an open handle at this point.
 
> >  MODE SENSE (10): plscsi hangs and sits there
> 
> I see in the log you say what plscsi line you tried:
> 
> ./plscsi -p -i xC0 -x "5A 00 1C:00:00:00 00 00:C0 00 00:00"
> 
> Adding -v might tell us more.
Not really:) It just shows the command going down and that's it.

> In the log I see this command repeated, time and again.  Did you ask for
> this command repeatedly yourself, or is it the code of SG_IO and below
> that is so helpfully retrying?

That wasn't me. I see these commands were sent *after* the device has 
been unplugged. It must've been SCSI layer.

> Here we see "auto-sense" "code: 0x70, key: 0x5, ASC: 0x24, ASCQ: 0x0".
> 
> In the t10.org English, x 5 24 means cdb[0] opcode understood, but whole
> cdb not understood.  x 5 20 means cdb[0] opcode not understood.
> 
> This result suggests, without guaranteeing, that the vendor-specific
> bInterfaceSubClass = xFF SCSI of this device includes some cdb's that
> begin with op x1A Mode Sense (6).

Hmm, I tried MODE SENSE(6) with the same pages (5,1B and 3F) that worked 
with MODE SENSE(10) and I've got the same error: x 5 24.

Anyway, it must be obvious by now that the device is broken or shall we say
proprietary. There is a quick workaround already in place. I'd say blacklist 
it in unusual_devs and be done with it.

The only really important question IMHO is how come SG_IO is not interruptible.

Regards,
Dmitri


