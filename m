From: Alan Stern <stern@rowland.harvard.edu>
Subject: [BUG] Yet another scsi_cmnd leak?
Date: Thu, 29 Sep 2005 16:02:25 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509291538520.6137-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:2027 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1030184AbVI2UC0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Sep 2005 16:02:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

This report is based on 2.6.14-rc2-git6.  The code in your scsi-misc-2.6 
git tree is somewhat different (and I don't know which is more current), 
but it still contains the same bug.


In scsi_prep_fn, a request can get deferred if scsi_init_io fails to 
allocate an sg table.  When this happens, the scsi_cmnd isn't released and 
the request is not marked DONTPREP.

Then when scsi_prep_fn is called again, the request may be killed for 
a number of reasons.  The code branches to the kill: label near the end of 
the routine, which returns BLKPREP_KILL.

Isn't it true that when this happens, the scsi_cmnd allocated during the
original prep will never be released?

It appears that scsi_prep_fn is undecided about whether or not the request
is allowed to have a scsi_cmnd already.  The jumps to kill: seem to assume
that it isn't, but the code for allocating a new scsi_cmnd tests for an
existing one first.

Alan Stern

