From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [PATCH 00/11] First pass at merging Bart's HA work
Date: Sun, 25 Nov 2012 23:44:05 -0500
Message-ID: <cover.1353903448.git.dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Here is a first, UNTESTED, pass at preparing a merge of Bart's SRP HA
work to upstream. It is not complete, as I have not yet added the
transport layer error handling and related patches. It is also currently
missing the patch to maintain a single connection for an I_T nexus.

I swapped Ishai's code to recreate QP/CQs for each connection, as that
adds recovery from fatal hardware errors, and reduces the code needed to
avoid stale completions. Similarly, Vu's patch slightly reduces reconnect
times.

Target blocking/unblocking hasn't been added from Bart's patch that
removes the SRP_TARGET_CONNECTING state; I think it is probably the right
thing to do, but want to think it over a bit more.

Similarly, I'm looking for a clean way to start the reconnection effort
as soon as we get an error through the CQ -- we know that any pending
commands are lost to us at that point, so we should be able to kick them
back upstream quickly. This should allow multipath to reissue them on one
of the remaining good paths.

This series compiles, but is otherwise UNTESTED. I'll be working on that
over the next few days, with an eye on getting as much of Bart's work
into 3.8 as possible.

One may also pull this series from github:

	git pull git://github.com/dillow/srp-initiator.git ha-merge-v1


Bart Van Assche (7):
  IB/srp: enlarge block layer timeout
  IB/srp: keep processing commands during host removal
  IB/srp: Document sysfs attributes
  srp_transport: Fix attribute registration
  srp_transport: Simplify attribute initialization code
  srp_transport: Document sysfs attributes
  IB/srp: Allow SRP disconnect through sysfs

David Dillow (2):
  IB/srp: simplify state tracking
  IB/srp: don't send anything on a bad QP

Ishai Rabinovitz (1):
  IB/srp: destroy and recreate QP and CQs on each connection

Vu Pham (1):
  IB/srp: send disconnect request without waiting for CM timewait exit

 Documentation/ABI/stable/sysfs-driver-ib_srp |  156 +++++++++++++++
 Documentation/ABI/stable/sysfs-transport-srp |   19 ++
 drivers/infiniband/ulp/srp/ib_srp.c          |  274 +++++++++++++++-----------
 drivers/infiniband/ulp/srp/ib_srp.h          |   13 +-
 drivers/scsi/scsi_transport_srp.c            |   51 +++---
 include/scsi/scsi_transport_srp.h            |    8 +
 6 files changed, 378 insertions(+), 143 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-driver-ib_srp
 create mode 100644 Documentation/ABI/stable/sysfs-transport-srp

-- 
1.7.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
