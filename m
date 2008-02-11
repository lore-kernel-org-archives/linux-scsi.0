From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] sym53c416: fix module parameters
Date: Mon, 11 Feb 2008 16:18:55 -0600
Message-ID: <1202768335.3122.67.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57666 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753458AbYBKWS6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Feb 2008 17:18:58 -0500
Received: from localhost (localhost [127.0.0.1])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 1AF9E897E
	for <linux-scsi@vger.kernel.org>; Mon, 11 Feb 2008 16:18:57 -0600 (CST)
Received: from accolon.hansenpartnership.com ([127.0.0.1])
	by localhost (redscar.int.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n0imd+S-hp8U for <linux-scsi@vger.kernel.org>;
	Mon, 11 Feb 2008 16:18:56 -0600 (CST)
Received: from [153.66.150.222] (mulgrave-w.int.hansenpartnership.com [153.66.150.222])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id EF2EC897B
	for <linux-scsi@vger.kernel.org>; Mon, 11 Feb 2008 16:18:55 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

It looks like there's been a bug in the module parameter setup forever.
The upshot doesn't really matter, because even if no parameters are ever
set, we just call sym53c416_setup() three times, but the zero values in
the arrays eventually cause nothing to happen.  Unfortunately gcc has
started to notice this now too:

drivers/scsi/sym53c416.c: In function 'sym53c416_detect':
drivers/scsi/sym53c416.c:624: warning: the address of 'sym53c416' will always evaluate as 'true'
drivers/scsi/sym53c416.c:630: warning: the address of 'sym53c416_1' will always evaluate as 'true'
drivers/scsi/sym53c416.c:636: warning: the address of 'sym53c416_2' will always evaluate as 'true'
drivers/scsi/sym53c416.c:642: warning: the address of 'sym53c416_3' will always evaluate as 'true'

So fix this longstanding bug to keep gcc quiet.

James

---

diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
index 6325901..f7d2795 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -187,10 +187,10 @@
 #define sym53c416_base_2 sym53c416_2
 #define sym53c416_base_3 sym53c416_3
 
-static unsigned int sym53c416_base[2] = {0,0};
-static unsigned int sym53c416_base_1[2] = {0,0};
-static unsigned int sym53c416_base_2[2] = {0,0};
-static unsigned int sym53c416_base_3[2] = {0,0};
+static unsigned int sym53c416_base[2];
+static unsigned int sym53c416_base_1[2];
+static unsigned int sym53c416_base_2[2];
+static unsigned int sym53c416_base_3[2];
 
 #endif
 
@@ -621,25 +621,25 @@ int __init sym53c416_detect(struct scsi_host_template *tpnt)
 	int ints[3];
 
 	ints[0] = 2;
-	if(sym53c416_base)
+	if(sym53c416_base[0])
 	{
 		ints[1] = sym53c416_base[0];
 		ints[2] = sym53c416_base[1];
 		sym53c416_setup(NULL, ints);
 	}
-	if(sym53c416_base_1)
+	if(sym53c416_base_1[0])
 	{
 		ints[1] = sym53c416_base_1[0];
 		ints[2] = sym53c416_base_1[1];
 		sym53c416_setup(NULL, ints);
 	}
-	if(sym53c416_base_2)
+	if(sym53c416_base_2[0])
 	{
 		ints[1] = sym53c416_base_2[0];
 		ints[2] = sym53c416_base_2[1];
 		sym53c416_setup(NULL, ints);
 	}
-	if(sym53c416_base_3)
+	if(sym53c416_base_3[0])
 	{
 		ints[1] = sym53c416_base_3[0];
 		ints[2] = sym53c416_base_3[1];


