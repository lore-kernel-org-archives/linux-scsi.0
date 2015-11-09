From: Sinan Kaya <okaya@codeaurora.org>
Subject: [PATCH V2 2/3] scsi: fix compiler warning for sg
Date: Sun,  8 Nov 2015 20:57:45 -0500
Message-ID: <1447034266-28003-3-git-send-email-okaya@codeaurora.org>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, timur@codeaurora.org, cov@codeaurora.org, jcm@redhat.com
Cc: agross@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Sinan Kaya <okaya@codeaurora.org>, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The MULDIV macro has been designed for small numbers.
Compiler emits an overflow warning on 64 bit systems.
This patch uses 64 bit numbers in order to suppress
warning.

Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
---
 drivers/scsi/sg.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 9d7b7db..112d8974 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -51,6 +51,7 @@ static int sg_version_num = 30536;	/* 2 digits for each component */
 #include <linux/atomic.h>
 #include <linux/ratelimit.h>
 #include <linux/uio.h>
+#include <asm/div64.h>
 
 #include "scsi.h"
 #include <scsi/scsi_dbg.h>
@@ -85,12 +86,17 @@ static void sg_proc_cleanup(void);
  * Replacing muldiv(x) by muldiv(x)=((x % d) * m) / d + int(x / d) * m
  * calculates the same, but prevents the overflow when both m and d
  * are "small" numbers (like HZ and USER_HZ).
- * Of course an overflow is inavoidable if the result of muldiv doesn't fit
- * in 32 bits.
  */
-#define MULDIV(X,MUL,DIV) ((((X % DIV) * MUL) / DIV) + ((X / DIV) * MUL))
+static inline u64 mult_frac64(u64 x, u32 numer, u32 denom)
+{
+	u64 r1 = do_div(x, denom);
+	u64 r2 = r1 * numer;
+
+	do_div(r2, denom);
+	return (x * numer) + r2;
+}
 
-#define SG_DEFAULT_TIMEOUT MULDIV(SG_DEFAULT_TIMEOUT_USER, HZ, USER_HZ)
+#define SG_DEFAULT_TIMEOUT mult_frac64(SG_DEFAULT_TIMEOUT_USER, HZ, USER_HZ)
 
 int sg_big_buff = SG_DEF_RESERVED_SIZE;
 /* N.B. This variable is readable and writeable via
@@ -877,10 +883,10 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 			return result;
 		if (val < 0)
 			return -EIO;
-		if (val >= MULDIV (INT_MAX, USER_HZ, HZ))
-		    val = MULDIV (INT_MAX, USER_HZ, HZ);
+		if (val >= mult_frac64(INT_MAX, USER_HZ, HZ))
+			val = mult_frac64(INT_MAX, USER_HZ, HZ);
 		sfp->timeout_user = val;
-		sfp->timeout = MULDIV (val, HZ, USER_HZ);
+		sfp->timeout = mult_frac64(val, HZ, USER_HZ);
 
 		return 0;
 	case SG_GET_TIMEOUT:	/* N.B. User receives timeout as return value */
-- 
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
