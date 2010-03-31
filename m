From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 31 Mar 2010 12:36:58 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1003311229460.1739-100000@iolanthe.rowland.org>
References: <4BB37454.8070808@interlog.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <4BB37454.8070808@interlog.com>
Sender: linux-hotplug-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: David Zeuthen <david@fubar.dk>, Jonas Schwertfeger <jschwertfeger@gmail.com>, linux-hotplug@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 31 Mar 2010, Douglas Gilbert wrote:

> > Stock udev comes with ata_id which I think may be invoked for this
> > device (but I'm not sure). Try moving it out of the way?
> > 
> > On most distros, udisks (also known as DeviceKit-disks before the name
> > was changed) is installed which runs a small program that uses
> > libatasmart to determine if the device is SMART capable:
> > 
> > http://cgit.freedesktop.org/udisks/tree/src/probers/udisks-probe-ata-smart.c
> > 
> > and this definitely runs for this USB device assuming removable is 0 in
> > sysfs. Perhaps http://bugs.freedesktop.org/show_bug.cgi?id=25673 is
> > related? Maybe try with the latest libatasmart?

Jonas, these sound like good things to try.  Find the ata_id and udisks 
programs on your computer and rename them so they can't be run 
automatically.  Then see if the problem still occurs.

> Since the sequence of commands was IDENTIFY DEVICE,
> SET FEATURES then IDENTIFY DEVICE again my guess is
> that SET FEATURES caused the problem.

More precisely, the commands were IDENTIFY DEVICE (ATA-12), SET 
FEATURES (ATA-16), IDENTIFY DEVICE (ATA-16).  The third command was not 
the same as the first, so one shouldn't assume that the third should 
have worked merely because the first did.

In fact, I would guess that the second IDENTIFY DEVICE is what caused
the problem, since the first two commands both succeeded and the third
failed.  If the second command was responsible for the problem, I would
have expected _it_ to fail.

> Why would a
> program called ata_id try to change the state of
> the device?

In fact, those three commands may have been sent by different programs.  
It certainly is possible that the problem is related to libatasmart.

Alan Stern

