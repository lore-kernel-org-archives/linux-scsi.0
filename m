From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Thu, 23 Jan 2003 16:15:37 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030123161537.A11487@beaverton.ibm.com>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <200301231919.40422.oliver@neukum.name> <3E303D5E.5020000@splentec.com> <200301232040.41862.oliver@neukum.name> <20030123202835.GA25838@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030123202835.GA25838@redhat.com>; from dledford@redhat.com on Thu, Jan 23, 2003 at 03:28:36PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

On Thu, Jan 23, 2003 at 03:28:36PM -0500, Doug Ledford wrote:
> On Thu, Jan 23, 2003 at 08:40:41PM +0100, Oliver Neukum wrote:
> 
> No, scsi_set_device_offline() schedules the error handler thread for that 
> host to be woken up.
> 

Doug -

Why would the error handler need to run?

If the LLDD fails all outstanding command with an appropriate error (like
DID_NO_CONNECT), the failure is passed to the upper levels.

It seems that we could just set the device offline, make sure we do not
send commands for an offline device, and let the adapter fail all
outstanding commands.

-- Patrick Mansfield
