From: Davidlohr Bueso <dave@gnu.org>
Subject: [PATCH 09/20] scsi/fd_mcs: No longer use Scsi_Cmd typedef
Date: Sun, 08 Nov 2009 17:17:14 -0300
Message-ID: <1257711434.4759.115.camel@dbueso-pc>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [190.108.161.231] ([190.108.161.231]:38439 "EHLO
	localhost.localdomain" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754554AbZKHUgI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 8 Nov 2009 15:36:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, faith@cs.unc.edu

Change Scsi_Cmnd for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>

---
 drivers/scsi/fd_mcs.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/fd_mcs.c b/drivers/scsi/fd_mcs.c
index 85bd54c..29ab1e1 100644
--- a/drivers/scsi/fd_mcs.c
+++ b/drivers/scsi/fd_mcs.c
@@ -184,7 +184,7 @@ struct fd_hostdata {
 	int _bios_major;
 	int _bios_minor;
 	volatile int _in_command;
-	Scsi_Cmnd *_current_SC;
+	struct scsi_cmnd *_current_SC;
 	enum chip_type _chip;
 	int _adapter_mask;
 	int _fifo_count;	/* Number of 512 byte blocks before INTR */
@@ -1071,7 +1071,7 @@ static int fd_mcs_release(struct Scsi_Host *shpnt)
 	return 0;
 }
 
-static int fd_mcs_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
+static int fd_mcs_queue(struct scsi_cmnd * SCpnt, void (*done) (struct scsi_cmnd *))
 {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
 
@@ -1122,7 +1122,7 @@ static int fd_mcs_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 }
 
 #if DEBUG_ABORT || DEBUG_RESET
-static void fd_mcs_print_info(Scsi_Cmnd * SCpnt)
+static void fd_mcs_print_info(struct scsi_cmnd * SCpnt)
 {
 	unsigned int imr;
 	unsigned int irr;
@@ -1193,7 +1193,7 @@ static void fd_mcs_print_info(Scsi_Cmnd * SCpnt)
 }
 #endif
 
-static int fd_mcs_abort(Scsi_Cmnd * SCpnt)
+static int fd_mcs_abort(struct scsi_cmnd * SCpnt)
 {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
 
@@ -1229,7 +1229,7 @@ static int fd_mcs_abort(Scsi_Cmnd * SCpnt)
 	return SUCCESS;
 }
 
-static int fd_mcs_bus_reset(Scsi_Cmnd * SCpnt) {
+static int fd_mcs_bus_reset(struct scsi_cmnd * SCpnt) {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
 	unsigned long flags;
 



