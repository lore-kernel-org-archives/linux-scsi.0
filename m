From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] scsi_debug: Add XDWRITEREAD_32 support
Date: Tue, 21 Sep 2010 22:50:56 -0700
Message-ID: <1285134656-7764-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds XDWRITEREAD_32 support to scsi_debug.c in
scsi_debug_queuecommand().  It follows the other READ_32 and WRITE_32
emulation for VARIABLE_LENGTH_CMD, and adds a simple goto back to existing
XDWRITEREAD_10 processing logic which already properly supports 64-bit LBA
and 32-bit transfer length in get_data_transfer_info()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/scsi_debug.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b02bdc6..f2547d7 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3796,6 +3796,7 @@ write:
 		errsts = check_readiness(SCpnt, 1, devip);
 		break;
 	case XDWRITEREAD_10:
+xdwrite_read:
 		if (!scsi_bidi_cmnd(SCpnt)) {
 			mk_sense_buffer(devip, ILLEGAL_REQUEST,
 					INVALID_FIELD_IN_CDB, 0);
@@ -3834,6 +3835,8 @@ write:
 				goto write;
 			}
 		}
+		if (cmd[9] == XDWRITEREAD_32)
+			goto xdwrite_read;
 
 		mk_sense_buffer(devip, ILLEGAL_REQUEST,
 				INVALID_FIELD_IN_CDB, 0);
-- 
1.7.3
