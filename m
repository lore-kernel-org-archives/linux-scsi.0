From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 0/6] Fix lifetime issues with devices and targets
Date: Fri, 29 May 2009 16:04:34 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0905291558250.2648-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:37084 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753784AbZE2UEc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2009 16:04:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, SCSI development list <linux-scsi@vger.kernel.org>

James:

This patch series addresses the problems we've been discussing during 
the past week.

The first patch is independent of the others.  It fixes the issue of 
making scsi_wait_scan wait until all sd probing is finished.

The next four are a bunch of cleanups of the existing device and target 
code.  I found quite a few bugs along the way.  One of those patches 
changes the meaning of starget->reap_ref, to make it count the number 
of underlying devices.

The last patch changes reap_ref again, to count only visible underlying 
devices.  The result is that scsi_target_reap() will remove a target 
from visibility whenever all its devices are invisible (unless someone 
has prevented it by temporarily increasing reap_ref).  The target will 
also be unlinked from the host, but it won't be deallocated until all 
the devices have been freed.

Alan Stern

