From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 09/18] srp_transport: Fix atttribute registration
Date: Sat, 14 Jan 2012 12:47:46 +0000
Message-ID: <1477501.CYGuWouoZM@asus>
References: <3109536.qySrY1Ts3e@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02ant.iops.be ([212.53.4.35]:50034 "EHLO
	relay02ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab2ANMrt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Jan 2012 07:47:49 -0500
In-Reply-To: <3109536.qySrY1Ts3e@asus>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>, David Dillow <dillowda@ornl.gov>, Roland Dreier <roland@purestorage.com>

Register transport attributes after the attribute array has been
set up instead of before. The current code can trigger a race
condition because the code reading the attribute array can run
on another thread than the code that initialized that array.
Make sure that any code reading the attribute array will see all
values written into that array.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: David Dillow <dillowda@ornl.gov>
Cc: Roland Dreier <roland@purestorage.com>
Cc: <stable@kernel.org>
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


