From: Dan Carpenter <error27@gmail.com>
Subject: [patch -next] qla2xxx: list cursors are not null
Date: Thu, 14 Oct 2010 20:22:37 +0200
Message-ID: <20101014182237.GC6614@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33636 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab0JNSWt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Oct 2010 14:22:49 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-driver@qlogic.com, "James E.J. Bottomley" <James.Bottomley@suse.de>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Grant Likely <grant.likely@secretlab.ca>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

This is just a cleanup.

The unneeded NULL check annoys static checkers because we already
derefenced it and the we check it and then (if it's not the _safe()
version) we dereference it again without checking.  And the static
checker is all, "Wah?  Is it null or not?"

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index c2d7bb8..f5cf356 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3830,7 +3830,7 @@ qla2x00_update_fcports(scsi_qla_host_t *base_vha)
 	/* Go with deferred removal of rport references. */
 	list_for_each_entry_safe(vha, tvp, &base_vha->hw->vp_list, list)
 		list_for_each_entry(fcport, &vha->vp_fcports, list)
-			if (fcport && fcport->drport &&
+			if (fcport->drport &&
 			    atomic_read(&fcport->state) != FCS_UNCONFIGURED)
 				qla2x00_rport_del(fcport);
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index bdd53f0..374670b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2351,7 +2351,7 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	ha = base_vha->hw;
 
 	list_for_each_entry_safe(vha, temp, &ha->vp_list, list) {
-		if (vha && vha->fc_vport)
+		if (vha->fc_vport)
 			fc_vport_terminate(vha->fc_vport);
 	}
 
