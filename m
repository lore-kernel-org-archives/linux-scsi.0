From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] mode sense blacklist how
Date: 19 Nov 2003 10:02:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069261377.2867.37.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>
	 <1068767049.2851.166.camel@patrh9>
	 <1068768796.3fb41e1c8d075@webmail.netregistry.net>
	 <1068775834.2851.321.camel@patrh9>
	 <20031113181945.I30194@one-eyed-alien.net>
	 <1068777510.2851.359.camel@patrh9>
	 <1068779468.3fb447ccc6e60@webmail.netregistry.net>
	 <1068838908.2852.34.camel@patrh9>
	 <1069246502.3fbb6826955dd@webmail.netregistry.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:63987 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261957AbTKSRDV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 12:03:21 -0500
In-Reply-To: <1069246502.3fbb6826955dd@webmail.netregistry.net>
List-Id: linux-scsi@vger.kernel.org
To: dmitrik@users.sourceforge.net
Cc: linux-scsi@vger.kernel.org

Apologies in advance for each reboot these experiments force on you.

>  MODE SENSE (10): plscsi hangs and sits there in 
>  usb_stor_bulk_transfer_buf until the device is 
>  physically unplugged. kill -9 has no effect.

Yes why `kill -9` has no effect on SG_IO in progress remains an open
question here at linux-scsi.

Meanwhile people have suggested the plscsi workaround: -X time 5 0. 
Does that work for you?  That option overrides a default something like
-X time 100800 0.  You can include that option in your `export PLSCSI`
setup, if you like.

For device folk working to explain why the device hangs, how to suppress
automagic resets despite short timeouts also remains an open question
here at linux-scsi.

> kill -9 has no effect.

Have you tried `modprobe -r usb-storage`?

>  MODE SENSE (10): plscsi hangs and sits there

I see in the log you say what plscsi line you tried:

./plscsi -p -i xC0 -x "5A 00 1C:00:00:00 00 00:C0 00 00:00"

Adding -v might tell us more.

In the log I see this command repeated, time and again.  Did you ask for
this command repeatedly yourself, or is it the code of SG_IO and below
that is so helpfully retrying?

>  Another interesting "feature": the camera does not work 
>  as a USB device without memory stick in its slot. That is 
>  if I plug it in without the stick nothing happens. When I 
>  then insert the stick it goes through the normal port 
>  status change/discovery/enumeration routine. When I
>  remove the stick from its slot the device pretends it 
>  has been disconnected.

Aye, USB storage varies here.  In byte 1 mask x80 of the op x12 Inquiry
data the device has to say if the disk can be removed without removing
the drive.  A device that clears that bit to say the disk and drive do
plug and unplug together has to virtually unplug USB when you
mechanically remove the disk.  Other devices may virtually unplug USB
when you mechanically remove the disk.

> Short version:
>  MODE SENSE (6): ...

Can you easily share the tty log of plscsi -v?  I ask because for me the
extra detail of a standard kernel log helps explain the plscsi tty log
without easily yielding an equally concise summary.

> Short version:
>  MODE SENSE (6): device reports STALL condition.

Stall is normal in mass storage, because provoking failure and
tolerating partial success is normal in mass storage.

Here the device design choice of bInterfaceProtocol = x01 = CB =
"Transport: Control/Bulk" makes control stall normal, rather than the
bulk stall of generic usb mass storage (bInterfaceProtocol = x50 =
*"Pat").

>  Subsequent
>  auto-REQUEST SENSE reports "Illegal Request in CDB".
>  As far as I undertand the device tries to tell us that the
>  command is not supported.

SCSI as defined by t10.org makes a subtle distinction.

Here we see "auto-sense" "code: 0x70, key: 0x5, ASC: 0x24, ASCQ: 0x0".

In the t10.org English, x 5 24 means cdb[0] opcode understood, but whole
cdb not understood.  x 5 20 means cdb[0] opcode not understood.

This result suggests, without guaranteeing, that the vendor-specific
bInterfaceSubClass = xFF SCSI of this device includes some cdb's that
begin with op x1A Mode Sense (6).

> here is my report ... Long version ... attached ...

Yes to interpret the English report and plscsi tty logs confidently, I
need the kernel log, thank you.

> in case you're still interested

Yes!

Pat LaVarre


