From: Tomas Henzl <thenzl@redhat.com>
Subject: megaraid_sas: add an i/o barrier
Date: Fri, 29 Jan 2016 18:35:01 +0100
Message-ID: <56ABA2C5.6060603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbcA2RfD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jan 2016 12:35:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "Sumit.Saxena@avagotech.com" <Sumit.Saxena@avagotech.com>, "Desai, Kashyap" <Kashyap.Desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>

A barrier should be added to ensure proper
ordering of memory mapped writes.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index d9d0029fb1..98a848bdfd 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -204,6 +204,7 @@ megasas_fire_cmd_fusion(struct megasas_instance *instance,
 		&instance->reg_set->inbound_low_queue_port);
 	writel(le32_to_cpu(req_desc->u.high),
 		&instance->reg_set->inbound_high_queue_port);
+	mmiowb();
 	spin_unlock_irqrestore(&instance->hba_lock, flags);
 #endif
 }
-- 
2.4.3

