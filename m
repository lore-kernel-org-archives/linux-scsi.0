From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 0/5] block subsystem refcounter conversions
Date: Mon, 20 Feb 2017 13:16:03 +0200
Message-ID: <1487589368-17666-1-git-send-email-elena.reshetova@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, axboe@kernel.dk, fujita.tomonori@lab.ntt.co.jp, mingo@redhat.com, clm@fb.com, jbacik@fb.com, dsterba@suse.com, Elena Reshetova <elena.reshetova@intel.com>
List-Id: linux-scsi@vger.kernel.org

Now when new refcount_t type and API are finally merged
(see include/linux/refcount.h), the following
patches convert various refcounters in the block susystem from atomic_t
to refcount_t. By doing this we prevent intentional or accidental
underflows or overflows that can led to use-after-free vulnerabilities.

The below patches are fully independent and can be cherry-picked separately.
Since we convert all kernel subsystems in the same fashion, resulting
in about 300 patches, we have to group them for sending at least in some
fashion to be manageable. Please excuse the long cc list.

Elena Reshetova (5):
  block: convert bio.__bi_cnt from atomic_t to refcount_t
  block: convert blk_queue_tag.refcnt from atomic_t to refcount_t
  block: convert blkcg_gq.refcnt from atomic_t to refcount_t
  block: convert io_context.active_ref from atomic_t to refcount_t
  block: convert bsg_device.ref_count from atomic_t to refcount_t

 block/bio.c                |  6 +++---
 block/blk-cgroup.c         |  2 +-
 block/blk-ioc.c            |  4 ++--
 block/blk-tag.c            |  8 ++++----
 block/bsg.c                |  9 +++++----
 block/cfq-iosched.c        |  4 ++--
 fs/btrfs/volumes.c         |  2 +-
 include/linux/bio.h        |  4 ++--
 include/linux/blk-cgroup.h | 11 ++++++-----
 include/linux/blk_types.h  |  3 ++-
 include/linux/blkdev.h     |  3 ++-
 include/linux/iocontext.h  |  7 ++++---
 12 files changed, 34 insertions(+), 29 deletions(-)

-- 
2.7.4
