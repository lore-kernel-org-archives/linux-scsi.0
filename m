From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 0/3] SCSI: eliminate scsi_end_request()
Date: Mon, 29 Sep 2008 17:10:37 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0809291703480.4420-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56798 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751477AbYI2VKi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Sep 2008 17:10:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

The following series of three patches simplifies scsi_io_completion() 
and eliminates scsi_end_request() -- its code is moved into 
scsi_io_completion() and streamlined.

The changes made here are based on an observation made by James, that
all the valid "retry" paths in scsi_io_completion() work by calling 
scsi_requeue_command().  The paths which call scsi_end_request() with 
the requeue argument set are all wrong; they should simply allow the 
request to fail.

When a request fails, whether or not it had to be broken up into
several low-level commands is immaterial.  If a request that isn't
broken up fails, the whole thing is over and done with.  So if an
intermediate command for a request that was broken up fails, it
likewise should cause the entire remaining part of the request to end.

Alan Stern

