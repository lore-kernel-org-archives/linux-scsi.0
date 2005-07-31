From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Unplugging of SBP-2 devices still does not work
Date: Sun, 31 Jul 2005 20:48:05 +0200
Message-ID: <42ED1CE5.9080903@s5r6.in-berlin.de>
References: <42E29DF5.5090603@s5r6.in-berlin.de> <42E2A15A.2030609@s5r6.in-berlin.de> <20050726042640.GA17885@phunnypharm.org> <42EBF6A2.7040305@s5r6.in-berlin.de> <42EC0A1D.1090008@s5r6.in-berlin.de> <20050731173554.GA2970@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:16333 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S261890AbVGaSsb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Jul 2005 14:48:31 -0400
In-Reply-To: <20050731173554.GA2970@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
Cc: Patrick Mansfield <patmans@us.ibm.com>

Patrick Mansfield wrote:
> Do you have slab poisoning on (CONFIG_DEBUG_SLAB)?

No, not yet...

> I reported the following problem, it looks like nodemgr had a similar
> patch to change list_for_each_safe to device_for_each_child, but
> device_for_each_child is not "safe", see this thread:
> 
> http://marc.theaimsgroup.com/?t=111931541100002&r=1&w=2
> 
> With nothing more from Greg ...
> 
> I think DEBUG_SLAB will catch any use after frees there. I haven't tried
> to run with *out* DEBUG_SLAB or analyze what might happen, so don't know
> the symptoms for fibre channel removal (the call in
> scsi_sysfs.c:scsi_remove_target()).

The patch you mention changed nodemgr_remove_host_dev which is
called when a FireWire controller is removed AFAIU. But when a
FireWire device is unplugged or switched off, a different code
path is followed in nodemgr:

static void nodemgr_suspend_ne(struct node_entry *ne)
{
	struct class_device *cdev;
	struct unit_directory *ud;

	HPSB_DEBUG("Node suspended: ID:BUS[" NODE_BUS_FMT "]  GUID[%016Lx]",
		   NODE_BUS_ARGS(ne->host, ne->nodeid), (unsigned long long)ne->guid);

	ne->in_limbo = 1;
	device_create_file(&ne->device, &dev_attr_ne_in_limbo);

	down_write(&ne->device.bus->subsys.rwsem);
	list_for_each_entry(cdev, &nodemgr_ud_class.children, node) {
		ud = container_of(cdev, struct unit_directory, class_dev);

		if (ud->ne != ne)
			continue;

		if (ud->device.driver &&
		    (!ud->device.driver->suspend ||
		      ud->device.driver->suspend(&ud->device, PMSG_SUSPEND, 0)))
			device_release_driver(&ud->device);
	}
	up_write(&ne->device.bus->subsys.rwsem);
}

If I understand it correctly, the call of device_release_driver()
leads to sbp2_remove() which calls scsi_remove_device() which, in
case of RBC disks, seems to hang in sd_shutdown()/ sd_sync_cache()/
scsi_wait_req().

Since ne->device.bus->subsys.rwsem is down, all other FireWire
device additions or removals cannot be served until
device_release_driver() returned, even everything that happens
on a second FireWire adapter. (I have two FireWire adapters, and
the other knodemgrd_# never wakes up while the first knodemgrd_#
is locked up.)

May ieee1394's rwsem cause a deadlock in scsi's device removals?
It would surprise me.
-- 
Stefan Richter
-=====-=-=-= -=== =====
http://arcgraph.de/sr/
