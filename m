From: dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Subject: [PATCH 0/5] Fix bugs in ib_srp patches for H.A. purposes
Date: Fri, 31 Aug 2012 22:00:36 +0200
Message-ID: <1346443241-24844-1-git-send-email-dongsu.park@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bvanassche-HInyCGIudOg@public.gmane.org
Cc: dillowda-1Heg1YXhbW8@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>

Hi Bart,

This patchset aims at fixing bugs that have been discovered in our own
SRP test environment so far. These patches are based on your patchset v4,
"Make ib_srp better suited for H.A. purposes",(09 Aug 2012).

The 5th patch, "fix an error accessing invalid memory in
rport_dev_loss_timedout" is including your suggestion (30 Aug 2012).

You can also pull the following git repo to get the patches.

  git://github.com/advance38/linux.git srp-ha

Our test setup consists of two systems.
Kernel 3.2.15 with SCST v4193 on the target,
and Kernel 3.2.8 with ib_srp-ha on the initiator.
Although I rebased the patches again onto 3.6-rc3,
I suppose there will be no significant differences.

All of the known critical issues seem to have been resolved
according to our internal tests in the last weeks.

Thanks,

Dongsu Park (3):
  ib_srp: free memory correctly in srp_free_iu()
  ib_srp: hold a mutex when adding a new target port
  ib_srp: check if rport->lld_data is NULL before removing rport

Sebastian Riemer (1):
  ib_srp: removed superfluous warning in send timeout case

Bart Van Assche (1):
  ib_srp: fix an error accessing invalid memory in
    rport_dev_loss_timedout

 drivers/infiniband/ulp/srp/ib_srp.c | 23 +++++++++++++++++++----
 drivers/scsi/scsi_transport_srp.c   | 11 ++++++++++-
 2 files changed, 29 insertions(+), 5 deletions(-)

-- 
1.7.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
