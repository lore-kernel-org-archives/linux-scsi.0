From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 30/42] qla2xxx: Reduce the time we wait for a command to complete during SCSI error handling.
Date: Fri, 11 Apr 2014 16:54:35 -0400
Message-ID: <1397249687-32666-31-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:65406 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754980AbaDKVcE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:04 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8f1a098..d1a76a6 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -781,7 +781,7 @@ static int
 qla2x00_eh_wait_on_command(struct scsi_cmnd *cmd)
 {
 #define ABORT_POLLING_PERIOD	1000
-#define ABORT_WAIT_ITER		((10 * 1000) / (ABORT_POLLING_PERIOD))
+#define ABORT_WAIT_ITER		((2 * 1000) / (ABORT_POLLING_PERIOD))
 	unsigned long wait_iter = ABORT_WAIT_ITER;
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	struct qla_hw_data *ha = vha->hw;
-- 
1.7.7

