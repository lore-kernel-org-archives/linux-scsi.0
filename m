From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] Re: /proc/scsi/map
Date: Mon, 17 Jun 2002 10:15:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <ael5hn$njm$2@main.gmane.org>
References: <200206162202.g5GM2XT02750@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Oliver Neukum <oliver@neukum.name>, Andries.Brouwer@cwi.nl, garloff@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, sancho@dauskardt.de, linux-usb-devel@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net, dougg@torque.net

> The idea behind using hotplug to solve the problem is that with scsimon, a 
> hotplug insertion event is generated for every SCSI device as it is added.  
> The script is provided with the information the kernel knows (host, channel, 
> pun lun, model and vendor inquiry strings---see www.torque.net/scsimon.html 

Make that http://www.torque.net/scsi/scsimon.html ... that page is linked
from the http://linux-hotplug.sourceforge.net links page, and I'm glad to
see it's been updated recently.


> for details).  The hotplug script then does the remaining processing to 
> extract the ID from the device (by ioctls, sending down SCSI commands etc.) 
> and then binds it into the /dev/volume nodes using the identifier it 
> determines.
> 
> The result is that however you move the device around (between controllers or 
> even change its id), it will always show up as its unique /dev/volume name.
> 
> The key philosophy is that the code to make the policy decision for assigning 
> a unique name isn't cluttering up the kernel, it's in user land where it can 
> be easily customised.  

I think that's a good approach for packaging that naming policy, though I'm
not quite sure where it stands in relation to "driverfs".  As with "usbfs"
it seems to me that there need to be both low-level "topological" and higher
level "logical/policy-driven" names.  And I'd prefer not to see a multiplicity
of approaches for anything except the bus-specific parts (which in this case
is "SCSI" even if the transport may be USB); I think I'm not alone in that.

Also, given what I noted earlier about stable IDs, I think SCSI_HOST should
be a stable string ID, not an integer that can easily get switched around
during system boot.

- Dave


