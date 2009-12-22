From: akpm@linux-foundation.org
Subject: [patch 03/19] ibmmca: fix buffer overflow
Date: Mon, 21 Dec 2009 16:27:40 -0800
Message-ID: <200912220027.nBM0ReQY005367@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752483AbZLVA2Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Dec 2009 19:28:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, roel.kluin@gmail.com, langa2@kph.uni-mainz.de

From: Roel Kluin <roel.kluin@gmail.com>

Allows i == IM_MAX_HOSTS, which is out of range.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Michael Lang <langa2@kph.uni-mainz.de>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ibmmca.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ibmmca.c~ibmmca-buffer-overflow drivers/scsi/ibmmca.c
--- a/drivers/scsi/ibmmca.c~ibmmca-buffer-overflow
+++ a/drivers/scsi/ibmmca.c
@@ -2336,7 +2336,7 @@ static int option_setup(char *str)
 	char *cur = str;
 	int i = 1;
 
-	while (cur && isdigit(*cur) && i <= IM_MAX_HOSTS) {
+	while (cur && isdigit(*cur) && i < IM_MAX_HOSTS) {
 		ints[i++] = simple_strtoul(cur, NULL, 0);
 		if ((cur = strchr(cur, ',')) != NULL)
 			cur++;
_
