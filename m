From: akpm@linux-foundation.org
Subject: [patch 11/17] scsi: use the common hex_asc array rather than a private one
Date: Mon, 22 Sep 2008 14:56:48 -0700
Message-ID: <200809222156.m8MLundg032294@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753808AbYIVV5Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2008 17:57:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, harvey.harrison@gmail.com

From: Harvey Harrison <harvey.harrison@gmail.com>

Also use the hi/lo helpers.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ibmmca.c    |    3 +--
 drivers/scsi/ultrastor.c |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/ibmmca.c~scsi-use-the-common-hex_asc-array-rather-than-a-private-one drivers/scsi/ibmmca.c
--- a/drivers/scsi/ibmmca.c~scsi-use-the-common-hex_asc-array-rather-than-a-private-one
+++ a/drivers/scsi/ibmmca.c
@@ -1002,12 +1002,11 @@ static char *ti_p(int dev)
 /* interpreter for logical device numbers (ldn) */
 static char *ti_l(int val)
 {
-	const char hex[16] = "0123456789abcdef";
 	static char answer[2];
 
 	answer[1] = (char) (0x0);
 	if (val <= MAX_LOG_DEV)
-		answer[0] = hex[val];
+		answer[0] = hex_asc[val];
 	else
 		answer[0] = '-';
 	return (char *) &answer;
diff -puN drivers/scsi/ultrastor.c~scsi-use-the-common-hex_asc-array-rather-than-a-private-one drivers/scsi/ultrastor.c
--- a/drivers/scsi/ultrastor.c~scsi-use-the-common-hex_asc-array-rather-than-a-private-one
+++ a/drivers/scsi/ultrastor.c
@@ -876,8 +876,8 @@ static int ultrastor_abort(struct scsi_c
 	for (i = 0; i < 16; i++)
 	  {
 	    unsigned char p = inb(port0 + i);
-	    out[28 + i * 3] = "0123456789abcdef"[p >> 4];
-	    out[29 + i * 3] = "0123456789abcdef"[p & 15];
+	    out[28 + i * 3] = hex_asc_hi(p);
+	    out[29 + i * 3] = hex_asc_lo(p);
 	    out[30 + i * 3] = ' ';
 	  }
 	out[28 + i * 3] = '\n';
_
