From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: adding flag for 192 byte mode sense
Date: Mon, 22 Mar 2004 11:16:55 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0403221105290.8035-100000@ida.rowland.org>
References: <20040313174651.A3054@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:8964 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262078AbUCVQQ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Mar 2004 11:16:59 -0500
In-Reply-To: <20040313174651.A3054@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: mdharm-usb@one-eyed-alien.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

Three items:


	1. I haven't seen much feedback regarding the suggested patches that 
Patrick and I wrote:

http://marc.theaimsgroup.com/?l=linux-scsi&m=107922926816157&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=107922905218137&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=107945931705407&w=2

Do they look good?  Should they be applied?  One suggestion for a change: 
the flag could be renamed "use_192_bytes_for_ms" since we may end up 
wanting to use it for both page 0x3f and 0x08.

Also, why does sd.c check write-enable only for removable media?  Can't 
non-removable-media drives also have a write-protect switch?


	2. Some users have reported problems with USB digital cameras that 
don't support PREVENT-ALLOW MEDIUM REMOVAL and crash when they receive 
that command, even though they return the RMB flag set in their INQUIRY 
data.  Their medium really _is_ removable, in the sense that you can swap 
memory cards while the camera is turned on and plugged in to the computer.
How should we handle this?


	3. When a USB mass storage device enters a state that requires a
device reset, what command completion code should the usb-storage driver
return to invoke the SCSI error handler?  And is there any way to do this
so that the error handler skips the initial TEST UNIT READY step and goes
directly to the device reset?


Alan Stern

