From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [linux-usb-devel] Re: /proc/scsi/map
Date: Mon, 17 Jun 2002 15:25:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <aelhf4$n6n$2@main.gmane.org>
References: <patmans@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id NAA27879
	for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2002 13:25:13 -0700
In-Reply-To: Message from Patrick Mansfield <patmans@us.ibm.com>
   of "Mon, 17 Jun 2002 12:07:06 PDT." <20020617120706.A16275@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Oliver Neukum <oliver@neukum.name>, David Brownell <david-b@pacbell.net>, Andries.Brouwer@cwi.nl, garloff@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, sancho@dauskardt.de, linux-usb-devel@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net, dougg@torque.net

patmans@us.ibm.com said:
> Yes, legacy or broken devices need vendor specific code to get a
> unique serial number or uid, but it is not clear to me that putting
> the code in user space is better or worse than kernel space. Maybe we
> need to see some implementations. 

For me the advantage of doing this in user space is that we can use simple 
scripting to handle all the exceptions (and actually, allowing easy 
reconfiguration of the exceptions), but I agree, a reference implementation 
would be a useful demonstration.

> What happens at boot time? Do we now need special stripped copies of
> user space get-id commands to boot from scsi (for use with initrd)? Do
> we just wait until the system is booted before getting/setting the
> ID's? 

That depends on whether you really need the unique id at boot or not.  The 
boot code is really only looking for the root filesystem, which can be found 
by fs label, so there may not be a need to put all this in initrd.  However, 
if we have to it would go in as part of the diet{libc, hotplug} stuff.

If you don't put it in initrd, then you have an init script that runs to scan 
all the existing devices and configure them accordingly.

> If I build without sg or /proc, should SCSI ID's still be available? 

Without /proc, depending on how you do the sg<->sd mapping, possibly.  Without 
sg, no since I'd use that to formulate the SCSI cdb to get the ID.

> How can I efficiently handle multi-path code without overallocating N
> Scsi_Devices (where N is the number of paths to each Scsi_Device)? 

Since this is a one time configuration, is overallocation such a bad thing 
(particularly as the allocator is moving towards a much more dynamic model in 
2.5)?  You can allow the normal stuff to run and then trigger multi-path 
configuration adds as you see the same unique ID come in for different devices.

> For kernel implementations, we could add a special entry in the
> device_list or have a new list mapping vendor+product to a get-the-id
> function. 

device_list is what first got me thinking down this path:  I keep running into 
customer problems that boil down to XXX linux distribution doesn't find all 
the LUNS on my array.  The obvious answer is "that's because it isn't in 
device_list".  Now, I could solve the problem by giving the customer a kernel 
patch adding the device, but this runs into problems with inexpert users, or 
enterprise customers who won't deviate from the "standard" kernel.  Being 
lazy, the solution I ultimately adopted was to send them an init script that 
recognised the array from it's inquiry strings and used scsi-add-single-device 
to probe its LUNs.

James


