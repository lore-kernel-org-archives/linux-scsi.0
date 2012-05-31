From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] [SCSI] scsi_lib: fix scsi_io_completion's SG_IO error propagation
Date: Thu, 31 May 2012 15:05:33 -0400
Message-ID: <1338491133-8077-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932395Ab2EaTFs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 May 2012 15:05:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: babu.moger@netapp.com, hare@suse.de, michaelc@cs.wisc.edu, James.Bottomley@hansenpartnership.com, Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org.#.3.4

The following v3.4-rc1 commit unmasked an existing bug in
scsi_io_completion's SG_IO error handling:
47ac56d [SCSI] scsi_error: classify some ILLEGAL_REQUEST sense as a permanent TARGET_ERROR

Given that certain ILLEGAL_REQUEST are now properly categorized as
TARGET_ERROR the host_byte is being set (before host_byte wasn't ever
set for these ILLEGAL_REQUEST).

In scsi_io_completion, initialize req->errors with cmd->result _after_
the SG_IO block that calls __scsi_error_from_host_byte (which may
modify the host_byte).

Before this fix:

    cdb to send: 12 01 01 00 00 00
ioctl(3, SG_IO, {'S', SG_DXFER_NONE, cmd[6]=[12, 01, 01, 00, 00, 00],
    mx_sb_len=32, iovec_count=0, dxfer_len=0, timeout=20000, flags=0,
    status=02, masked_status=01, sb[19]=[70, 00, 05, 00, 00, 00, 00, 0b,
    00, 00, 00, 00, 24, 00, 00, 00, 00, 00, 00], host_status=0x10,
    driver_status=0x8, resid=0, duration=0, info=0x1}) = 0
SCSI Status: Check Condition

Sense Information:
sense buffer empty

After:

    cdb to send: 12 01 01 00 00 00
ioctl(3, SG_IO, {'S', SG_DXFER_NONE, cmd[6]=[12, 01, 01, 00, 00, 00],
    mx_sb_len=32, iovec_count=0, dxfer_len=0, timeout=20000, flags=0,
    status=02, masked_status=01, sb[19]=[70, 00, 05, 00, 00, 00, 00, 0b,
    00, 00, 00, 00, 24, 00, 00, 00, 00, 00, 00], host_status=0,
    driver_status=0x8, resid=0, duration=0, info=0x1}) = 0
SCSI Status: Check Condition

Sense Information:
 Fixed format, current;  Sense key: Illegal Request
 Additional sense: Invalid field in cdb
 Raw sense data (in hex):
        70 00 05 00 00 00 00 0b  00 00 00 00 24 00 00 00
        00 00 00

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Babu Moger <babu.moger@netapp.com>
Cc: stable@vger.kernel.org # 3.4
---
 drivers/scsi/scsi_lib.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5dfd749..8db7ef0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -753,7 +753,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	}
 
 	if (req->cmd_type == REQ_TYPE_BLOCK_PC) { /* SG_IO ioctl from block level */
-		req->errors = result;
 		if (result) {
 			if (sense_valid && req->sense) {
 				/*
@@ -769,6 +768,10 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			if (!sense_deferred)
 				error = __scsi_error_from_host_byte(cmd, result);
 		}
+		/*
+		 * __scsi_error_from_host_byte may have reset the host_byte
+		 */
+		req->errors = cmd->result;
 
 		req->resid_len = scsi_get_resid(cmd);
 
-- 
1.7.1

