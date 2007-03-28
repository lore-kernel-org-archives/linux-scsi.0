From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: [PATCH 0/2][resend] ibmvscsi: dynamic request_limit and device restart
Date: Wed, 28 Mar 2007 12:38:28 -0500
Message-ID: <20070328173828.GA22676@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49425 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965075AbXC1Rib (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Mar 2007 13:38:31 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2SHdGnR010141
	for <linux-scsi@vger.kernel.org>; Wed, 28 Mar 2007 13:39:16 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2SHcTdl263428
	for <linux-scsi@vger.kernel.org>; Wed, 28 Mar 2007 13:38:29 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2SHcToD023086
	for <linux-scsi@vger.kernel.org>; Wed, 28 Mar 2007 13:38:29 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>

James,

Resending these patches for inclusion in your tree.

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
