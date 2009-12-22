From: akpm@linux-foundation.org
Subject: [patch 04/19] scsi/eata: fix buffer overflow
Date: Mon, 21 Dec 2009 16:27:41 -0800
Message-ID: <200912220027.nBM0Rfdx005370@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594AbZLVA2L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Dec 2009 19:28:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, roel.kluin@gmail.com, ballabio_dario@emc.com, mike@i-Connect.Net

From: Roel Kluin <roel.kluin@gmail.com>

Allows i == MAX_INT_PARAM, which is out of range.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Michael Neuffer <mike@i-Connect.Net>
Cc: Dario Ballabio <ballabio_dario@emc.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/eata.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/eata.c~scsi-eata-fix-buffer-overflow drivers/scsi/eata.c
--- a/drivers/scsi/eata.c~scsi-eata-fix-buffer-overflow
+++ a/drivers/scsi/eata.c
@@ -1509,7 +1509,7 @@ static int option_setup(char *str)
 	char *cur = str;
 	int i = 1;
 
-	while (cur && isdigit(*cur) && i <= MAX_INT_PARAM) {
+	while (cur && isdigit(*cur) && i < MAX_INT_PARAM) {
 		ints[i++] = simple_strtoul(cur, NULL, 0);
 
 		if ((cur = strchr(cur, ',')) != NULL)
_
