From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Subject: [PATCH] scsi: eata: drop VLA in reorder()
Date: Sun, 11 Mar 2018 22:06:58 +0100
Message-ID: <1520802418-17284-1-git-send-email-s.mesoraca16@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dario Ballabio <ballabio_dario@emc.com>, Kees Cook <keescook@chromium.org>, Salvatore Mesoraca <s.mesoraca16@gmail.com>
List-Id: linux-scsi@vger.kernel.org

n_ready will always be less than or equal to MAX_MAILBOXES.
So we avoid a VLA[1] and use fixed-length arrays instead.

[1] https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
 drivers/scsi/eata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 6501c33..202cd17 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -2096,7 +2096,7 @@ static int reorder(struct hostdata *ha, unsigned long cursec,
 	unsigned int k, n;
 	unsigned int rev = 0, s = 1, r = 1;
 	unsigned int input_only = 1, overlap = 0;
-	unsigned long sl[n_ready], pl[n_ready], ll[n_ready];
+	unsigned long sl[MAX_MAILBOXES], pl[MAX_MAILBOXES], ll[MAX_MAILBOXES];
 	unsigned long maxsec = 0, minsec = ULONG_MAX, seek = 0, iseek = 0;
 	unsigned long ioseek = 0;
 
-- 
1.9.1
