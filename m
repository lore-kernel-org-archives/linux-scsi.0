From: Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH 3/9] [SCSI] lpfc: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning
Date: Thu, 12 May 2011 16:50:06 -0700
Message-ID: <1305244212-19183-4-git-send-email-sboyd@codeaurora.org>
References: <1305244212-19183-1-git-send-email-sboyd@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1305244212-19183-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>
List-Id: linux-scsi@vger.kernel.org

Enabling DEBUG_STRICT_USER_COPY_CHECKS causes the following
warning:

In file included from arch/x86/include/asm/uaccess.h:573,
                 from include/linux/uaccess.h:5,
                 from include/linux/highmem.h:7,
                 from include/linux/pagemap.h:10,
                 from include/linux/blkdev.h:12,
                 from drivers/scsi/lpfc/lpfc_debugfs.c:21:
In function 'copy_from_user':
arch/x86/include/asm/uaccess_64.h:65:
warning: call to 'copy_from_user_overflow' declared with
attribute warning: copy_from_user() buffer size is not provably
correct

presumably due to buf_size being signed causing GCC to fail to
see that buf_size can't become negative.

Cc: James Smart <james.smart@emulex.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/scsi/lpfc/lpfc_debugfs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 3d96774..0af53a6 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -1305,7 +1305,8 @@ static int lpfc_idiag_cmd_get(const char __user *buf, size_t nbytes,
 {
 	char mybuf[64];
 	char *pbuf, *step_str;
-	int bsize, i;
+	int i;
+	size_t bsize;
 
 	/* Protect copy from user */
 	if (!access_ok(VERIFY_READ, buf, nbytes))
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
