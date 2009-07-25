From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] eata: Buffer overflow
Date: Sun, 26 Jul 2009 01:05:24 +0200
Message-ID: <4A6B8FB4.2030603@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:40235 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbZGYXCt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Jul 2009 19:02:49 -0400
Received: by ey-out-2122.google.com with SMTP id 9so643490eyd.37
        for <linux-scsi@vger.kernel.org>; Sat, 25 Jul 2009 16:02:48 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ballabio_dario@emc.com, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

allows i == MAX_INT_PARAM, which is out of range

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index c7076ce..3c5abf7 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1509,7 +1509,7 @@ static int option_setup(char *str)
 	char *cur = str;
 	int i = 1;
 
-	while (cur && isdigit(*cur) && i <= MAX_INT_PARAM) {
+	while (cur && isdigit(*cur) && i < MAX_INT_PARAM) {
 		ints[i++] = simple_strtoul(cur, NULL, 0);
 
 		if ((cur = strchr(cur, ',')) != NULL)
