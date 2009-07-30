From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Linux enclosure services, hot swap issues
Date: Thu, 30 Jul 2009 20:05:08 +0000
Message-ID: <1248984308.3880.271.camel@mulgrave.site>
References: <4A71F4DF.1060600@arrisi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47749 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752666AbZG3UFV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jul 2009 16:05:21 -0400
In-Reply-To: <4A71F4DF.1060600@arrisi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Ptacek <chris.ptacek@arrisi.com>
Cc: dave.romrell@arrisi.com, Michael Galassi <michael.galassi@arrisi.com>, linux-scsi <linux-scsi@vger.kernel.org>

cc to linux-scsi added

On Thu, 2009-07-30 at 12:30 -0700, Chris Ptacek wrote:
> Hello,
> We are attempting to use the enclosure services (ses.c and enclosure.c) 
> with Xyratex shelves (note we may have the same/similar issues with the 
> IBM enclosure shelves) and have been running tests performing hot 
> swapping of drives and seeing issues.  There appear to be two similar 
> issues.
> 
> 1. When we pull a drive the drive information in the enclosure (slot, 
> device link, etc) is not cleaned up and released.  It appears that 
> ses_intf_remove() is being called however as the device is not an 
> enclosure it just returns and does nothing.  This leaves a stale device 
> link and other information within the sysfs information for that 
> enclosure slot.
> 
> 2. When we re-add a drive to the system the drive gets assigned a new 
> port and number.  At the moment we are unsure if this may be caused by 
> refcounts on the old drive never being fully decremented.  However as 
> the drive has a new port name the stale link in the sysfs enclosure slot 
> is no longer pointing to the drive. 
> It also appears that when adding the drive the ses_intf_add() function 
> checks to see if the device is in an enclosure by examining the parent.  
> However this appears to always fail.  On boot when the actual enclosure 
> is added it manages to walk all the drives and add them, however on some 
> systems it appears that the boot ordering may cause only some subset of 
> drives to appear.
> 
> Before issue, the device in slot 15 of enclosure looks as follows
> /sys/block/sde/device/enclosure_device:15/device ->
> ../../../../devices/pci0000:00/0000:00:06.0/0000:07:00.0/host2/port-2:0/expander-2:0/port-2:0:2/end_device-2:0:2/target2:0:2/2:0:2:0
> 
> NOTE: under the expander-2:0 it shows as "port-2:0:2"
> If we look at this directory it shows following...
> 
> -bash-3.2# ls 
> /sys/devices/pci0000:00/0000:00:06.0/0000:07:00.0/host2/port-2:0/expander-2:0/
> phy-2:0:10 phy-2:0:16 phy-2:0:22 phy-2:0:28 phy-2:0:34 phy-2:0:40 
> phy-2:0:9 port-2:0:13 port-2:0:19 port-2:0:24 port-2:0:7 uevent
> phy-2:0:11 phy-2:0:17 phy-2:0:23 phy-2:0:29 phy-2:0:35 phy-2:0:41 
> port-2:0:0 port-2:0:14 port-2:0:2 port-2:0:25 port-2:0:8
> phy-2:0:12 phy-2:0:18 phy-2:0:24 phy-2:0:30 phy-2:0:36 phy-2:0:42 
> port-2:0:1 port-2:0:15 port-2:0:20 port-2:0:3 port-2:0:9
> phy-2:0:13 phy-2:0:19 phy-2:0:25 phy-2:0:31 phy-2:0:37 phy-2:0:43 
> port-2:0:10 port-2:0:16 port-2:0:21 port-2:0:4 power
> phy-2:0:14 phy-2:0:20 phy-2:0:26 phy-2:0:32 phy-2:0:38 phy-2:0:44 
> port-2:0:11 port-2:0:17 port-2:0:22 port-2:0:5 sas_device:expander-2:0
> phy-2:0:15 phy-2:0:21 phy-2:0:27 phy-2:0:33 phy-2:0:39 phy-2:0:8 
> port-2:0:12 port-2:0:18 port-2:0:23 port-2:0:6 sas_expander:expander-2:0
> 
> === REMOVE AND INSERT DRIVE =====
> 
> However, if we then remove the drive and insert it again the above 
> relationship breaks down. The link that we follow above is stale and 
> still points at "port-2:0:2".
> /sys/block/sde/device/enclosure_device:15/device ->
> ../../../../devices/pci0000:00/0000:00:06.0/0000:07:00.0/host2/port-2:0/expander-2:0/port-2:0:2/end_device-2:0:2/target2:0:2/2:0:2:0
> 
> Yet, if we look at that expander directory we find that this port no 
> longer exists and a new one was added now as "port-2:0:26".
> 
> -bash-3.2# ls 
> /sys/devices/pci0000\:00/0000:00:06.0/0000:07:00.0/host2/port-2:0/expander-2:0/
> phy-2:0:10 phy-2:0:16 phy-2:0:22 phy-2:0:28 phy-2:0:34 phy-2:0:40 
> phy-2:0:9 port-2:0:13 port-2:0:19 port-2:0:25 port-2:0:7 uevent
> phy-2:0:11 phy-2:0:17 phy-2:0:23 phy-2:0:29 phy-2:0:35 phy-2:0:41 
> port-2:0:0 port-2:0:14 port-2:0:20 port-2:0:26 port-2:0:8
> phy-2:0:12 phy-2:0:18 phy-2:0:24 phy-2:0:30 phy-2:0:36 phy-2:0:42 
> port-2:0:1 port-2:0:15 port-2:0:21 port-2:0:3 port-2:0:9
> phy-2:0:13 phy-2:0:19 phy-2:0:25 phy-2:0:31 phy-2:0:37 phy-2:0:43 
> port-2:0:10 port-2:0:16 port-2:0:22 port-2:0:4 power
> phy-2:0:14 phy-2:0:20 phy-2:0:26 phy-2:0:32 phy-2:0:38 phy-2:0:44 
> port-2:0:11 port-2:0:17 port-2:0:23 port-2:0:5 sas_device:expander-2:0
> phy-2:0:15 phy-2:0:21 phy-2:0:27 phy-2:0:33 phy-2:0:39 phy-2:0:8 
> port-2:0:12 port-2:0:18 port-2:0:24 port-2:0:6 sas_expander:expander-2:0
> 
> 
> When adding the drive we are printing out the names and the parents. 
> 
> Jul 30 11:29:53 sweng72 kernel: sd 2:0:51:0: [sdad] 976773168 512-byte 
> hardware sectors: (500 GB/465 GiB)
> Jul 30 11:29:53 sweng72 kernel: sd 2:0:51:0: [sdad] Write Protect is off
> Jul 30 11:29:53 sweng72 kernel: sd 2:0:51:0: [sdad] Write cache: 
> disabled, read cache: enabled, supports DPO and FUA
> Jul 30 11:29:53 sweng72 kernel: sd 2:0:51:0: Attached scsi generic sg33 
> type 0
> ## In ses_intf_add we are printing the name of the device passed in:
> ##  printk("%s : %s\n", __func__, dev_name(cdev));
> Jul 30 11:29:53 sweng72 kernel: ses_intf_add : 2:0:51:0
> Jul 30 11:29:53 sweng72 kernel: device: 'sdad': device_add
> ## In enclosure_add we are printing the name of the host passed in and 
> the parentage:
> ##   printk("%s : %s (%p)\n", __func__, dev_name(dev), dev);
> ## Then per enclosure
> ##   printk("%s : edev %s parent %s \n", __func__, 
> dev_name(&edev->edev), dev_name(edev->edev.parent));
> ##   pdev = edev->edev.parent;
> ##   while(pdev != NULL)
> ##   {
> ##        printk("%s :         parent %s (%p)\n", __func__, 
> dev_name(pdev), pdev);
> ##        pdev = pdev->parent;
> ##    }
> Jul 30 11:29:53 sweng72 kernel: enclosure_find : host2 (ffff8804cb804178)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find : edev 0:3:0:0 parent 0:3:0:0
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent 0:3:0:0 
> (ffff8804c9d63928)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent 
> target0:3:0 (ffff8804c9d62828)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent host0 
> (ffff8804ca3d6978)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent 
> 0000:04:00.0 (ffff8804cb867880)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent 
> 0000:00:03.0 (ffff8804cb802880)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent 
> pci0000:00 (ffff8804cb800e00)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find : edev 2:0:24:0 parent 
> 2:0:24:0
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent 2:0:24:0 
> (ffff8804c98f5128)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent 
> target2:0:24 (ffff8804c9916428)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent 
> end_device-2:0:25 (ffff8804c9914000)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent 
> port-2:0:25 (ffff8804c9914800)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent 
> expander-2:0 (ffff8804c9c0b838)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent port-2:0 
> (ffff8804c9c0d400)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent host2 
> (ffff8804cb804178)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent 
> 0000:07:00.0 (ffff8804cb86d880)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent 
> 0000:00:06.0 (ffff8804cb803080)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent 
> pci0000:00 (ffff8804cb800e00)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find : edev 2:0:49:0 parent 
> 2:0:49:0
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent 2:0:49:0 
> (ffff8804c9a85928)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent 
> target2:0:49 (ffff8804c9a82828)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent 
> end_device-2:1:25 (ffff8804c9a81400)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent 
> port-2:1:25 (ffff8804c9a81c00)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent 
> expander-2:1 (ffff8804c9d11838)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent port-2:1 
> (ffff8804ca1d3400)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent host2 
> (ffff8804cb804178)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent 
> 0000:07:00.0 (ffff8804cb86d880)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent 
> 0000:00:06.0 (ffff8804cb803080)
> Jul 30 11:29:54 sweng72 kernel: enclosure_find :         parent 
> pci0000:00 (ffff8804cb800e00)
> 
> Note these enclosures are double cabled, we have tried without it with 
> the same results. 
> If we examine the parentage of the enclosures the host2 entry is way 
> down the list, not the direct parent of the device passed in.  This 
> causes no enclosure to be found and no links, etc are handled for the 
> drive that was added.
> 
> We were wondering if you may have any input on these issues and their 
> expected operation?

The problems are basically because ses has no hotplug code (it doesn't
expect the configuration to change).  It shouldn't be too hard to add
via the SCSI interface function, though; I'll take a look.

James


