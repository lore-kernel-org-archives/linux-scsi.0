From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 0/5] v2: block subsystem refcounter conversions
Date: Thu, 20 Apr 2017 14:27:19 +0300
Message-ID: <1492687644-4405-1-git-send-email-elena.reshetova@intel.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, fujita.tomonori@lab.ntt.co.jp, mingo@redhat.com, clm@fb.com, jbacik@fb.com, dsterba@suse.com, Elena Reshetova <elena.reshetova@intel.com>
List-Id: linux-scsi@vger.kernel.org

changes in v2:
Not needed WARNs are removed since refcount_t warns by itself.
BUG_ONs are left as it is, since refcount_t doesn't bug by default.

This series, for block subsystem, replaces atomic_t reference
counters with the new refcount_t type and API (see include/linux/refcount.h).
By doing this we prevent intentional or accidental
underflows or overflows that can lead to use-after-free vulnerabilities.


Elena Reshetova (5):
  block: convert bio.__bi_cnt from atomic_t to refcount_t
  block: convert blk_queue_tag.refcnt from atomic_t to refcount_t
  block: convert blkcg_gq.refcnt from atomic_t to refcount_t
  block: convert io_context.active_ref from atomic_t to refcount_t
  block: convert bsg_device.ref_count from atomic_t to refcount_t

 block/bio.c                | 6 +++---
 block/blk-cgroup.c         | 2 +-
 block/blk-ioc.c            | 4 ++--
 block/blk-tag.c            | 8 ++++----
 block/bsg.c                | 9 +++++----
 block/cfq-iosched.c        | 4 ++--
 fs/btrfs/volumes.c         | 2 +-
 include/linux/bio.h        | 4 ++--
 include/linux/blk-cgroup.h | 9 ++++-----
 include/linux/blk_types.h  | 3 ++-
 include/linux/blkdev.h     | 3 ++-
 include/linux/iocontext.h  | 6 +++---
 12 files changed, 31 insertions(+), 29 deletions(-)

-- 
2.7.4
