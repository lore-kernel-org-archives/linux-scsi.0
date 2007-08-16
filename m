From: Alan Stern <stern@rowland.harvard.edu>
Subject: Deadlock in SCSI core!
Date: Thu, 16 Aug 2007 15:21:43 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0708161511180.2557-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:48593 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753763AbXHPTVr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Aug 2007 15:21:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James and others:

One of the things scsi_host_dev_release() does is to call 
kthread_stop(shost->ehandler).  This is all well and good, and to be 
expected.

But...

What if a host is hotunplugged in the middle of error recovery, and the
error-handler thread holds the last reference?  Then when the
error-handler gives up and does its final put, it will end up waiting 
endlessly for itself to terminate.

I have managed to trigger this a couple of times now while testing 
other things.  Here's the relevant part of a stack trace:

scsi_eh_6     D 00000136     0  7975      2
       c87cfd88 00000096 17070554 00000136 00000000 00000008 cfdd8fec cfdd8a90 
       00000000 cfdd8a90 cfdd8bc4 c138ac00 00000000 c02ab06a c87cfda4 cfa33280 
       c013a35e c03d89ac c02a8818 00000046 c03d89ac c03d89ac c03d89ac c03d89a8 
Call Trace:
 [<c02a881d>] wait_for_completion+0x74/0xaa
 [<c0131b3e>] kthread_stop+0x6b/0x8b
 [<d09b8e6a>] scsi_host_dev_release+0x3e/0xa4 [scsi_mod]
 [<c02212ae>] device_release+0x3c/0x7e
 [<c01d2786>] kobject_cleanup+0x3c/0x4d
 [<c01d27a2>] kobject_release+0xb/0xd
 [<c01d33f1>] kref_put+0x79/0x88
 [<c01d2748>] kobject_put+0x14/0x16
 [<c0221400>] put_device+0x11/0x13
 [<d09be37f>] scsi_target_dev_release+0x19/0x1c [scsi_mod]
 [<c02212ae>] device_release+0x3c/0x7e
 [<c01d2786>] kobject_cleanup+0x3c/0x4d
 [<c01d27a2>] kobject_release+0xb/0xd
 [<c01d33f1>] kref_put+0x79/0x88
 [<c01d2748>] kobject_put+0x14/0x16
 [<c0221400>] put_device+0x11/0x13
 [<d09c11db>] scsi_device_dev_release_usercontext+0xfd/0x106 [scsi_mod]
 [<c012f052>] execute_in_process_context+0x19/0x3d
 [<d09c0305>] scsi_device_dev_release+0x13/0x15 [scsi_mod]
 [<c02212ae>] device_release+0x3c/0x7e
 [<c01d2786>] kobject_cleanup+0x3c/0x4d
 [<c01d27a2>] kobject_release+0xb/0xd
 [<c01d33f1>] kref_put+0x79/0x88
 [<c01d2748>] kobject_put+0x14/0x16
 [<c0221400>] put_device+0x11/0x13
 [<d09b80d1>] scsi_device_put+0x32/0x36 [scsi_mod]
 [<d09b8268>] __scsi_iterate_devices+0x57/0x60 [scsi_mod]
 [<d09bd2d3>] scsi_run_host_queues+0x1c/0x26 [scsi_mod]
 [<d09bc105>] scsi_error_handler+0x40d/0x46c [scsi_mod]
 [<c0131d9a>] kthread+0x3b/0x61
 [<c0104d53>] kernel_thread_helper+0x7/0x10
 =======================

What's the solution?

Alan Stern

