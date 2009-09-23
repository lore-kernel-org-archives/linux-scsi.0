From: Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 4/5] SCSI: qla2xxx, fix NULL-ptr dereference
Date: Wed, 23 Sep 2009 16:15:34 +0200
Message-ID: <1253715335-6723-4-git-send-email-jirislaby@gmail.com>
References: <1253715335-6723-1-git-send-email-jirislaby@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from server1.wserver.cz ([82.113.45.157]:58691 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbZIWOPZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Sep 2009 10:15:25 -0400
In-Reply-To: <1253715335-6723-1-git-send-email-jirislaby@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

Stanse found a NULL-ptr dereference on one fail path in
qla25xx_create_rsp_que. It jumps to que_failed label and
qla25xx_free_rsp_que there dereferences rsp which is NULL.

Return with ENOMEM directly instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/qla2xxx/qla_mid.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 42b799a..8b4e723 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -659,7 +659,7 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 	if (rsp == NULL) {
 		qla_printk(KERN_WARNING, ha, "could not allocate memory for"
 				" response que\n");
-		goto que_failed;
+		return -ENOMEM;
 	}
 
 	rsp->length = RESPONSE_ENTRY_CNT_MQ;
-- 
1.6.4.2

