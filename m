From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2 0/3] Badblock tracking for gendisks
Date: Mon,  7 Dec 2015 19:52:34 -0700
Message-ID: <1449543157-5905-1-git-send-email-vishal.l.verma@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Vishal Verma <vishal.l.verma@intel.com>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>, NeilBrown <neilb@suse.com>, Jeff Moyer <jmoyer@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

v3:
  - Add kernel-doc style comments to all exported functions in badblocks.c (James)
  - Make return values from badblocks functions consistent with themselves
    and the kernel style. Change the polarity of badblocks_set, and update
    all callers accordingly (James)
  - In gendisk, don't unconditionally allocate badblocks, export the initializer.
    This also allows the initializer to be a non-void return type, so that the
    badblocks user can act upon failures better (James)


v2:
  - In badblocks_free, make 'page' NULL (patch 1)
  - Move the core badblocks code to a new .c file (patch 1) (Jens)
  - Fix a sizeof usage in disk_alloc_badblocks (patch 2) (Dan)
  - Since disk_alloc_badblocks can fail, check disk->bb for NULL in the
    genhd wrappers (patch 2) (Jeff)
  - Update the md conversion to also ise the badblocks init and free
    functions (patch 3)
  - Remove the BB_* macros from md.h as they are now in badblocks.h (patch 3)

Patch 1 copies badblock management code into a header of its own,
making it generally available. It follows common libraries of code
such as linked lists, where anyone may embed a core data structure
in another place, and use the provided accessor functions to
manipulate the data.

Patch 2 adds badblock tracking to gendisks (in preparation for use
by NVDIMM devices).

Patch 3 converts md over to use the new badblocks 'library'. I have
done some pretty simple testing on this - created a raid 1 device,
made sure the sysfs entries show up, and can be used to add and view
badblocks. A closer look by the md folks would be nice here.

Vishal Verma (3):
  badblocks: Add core badblock management code
  block: Add badblock management for gendisks
  md: convert to use the generic badblocks code

 block/Makefile            |   2 +-
 block/badblocks.c         | 576 ++++++++++++++++++++++++++++++++++++++++++++++
 block/genhd.c             |  76 ++++++
 drivers/md/md.c           | 516 ++---------------------------------------
 drivers/md/md.h           |  40 +---
 include/linux/badblocks.h |  53 +++++
 include/linux/genhd.h     |   7 +
 7 files changed, 741 insertions(+), 529 deletions(-)
 create mode 100644 block/badblocks.c
 create mode 100644 include/linux/badblocks.h

-- 
2.5.0

