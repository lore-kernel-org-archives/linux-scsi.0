From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [linux-usb-devel] Re: /proc/scsi/map
Date: Sun, 16 Jun 2002 12:25:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200206161725.g5GHP6S23020@localhost.localdomain>
References: <david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id KAA20598
	for <linux-scsi@vger.kernel.org>; Sun, 16 Jun 2002 10:25:18 -0700
In-Reply-To: Message from David Brownell <david-b@pacbell.net>
   of "Sun, 16 Jun 2002 10:05:49 PDT." <3D0CC56D.9050805@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: Andries.Brouwer@cwi.nl, garloff@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, sancho@dauskardt.de, linux-usb-devel@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net, dougg@torque.net

Since we already have a huge long list of different ways to identify different 
devices, I don't think coding any one or even a set of such methods into the 
kernel would satisfy everyone.

What about a different approach:

We already (nearly) have the scsimon patches to do hot plug events on SCSI 
devices incorporated.  Any identification could be done from the scsi device 
hotplug script (i.e. if you see it's USB, get the GID, if it's enterprise 
storage get the WWN, try the filesystem UUID etc).  Then all the hotplug 
script does is plug this device into some type of volume idenfication scheme 
like /dev/volume/<name>.

Any application needing to always know where the device is would refer to it 
by name, and since there's no prescription at all about what the <name> is, 
you could even alias horribly unfriendly things like the WWN to more palatable 
names using a user specified translation table.

This implementation doesn't even depend on SCSI, so it could potentially be 
used by any subsystem (IDE, block devices).

The only component that doesn't exist is the configurable /dev/volume piece.  
Since the name would be a property of the device node, it probably makes sense 
to place this into the new driverfs somehow.

James


