From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 1/6] ilog2: create truly constant version for sparse
Date: Wed, 18 Apr 2018 01:35:06 +0200
Message-ID: <20180417233511.6573-2-mwilck@suse.com>
References: <20180417233511.6573-1-mwilck@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180417233511.6573-1-mwilck@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Sparse emits errors about ilog2() in array indices because of the use of
__ilog2_32() and __ilog2_64(), rightly so
(https://www.spinics.net/lists/linux-sparse/msg03471.html).

Create a const_ilog2() variant that works with sparse for this
scenario.

(Note: checkpatch.pl complains about missing parentheses, but that appears
to be a false positive. I can get rid of the warning simply by inserting
whitespace, making checkpatch "see" the whole macro).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 include/linux/log2.h | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/include/linux/log2.h b/include/linux/log2.h
index 41a1ae0..2af7f778 100644
--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -72,16 +72,13 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
 }
 
 /**
- * ilog2 - log base 2 of 32-bit or a 64-bit unsigned value
+ * const_ilog2 - log base 2 of 32-bit or a 64-bit constant unsigned value
  * @n: parameter
  *
- * constant-capable log of base 2 calculation
- * - this can be used to initialise global variables from constant data, hence
- * the massive ternary operator construction
- *
- * selects the appropriately-sized optimised version depending on sizeof(n)
+ * Use this where sparse expects a true constant expression, e.g. for array
+ * indices.
  */
-#define ilog2(n)				\
+#define const_ilog2(n)				\
 (						\
 	__builtin_constant_p(n) ? (		\
 		(n) < 2 ? 0 :			\
@@ -147,10 +144,26 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
 		(n) & (1ULL <<  4) ?  4 :	\
 		(n) & (1ULL <<  3) ?  3 :	\
 		(n) & (1ULL <<  2) ?  2 :	\
-		1 ) :				\
-	(sizeof(n) <= 4) ?			\
-	__ilog2_u32(n) :			\
-	__ilog2_u64(n)				\
+		1) :				\
+	-1)
+
+/**
+ * ilog2 - log base 2 of 32-bit or a 64-bit unsigned value
+ * @n: parameter
+ *
+ * constant-capable log of base 2 calculation
+ * - this can be used to initialise global variables from constant data, hence
+ * the massive ternary operator construction
+ *
+ * selects the appropriately-sized optimised version depending on sizeof(n)
+ */
+#define ilog2(n) \
+( \
+	__builtin_constant_p(n) ?	\
+	const_ilog2(n) :		\
+	(sizeof(n) <= 4) ?		\
+	__ilog2_u32(n) :		\
+	__ilog2_u64(n)			\
  )
 
 /**
-- 
2.16.1
