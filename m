From: Sinan Kaya <okaya@codeaurora.org>
Subject: [PATCH 3/4] scsi: fix compiler warning for sg
Date: Wed,  4 Nov 2015 23:46:28 -0500
Message-ID: <1446698789-19308-3-git-send-email-okaya@codeaurora.org>
References: <1446698789-19308-1-git-send-email-okaya@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446698789-19308-1-git-send-email-okaya@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, timur@codeaurora.org, cov@codeaurora.org, jcm@redhat.com
Cc: Sinan Kaya <okaya@codeaurora.org>, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The MULDIV macro has been designed for small
numbers. It emits an overflow warning on 64 bit
systems. This patch places type casts in the
parameters to fix the compiler warning.

Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
---
 drivers/scsi/sg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 9d7b7db..eb2739d 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -88,7 +88,10 @@ static void sg_proc_cleanup(void);
  * Of course an overflow is inavoidable if the result of muldiv doesn't fit
  * in 32 bits.
  */
-#define MULDIV(X,MUL,DIV) ((((X % DIV) * MUL) / DIV) + ((X / DIV) * MUL))
+static inline u64 MULDIV(u64 X, u32 MUL, u32 DIV)
+{
+	return ((((X % DIV) * MUL) / DIV) + ((X / DIV) * MUL));
+}
 
 #define SG_DEFAULT_TIMEOUT MULDIV(SG_DEFAULT_TIMEOUT_USER, HZ, USER_HZ)
 
-- 
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
