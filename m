From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH -mm 1/6] add IOMMU helper functions for the free area
 management
Date: Fri, 7 Dec 2007 23:56:39 +0900
Message-ID: <20071207235649E.tomof@acm.org>
References: <21710c4b9cd6848e70e29949dfb54894e9aabbe6.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:53678 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756316AbXLGO5k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2007 09:57:40 -0500
In-Reply-To: <21710c4b9cd6848e70e29949dfb54894e9aabbe6.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, muli@il.ibm.com, benh@kernel.crashing.org, paulus@samba.org, olof@lixom.net, anton@samba.org, fujita.tomonori@lab.ntt.co.jp

This adds IOMMU helper functions for the free area management. These
functions take care of LLD's segment boundary limit for IOMMUs. They
would be useful for IOMMUs that use bitmap for the free area
management.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/iommu-helper.h |    7 ++++
 lib/Makefile                 |    1 +
 lib/iommu-helper.c           |   76 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 84 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/iommu-helper.h
 create mode 100644 lib/iommu-helper.c

diff --git a/include/linux/iommu-helper.h b/include/linux/iommu-helper.h
new file mode 100644
index 0000000..4dd4c04
--- /dev/null
+++ b/include/linux/iommu-helper.h
@@ -0,0 +1,7 @@
+extern unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
+				      unsigned long start, unsigned int nr,
+				      unsigned long shift,
+				      unsigned long boundary_size,
+				      unsigned long align_mask);
+extern void iommu_area_free(unsigned long *map, unsigned long start,
+			    unsigned int nr);
diff --git a/lib/Makefile b/lib/Makefile
index b862b90..17fb758 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -65,6 +65,7 @@ obj-$(CONFIG_SMP) += pcounter.o
 obj-$(CONFIG_AUDIT_GENERIC) += audit.o
 
 obj-$(CONFIG_SWIOTLB) += swiotlb.o
+obj-$(CONFIG_IOMMU_HELPER) += iommu-helper.o
 obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
new file mode 100644
index 0000000..e7d8544
--- /dev/null
+++ b/lib/iommu-helper.c
@@ -0,0 +1,76 @@
+/*
+ * IOMMU helper functions for the free area management
+ */
+
+#include <linux/module.h>
+#include <linux/bitops.h>
+
+static unsigned long find_next_zero_area(unsigned long *map,
+					 unsigned long size,
+					 unsigned long start,
+					 unsigned int nr)
+{
+	unsigned long index, end, i;
+again:
+	index = find_next_zero_bit(map, size, start);
+	end = index + nr;
+	if (end > size)
+		return -1;
+	for (i = index + 1; i < end; i++) {
+		if (test_bit(i, map)) {
+			start = i+1;
+			goto again;
+		}
+	}
+	return index;
+}
+
+static inline void set_bit_area(unsigned long *map, unsigned long i,
+				int len)
+{
+	unsigned long end = i + len;
+	while (i < end) {
+		__set_bit(i, map);
+		i++;
+	}
+}
+
+static inline int is_span_boundary(unsigned int index, unsigned int nr,
+				   unsigned long shift,
+				   unsigned long boundary_size)
+{
+	shift = (shift + index) & (boundary_size - 1);
+	return shift + nr > boundary_size;
+}
+
+unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
+			       unsigned long start, unsigned int nr,
+			       unsigned long shift, unsigned long boundary_size,
+			       unsigned long align_mask)
+{
+	unsigned long index;
+again:
+	index = find_next_zero_area(map, size, start, nr);
+	if (index != -1) {
+		index = (index + align_mask) & ~align_mask;
+		if (is_span_boundary(index, nr, shift, boundary_size)) {
+			/* we could do more effectively */
+			start = index + 1;
+			goto again;
+		}
+		set_bit_area(map, index, nr);
+	}
+	return index;
+}
+EXPORT_SYMBOL(iommu_area_alloc);
+
+void iommu_area_free(unsigned long *map, unsigned long start, unsigned int nr)
+{
+	unsigned long end = start + nr;
+
+	while (start < end) {
+		__clear_bit(start, map);
+		start++;
+	}
+}
+EXPORT_SYMBOL(iommu_area_free);
-- 
1.5.3.4

