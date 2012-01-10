From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 0/3] SCSI & usb-storage: new flags for VPD pages and REPORT
 LUNS
Date: Tue, 10 Jan 2012 13:42:40 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1201101327030.1594-100000@iolanthe.rowland.org>
References: <E9801365-C2D1-4E5C-8BE4-BD712DA0D2FD@mac.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55174 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756457Ab2AJSmm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2012 13:42:42 -0500
In-Reply-To: <E9801365-C2D1-4E5C-8BE4-BD712DA0D2FD@mac.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Perry Wagle <wagle@mac.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

James and Greg:

Perry Wagle reports that his new USB-ESATA drives don't work properly 
because they don't like getting the LUN bits in the second byte of the 
command string.  We set those bits only because usb-storage adjusts the 
SCSI revision level for all devices to SCSI-2; the drives themselves 
report a value of 0x06 (which would be SCSI-7).

The reason for mangling the scsi_level value was that some USB devices 
reported SCSI-3 but couldn't handle some of the mandatory features: VPD 
pages and the REPORT LUNS command.  It's now clear that instead of 
abusing scsi_level, we should have separate flags for the individual 
features we need to control.

That's what this patch series does.  The first merely corrects an 
existing typo in the definition of struct scsi_target.  The second adds 
the new flags and makes usb-storage use them.  The third takes this 
opportunity to do a little code clean-up in usb-storage.

The changes are more or less equally divided between SCSI and
usb-storage.  James, if they look okay to you and you don't mind taking
them through your tree, that would be fine.  Or if you prefer, I'm sure
Greg won't mind taking them.

Although this should be quite safe, there is a small possibility that
it will mess up some buggy device that has been working okay up to now.  
If necessary, we can always add another blacklist flag to usb-storage
to treat such devices in the old way -- setting scsi_level to SCSI_2.  
However, because of this possibility I'm not going to send these
patches to the stable tree.

Alan Stern

