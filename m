From: giridhar.malavali@qlogic.com
Subject: [PATCH 05/14] qla2xxx: Process DPC requests within valid Fabric topologies.
Date: Wed, 29 Jul 2009 11:03:54 -0700
Message-ID: <1248890643-761-6-git-send-email-giridhar.malavali@qlogic.com>
References: <1248890643-761-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:35940 "EHLO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751406AbZG2SEF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 14:04:05 -0400
In-Reply-To: <1248890643-761-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Lalit Chandivade <lalit.chandivade@qlogic.com>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

If vports are created and topology is changed to Loop only, the
driver continuously gets a LIP reset occurred and keeps trying to
enable the vport.  Only manage requests during F_Port.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mid.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index cd78c50..6238be3 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -250,6 +250,9 @@ qla2x00_do_dpc_vp(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
+	if (!(ha->current_topology & ISP_CFG_F))
+		return 0;
+
 	if (test_and_clear_bit(VP_IDX_ACQUIRED, &vha->vp_flags)) {
 		/* VP acquired. complete port configuration */
 		if (atomic_read(&base_vha->loop_state) == LOOP_READY) {
-- 
1.6.2.rc1.30.gd43c

