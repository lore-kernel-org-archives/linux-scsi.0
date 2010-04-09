From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 05/12] libfc: fix hton24 macro to take expressions as args
Date: Fri, 09 Apr 2010 14:22:39 -0700
Message-ID: <20100409212238.1968.68620.stgit@localhost.localdomain>
References: <20100409212212.1968.59251.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53131 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757346Ab0DIVWl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2010 17:22:41 -0400
In-Reply-To: <20100409212212.1968.59251.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

hton24(p + 3, value) would fail to compile because
p + 3[0] is not a valid expression.

Went ahead and converted hton24 and ntoh24 to inline
functions, which is better because the parameters
are evalutated only once.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 include/scsi/libfc.h |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 8d0d1b2..a26bb50 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -47,13 +47,18 @@
 #define ntohll(x) be64_to_cpu(x)
 #define htonll(x) cpu_to_be64(x)
 
-#define ntoh24(p) (((p)[0] << 16) | ((p)[1] << 8) | ((p)[2]))
 
-#define hton24(p, v)	do {			\
-		p[0] = (((v) >> 16) & 0xFF);	\
-		p[1] = (((v) >> 8) & 0xFF);	\
-		p[2] = ((v) & 0xFF);		\
-	} while (0)
+static inline u32 ntoh24(const u8 *p)
+{
+	return (p[0] << 16) | (p[1] << 8) | p[2];
+}
+
+static inline void hton24(u8 *p, u32 v)
+{
+	p[0] = (v >> 16) & 0xff;
+	p[1] = (v >> 8) & 0xff;
+	p[2] = v & 0xff;
+}
 
 /**
  * enum fc_lport_state - Local port states

