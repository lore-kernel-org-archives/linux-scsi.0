From: Sebastian Herbszt <herbszt@gmx.de>
Subject: [PATCH] efct: fix compilation warning about atomic_t usage
Date: Wed, 15 Mar 2017 22:27:43 +0100
Message-ID: <20170315222743.00004630@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:61442 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752585AbdCOV15 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 17:27:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

Use kref_read() instead of accessing the counter inside a kref.

Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
---
 efct/efct_ddump.c | 5 ++---
 efct/efct_hw.c    | 6 +++---
 efct/efct_io.c    | 3 +--
 efct/efct_lio.c   | 2 +-
 efct/efct_scsi.c  | 4 ++--
 5 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/efct/efct_ddump.c b/efct/efct_ddump.c
index e91a838..faea9a0 100644
--- a/efct/efct_ddump.c
+++ b/efct/efct_ddump.c
@@ -340,8 +340,7 @@ efct_ddump_hw_io(struct efct_textbuf_s *textbuf, struct efct_hw_io_s *io)
 	efct_ddump_value(textbuf, "tag", "0x%x", io->reqtag);
 	efct_ddump_value(textbuf, "abort_reqtag",
 			"0x%x", io->abort_reqtag);
-	efct_ddump_value(textbuf, "ref_count", "%d",
-					atomic_read(&io->ref.refcount));
+	efct_ddump_value(textbuf, "ref_count", "%d", kref_read(&io->ref));
 
 	/* just to make it obvious, display abort bit from tag */
 	efct_ddump_value(textbuf, "abort", "0x%x", io->abort_in_progress);
@@ -606,7 +605,7 @@ efct_ddump_hw(struct efct_textbuf_s *textbuf, struct efct_hw_s *hw,
 		io = &hw->io[i];
 
 		if (efct_hw_is_xri_port_owned(hw, io->indicator)) {
-			if (atomic_read(&io->ref.refcount)) {
+			if (kref_read(&io->ref)) {
 				/* only display free ios if they're active */
 				efct_ddump_hw_io(textbuf, io);
 			}
diff --git a/efct/efct_hw.c b/efct/efct_hw.c
index e52a505..cf37dc9 100644
--- a/efct/efct_hw.c
+++ b/efct/efct_hw.c
@@ -3647,7 +3647,7 @@ efct_hw_io_alloc(struct efct_hw_s *hw)
 struct efct_hw_io_s *
 efct_hw_io_activate_port_owned(struct efct_hw_s *hw, struct efct_hw_io_s *io)
 {
-	if (atomic_read(&io->ref.refcount) > 0) {
+	if (kref_read(&io->ref) > 0) {
 		efct_log_err(hw->os, "Bad parameter: refcount > 0\n");
 		return NULL;
 	}
@@ -3794,7 +3794,7 @@ int32_t
 efct_hw_io_free(struct efct_hw_s *hw, struct efct_hw_io_s *io)
 {
 	/* just put refcount */
-	if (atomic_read(&io->ref.refcount) <= 0) {
+	if (kref_read(&io->ref) <= 0) {
 		efct_log_err(hw->os,
 			    "Bad parameter: refcount <= 0 xri=%x tag=%x\n",
 			    io->indicator, io->reqtag);
@@ -3821,7 +3821,7 @@ efct_hw_io_free(struct efct_hw_s *hw, struct efct_hw_io_s *io)
 uint8_t
 efct_hw_io_inuse(struct efct_hw_s *hw, struct efct_hw_io_s *io)
 {
-	return (atomic_read(&io->ref.refcount) > 0);
+	return (kref_read(&io->ref) > 0);
 }
 
 /**
diff --git a/efct/efct_io.c b/efct/efct_io.c
index 988ec28..9ee9932 100644
--- a/efct/efct_io.c
+++ b/efct/efct_io.c
@@ -332,8 +332,7 @@ efct_ddump_io(struct efct_textbuf_s *textbuf, struct efct_io_s *io)
 	efct_ddump_value(textbuf, "display_name", "%s", io->display_name);
 	efct_ddump_value(textbuf, "node_name", "%s", io->node->display_name);
 
-	efct_ddump_value(textbuf, "ref_count", "%d",
-			atomic_read(&io->ref.refcount));
+	efct_ddump_value(textbuf, "ref_count", "%d", kref_read(&io->ref));
 	efct_ddump_value(textbuf, "io_type", "%d", io->io_type);
 	efct_ddump_value(textbuf, "hio_type", "%d", io->hio_type);
 	efct_ddump_value(textbuf, "cmd_tgt", "%d", io->cmd_tgt);
diff --git a/efct/efct_lio.c b/efct/efct_lio.c
index f5c7a70..74b48ad 100644
--- a/efct/efct_lio.c
+++ b/efct/efct_lio.c
@@ -2276,7 +2276,7 @@ efct_scsi_tgt_ddump(struct efct_textbuf_s *textbuf,
 		efct_ddump_value(textbuf, "se_cmd.state_active", "%d",
 				io->tgt_io.cmd.state_active);
 		efct_ddump_value(textbuf, "se_cmd.cmd_kref.refcount", "%d",
-				atomic_read(&io->tgt_io.cmd.cmd_kref.refcount));
+				kref_read(&io->tgt_io.cmd.cmd_kref));
 		efct_ddump_value(textbuf, "se_cmd.se_cmd_flags", "%#x",
 				io->tgt_io.cmd.se_cmd_flags);
 		efct_ddump_value(textbuf, "se_cmd.t_state", "%d",
diff --git a/efct/efct_scsi.c b/efct/efct_scsi.c
index c2f5a35..ad49aa6 100644
--- a/efct/efct_scsi.c
+++ b/efct/efct_scsi.c
@@ -301,7 +301,7 @@ void
 efct_scsi_io_free(struct efct_io_s *io)
 {
 	scsi_io_trace(io, "freeing io 0x%p %s\n", io, io->display_name);
-	efct_assert(atomic_read(&io->ref.refcount) > 0);
+	efct_assert(kref_read(&io->ref) > 0);
 	kref_put(&io->ref, io->release);
 }
 
@@ -2320,7 +2320,7 @@ efct_scsi_io_complete(struct efct_io_s *io)
 	}
 
 	scsi_io_trace(io, "freeing io 0x%p %s\n", io, io->display_name);
-	efct_assert(atomic_read(&io->ref.refcount) > 0);
+	efct_assert(kref_read(&io->ref) > 0);
 	kref_put(&io->ref, io->release);
 }
 
-- 
2.7.3
