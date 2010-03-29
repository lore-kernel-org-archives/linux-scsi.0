From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 9/12] drivers/scsi/qla2xxx: Add missing unlock
Date: Mon, 29 Mar 2010 17:36:02 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1003291735420.21896@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:48591 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034Ab0C2PgH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Mar 2010 11:36:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, "J, ames E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.orgker

From: Julia Lawall <julia@diku.dk>

This code represents error handling code.  Add an unlock as done in the
normal exit path from the function.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E1;
identifier f;
@@

f (...) { <+...
* spin_lock_irqsave (E1,...);
... when != E1
* return ...;
...+> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/qla2xxx/qla_attr.c     |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 90d1e06..e8ace7a 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2392,6 +2392,7 @@ done:
 		kfree(sp->fcport);
 	kfree(sp->ctx);
 	mempool_free(sp, ha->srb_mempool);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return 0;
 }
 
