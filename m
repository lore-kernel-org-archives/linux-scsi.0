From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 0/2] SCSI: fix bug in scsi_dev_info_list lookup
Date: Mon, 3 Aug 2015 11:57:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1508031134160.1667-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:43512 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753460AbbHCP5O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2015 11:57:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Giulio Bernardi <ugilio@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>

James:

Giulio Bernardi recently reported a problem (the second Logical Unit of
his SATA-USB docking station was not being detected) which we traced
down to a bug in the matching code in scsi_devinfo.c.  The entire
search algorithm (including the bug) is present in two separate 
routines of that source file.

The first patch in the following sequence refactors the matching code 
by moving it into its own subroutine, where the others can call it.

The second patch fixes the matching code's bug.  Namely, the code
thinks it has found a match if either the device's vendor string (with
leading blanks removed) or the device list entry's vendor string is a
substring of the other, and likewise for the product strings.  For
example, a device string of "VENDOR12" would match against a list
entry's string of "VENDOR", which obviously is not what we want.

Alan Stern

