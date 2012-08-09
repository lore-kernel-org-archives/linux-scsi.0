From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 13/20] srp_transport: Fix atttribute registration
Date: Thu, 09 Aug 2012 15:56:02 +0000
Message-ID: <5023DD92.3080407@acm.org>
References: <5023DA39.7020000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5023DA39.7020000-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Jennings <rcj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Register transport attributes after the attribute array has been
set up instead of before. The current code can trigger a race
condition because the code reading the attribute array can run
on another thread than the code that initialized that array.
Make sure that any code reading the attribute array will see all
values written into that array.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Robert Jennings <rcj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
1.7.7


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
