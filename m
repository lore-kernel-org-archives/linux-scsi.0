From: madhu.iyengar@qlogic.com
Subject: [PATCH 01/12] qla2xxx: locking problem in qla2x00_init_rings()
Date: Fri, 15 Oct 2010 11:27:38 -0700
Message-ID: <1287167269-8034-2-git-send-email-madhu.iyengar@qlogic.com>
References: <1287167269-8034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36962 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1756291Ab0JOSg2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2010 14:36:28 -0400
In-Reply-To: <1287167269-8034-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Dan Carpenter <error27@gmail.com>

From: Dan Carpenter <error27@gmail.com>

IRQs are already disabled here so we don't need to disable them again.
But more importantly, the spin_lock_irqsave() overwrites "flags" and
that breaks things when we want to re-enable the IRQs when we call
spin_unlock_irqrestore(&ha->hardware_lock, flags);

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3cafbef..c8d0b12 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1818,14 +1818,14 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 		qla2x00_init_response_q_entries(rsp);
 	}
 
-	spin_lock_irqsave(&ha->vport_slock, flags);
+	spin_lock(&ha->vport_slock);
 	/* Clear RSCN queue. */
 	list_for_each_entry(vp, &ha->vp_list, list) {
 		vp->rscn_in_ptr = 0;
 		vp->rscn_out_ptr = 0;
 	}
 
-	spin_unlock_irqrestore(&ha->vport_slock, flags);
+	spin_unlock(&ha->vport_slock);
 
 	ha->isp_ops->config_rings(vha);
 
-- 
1.6.0.2

