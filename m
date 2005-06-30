From: James.Smart@Emulex.Com
Subject: RE: [PATCH 2/2] - mptfusion - FC Transport Support
Date: Thu, 30 Jun 2005 17:50:54 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F419C@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:29394 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S263055AbVF3VvJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jun 2005 17:51:09 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: Eric.Moore@lsil.com, linux-scsi@vger.kernel.org

I haven't planned to make any changes as yet. I also didn't quite know
the rules for how to "break" compatibility things like this.

The other thing I'm unclear on is - how does udev get to attributes
are not on the base device ? For example, for FC disks, I'd like to
get the SCSI lun #, and the FC WWPN of the target hosting it. I don't
know that udev has considered the "classes", or that a device may be
in multiple classes (well, not programatically, but that scsi disk 
entity that I want to manage is both in the block class as well as
the scsi_device class).

Also, in some of the discussions on lsscsi, something that makes a lot
of sense is have soft links from the device to the class(es) it's a
part of. Right now, the utility has to find the device, and search the
classes for something of like name (which there isn't a rule that it
will always be true). I'd rather see that whenever a class is added to
a device, a symbolic link (name is class name, points to class object)
is made under the device object.

-- james s

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
> Sent: Thursday, June 30, 2005 9:28 AM
> To: Smart, James
> Cc: Eric.Moore@lsil.com; SCSI Mailing List
> Subject: RE: [PATCH 2/2] - mptfusion - FC Transport Support
> 
> 
> On Fri, 2005-06-24 at 14:34 -0400, James.Smart@Emulex.Com wrote:
> > To be honest, if I could have killed it (target-based object
> > in sysfs), I would have as part of the FC transport rework. 
> There was
> > unfortunately too many app side things (udev, etc) that refer to it.
> > This object is really a lame-duck.
> 
> Surely udev is about the only problem ... and we should be able to
> persuade Greg to change easily enough.  It does seem that all of the
> port information belongs in the rport, and so the attributes should be
> deprecated and eventually eliminated.  Are you planning to do this?
> 
> James
> 
> 
> 
