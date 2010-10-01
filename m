From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] qla4xxx: Fix build on some architectures lacking 64-bit I/O
Date: Fri, 01 Oct 2010 04:11:07 +0100
Message-ID: <1285902667.3916.62.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36021 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751542Ab0JADLO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Sep 2010 23:11:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Ravi Anand <ravi.anand@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, iscsi-driver@qlogic.com, linux-scsi <linux-scsi@vger.kernel.org>, 598503@bugs.debian.org

readq() and writeq() are not defined on all archictectures.  Where
they are missing, define fallback implementations (copied from
qla2xxx).

Reference: http://bugs.debian.org/598503
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
This is a regression from 2.6.35, so please include this fix in 2.6.36.

Ben.

 drivers/scsi/qla4xxx/ql4_nx.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.h b/drivers/scsi/qla4xxx/ql4_nx.h
index 931ad3f..85fe6cf 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.h
+++ b/drivers/scsi/qla4xxx/ql4_nx.h
@@ -776,4 +776,19 @@ struct crb_addr_pair {
 #define MIU_TEST_AGT_WRDATA_UPPER_LO	(0x0b0)
 #define	MIU_TEST_AGT_WRDATA_UPPER_HI	(0x0b4)
 
+#ifndef readq
+static inline u64 readq(void __iomem *addr)
+{
+	return readl(addr) | (((u64) readl(addr + 4)) << 32LL);
+}
+#endif
+
+#ifndef writeq
+static inline void writeq(u64 val, void __iomem *addr)
+{
+	writel(((u32) (val)), (addr));
+	writel(((u32) (val >> 32)), (addr + 4));
+}
+#endif
+
 #endif
-- 
1.7.1


