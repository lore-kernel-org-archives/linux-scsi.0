From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: scsi_devinfo.c:  Cleaning up unnecessarily complicated in conjunction with strncpy
Date: Sun, 14 Sep 2014 22:48:58 +0200
Message-ID: <1410727738-17430-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I have revamped the code so it becomes both more effective and far more clear.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/scsi_devinfo.c |   31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 49014a1..f6752cc 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -282,27 +282,18 @@ static struct scsi_dev_info_list_table *scsi_devinfo_lookup_by_key(int key)
 static void scsi_strcpy_devinfo(char *name, char *to, size_t to_length,
 				char *from, int compatible)
 {
-	size_t from_length;
-
-	from_length = strlen(from);
-	strncpy(to, from, min(to_length, from_length));
-	if (from_length < to_length) {
-		if (compatible) {
-			/*
-			 * NUL terminate the string if it is short.
-			 */
-			to[from_length] = '\0';
-		} else {
-			/* 
-			 * space pad the string if it is short. 
-			 */
-			strncpy(&to[from_length], spaces,
-				to_length - from_length);
-		}
-	}
-	if (from_length > to_length)
-		 printk(KERN_WARNING "%s: %s string '%s' is too long\n",
+	strncpy(to, from, to_length);
+	if (to[to_length - 1] != '\0') {
+		to[to_length - 1] = '\0';
+		printk(KERN_WARNING "%s: %s string '%s' is too long\n",
 			__func__, name, from);
+	}
+	if (!compatible) {
+		/*
+		 * space pad the string if it is short.
+		 */
+		strlcat(to, spaces, to_length);
+	}
 }
 
 /**
-- 
1.7.10.4
