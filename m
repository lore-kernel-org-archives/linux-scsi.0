From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Handling erroneous READ CAPACITY response in sd.c
Date: Sun, 24 Oct 2004 13:11:30 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0410241306060.26683-100000@netrider.rowland.org>
References: <417AFDA5.5080806@micro.ee.nthu.edu.tw>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:52494 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S261538AbUJXRLa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Oct 2004 13:11:30 -0400
In-Reply-To: <417AFDA5.5080806@micro.ee.nthu.edu.tw>
List-Id: linux-scsi@vger.kernel.org
To: Darsen <darsen@micro.ee.nthu.edu.tw>
Cc: Adriaan Penning <a.penning@luon.net>, Eero Volotinen <eero@ping-viini.org>, Luben Tuikov <luben_tuikov@adaptec.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Sun, 24 Oct 2004, Darsen wrote:

> I've tried the patches you gave me.
> Unfortunately they do not work on my computer.
> Here is the result of "dmesg:" 
> 
> usb 2-2: reset full speed USB device using address 2
> usb 2-2: device not accepting address 2, error -110
> usb-storage: usb_reset_device returns -19
> scsi: Device offlined - not ready after error recovery: host 0 channel 0 
> id 0 lun 0
> sd_read_true_cap: sda: PMI not supported
> scsi0 (0:0): rejecting I/O to offline device
> sd_read_format_cap: sda: READ FORMAT CAPACITIES not supported
> SCSI device sda: 251905 512-byte hdwr sectors (129 MB)
> sda: assuming Write Enabled
> sda: assuming drive cache: write through
> Attached scsi removable disk sda at scsi0, channel 0, id 0, lun 0
> Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 0
> usb-storage: queuecommand called
> usb 2-2: USB disconnect, address 2
> 
> It seems that the two commands you tried were not supported by my device 
> (Apacer Audio Steno).  Strange isn't it?

It's not that they are unsupported -- it's that your device crashed before 
they were sent!

The dmesg extract above starts way too late, after the device has already 
crashed.  What happened before that might be of interest, but it probably 
won't tell us anything about the new code we want to test.

> (I eliminated the usb-storage verbose debug messages because it was too 
> long, if you need them I can send it to you.)

Yes, please.  Maybe it contains something useful.  Like why your device 
crashed when it used to work okay.

> I tried another way: by correcting capacity that is not a multiple of 
> 256. (see below)
> This does work on my device, but I don't know whether it works on other 
> machines.

No, it won't.  Besides, a major point of this effort is to see if the 
fix_read_capacity() routine can be eliminated.

Alan Stern

