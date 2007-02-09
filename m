From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: [PATCH 0/2] ibmvscsi: dynamic request_limit and device restart
Date: Fri, 09 Feb 2007 11:49:49 -0600
Message-ID: <20070209174949.5080.69663.sendpatchset@toy>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:54374 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992456AbXBIRt4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Feb 2007 12:49:56 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l19HnrGM017687
	for <linux-scsi@vger.kernel.org>; Fri, 9 Feb 2007 12:49:53 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l19HnrnW381824
	for <linux-scsi@vger.kernel.org>; Fri, 9 Feb 2007 10:49:53 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l19HnnDH018565
	for <linux-scsi@vger.kernel.org>; Fri, 9 Feb 2007 10:49:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>

There are two fixes for the ibmvscsi client driver in this set.

- Dynamic request_limit
The request_limit for the driver was not properly reflecting the value on
the server side and could cause can_queue to be set to improper values (-1).
The patch corrects this so that request_limit mirrors the value
on the server and sets can_queue appropriately.

- Device restart
When a drive was removed from the server and then re-added the client
would not be able to use that device.  The device would return a unit
attention and then not ready.  By adding a slave_configure function we
can set the "allow_restart" flag for all disk devices.  Now devices will
resume functioning when they are re-added to the server.

---
