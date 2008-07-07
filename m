From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] sym53c8xx: Fix bogus sym_que_entry re-implementation of container_of
Date: Mon, 07 Jul 2008 10:50:25 +1000
Message-ID: <20080707005030.503A3DDE08@ozlabs.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:33300 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757373AbYGGAub (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Jul 2008 20:50:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

The sym53c8xx driver, for some reason, seems to mostly re-implement
linux/list.h with added bogosity. The main one is it's implementation
of sym_que_entry which spits warnings with recent gcc's on some
64 bits architectures.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Can somebody with that HW test the patch in case I did something
stupid ? I don't have a symbios controller at hand, it's just that
this driver is part of our defconfig :-)

 drivers/scsi/sym53c8xx_2/sym_misc.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- linux-work.orig/drivers/scsi/sym53c8xx_2/sym_misc.h	2008-07-07 10:42:03.000000000 +1000
+++ linux-work/drivers/scsi/sym53c8xx_2/sym_misc.h	2008-07-07 10:44:41.000000000 +1000
@@ -121,9 +121,7 @@ static __inline void sym_que_move(struct
 	}
 }
 
-#define sym_que_entry(ptr, type, member) \
-	((type *)((char *)(ptr)-(unsigned int)(&((type *)0)->member)))
-
+#define sym_que_entry(ptr, type, member) container_of(ptr, type, member)
 
 #define sym_insque(new, pos)		__sym_que_add(new, pos, (pos)->flink)
 
