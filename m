From: akpm@linux-foundation.org
Subject: [patch 04/17] scsi/eata: fix buffer overflow
Date: Tue, 08 Dec 2009 14:08:57 -0800
Message-ID: <200912082208.nB8M8vsB007021@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966663AbZLHWJT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2009 17:09:19 -0500
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
