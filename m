From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: [PATCH 2.4] sym53c8xx_2 sniff inquiry fix
Date: Mon, 5 Apr 2004 11:24:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <04Apr5.112407edt.332198@cyborg.cybernetics.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:25866 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S262849AbUDEPY0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Apr 2004 11:24:26 -0400
List-Id: linux-scsi@vger.kernel.org
To: willy@debian.org
Cc: linux-scsi@vger.kernel.org

The following patch fixes a problem where sym53c8xx_2 always sniffs a
value of 0x00 for inquiry byte 56, which breaks 160 MB/s negotiations.

I am working with lk 2.4.x; I don't know if this needs to be applied to
lk 2.6.x also.

--- drivers/scsi/sym53c8xx_2/sym_misc.c.orig	Mon Apr  5 11:03:28 2004
+++ drivers/scsi/sym53c8xx_2/sym_misc.c	Mon Apr  5 11:03:38 2004
@@ -315,7 +315,7 @@
 	 */
 	inq_byte56 = tp->inq_byte56;
 	if (inq_version >= 4 && inq_len > 56)
-		tp->inq_byte56 = inq_data[56];
+		inq_byte56 = inq_data[56];
 #if 0
 printf("XXXXXX [%d] inq_version=%x inq_byte7=%x inq_byte56=%x XXXXX\n",
 	inq_len, inq_version, inq_byte7, inq_byte56);



Anthony J. Battersby
Cybernetics

