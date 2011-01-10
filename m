From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [GIT] lock scaling and bug fixes for 2.6.38
Date: Mon, 10 Jan 2011 17:45:30 -0500
Message-ID: <1294699530.3038.27.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Roland,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/dad/srp-initiator.git srp-lock-scaling

to get the following commits. This is the series posted and reviewed on
the RDMA mailing list. I expect to have another pull request once you
sort out how you want to handle work queues in the IB stack so that we
can remove flush_scheduled_work() from the initiator.

Thanks!

Bart Van Assche (6):
  IB/srp: consolidate state change code
  IB/srp: allow lockless work posting
  IB/srp: don't move active requests to their own list
  IB/srp: reduce local coverage for command submission and EH
  IB/srp: reduce lock coverage of command completion
  IB/srp: stop sharing the host lock with SCSI

David Dillow (8):
  IB/srp: allow task management without a previous request
  IB/srp: consolidate hot-path variables into cache lines

 drivers/infiniband/ulp/srp/ib_srp.c |  392 ++++++++++++++++-------------------
 drivers/infiniband/ulp/srp/ib_srp.h |   46 +++--
 2 files changed, 206 insertions(+), 232 deletions(-)

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
