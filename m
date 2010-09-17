From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH v2 06/11] libata: Remove host_lock unlock() + lock() from ata_scsi_queuecmd()
Date: Fri, 17 Sep 2010 11:22:36 -0700
Message-ID: <1284747756-20957-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp104.sbc.mail.re3.yahoo.com ([66.196.96.80]:43423 "HELO
	smtp104.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754319Ab0IQSWl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2010 14:22:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux>
Cc: James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the now legacy host_lock unlock() + lock() optimization
from libata-scsi.c:ata_scsi_queuecmd()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/ata/libata-scsi.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a89172c..33ead2a 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3177,7 +3177,6 @@ int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 
 	ap = ata_shost_to_port(shost);
 
-	spin_unlock(shost->host_lock);
 	spin_lock(ap->lock);
 
 	ata_scsi_dump_cdb(ap, cmd);
@@ -3191,7 +3190,6 @@ int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	}
 
 	spin_unlock(ap->lock);
-	spin_lock(shost->host_lock);
 	return rc;
 }
 
-- 
1.7.2.3

