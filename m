From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [linux-usb-devel] Re: /proc/scsi/map
Date: Sun, 16 Jun 2002 18:14:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200206162314.g5GNEYf03058@localhost.localdomain>
References: <oliver@neukum.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id QAA11351
	for <linux-scsi@vger.kernel.org>; Sun, 16 Jun 2002 16:14:44 -0700
In-Reply-To: Message from Oliver Neukum <oliver@neukum.name>
   of "Mon, 17 Jun 2002 00:38:51 +0200." <200206170038.51403.oliver@neukum.name>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, David Brownell <david-b@pacbell.net>, Andries.Brouwer@cwi.nl, garloff@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, sancho@dauskardt.de, linux-usb-devel@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net, dougg@torque.net

oliver@neukum.name said:
> But the drivers already know, or would have to be taught to know about
> it. Somewhence that information has to come. You cannot avoid that
> effort. 

Not necessarily: consider the SCSI WWN, which is supported by most modern SCSI 
devices.  The driver never probes for or asks for this.  Nowhere in the 
current SCSI code do we ask for this.  However user level commands (like 
sg_inq) can formulate the 0x83 page inquiry to get this and return the output. 
 This works today with the current driver.

> That is wrong. You'd need a common method to determine device type and
> several methods of passing guid. You are better off in implementing
> one common way of getting at that information, which shouldn't be too
> hard, as all the generic layer would have to do is pass up that
> information. 

but the complexity is in the "common method to determine device type and 
several methods of passing guid".  Even for a simple SCSI disk, there's no one 
universal way of getting a unique id (let alone when we add the usb devices 
masquerading as scsi disks into the mix).  That will lead us to scanning a 
list of inquiry strings to see what the disk is and determine what globally 
unique ID it supports.  Since we have to implement a lookup table just to 
determine how to get the unqiue id, it's far better off being done outside the 
kernel.

James



