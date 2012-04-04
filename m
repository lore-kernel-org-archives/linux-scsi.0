From: michaelc@cs.wisc.edu
Subject: [PATCH 02/17] be2iscsi: Fix in ASYNC PDU stitching logic.
Date: Tue,  3 Apr 2012 23:41:37 -0500
Message-ID: <1333514512-21799-3-git-send-email-michaelc@cs.wisc.edu>
References: <1333514512-21799-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab2DDElu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Apr 2012 00:41:50 -0400
In-Reply-To: <1333514512-21799-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 The buffer length passed for processing the ASYNC PDU
 was not proper.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 4765f47..fef6f07 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1655,7 +1655,7 @@ hwi_fwd_async_msg(struct beiscsi_conn *beiscsi_conn,
 			}
 			memcpy(pfirst_buffer + offset,
 			       pasync_handle->pbuffer, buf_len);
-			offset = buf_len;
+			offset += buf_len;
 		}
 		index++;
 	}
@@ -1664,7 +1664,7 @@ hwi_fwd_async_msg(struct beiscsi_conn *beiscsi_conn,
 					   (beiscsi_conn->beiscsi_conn_cid -
 					    phba->fw_config.iscsi_cid_start),
 					    phdr, hdr_len, pfirst_buffer,
-					    buf_len);
+					    offset);
 
 	if (status == 0)
 		hwi_free_async_msg(phba, cri);
-- 
1.7.7.6

