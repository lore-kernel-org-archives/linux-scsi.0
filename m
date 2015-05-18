From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 02/12] scsi_transport_srp: Fix a race condition
Date: Mon, 18 May 2015 13:22:44 +0200
Message-ID: <5559CB84.7020506@sandisk.com>
References: <5559CB3A.6060102@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5559CB3A.6060102-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <jbottomley-wo1vFcy6AUs@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Avoid that srp_terminate_io() can get invoked while srp_queuecommand()
is in progress. This patch avoids that an I/O timeout can trigger the
following kernel warning:

WARNING: at drivers/infiniband/ulp/srp/ib_srp.c:1447 srp_terminate_io+0xef/0x100 [ib_srp]()
Call Trace:
 [<ffffffff814c65a2>] dump_stack+0x4e/0x68
 [<ffffffff81051f71>] warn_slowpath_common+0x81/0xa0
 [<ffffffff8105204a>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa075f51f>] srp_terminate_io+0xef/0x100 [ib_srp]
 [<ffffffffa07495da>] __rport_fail_io_fast+0xba/0xc0 [scsi_transport_srp]
 [<ffffffffa0749a90>] rport_fast_io_fail_timedout+0xe0/0xf0 [scsi_transport_srp]
 [<ffffffff8106e09b>] process_one_work+0x1db/0x780
 [<ffffffff8106e75b>] worker_thread+0x11b/0x450
 [<ffffffff81073c64>] kthread+0xe4/0x100
 [<ffffffff814cf26c>] ret_from_fork+0x7c/0xb0

See also patch "scsi_transport_srp: Add transport layer error
handling" (commit ID 29c17324803c).

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: James Bottomley <JBottomley-O3H1v1f1dlM@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> #v3.13
---
 drivers/scsi/scsi_transport_srp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index e05cd7e..f115f67 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -439,8 +439,10 @@ static void __rport_fail_io_fast(struct srp_rport *rport)
 
 	/* Involve the LLD if possible to terminate all I/O on the rport. */
 	i = to_srp_internal(shost->transportt);
-	if (i->f->terminate_rport_io)
+	if (i->f->terminate_rport_io) {
+		srp_wait_for_queuecommand(shost);
 		i->f->terminate_rport_io(rport);
+	}
 }
 
 /**
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
