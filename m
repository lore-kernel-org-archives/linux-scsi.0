From: Patrick Mansfield <patmans@us.ibm.com>
Subject: scsi command slab allocation under memory pressure
Date: Wed, 29 Jan 2003 10:47:31 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030129104731.A2811@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from patman@localhost)
	by w-patman.des (8.11.2/8.11.2) id h0TIlVj02827
	for linux-scsi@vger.kernel.org; Wed, 29 Jan 2003 10:47:31 -0800
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

James had a similiar comment about this (free_list storing multiple
commands).

The linux-scsi.bkbits.net scsi-kmem_alloc-2.5 and scsi-combined-2.5 tree
include the scsi command slab allocation (Luben's patch).

How does the use of a single slab for all hosts and all devices allow for
IO while under memory pressure?

There is one extra scsi command pre-allocated per host, but don't we
require at least one (and ideally maybe more) per device? The pre-slab
(current mainline kernel) command allocation always had at least one
command per device available, and usually more (because we allocated more
commands during the scan and upper level init).

That is - if we have swap on a separate disk and our command pool is small
enough, IO to another disk could use the single per-host command under
memory pressure, and we can fail to get a scsi command in order to write
to the swap disk. 

scsi_put_command() re-fills the host->free_list if it is empty, but under
high (or higher) IO loads, the disk/device that generated the
scsi_put_command will immediately issue a scsi_get_command for the same
device.

If all command allocations are failing for a particular device (i.e.
swap), we will wait a bit (device_blocked and device_busy == 0) and try
again, we will not retry based on a scsi_put_command(). Even if we did
retry based on a scsi_put_command, we will can race with the
scsi_put_command caller.

-- Patrick Mansfield
