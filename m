From: Steven Dake <sdake@mvista.com>
Subject: Re: Physical disk removal does not create hotplug events
Date: Tue, 23 Mar 2004 15:29:40 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080080980.26056.39.camel@persist.az.mvista.com>
References: <2F75A5CCEF1E6A4C8CA2E75CF7F529E9022B1547@orsmsx409.jf.intel.com>
Reply-To: sdake@mvista.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rav-az.mvista.com ([65.200.49.157]:28912 "EHLO
	zipcode.az.mvista.com") by vger.kernel.org with ESMTP
	id S262881AbUCWW3s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Mar 2004 17:29:48 -0500
In-Reply-To: <2F75A5CCEF1E6A4C8CA2E75CF7F529E9022B1547@orsmsx409.jf.intel.com>
List-Id: linux-scsi@vger.kernel.org
To: "Sabharwal, Atul" <atul.sabharwal@intel.com>
Cc: linux-scsi@vger.kernel.org

Atul,

The problem you face is that the device is still "seen" by the operating
system in a "failed" state.

How should the operating system (scsi layer) know when you pull out a
disk, vs when the disk has failed?  This is the problem faced by the
current SCSI tree.

If removals are to work properly, the operating system (Linux) should
always be notified.

One possibility you might suggest is that the FibreChannel knows the
difference between when a device is removed (It doesn't participate in
the LIP), and when it is failed.  It might be simple for the driver to
notify the scsi layer to remove the device, because it has been
physically removed...

If you have tried to remove a SCSI disk while in use using the standard
interface, you will see the next problem of notification.  What about
all those references in the filesystems, VFS layers, RAID layers, and
LVM layers still attached to that FibreChannel disk?  Those layers have
to be notified of the removal as well so they can clean up their
references and remove the device.

There are bits and peices of this functionality floating around, but it
has not been accepted into the mainline kernel as of yet.  It is in some
vendor products, though.

For now, the safest bet is to remove the device using the standard
interfaces provided by the kernel.  Another option is to use vendor
kernels with these features, but then you deviate from kernel.org.

Good luck
-steve


On Tue, 2004-03-23 at 11:03, Sabharwal, Atul wrote:
> I have a Linux system running 2.6.3 kernel, udev v 22.  I have an array
> of Qlogic Disk array which shows up as a SCSI device to the kernel.
>  
> Now, when I do virtual insertion/deletion of devices, rules get called
> and Device entries get created/deleted.  ( using sysfs interface to
> delete or Scan new devices ).
>  
> Now, when I do physical insertion/deletions, the deletions do not work.
> The sysfs Sub-system still shows the device under /sys although the
> device has been physically Removed.
> 
> Is this is Qlogic driver problem or a SCSI sub-system problem ? In
> syslog,
> The LIP up/down events are detected. 
> 
> Thanks,
> 
> Atul
> 
> >-------------------------------------------------------------
> >P.S:  All opinions are my personal opinion(s) & responsibility and do
> >not represent the view of my employer ( Intel Corporation ).
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

