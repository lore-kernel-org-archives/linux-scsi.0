From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] make the SCSI mid-layer obey the device online flag
Date: Mon, 9 Jun 2003 17:00:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030610000043.GA2240@beaverton.ibm.com>
References: <1054742495.1674.18.camel@mulgrave> <20030604165146.GA1426@beaverton.ibm.com> <1054754103.2360.8.camel@mulgrave> <20030606073603.A13259@infradead.org> <3EE0B316.4060207@rogers.com> <20030606202350.GC3330@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:19907 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S262298AbTFIXpT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jun 2003 19:45:19 -0400
Content-Disposition: inline
In-Reply-To: <20030606202350.GC3330@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <tluben@rogers.com>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

Mike Anderson [andmike@us.ibm.com] wrote:
> I am currently updating my previously posted SCSI Mid refcounting text
> to match recent updates by Christoph. I am also adding current bit fields
> in scsi_device and Scsi_Host used for state.
> 

I update the previously posted refcounting document. I added scsi_host
and scsi_device bitfields "related" to state. I added some thoughts
on host and device states (really status bits as there is no indication
of valid state transitions in this document). 

-andmike
--
Michael Anderson
andmike@us.ibm.com

<ref counting rules>

1.) Reference counting for scsi_host
	Private = Private to SCSI mid
	Public = SCSI mid API

	(Public) scsi_host_alloc:
		(A) kmalloc Scsi_Host + xtr_bytes.
		(B) Call device_initialize, class_device_initialize
			refcount is 1 on host_gendev.
			refcount is 1 on class_dev.
	(Public) scsi_register:
		(A) Call scsi_host_alloc
		(B) Add Scsi_Host to legacy_hosts.

	(Public) scsi_get_host:
		(A) Call get_device on host_gendev
			refcount +1 on host_gendev
		(B) Call class_device_get on class_dev
			refcount +1 on class_dev
	(Public) scsi_host_put:
		(A) Call put_device on host_gendev
			refcount -1 on host_gendev
		(B) Call class_device_put on class_dev
			refcount -1 on class_dev
	(Public) scsi_add_host:
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

	(Public) scsi_remove_host:
		(A) "scsi_offline_host" NOT implemented.
		(B) Call scsi_proc_host_rm
		(C) Call scsi_forget_host
			refcount -1 on host_gendev for each scsi_device
			unregistered
		(D) Call scsi_sysfs_remove_host
			(1) Call class_device_del
			(2) Call device_del

	(Public) scsi_unregister:
		(A) Call scsi_put_host

	(Private) scsi_free_shost:
		(A) Kill error recovery thread.
		(B) Call scsi_destroy_command_freelist
		(C) kfree(shost)

	(Private) scsi_host_release:
		(A) Call scsi_free_shost

	(Private) init_this_scsi_driver: (Legacy only)
		(A) Call template detect
			(1) Call scsi_register for each instance
		(B) Call scsi_add_host for each instance
	
	(Private) exit_this_scsi_driver: (Legacy only)
		(A) Call scsi_remove_host for each instance
		(B) Call template release for each instance
			(1) Call scsi_unregister for Scsi_Host

2.) Reference counting for scsi_device

	(Private) scsi_add_lun:
		(A) Call scsi_device_register
		refcount 1 on sdev_driverfs_dev
		refcount +1 on parent struct device (i.e host_gendev)

	(Public) scsi_add_device:
		(A) Call scsi_probe_and_add_lun

	(Public) scsi_remove_device:
		(C) Call scsi_device_unregister
		refcount -1 on sdev_driverfs_dev
		refcount -1 on parent struct device (i.e host_gendev)

	(Public) scsi_device_get:
		(A) try_module_get
		(B) access_count +1

	(Public) scsi_device_put:
		(A) access_count -1
		(B) module_put on host module

</ref counting rules>

<device and host states>

3.) struct scsi_device states

	(A) Bitfields
		- online (device responding / connected. Currently
		  overloaded)
		- access_count (Number of openers, ?other get/put callers?)

		- device_busy (if non-zero IO in-flight)
		- device_blocked (no processing)

		- locked (SCSI_REMOVAL_PREVENT active)
		- changed (possible media change)

		- was_reset (device reset or bus reset)
		- expecting_cc_ua (redundant was_reset bit field)

	(B) States (?? Needs review ??)
		(1) Init
		(2) Ready (PQ of 000b, TUR Good)
		(3) Not_Ready (sense key not ready)
		(4) Lun_Not_Connected (PQ of 001b)
		(5) No_Response (DID_NO_CONNECT) (Surprise removal here?)

		(6) Blocked (QUEUE_FULL or BUSY status)
		(7) Timed_Out (A command timed out on this lun)
		(8) Shutdown (Device going away)

4.) struct Scsi_Host states

	(A) Bitfields
		- host_blocked (no processing)
		- host_self_blocked ( "host requested no processing")
		- host_busy (if non-zero IO in-flight)

		- host_failed (if non-zero IO failure(s))
		- in_recovery (error recovery scheduled or running)

		- resetting (delay calling queuecommand due to reset)
		- last_reset (used in conjunction with resetting).

	(B) States (?? Needs review ??)
		(1) Init
		(2) Ready (registered)
		(3) In_Recovery (error recovery thread scheduled to run)
		(4) Blocked (queuecommand returned non-zero)
		(4) Shutdown (Host going away)

