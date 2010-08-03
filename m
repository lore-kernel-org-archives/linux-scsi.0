From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 1/9] drivers/scsi/qla2xxx: Drop unnecessary null test
Date: Tue, 3 Aug 2010 23:31:35 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1008032331170.20393@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:57708 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab0HCVbi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Aug 2010 17:31:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, "J, ames E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.orgker

From: Julia Lawall <julia@diku.dk>

list_for_each_entry_safe binds its first argument to a non-null value, and
thus any null test on the value of that argument is superfluous.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
iterator I;
expression x,E;
@@

I(x,...) { <...
- (x != NULL) &&
  E
  ...> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ff2172d..2b0e6ef 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2348,7 +2348,7 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	ha = base_vha->hw;
 
 	list_for_each_entry_safe(vha, temp, &ha->vp_list, list) {
-		if (vha && vha->fc_vport)
+		if (vha->fc_vport)
 			fc_vport_terminate(vha->fc_vport);
 	}
 
