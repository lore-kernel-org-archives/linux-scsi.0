From: David Dillow <dillowda@ornl.gov>
Subject: [RFC 0/8] IB/srp: scaling and bug fixes for 2.6.38
Date: Thu, 23 Dec 2010 16:55:32 -0500
Message-ID: <1293141332-12318-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from amavis-outgoing1.knology.net ([24.214.64.230]:34230 "EHLO
	amavis-outgoing1.knology.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752116Ab0LWVzh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Dec 2010 16:55:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>

[ Sorry to break threading, I botched things when editing the cover
letter to add an attachment... ]

The first patch in this series fixes a longstanding issue where we crash if we
use sg_reset to perform a bus reset, but haven't sent enough commands to
initialize all of our request structures. The remaining patches break up Bart
Van Assche's lock scaling work, and add a few optimizations on top.

The scaling work looks to have paid off pretty well. All tests were conducted
over a QDR link between two Dell R410s with 2.6GHz Xeons. To push any possible
bottlenecks to the initiator, the test target was stripped down to not transfer
the requests data -- it simply response to the command as though it had.

For fio driving one LUN using the SG engine, refactoring the locking using
patches 2 through 6 give a 30% increase in command throughput from 16 to 64
threads, while allowing similar (within the noise) or slight improvements for 1
to 8 threads and 128 threads and above. Unsharing the lock (patch 7) with the
SCSI mid-layer hurts a bit for the single thread case (~2%) but gives an
additional 1 to 6% with more than one thread. Cache optimization (patch 8)
returns the single thread case back to par, and gives a modest increase as
threads increase.

For fio driving mulitple LUNs using the AIO engine, patches 2 through 6 give
slightly smaller increases at low thread counts with a single drive (20% over
baseline), but the improvement increases as drives are added and/or iodepth
increases, reaching 50% in many cases. The removing the shared lock typically
brings 5-10% improvement over the lock reduction work, and optimizing the cache
usage also gives a modest improvement, though more than in the SG case.

There is more investigation to be done -- for example, AIO peaked at 296k IOPs
from a single drive at an iodepth of 32 and a thread count of 32. SG peaked at
183k IOPS at 64 threads (iodepth was 1, but I did not try a survey for this
engine). I have some completion batching and blk-iopoll conversion patches as
well, but they have some interesting performance anomolies at the moment that
prevent them being a win.

I'd appreciate people's review and comments, as while the patches have over 10
billion commands on them from the performance testing and real hardware, they
involve locking and race conditions, which have a habit of not showing up until
the most inopportune time.

Once 2.6.37 is out, I'll add sign offs and push these to my repo for 2.6.38.



David Dillow (8):
  IB/srp: allow task management without a previous request
  IB/srp: consolidate state change code
  IB/srp: allow lockless work posting
  IB/srp: don't move active requests to their own list
  IB/srp: reduce local coverage for command submission and EH
  IB/srp: reduce lock coverage of command completion
  IB/srp: stop sharing the host lock with SCSI
  IB/srp: consolidate hot-path variables into cache lines

 drivers/infiniband/ulp/srp/ib_srp.c |  390 ++++++++++++++++-------------------
 drivers/infiniband/ulp/srp/ib_srp.h |   46 +++--
 2 files changed, 204 insertions(+), 232 deletions(-)

-- 
1.7.2.3
