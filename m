From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 13/22] scsi: Replace strnicmp with strncasecmp
Date: Tue, 16 Sep 2014 22:51:27 +0200
Message-ID: <1410900696-6481-14-git-send-email-linux@rasmusvillemoes.dk>
References: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:37065 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbaIPUwN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Sep 2014 16:52:13 -0400
Received: by mail-la0-f44.google.com with SMTP id mc6so600612lab.17
        for <linux-scsi@vger.kernel.org>; Tue, 16 Sep 2014 13:52:12 -0700 (PDT)
In-Reply-To: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics
and a slightly buggy strncasecmp. The latter is the POSIX name, so
strnicmp was renamed to strncasecmp, and strnicmp made into a wrapper
for the new strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in
the future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/scsi/ips.c        | 2 +-
 drivers/scsi/scsi_debug.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 52a216f..e5afc38 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -528,7 +528,7 @@ ips_setup(char *ips_str)
 		 * Update the variables
 		 */
 		for (i = 0; i < ARRAY_SIZE(options); i++) {
-			if (strnicmp
+			if (strncasecmp
 			    (key, options[i].option_name,
 			     strlen(options[i].option_name)) == 0) {
 				if (value)
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d19c0e3..c81af36 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3367,7 +3367,7 @@ static ssize_t opts_store(struct device_driver *ddp, const char *buf,
 	char work[20];
 
         if (1 == sscanf(buf, "%10s", work)) {
-		if (0 == strnicmp(work,"0x", 2)) {
+		if (0 == strncasecmp(work,"0x", 2)) {
 			if (1 == sscanf(&work[2], "%x", &opts))
 				goto opts_done;
 		} else {
-- 
2.0.4

