From: giridhar.malavali@qlogic.com
Subject: [PATCH 3/9] qla2xxx: Reread firmware versions information after an ISP abort.
Date: Tue, 13 Oct 2009 15:16:47 -0700
Message-ID: <1255472213-472-4-git-send-email-giridhar.malavali@qlogic.com>
References: <1255472213-472-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:49692 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1760088AbZJMWYP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Oct 2009 18:24:15 -0400
In-Reply-To: <1255472213-472-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Lalit Chandivade <lalit.chandivade@qlogic.com>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

In some case, the MPI and PHY versions when retrieved after the
Execute-FW mailbox-command are incorrect (255.255.255.255).
Instead, query the information after the check for firmware ready
is done in the abort ISP path.

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 9e3eaac..c2494ca 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3573,6 +3573,15 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 			ha->isp_abort_cnt = 0;
 			clear_bit(ISP_ABORT_RETRY, &vha->dpc_flags);
 
+			if (IS_QLA81XX(ha))
+				qla2x00_get_fw_version(vha,
+				    &ha->fw_major_version,
+				    &ha->fw_minor_version,
+				    &ha->fw_subminor_version,
+				    &ha->fw_attributes, &ha->fw_memory_size,
+				    ha->mpi_version, &ha->mpi_capabilities,
+				    ha->phy_version);
+
 			if (ha->fce) {
 				ha->flags.fce_enabled = 1;
 				memset(ha->fce, 0,
-- 
1.6.2.rc1.30.gd43c

