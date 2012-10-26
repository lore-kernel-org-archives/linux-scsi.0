From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 11/19] srp_transport: Fix attribute registration
Date: Fri, 26 Oct 2012 14:52:43 +0200
Message-ID: <508A879B.3010502@acm.org>
References: <508A85BB.1000505@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:48785 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694Ab2JZMwq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Oct 2012 08:52:46 -0400
In-Reply-To: <508A85BB.1000505@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Cc: David Dillow <dillowda@ornl.gov>, Roland Dreier <roland@purestorage.com>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Robert Jennings <rcj@linux.vnet.ibm.com>

Register transport attributes after the attribute array has been
set up instead of before. The current code can trigger a race
condition because the code reading the attribute array can run
on another thread than the code that initialized that array.
Make sure that any code reading the attribute array will see all
values written into that array.

Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: David Dillow <dillowda@ornl.gov>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_transport_srp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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
1.7.10.4

