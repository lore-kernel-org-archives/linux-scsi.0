From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Fri, 25 Apr 2003 10:32:09 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0304251009030.30350-100000@netrider.rowland.org>
References: <UTC200304250043.h3P0hPH01942.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:26897 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S263230AbTDYOT6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2003 10:19:58 -0400
In-Reply-To: <UTC200304250043.h3P0hPH01942.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: stelian@popies.net, James.Bottomley@steeleye.com, afafc@rnl.ist.utl.pt, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, USB development list <linux-usb-devel@lists.sourceforge.net>, pwkpete@yahoo.com

On Fri, 25 Apr 2003 Andries.Brouwer@cwi.nl wrote:

> Now about fixing the code. We must do something in usb-storage
> or sd.c or both. I would prefer if sr_bufflen denotes the
> actually available length, instead of the length that
> will be transferred. If it has that meaning, then the
> fudger in usb-storage knows for sure that there is space.
> And sd_do_mode_sense6 and family can store the right number.

There is a pattern emerging here, and I would like to propose a more 
general strategy for this problem.

We have seen that low-level device drivers such as usb-storage need to 
filter/alter the commands they accept.  Such actions include:

	(1) Refusing to issue a command that is known (or very likely) to 
crash the device's firmware.

	(2) Synthesizing an artificial reply to a command which the device 
doesn't handle well but the SCSI code needs.

	(3) Changing one command to another (e.g., READ(6) -> READ(10)).

	(4) Changing the data length for a command to meet the device's 
restrictions.

There may be other cases as well that I haven't thought of.

To begin with, in my opinion the LLDD should do a minimum of filtering and 
altering.  Not only is it frequently difficult to know if such actions are 
valid or will be acceptable to the caller, there is also the principle 
that user-generated requests (via the scsi-generic interface) should be 
left totally alone -- after all, the user may be probing precisely to 
determine whether or not the device will accept a particular command.

(1) is obviously necessary.  In general, refusing to accept a command is 
better than changing it, IMO.

(2) should be minimized, but there are times when it is unavoidable (such 
as INQUIRY for various USB storage devices that don't support it).

(3) should be avoided completely.  If the device doesn't accept some form 
of a command, then that fact should be transmitted back to the caller.

(4) also should be avoided.

This puts the burden of dealing with partially-compliant devices on the 
SCSI midlayer.  The routines there should be prepared to issue multiple 
forms of a some commands, so that if one form doesn't work another form 
can be tried.  Of course, this is already being done for READ and WRITE.  
A similar strategy could be used for things like MODE-SENSE.  However, 
detailed per-device information should be kept small -- little more than 
"this device likes the 6-byte commands rather than the 10-byte commands".

The same idea goes for retrying commands using different data lengths.  
It would be especially nice if there was a good way for the LLDD to report
that the data length specified was too short (or too long) for the device
to accept.

The filtering done by the LLDD should be relatively simple, and removing
the complex translations that are currently being done would help.  
Whether the filtering relies on centralized library routines (such as Matt
Dharm recently proposed) or a more decentralized scheme doesn't need to be
settled now.  In fact, it can fairly easily be changed later, as usage
patterns dictate.

This approach puts the burden of the various tasks where they belong.  
The LLDD is responsible for keeping the device from crashing, which only
it has the knowledge to do.  The SCSI mid-layer is responsible for the
strategies needed to get a device to carry out a particular action, which
is a problem that extends to all sorts of SCSI devices and is not peculiar
to one particular type.

Alan Stern

