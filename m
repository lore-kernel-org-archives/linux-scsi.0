From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 20/41] hpsa: Acknowledge controller events in ioaccell mode 2
	as well as mode 1
Date: Wed, 15 Jan 2014 16:38:01 -0600
Message-ID: <20140115223801.5061.11209.stgit@beardog.cce.hp.com>
References: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:45455 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbaAOViC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 16:38:02 -0500
In-Reply-To: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c     |    3 ++-
 drivers/scsi/hpsa_cmd.h |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ebca59b..fbf41c7 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5490,7 +5490,8 @@ static int hpsa_kickoff_rescan(struct ctlr_info *h)
 	char *event_type;
 
 	/* Ask the controller to clear the events we're handling. */
-	if (h->transMethod & (CFGTBL_Trans_io_accel1) &&
+	if ((h->transMethod & (CFGTBL_Trans_io_accel1
+			| CFGTBL_Trans_io_accel2)) &&
 		(h->events & HPSA_EVENT_NOTIFY_ACCEL_IO_PATH_STATE_CHANGE ||
 		 h->events & HPSA_EVENT_NOTIFY_ACCEL_IO_PATH_CONFIG_CHANGE)) {
 
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 9e00988..6b336e8 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -133,6 +133,7 @@
 #define CFGTBL_Trans_Simple     0x00000002l
 #define CFGTBL_Trans_Performant 0x00000004l
 #define CFGTBL_Trans_io_accel1	0x00000080l
+#define CFGTBL_Trans_io_accel2	0x00000100l
 #define CFGTBL_Trans_use_short_tags 0x20000000l
 #define CFGTBL_Trans_enable_directed_msix (1 << 30)
 

