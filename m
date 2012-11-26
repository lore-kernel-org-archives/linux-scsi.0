From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [PATCH 08/11] srp_transport: Fix attribute registration
Date: Sun, 25 Nov 2012 23:44:13 -0500
Message-ID: <dbcc2ab781fc513e8a880d028053020665765fd3.1353903448.git.dillowda@ornl.gov>
References: <cover.1353903448.git.dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1353903448.git.dillowda-1Heg1YXhbW8@public.gmane.org>
In-Reply-To: <cover.1353903448.git.dillowda-1Heg1YXhbW8@public.gmane.org>
References: <cover.1353903448.git.dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Robert Jennings <rcj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>

Register transport attributes after the attribute array has been
set up instead of before. The current code can trigger a race
condition because the code reading the attribute array can run
on another thread than the code that initialized that array.
Make sure that any code reading the attribute array will see all
values written into that array.

Cc: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Robert Jennings <rcj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Signed-off-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
---
 drivers/scsi/scsi_transport_srp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 21a045e..07c4394 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -324,13 +324,14 @@ srp_attach_transport(struct srp_function_template *ft)
 	i->rport_attr_cont.ac.attrs = &i->rport_attrs[0];
 	i->rport_attr_cont.ac.class = &srp_rport_class.class;
 	i->rport_attr_cont.ac.match = srp_rport_match;
-	transport_container_register(&i->rport_attr_cont);
 
 	count = 0;
 	SETUP_RPORT_ATTRIBUTE_RD(port_id);
 	SETUP_RPORT_ATTRIBUTE_RD(roles);
 	i->rport_attrs[count] = NULL;
 
+	transport_container_register(&i->rport_attr_cont);
+
 	i->f = ft;
 
 	return &i->t;
-- 
1.7.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
