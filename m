From: Alan Stern <stern@rowland.harvard.edu>
Subject: Bug in SCSI async probing
Date: Tue, 26 May 2009 11:22:36 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0905261040230.5554-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:51608 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754947AbZEZPWg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2009 11:22:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Arjan van de Ven <arjan@linux.intel.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>

James & Arjan:

Am I missing something here?  It looks like

	fastboot: make scsi probes asynchronous

has introduced a bug in the sd probing code.  AFAICT, there is now
nothing to prevent do_scan_async() from returning before
sd_probe_async() has run.

Doesn't this mean that there's nothing to prevent sd_remove() from 
being called and trying to unregister the disk _before_ 
sd_probe_async() has managed to register it?

Alan Stern

