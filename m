From: madhu.iyengar@qlogic.com
Subject: [PATCH 4/5] qla2xxx: Properly set the return value in qla2xxx_eh_abort function.
Date: Tue, 23 Nov 2010 16:52:49 -0800
Message-ID: <1290559970-12123-5-git-send-email-madhu.iyengar@qlogic.com>
References: <1290559970-12123-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:59508 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755625Ab0KXBFs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2010 20:05:48 -0500
In-Reply-To: <1290559970-12123-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Saurav Kashyap <saurav.kashyap@qlogic.com>

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

A return value is not set for the successful case and it has a garbage value.
This fix will set the default value to SUCCESS and in case of any failures
it is changed.

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b873156..2c0876c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -829,7 +829,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	srb_t *sp;
-	int ret;
+	int ret = SUCCESS;
 	unsigned int id, lun;
 	unsigned long flags;
 	int wait = 0;
-- 
1.6.0.2

