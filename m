From: Greg KH <greg@kroah.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Thu, 16 Jan 2003 11:53:06 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030116195306.GA32697__27134.9019058563$1042747068@kroah.com>
References: <10426732153816@kroah.com> <10426732212871@kroah.com> <20030116093112.B29001@one-eyed-alien.net> <20030116173539.GA31235@kroah.com> <20030116114323.C29001@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030116114323.C29001@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

On Thu, Jan 16, 2003 at 11:43:23AM -0800, Matthew Dharm wrote:
> Well, we only create the host when the device is first attached.  After
> that, if it goes away and comes back, we re-connect it to the old SCSI
> host.

Ick, so when the device is gone, where does the SCSI host go?  Is it
still represented in sysfs and in the SCSI core properly?

> But, while the device is gone, you've created an association between a SCSI
> node that exists and a non-existant USB device.  Basically, you've got a
> pointer that is no longer valid.  And when the device is re-attached, there
> isn't code to re-establish the correct SCSI<->USB association.

Why not?  I'm guessing that you re-establish this association, right?
Then you might have to add this same call to whereever that is done.

> Something like this would proabably make sense if the hot-unplugging code
> for SCSI hosts was really stable -- then we could unregister the host when
> the device went away, and this relation would be disconnected
> automatically.

Well, push back on the SCSI people to fix this then, hot-unplug should
work properly on the SCSI layer too :)

thanks,

greg k-h
