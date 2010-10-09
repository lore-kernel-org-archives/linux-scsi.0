From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 6/8] libfc: Do not let disc work cancel itself
Date: Fri, 08 Oct 2010 17:12:36 -0700
Message-ID: <20101009001236.7744.68960.stgit@localhost.localdomain>
References: <20101009001204.7744.21642.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:29538 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759999Ab0JIAMh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Oct 2010 20:12:37 -0400
In-Reply-To: <20101009001204.7744.21642.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

When number of NPIV ports created are greater than the xids
allocated per pool -- for eg., creating 255 NPIV ports on a
system with nr_cpu_ids of 32, with each pool containing 128
xids -- and then generating a link event - for eg.,
shutdown/no shutdown -- on the switch port causes the hang
with the following stack trace.

Call Trace:
schedule_timeout+0x19d/0x230
wait_for_common+0xc0/0x170
__cancel_work_timer+0xcf/0x1b0
fc_disc_stop+0x16/0x30 [libfc]
fc_lport_reset_locked+0x47/0x90 [libfc]
fc_lport_enter_reset+0x67/0xe0 [libfc]
fc_lport_disc_callback+0xbc/0xe0 [libfc]
fc_disc_done+0xa8/0xf0 [libfc]
fc_disc_timeout+0x29/0x40 [libfc]
run_workqueue+0xb8/0x140
worker_thread+0x96/0x110
kthread+0x96/0xa0
child_rip+0xa/0x20

Fix is to not cancel the disc_work if discovery is already
stopped, thus allowing lport state machine to restart and try
discovery again.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Acked-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_disc.c |    5 ++---
 include/scsi/libfc.h         |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 32f67c4..911b273 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -684,10 +684,9 @@ void fc_disc_stop(struct fc_lport *lport)
 {
 	struct fc_disc *disc = &lport->disc;
 
-	if (disc) {
+	if (disc->pending)
 		cancel_delayed_work_sync(&disc->disc_work);
-		fc_disc_stop_rports(disc);
-	}
+	fc_disc_stop_rports(disc);
 }
 
 /**
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 14be49b..f986ab7 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -721,7 +721,7 @@ struct libfc_function_template {
  * struct fc_disc - Discovery context
  * @retry_count:   Number of retries
  * @pending:       1 if discovery is pending, 0 if not
- * @requesting:    1 if discovery has been requested, 0 if not
+ * @requested:     1 if discovery has been requested, 0 if not
  * @seq_count:     Number of sequences used for discovery
  * @buf_len:       Length of the discovery buffer
  * @disc_id:       Discovery ID

