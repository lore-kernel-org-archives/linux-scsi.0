From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH v2 1/5] add scsi_build_sense_buffer helper function
Date: Tue, 25 Mar 2008 09:26:49 +0900
Message-ID: <1206404816-21710-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:53690 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492AbYCYAvZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Mar 2008 20:51:25 -0400
In-Reply-To: 1206378609.3494.50.camel@localhost.localdomain
References: 1206378609.3494.50.camel@localhost.localdomain
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@HansenPartnership.com>

This adds scsi_build_sense_buffer, a simple helper function to build
sense data in a buffer.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_error.c |   28 ++++++++++++++++++++++++++++
 include/scsi/scsi_eh.h    |    4 +++-
 2 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1221d2c..221f31e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1993,3 +1993,31 @@ int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
 	}
 }
 EXPORT_SYMBOL(scsi_get_sense_info_fld);
+
+/**
+ * scsi_build_sense_buffer - build sense data in a buffer
+ * @desc:	Sense format (non zero == descriptor format,
+ * 		0 == fixed format)
+ * @buf:	Where to build sense data
+ * @key:	Sense key
+ * @asc:	Additional sense code
+ * @ascq:	Additional sense code qualifier
+ *
+ **/
+void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq)
+{
+	if (desc) {
+		buf[0] = 0x72;	/* descriptor, current */
+		buf[1] = key;
+		buf[2] = asc;
+		buf[3] = ascq;
+		buf[7] = 0;
+	} else {
+		buf[0] = 0x70;	/* fixed, current */
+		buf[2] = key;
+		buf[7] = 0xa;
+		buf[12] = asc;
+		buf[13] = ascq;
+	}
+}
+EXPORT_SYMBOL(scsi_build_sense_buffer);
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 37a7614..d3a133b 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -57,7 +57,9 @@ extern const u8 * scsi_sense_desc_find(const u8 * sense_buffer, int sb_len,
 
 extern int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
 				   u64 * info_out);
- 
+
+extern void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq);
+
 /*
  * Reset request from external source
  */
-- 
1.5.3.7

