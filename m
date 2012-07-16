From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] sd: do not set changed flag on all unit attention conditions
Date: Mon, 16 Jul 2012 18:06:12 +0200
Message-ID: <1342454772-9018-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com
List-Id: linux-scsi@vger.kernel.org

Right now, I/O will fail as soon as a unit attention condition is
detected on a unit with removable media.  However, this is not
always necessary.  There are some cases (such as "Capacity data
has changed") where no particular action is needed.  On the
other hand, all problematic cases have to report at least one
of "No medium" and/or a "Medium may have changed", so restrict
our attention to those.

This patch fixes resizing a removable medium with virtio-scsi.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/scsi_lib.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b583277..6d8ca08 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -843,8 +843,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	} else if (sense_valid && !sense_deferred) {
 		switch (sshdr.sense_key) {
 		case UNIT_ATTENTION:
-			if (cmd->device->removable) {
-				/* Detected disc change.  Set a bit
+			if (cmd->device->removable &&
+			    (sshdr.asc == 0x3a ||
+			     (sshdr.asc == 0x28 && sshdr.ascq == 0x00))) {
+				/* "No medium" or "Medium may have changed."
+				 * This means a disc change.  Set a bit
 				 * and quietly refuse further access.
 				 */
 				cmd->device->changed = 1;
-- 
1.7.1
