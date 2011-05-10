From: madhu.iyengar@qlogic.com
Subject: [PATCH 01/11] qla2xxx: Update firmware version after flash update for ISP82xx.
Date: Tue, 10 May 2011 11:30:06 -0700
Message-ID: <1305052216-17347-2-git-send-email-madhu.iyengar@qlogic.com>
References: <1305052216-17347-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:39918 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751344Ab1EJSgd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 May 2011 14:36:33 -0400
In-Reply-To: <1305052216-17347-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Saurav Kashyap <saurav.kashyap@qlogic.com>

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

The driver keeps a copy of the fw_version within the ha structure.
For ISP82xx, this local copy doesn't get updated, and as a result,
the old firmware version ends up getting displayed. This patch fixes
this issue.

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 24d2d19..cb69693 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5435,6 +5435,13 @@ qla82xx_restart_isp(scsi_qla_host_t *vha)
 		ha->isp_abort_cnt = 0;
 		clear_bit(ISP_ABORT_RETRY, &vha->dpc_flags);
 
+		/* Update the firmware version */
+		qla2x00_get_fw_version(vha, &ha->fw_major_version,
+		    &ha->fw_minor_version, &ha->fw_subminor_version,
+		    &ha->fw_attributes, &ha->fw_memory_size,
+		    ha->mpi_version, &ha->mpi_capabilities,
+		    ha->phy_version);
+
 		if (ha->fce) {
 			ha->flags.fce_enabled = 1;
 			memset(ha->fce, 0,
-- 
1.6.0.2

