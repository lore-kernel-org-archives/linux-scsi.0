From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] scsi_host sysfs updates scsi-misc-2.5 [0/2]
Date: Thu, 8 May 2003 23:33:21 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030509063321.GA3259@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:37615 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S262298AbTEIGSQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 May 2003 02:18:16 -0400
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.195.10])
	by e35.co.us.ibm.com (8.12.9/8.12.2) with ESMTP id h496UmuT238140
	for <linux-scsi@vger.kernel.org>; Fri, 9 May 2003 02:30:48 -0400
Received: from hmsbounty (sig-9-65-19-60.mts.ibm.com [9.65.19.60])
	by westrelay01.boulder.ibm.com (8.12.9/NCO/VER6.5) with ESMTP id h496UlKU100842
	for <linux-scsi@vger.kernel.org>; Fri, 9 May 2003 00:30:48 -0600
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This series of patches is an update to the scsi_host sysfs / ref
counting patches previously merged into the scsi-misc-2.5 tree. 

insmod / rmmod Testing:
	Legacy registration:
		aic7xxx_old, qlogicisp
		qla2xxx v8.00.00b1 - Driver oops system with garbled
		messages on rmmod. Does not seem related to this patch.

	New registration:
		scsi_debug 
		aic7xxx has an issue with holding lock while calling
		scsi_remove_host. I created a test patch to not hold the
		lock and the scsi mid layer illegal context messages
		stopped. Justin will need to address a real fix.

	I am booted on the ips driver, but have done no insmod / rmmod
	testing.

Attached is the current Reference Counting Rules and a small future
TODO cleanup list.

Post feedback I will work to roll this into the scsi documentation.

-andmike
--
Michael Anderson
andmike@us.ibm.com


<Referemnce Counting Rules>

1.) Reference counting for scsi_host
	scsi_register (scsi_alloc_host):
		(A) kmalloc Scsi_Host + xtr_bytes
		(B) Call device_initialize, class_device_initialize
			refcount is 1 on host_gendev.
			refcount is 1 on class_dev.
	scsi_get_host:
		(A) Call get_device on host_gendev
			refcount +1 on host_gendev
		(B) Call class_device_get on class_dev
			refcount +1 on class_dev
	scsi_host_put:
		(A) Call put_device on host_gendev
			refcount -1 on host_gendev
		(B) Call class_device_put on class_dev
			refcount -1 on class_dev
	scsi_add_host:
		(A) Call scsi_sysfs_add_host
			(1) Call device_add
				refcount +1 on parent struct device
				host_gendev now visible in sysfs tree.
			(2) Call class_device_add
				refcount +1 on scsi_host class
				refcount +1 on parent struct device
				class_dev now visible in sysfs tree
		(C) Call scsi_proc_host_add
			Scsi_Host now visible in proc.
		(D) Call scsi_scan_host
			refcount +1 on host_gendev for each scsi_device
			discovered
		(E) Call scsi_attach_device.

	scsi_remove_host:
		(A) "scsi_offline_host" see note above.
		(B) Call scsi_proc_host_rm
		(C) Call scsi_forget_host
			refcount -1 on host_gendev for each scsi_device
			unregistered
		(D) Call scsi_sysfs_remove_host
			(1) Call class_device_del
			(2) Call device_del

	scsi_unregister:
		(A) Call scsi_put_host

	scsi_host_release:
		(A) Call scsi_free_shost
			(1) Remove Scsi_Host from scsi_host_list list.
			(2) Kill error recovery thread.
			(3) Call scsi_destroy_command_freelist
			(4) kfree(shost)

	scsi_register_host:
		(A) Call template detect
			(1) Call scsi_register for each instance
		(B) Call scsi_add_host for each instance
	
	scsi_unregister_host:
		(A) Call scsi_remove_host, hostt->release for all
		Scsi_Host instances.

2.) Reference counting for scsi_device

	scsi_add_lun:
		(A) Call scsi_device_register
		refcount 1 on sdev_driverfs_dev
		refcount +1 on parent struct device (i.e host_gendev)

	scsi_add_device:
		(A) Call scsi_probe_and_add_lun

	scsi_remove_device:
		(A) Call scsi_detach_device
		(B) Call scsi_device_unregister
		refcount -1 on sdev_driverfs_dev
		refcount -1 on parent struct device (i.e host_gendev)

	scsi_device_get:
		(A) try_module_get
		(B) access_count +1

	scsi_device_put:
		(A) access_count -1
		(B) module_put on host module

TODO:
	- scsi_set_host_offline needs work on sync between LLDD and mid on
	  surprise remove.

	- Move upper level attaches to driver model so scsi_add_host does
	  not need to loop over my_devices. Post the cleanups that have
	  happen on the upper level driver we really close to matching the
	  model already this should be doable.  (Christoph has old patch
	  that needs refreshed to handle this)

	- Remove scsi_host_get_next.

	- Should move scsi_device device_register to (initialize, add)
	  pair. (Low priority)

	- Evaluate the need for scsi_host_list as this is duplicated in
	  the scsi_host class structure. (Low priority)
