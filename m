From: dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Subject: [PATCH 5/5] ib_srp: fix an error accessing invalid memory in rport_dev_loss_timedout
Date: Fri, 31 Aug 2012 22:00:41 +0200
Message-ID: <1346443241-24844-6-git-send-email-dongsu.park@profitbricks.com>
References: <1346443241-24844-1-git-send-email-dongsu.park@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346443241-24844-1-git-send-email-dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bvanassche-HInyCGIudOg@public.gmane.org
Cc: dillowda-1Heg1YXhbW8@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>

In rport_dev_loss_timedout(), rport must be obtained by accessing
the member entry dev_loss_work, not fast_io_fail_work.

Signed-off-By: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 drivers/scsi/scsi_transport_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 915b355..d796413 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -242,7 +242,7 @@ static void rport_fast_io_fail_timedout(struct work_struct *work)
 {
 	struct srp_rport *rport =
 		container_of(to_delayed_work(work), struct srp_rport,
-			     fast_io_fail_work);
+			     dev_loss_work);
 	struct Scsi_Host *shost;
 	struct srp_internal *i;
 
-- 
1.7.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
