From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 16/26] qlogicfas: move bus_reset to host_reset
Date: Fri, 25 Aug 2017 13:57:11 +0200
Message-ID: <1503662241-127788-17-git-send-email-hare@suse.de>
References: <1503662241-127788-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49653 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756523AbdHYL6F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 07:58:05 -0400
In-Reply-To: <1503662241-127788-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

From: Hannes Reinecke <hare@suse.com>

The bus reset handler is really a host reset.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/pcmcia/qlogic_stub.c | 4 ++--
 drivers/scsi/qlogicfas.c          | 2 +-
 drivers/scsi/qlogicfas408.c       | 6 +++---
 drivers/scsi/qlogicfas408.h       | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
index c670dc7..0556054 100644
--- a/drivers/scsi/pcmcia/qlogic_stub.c
+++ b/drivers/scsi/pcmcia/qlogic_stub.c
@@ -67,7 +67,7 @@
 	.info			= qlogicfas408_info,
 	.queuecommand		= qlogicfas408_queuecommand,
 	.eh_abort_handler	= qlogicfas408_abort,
-	.eh_bus_reset_handler	= qlogicfas408_bus_reset,
+	.eh_host_reset_handler	= qlogicfas408_host_reset,
 	.bios_param		= qlogicfas408_biosparam,
 	.can_queue		= 1,
 	.this_id		= -1,
@@ -264,7 +264,7 @@ static int qlogic_resume(struct pcmcia_device *link)
 		outb(0x04, link->resource[0]->start + 0xd);
 	}
 	/* Ugggglllyyyy!!! */
-	qlogicfas408_bus_reset(NULL);
+	qlogicfas408_host_reset(NULL);
 
 	return 0;
 }
diff --git a/drivers/scsi/qlogicfas.c b/drivers/scsi/qlogicfas.c
index 840823b..95431d6 100644
--- a/drivers/scsi/qlogicfas.c
+++ b/drivers/scsi/qlogicfas.c
@@ -188,7 +188,7 @@ static int qlogicfas_release(struct Scsi_Host *shost)
 	.info			= qlogicfas408_info,
 	.queuecommand		= qlogicfas408_queuecommand,
 	.eh_abort_handler	= qlogicfas408_abort,
-	.eh_bus_reset_handler	= qlogicfas408_bus_reset,
+	.eh_host_reset_handler	= qlogicfas408_host_reset,
 	.bios_param		= qlogicfas408_biosparam,
 	.can_queue		= 1,
 	.this_id		= -1,
diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index c3a9151..8b471a9 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -496,13 +496,13 @@ int qlogicfas408_abort(struct scsi_cmnd *cmd)
 	return SUCCESS;
 }
 
-/* 
+/*
  *	Reset SCSI bus
  *	FIXME: This function is invoked with cmd = NULL directly by
  *	the PCMCIA qlogic_stub code. This wants fixing
  */
 
-int qlogicfas408_bus_reset(struct scsi_cmnd *cmd)
+int qlogicfas408_host_reset(struct scsi_cmnd *cmd)
 {
 	struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
 	unsigned long flags;
@@ -607,7 +607,7 @@ static void __exit qlogicfas408_exit(void)
 EXPORT_SYMBOL(qlogicfas408_info);
 EXPORT_SYMBOL(qlogicfas408_queuecommand);
 EXPORT_SYMBOL(qlogicfas408_abort);
-EXPORT_SYMBOL(qlogicfas408_bus_reset);
+EXPORT_SYMBOL(qlogicfas408_host_reset);
 EXPORT_SYMBOL(qlogicfas408_biosparam);
 EXPORT_SYMBOL(qlogicfas408_ihandl);
 EXPORT_SYMBOL(qlogicfas408_get_chip_type);
diff --git a/drivers/scsi/qlogicfas408.h b/drivers/scsi/qlogicfas408.h
index 2f6c0a1..f6b1216 100644
--- a/drivers/scsi/qlogicfas408.h
+++ b/drivers/scsi/qlogicfas408.h
@@ -108,7 +108,7 @@ int qlogicfas408_biosparam(struct scsi_device * disk,
 			   struct block_device *dev,
 			   sector_t capacity, int ip[]);
 int qlogicfas408_abort(struct scsi_cmnd * cmd);
-int qlogicfas408_bus_reset(struct scsi_cmnd * cmd);
+extern int qlogicfas408_host_reset(struct scsi_cmnd *cmd);
 const char *qlogicfas408_info(struct Scsi_Host *host);
 int qlogicfas408_get_chip_type(int qbase, int int_type);
 void qlogicfas408_setup(int qbase, int id, int int_type);
-- 
1.8.5.6
