From: adam radford <aradford@gmail.com>
Subject: [PATCH 1/7] megaraid_sas: Remove un-needed completion_lock spinlock calls
Date: Mon, 1 Oct 2012 19:26:50 -0700
Message-ID: <CAHtARFEL6m6PveTnckb6OjpEs7pwqOeNjwkJK=YwmizyU4DKaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf307f37b430444604cb0a4103
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48521 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757846Ab2JBC0v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Oct 2012 22:26:51 -0400
Received: by mail-vc0-f174.google.com with SMTP id fo13so6426342vcb.19
        for <linux-scsi@vger.kernel.org>; Mon, 01 Oct 2012 19:26:50 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Kashyap Desai <Kashyap.Desai@lsi.com>

--20cf307f37b430444604cb0a4103
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas removes some un-needed
completion_lock spinlock calls.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas_fusion.c	2012-10-01
15:51:15.218956132 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2012-10-01
16:52:32.515019501 -0700
@@ -1855,10 +1855,8 @@
 	}
 	spin_unlock_irqrestore(&instance->hba_lock, flags);

-	spin_lock_irqsave(&instance->completion_lock, flags);
 	for (MSIxIndex = 0 ; MSIxIndex < count; MSIxIndex++)
 		complete_cmd_fusion(instance, MSIxIndex);
-	spin_unlock_irqrestore(&instance->completion_lock, flags);
 }

 /**

--20cf307f37b430444604cb0a4103
Content-Type: application/octet-stream; name="megaraid_sas.patch1"
Content-Disposition: attachment; filename="megaraid_sas.patch1"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19m
dXNpb24uYyBzY3NpLW1pc2MubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNf
ZnVzaW9uLmMKLS0tIHNjc2ktbWlzYy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2Fz
X2Z1c2lvbi5jCTIwMTItMTAtMDEgMTU6NTE6MTUuMjE4OTU2MTMyIC0wNzAwCisrKyBzY3NpLW1p
c2MubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmMJMjAxMi0x
MC0wMSAxNjo1MjozMi41MTUwMTk1MDEgLTA3MDAKQEAgLTE4NTUsMTAgKzE4NTUsOCBAQAogCX0K
IAlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZpbnN0YW5jZS0+aGJhX2xvY2ssIGZsYWdzKTsKIAot
CXNwaW5fbG9ja19pcnFzYXZlKCZpbnN0YW5jZS0+Y29tcGxldGlvbl9sb2NrLCBmbGFncyk7CiAJ
Zm9yIChNU0l4SW5kZXggPSAwIDsgTVNJeEluZGV4IDwgY291bnQ7IE1TSXhJbmRleCsrKQogCQlj
b21wbGV0ZV9jbWRfZnVzaW9uKGluc3RhbmNlLCBNU0l4SW5kZXgpOwotCXNwaW5fdW5sb2NrX2ly
cXJlc3RvcmUoJmluc3RhbmNlLT5jb21wbGV0aW9uX2xvY2ssIGZsYWdzKTsKIH0KIAogLyoqCg==
--20cf307f37b430444604cb0a4103--
