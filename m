From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: [PATCH] return valid data buffer length in scsi_bufflen() API using RQF_SPECIAL_PAYLOAD
Date: Mon, 13 Feb 2017 17:25:19 +0530
Message-ID: <4c804c26dcaea4a30e89734bb351c523@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:33781 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752829AbdBMLzc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2017 06:55:32 -0500
Received: by mail-qk0-f181.google.com with SMTP id s140so91235383qke.0
        for <linux-scsi@vger.kernel.org>; Mon, 13 Feb 2017 03:55:31 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, hch@infradead.org, Jens Axboe <axboe@kernel.dk>

Regression due to  commit f9d03f96b988002027d4b28ea1b7a24729a4c9b5
block: improve handling of the magic discard payload

<megaraid_sas> and <mpt3sas> HBA FW encounter FW fault in DMA operation
while creating File system on SSDs.
Below CDB cause FW fault.
CDB: Write same(16) 93 08 00 00 00 00 00 00 00 00 00 00 80 00 00 00

Root cause is SCSI buffer length and DMA buffer length miss match for
WRITE SAME command.

Fix - return valid data buffer length in scsi_bufflen() API using
RQF_SPECIAL_PAYLOAD

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
---
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 9fc1aec..1f796fc 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -180,7 +180,8 @@ static inline struct scatterlist *scsi_sglist(struct
scsi_cmnd *cmd)

 static inline unsigned scsi_bufflen(struct scsi_cmnd *cmd)
 {
-	return cmd->sdb.length;
+	return (cmd->request->rq_flags & RQF_SPECIAL_PAYLOAD) ?
+			cmd->request->special_vec.bv_len :
cmd->sdb.length;
 }

 static inline void scsi_set_resid(struct scsi_cmnd *cmd, int resid)
