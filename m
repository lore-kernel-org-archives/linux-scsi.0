From: Alan Stern <stern@rowland.harvard.edu>
Subject: Time to allow MODE SENSE for USB disk-type storage devices?
Date: Mon, 8 Mar 2004 11:05:38 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0403081046190.1187-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:6660 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262505AbUCHQFq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Mar 2004 11:05:46 -0500
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Patrick Mansfield <patmans@us.ibm.com>
Cc: USB Storage List <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

Matt & Patrick:

Maybe it's time to think about improving the situation with MODE SENSE for 
USB devices.  I don't know that page 0x08 is particularly crucial for USB 
devices, but page 0x3f (for the write-protect setting) certainly would be 
good to have.

Traces taken from various Windows systems show that Windows 2000
consistently issues MODE SENSE for page 0x3f, while Windows XP does both
page 0x3f and page 0x08.  Now it's entirely possible that certain
vendor-specific drivers cause Windows to skip those steps, but on the
whole we ought to be pretty safe if we do them in exactly the same way as
Windows.  For page 0x3f, anyway.  (If necessary, we can add an
unusual_devs flag bit to usb-storage for devices that can't handle page
0x3f.)

There are two important things to note.  First, Windows _always_ uses a
transfer length of 192 for these commands.  None of this "Let's just get
the header" or "Only request as much as we need" wishy-washiness.  
Second, Windows uses MODE SENSE(6) for Transparent Scsi (USB SubClass =
0x06) and MODE SENSE(10) for everything else -- according to Pat LaVarre
anyway, and it agrees with the trace data.  (MODE SELECT is treated the
same way, but that's irrelevant for our purposes.)

The usb-storage driver can fix the 6-byte vs. 10-byte issue by clearing or
setting the appropriate flag during the slave_configure() callback.  Is it 
possible to force the 192-byte transfer lengths in a similar way?

On a related note, we've run across reports from several users indicating 
that their USB devices die when handed a PREVENT-ALLOW MEDIUM REMOVAL 
command, even though they set the Removable-Medium flag in their INQUIRY 
data.  Could there be a device flag that would cause the sd driver to 
avoid these commands?

Alan Stern

