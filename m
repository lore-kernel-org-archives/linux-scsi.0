From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH 0/2] block: rq_affinity performance fixes
Date: Fri, 22 Jul 2011 13:59:33 -0700
Message-ID: <20110722205736.17420.41366.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jaxboe@fusionio.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jens,

Per the "rq_affinity doesn't seem to work?" thread [1].  We found that the
default cpu steering that rq_affinity performs is insufficient to keep up with
some completion loads.

Dave collected the following relative iops measures:
pre-patches  rq_affinity=0: 1x
pre-patches  rq_affinity=1: 1x
post-patches rq_affinity=1: 1.08x
post-patches rq_affinity=2: 1.35x

The "adaptive rq_affinity" patch is more of a discussion point than a
real fix.  However, it shows that even something straightforward and
seemingly aggressive does not really come close to the performance of
just turning cpu grouping off altogether.  The "strict rq_affinity"
patch follows the "nomerges" interface precedent of setting 2 to
indicate "I really mean it".

So, at a minimum consider taking patch 1, and we can leave the search
for a better adaptive algorithm as future work.

[1]: http://marc.info/?l=linux-kernel&m=131049742925413&w=4

---

Dan Williams (2):
      block: strict rq_affinity
      block: adaptive rq_affinity

 Documentation/block/queue-sysfs.txt |   10 +++++++---
 block/blk-core.c                    |    6 ++----
 block/blk-softirq.c                 |   23 ++++++++++++++++++-----
 block/blk-sysfs.c                   |   13 +++++++++----
 include/linux/blkdev.h              |    3 ++-
 5 files changed, 38 insertions(+), 17 deletions(-)
