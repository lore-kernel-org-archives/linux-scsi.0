From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] [SCSI] scsi_error: classify some ILLEGAL_REQUEST sense as
 a permanent TARGET_ERROR
Date: Mon, 13 Feb 2012 18:35:11 -0500
Message-ID: <20120213233511.GA27146@redhat.com>
References: <1322857889-2623-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555Ab2BMXfW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Feb 2012 18:35:22 -0500
Content-Disposition: inline
In-Reply-To: <1322857889-2623-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com

Permanent target failures are non-retryable and should be classified as
TARGET_ERROR; otherwise dm-multipath will retry an IO request that will
always fail at the target.

A SCSI command that fails with ILLEGAL_REQUEST sense and Additional
sense 0x20, 0x21, 0x24 or 0x26 represents a permanent TARGET_ERROR.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/scsi/scsi_error.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

v2: revised patch header to not be hyper-focused on WRITE SAME failures

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index dc6131e..33d3a50 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -366,6 +366,14 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 			return TARGET_ERROR;
 
 	case ILLEGAL_REQUEST:
+		if (sshdr.asc == 0x20 || /* Invalid command operation code */
+		    sshdr.asc == 0x21 || /* Logical block address out of range */
+		    sshdr.asc == 0x24 || /* Invalid field in cdb */
+		    sshdr.asc == 0x26) { /* Parameter value invalid */
+			return TARGET_ERROR;
+		}
+		return SUCCESS;
+
 	default:
 		return SUCCESS;
 	}

