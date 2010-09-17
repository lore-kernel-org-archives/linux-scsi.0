From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH v2 02/11] scsi: Drop struct Scsi_Host->host_lock usage in scsi_dispatch_cmd()
Date: Fri, 17 Sep 2010 11:21:59 -0700
Message-ID: <1284747719-20881-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux>
Cc: James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts scsi_dispatch_cmd() to no longer lock() + unlock()
struct Scsi_Host->host_lock while calling scsi_cmd_get_serial() and
SHT->queuecommand() dispatcher.  This patch follows commit 5900e428420d
which means we can now safely call scsi_cmd_get_serial() without the
host_lock held.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/scsi.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 4724ce7..d1aa209 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -658,7 +658,6 @@ static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd
 int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
-	unsigned long flags = 0;
 	unsigned long timeout;
 	int rtn = 0;
 
@@ -744,7 +743,6 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		goto out;
 	}
 
-	spin_lock_irqsave(host->host_lock, flags);
 	/*
 	 * AK: unlikely race here: for some reason the timer could
 	 * expire before the serial number is set up below.
@@ -760,7 +758,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		trace_scsi_dispatch_cmd_start(cmd);
 		rtn = host->hostt->queuecommand(cmd, scsi_done);
 	}
-	spin_unlock_irqrestore(host->host_lock, flags);
+
 	if (rtn) {
 		trace_scsi_dispatch_cmd_error(cmd, rtn);
 		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
-- 
1.7.2.3
