From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 0/3] Badblock tracking for gendisks
Date: Fri, 20 Nov 2015 17:49:17 -0700
Message-ID: <1448066960-20119-1-git-send-email-vishal.l.verma@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:54887 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760788AbbKUAtg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2015 19:49:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Vishal Verma <vishal.l.verma@intel.com>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>, NeilBrown <neilb@suse.com>, Jeff Moyer <jmoyer@redhat.com>

Patch 1 copies badblock management code into a header of its own,
making it generally available. It follows common libraries of code
such as linked lists, where anyone may embed a core data structure
in another place, and use the provided accessor functions to
manipulate the data.

Patch 2 adds badblock tracking to gendisks (in preparation for use
by NVDIMM devices). Right now, it is turned on unconditionally - I'd
appreciate comments on if that is the right path.

Patch 3 converts md over to use the new badblocks 'library'. I have
done some pretty simple testing on this - created a raid 1 device,
made sure the sysfs entries show up, and can be used to add and view
badblocks. A closer look by the md folks would be nice here.

Vishal Verma (3):
  badblocks: Add core badblock management code
  block: Add badblock management for gendisks
  md: convert to use the generic badblocks code

 block/genhd.c             |  64 ++++++
 drivers/md/md.c           | 495 ++------------------------------------------
 drivers/md/md.h           |  31 +--
 include/linux/badblocks.h | 512 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/genhd.h     |   6 +
 5 files changed, 603 insertions(+), 505 deletions(-)
 create mode 100644 include/linux/badblocks.h

-- 
2.5.0

