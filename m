From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Wed, 26 Feb 2003 15:37:02 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030226233702.GC1376@beaverton.ibm.com>
References: <20030124152540.B27859@one-eyed-alien.net> <20030125000529.GE28812@redhat.com> <20030124164553.C27859@one-eyed-alien.net> <20030125010729.GG28812@redhat.com> <20030202101317.A26796@one-eyed-alien.net> <20030202120628.A28024@one-eyed-alien.net> <20030203171726.GA1583@beaverton.ibm.com> <20030216131835.B23422@one-eyed-alien.net> <20030217193737.GB1990@beaverton.ibm.com> <20030222234834.A32167@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030222234834.A32167@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Matthew,
	Sorry for the delay in replying (non coding activities are
	consuming to many hours).

Matthew Dharm [mdharm-scsi@one-eyed-alien.net] wrote:
> Okay, I see Linus has now accepted this into his tree.  It should propagate
> to the USB development trees soon.
> 
> One question: What else is needed?  We set the device offline,
> error/complete all pending commands, and the need to (somehow) make certain
> we're in a good state for calling scsi_remove_host().  How do we make that
> final guarantee?
> 
> There was talk that scsi_set_device_offline() would take care of that for
> us by waking up the error handler... there seems to be code to do that....
> 

Yes,

The scsi_set_device_offline will wake up the error handler to abort
outstanding commands.

> There was talk of using the release() function from the SCSI template to
> actually release resources....
> 
> So, what's the plan?

There still are a few things on the to do list, but should not effect the
LLDD interface (at least this is the goal).
	- scsi_request_fn needs a fix for device offline that will
	  handle all request types.
	- scsi_remove_host needs to call template release at the correct
	  time (ref counting ??).
	- need fix for offline hotplug event.
		- Should do_hotplug be exported or should device states
		  be added / fixed ??

Cleanups
	- Change scsi_remove_host for int to void function.


-andmike
--
Michael Anderson
andmike@us.ibm.com

