Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F06C47095
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:41:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B32852064C
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:41:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B+eCSQXq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbgJEIlj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 04:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgJEIlj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2020 04:41:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07145C0613CE
        for <linux-scsi@vger.kernel.org>; Mon,  5 Oct 2020 01:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=TKhNxLQUPbMqxLdH9p21zrAQJZyzC6dfZw+MHylrLZE=; b=B+eCSQXqkbGTjXyQSQtjxhWOPN
        8Cyc1HAzrUqujTs7pMjppQM5J4JGn7NQxtTqKQ9ddLU/SfS++V1zmCU8FYDA5YpeZoJTX19qrI1RA
        3SaMt32cxMGz3DlqAdsoUho5jBCSjm8ZlxTZXFbKqPWqxl3TQWYMnSI/VSct+dXrLWus3x4Uob6h4
        Codx2zBHooBzykL1mxEuFNEwe1x+QT+crKpaSh/vqqamk2E/3YJEjkX+9Qqan7/doEF7b3h0kYr7x
        Sb6W7X/F5O/Ve0OF++86Ezj7wdE8btallhE/abA5aoHddC7A9/ZqFJzjwtHTjB1N9DfOhhNjkc7nf
        CEr49f7Q==;
Received: from [2001:4bb8:184:92a2:b8a4:f4a0:f053:4f06] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPM3s-0000lr-UB; Mon, 05 Oct 2020 08:41:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH 04/10] scsi: simplify varlen CDB length checking
Date:   Mon,  5 Oct 2020 10:41:24 +0200
Message-Id: <20201005084130.143273-5-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005084130.143273-1-hch@lst.de>
References: <20201005084130.143273-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Directly access the cdb array like we do everywhere else insted of
overlaying a structure on top of it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_logging.c |  2 +-
 include/scsi/scsi_common.h  | 11 +++--------
 include/scsi/scsi_proto.h   | 10 ----------
 3 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index 8ea44c6595efa7..b6222df7254a3a 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -111,7 +111,7 @@ static size_t scsi_format_opcode_name(char *buffer, size_t buf_len,
 
 	cdb0 = cdbp[0];
 	if (cdb0 == VARIABLE_LENGTH_CMD) {
-		int len = scsi_varlen_cdb_length(cdbp);
+		int len = cdbp[7] + 8;
 
 		if (len < 10) {
 			off = scnprintf(buffer, buf_len,
diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
index 731ac09ed23135..297fc1881607b6 100644
--- a/include/scsi/scsi_common.h
+++ b/include/scsi/scsi_common.h
@@ -9,20 +9,15 @@
 #include <linux/types.h>
 #include <scsi/scsi_proto.h>
 
-static inline unsigned
-scsi_varlen_cdb_length(const void *hdr)
-{
-	return ((struct scsi_varlen_cdb_hdr *)hdr)->additional_cdb_length + 8;
-}
-
 extern const unsigned char scsi_command_size_tbl[8];
 #define COMMAND_SIZE(opcode) scsi_command_size_tbl[((opcode) >> 5) & 7]
 
 static inline unsigned
 scsi_command_size(const unsigned char *cmnd)
 {
-	return (cmnd[0] == VARIABLE_LENGTH_CMD) ?
-		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);
+	if (cmnd[0] == VARIABLE_LENGTH_CMD)
+		return cmnd[7] + 8;
+	return COMMAND_SIZE(cmnd[0]);
 }
 
 /* Returns a human-readable name for the device */
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index c3686011193224..c57f9cd8185526 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -176,16 +176,6 @@
 
 #define SCSI_MAX_VARLEN_CDB_SIZE 260
 
-/* defined in T10 SCSI Primary Commands-2 (SPC2) */
-struct scsi_varlen_cdb_hdr {
-	__u8 opcode;        /* opcode always == VARIABLE_LENGTH_CMD */
-	__u8 control;
-	__u8 misc[5];
-	__u8 additional_cdb_length;         /* total cdb length - 8 */
-	__be16 service_action;
-	/* service specific data follows */
-};
-
 /*
  *  SCSI Architecture Model (SAM) Status codes. Taken from SAM-3 draft
  *  T10/1561-D Revision 4 Draft dated 7th November 2002.
-- 
2.28.0

