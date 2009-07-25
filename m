From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] ibmmca: Buffer overflow
Date: Sun, 26 Jul 2009 01:02:55 +0200
Message-ID: <4A6B8F1F.8090502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:63199 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbZGYXAV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Jul 2009 19:00:21 -0400
Received: by ewy26 with SMTP id 26so2457263ewy.37
        for <linux-scsi@vger.kernel.org>; Sat, 25 Jul 2009 16:00:20 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: langa2@kph.uni-mainz.de, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

allows i == IM_MAX_HOSTS, which is out of range

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 9c1e6a5..9a4b69d 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -2336,7 +2336,7 @@ static int option_setup(char *str)
 	char *cur = str;
 	int i = 1;
 
-	while (cur && isdigit(*cur) && i <= IM_MAX_HOSTS) {
+	while (cur && isdigit(*cur) && i < IM_MAX_HOSTS) {
 		ints[i++] = simple_strtoul(cur, NULL, 0);
 		if ((cur = strchr(cur, ',')) != NULL)
 			cur++;
