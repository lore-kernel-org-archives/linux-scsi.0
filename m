From: Alan Stern <stern@rowland.harvard.edu>
Subject: SCSI BLIST_*, sdev_bflags, and scsi_device flags
Date: Thu, 9 Feb 2006 14:55:15 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0602091438550.5532-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:35799 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1750748AbWBITzU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Feb 2006 14:55:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

A fair number of SCSI BLIST bits have duplicate entries in the scsi_device 
structure (in one instance the meaning is inverted):

BLIST_BORKEN			borken
BLIST_SINGLELUN			single_lun
BLIST_USE_10_BYTE_MS		use_10_for_ms
BLIST_MS_SKIP_PAGE_08		skip_ms_page_8
BLIST_MS_SKIP_PAGE_3F		skip_ms_page_3f
BLIST_MS_192_BYTES_FOR_3F	use_192_bytes_for_3f
BLIST_RETRY_HWERROR		retry_hwerror
BLIST_NOT_LOCKABLE		lockable
BLIST_NOSTARTONADD		no_start_on_add

There's no good reason for this duplication.  It's largely historical; at 
the time the device flags were added there was no way to alter the bflags 
value.  Now there is, since sdev_bflags is stored in the scsi_device.

Should we keep this duplication?  Should we remove the device bits and use
the sdev_bflags bitmasks instead?  I presume we don't want to remove the
BLIST entries because they are visible to userspace.  (Although probably
some of them are not used anywhere at all.)

What about things like BLIST_REPORTLUN2 and BLIST_NOREPORTLUN?  They don't
mean anything for scsi_devices, only for scsi_targets.  Nevertheless they
are part of the same BLIST entries.  Again, I don't see any way around
that without affecting userspace.

Alan Stern

