From: Sam Protsenko <semen.protsenko@linaro.org>
Subject: [PATCH 1/2] codafs: Fix build using bare-metal toolchain
Date: Tue, 28 Aug 2018 17:24:20 +0300
Message-ID: <20180828142421.15335-2-semen.protsenko@linaro.org>
References: <20180828142421.15335-1-semen.protsenko@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180828142421.15335-1-semen.protsenko@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, codalist@coda.cs.cmu.edu, coda@cs.cmu.edu
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Praneeth Bajjuri <praneeth@ti.com>, Paul Sokolovsky <paul.sokolovsky@linaro.org>, Miklos Szeredi <mszeredi@suse.cz>, Sumit Semwal <sumit.semwal@linaro.org>, Ruslan Bilovol <ruslan.bilovol@gmail.com>, Andy Shevchenko <andy.shevchenko@gmail.com>
List-Id: linux-scsi@vger.kernel.org

The kernel is self-contained project and can be built with bare-metal
toolchain. But bare-metal toolchain doesn't define u_quad_t type.
Because of this codafs build fails when building with bare-metal
toolchain. This patch fixes it by defining u_quad_t type in case when
non-Linux toolchain is used.

Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
---
 include/uapi/linux/coda.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/coda.h b/include/uapi/linux/coda.h
index 695fade33c64..098a6c318b0a 100644
--- a/include/uapi/linux/coda.h
+++ b/include/uapi/linux/coda.h
@@ -96,6 +96,11 @@ typedef unsigned long long u_quad_t;
 #endif /* !KERNEL */
 #endif /* !DJGPP */
 
+/* Handle bare-metal toolchain case */
+#if defined(__KERNEL__) && !defined(__linux__) && !defined(_UQUAD_T_) && \
+!defined(__UQUAD_TYPE)
+typedef unsigned long long u_quad_t;
+#endif
 
 #if defined(__linux__)
 #include <linux/time.h>
-- 
2.18.0
