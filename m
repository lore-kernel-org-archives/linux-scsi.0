From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/5] megaraid_sas: add mmio barrier after register writes
Date: Fri, 11 Nov 2016 10:44:52 +0100
Message-ID: <1478857492-4581-6-git-send-email-hare@suse.de>
References: <1478857492-4581-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60661 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754978AbcKKJpH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Nov 2016 04:45:07 -0500
In-Reply-To: <1478857492-4581-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The megaraid_sas HBA only has a single register for I/O submission,
which will be hit pretty hard with scsi-mq. To ensure that the
PCI writes have made it across we need to add a mmio barrier
after each write; otherwise I've been seeing spurious command
completions and I/O stalls.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index aba53c0..729a654 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -196,6 +196,7 @@ inline void megasas_return_cmd_fusion(struct megasas_instance *instance,
 			le32_to_cpu(req_desc->u.low));
 
 	writeq(req_data, &instance->reg_set->inbound_low_queue_port);
+	mmiowb();
 #else
 	unsigned long flags;
 
-- 
1.8.5.6

