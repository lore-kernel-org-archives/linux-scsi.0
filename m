From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 3/3] esas2r: fix an oversight in setting return value
Date: Sun, 16 Nov 2014 14:35:34 +0100
Message-ID: <1416144934-21338-4-git-send-email-thenzl@redhat.com>
References: <1416144934-21338-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326AbaKPNgn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Nov 2014 08:36:43 -0500
In-Reply-To: <1416144934-21338-1-git-send-email-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bgrove@attotech.com

The patch moves an error code assigment to a 'default' case
in the previous switch statement.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/esas2r/esas2r_ioctl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
index c88b9f9491..baf913047b 100644
--- a/drivers/scsi/esas2r/esas2r_ioctl.c
+++ b/drivers/scsi/esas2r/esas2r_ioctl.c
@@ -1524,9 +1524,12 @@ ioctl_done:
 		case -EINVAL:
 			ioctl->header.return_code = IOCTL_INVALID_PARAM;
 			break;
+
+		default:
+			ioctl->header.return_code = IOCTL_GENERAL_ERROR;
+			break;
 		}
 
-		ioctl->header.return_code = IOCTL_GENERAL_ERROR;
 	}
 
 	/* Always copy the buffer back, if only to pick up the status */
-- 
1.9.3

