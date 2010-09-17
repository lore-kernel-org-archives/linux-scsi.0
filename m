From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH v2 01/11] scsi: Convert struct Scsi_Host->cmd_serial_number to atomic_t
Date: Fri, 17 Sep 2010 11:21:49 -0700
Message-ID: <1284747709-20862-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux>
Cc: James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts struct Scsi_Host->cmd_serial_number to an atomic_t so that
scsi_cmd_get_serial() can be safely called without struct Scsi_Host->host_lock
in scsi_dispatch_cmd().  This patch also adds a struct Scsi_Host->use_serial_number
to signal serial_number usage, but this is now disabled by default in
scsi_host_alloc().

One special item in scsi_cmd_get_serial() recommended by Joe Eykholt is to
start struct Scsi_Host->cmd_serial_number at 1, and increment each serial_number
by 2 so that the serial is odd, and wraps to 1 instead of 0.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/hosts.c     |    4 ++++
 drivers/scsi/scsi.c      |   13 ++++++++++---
 include/scsi/scsi_host.h |    8 +++++---
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 8a8f803..aff1c9c 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -380,6 +380,10 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
+	/*
+	 * Set the default shost->cmd_serial_number to 1.
+	 */
+	atomic_set(&shost->cmd_serial_number, 1);
 
 	if (sht->supported_mode == MODE_UNKNOWN)
 		/* means we didn't set it ... default to INITIATOR */
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index ad0ed21..4724ce7 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -636,9 +636,16 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
  */
 static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 {
-	cmd->serial_number = host->cmd_serial_number++;
-	if (cmd->serial_number == 0) 
-		cmd->serial_number = host->cmd_serial_number++;
+	/*
+	 * The use of per struct scsi_cmnd->serial_number is disabled by default
+	 */
+	if (!(host->use_serial_number))
+		return;
+	/*
+	 * Increment the host->cmd_serial_number by 2 so cmd->serial_number
+	 * is always odd and wraps to 1 instead of 0.
+	 */
+	cmd->serial_number = atomic_add_return(2, &host->cmd_serial_number);
 }
 
 /**
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index b7bdecb..b08d0f2 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -602,10 +602,9 @@ struct Scsi_Host {
 	short unsigned int max_sectors;
 	unsigned long dma_boundary;
 	/* 
-	 * Used to assign serial numbers to the cmds.
-	 * Protected by the host lock.
+	 * Used to assign serial numbers to the cmds in scsi_cmd_get_serial()
 	 */
-	unsigned long cmd_serial_number;
+	atomic_t cmd_serial_number;
 	
 	unsigned active_mode:2;
 	unsigned unchecked_isa_dma:1;
@@ -636,6 +635,9 @@ struct Scsi_Host {
 	/* Asynchronous scan in progress */
 	unsigned async_scan:1;
 
+	/* Signal usage of per struct scsi_cmnd->serial_number */
+	unsigned use_serial_number:1;
+
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */
-- 
1.7.2.3
