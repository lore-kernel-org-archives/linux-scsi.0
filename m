From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/5] add scsi_build_sense_buffer helper function
Date: Tue, 25 Mar 2008 01:54:51 +0900
Message-ID: <1206377695-26084-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1206377695-26084-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:41624 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbYCXQ4h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Mar 2008 12:56:37 -0400
In-Reply-To: <1206377695-26084-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@HansenPartnership.com>

This adds scsi_build_sense_buffer, a simple helper function to build
sense data in a buffer.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_error.c |   30 ++++++++++++++++++++++++++++++
 include/scsi/scsi_eh.h    |    5 ++++-
 2 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1221d2c..85add5b 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1993,3 +1993,33 @@ int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
 	}
 }
 EXPORT_SYMBOL(scsi_get_sense_info_fld);
+
+/**
+ * scsi_build_sense_buffer - build sense data in a buffer
+ * @desc:	Sense format (non zero == descriptor format,
+ * 		0 == fixed format
+ * @buf:	Where to build sense data
+ * @key:	Sense key
+ * @asc:	Additional sense code
+ * @ascq:	Additional sense code qualifier
+ * @addlen:	Additional sense length
+ *
+ **/
+void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq,
+			     int addlen)
+{
+	if (desc) {
+		buf[0] = 0x72;	/* descriptor, current */
+		buf[1] = key;
+		buf[2] = asc;
+		buf[3] = ascq;
+		buf[7] = addlen;
+	} else {
+		buf[0] = 0x70;	/* fixed, current */
+		buf[2] = key;
+		buf[7] = addlen;
+		buf[12] = asc;
+		buf[13] = ascq;
+	}
+}
+EXPORT_SYMBOL(scsi_build_sense_buffer);
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 37a7614..0d0db78 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -57,7 +57,10 @@ extern const u8 * scsi_sense_desc_find(const u8 * sense_buffer, int sb_len,
 
 extern int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
 				   u64 * info_out);
- 
+
+extern void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq,
+				    int addlen);
+
 /*
  * Reset request from external source
  */
-- 
1.5.3.7

