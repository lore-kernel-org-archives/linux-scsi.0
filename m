From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] first bug fixes for 2.6.27-rc1
Date: Mon, 28 Jul 2008 19:17:11 -0500
Message-ID: <1217290631.3503.176.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35097 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063AbYG2ARm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2008 20:17:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

This is the missed delay.h include in qla2xxx

available from:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

Entire commit below.

James

---

>From 00eabe7c4478f38b42d632763c4878ced5a1f25c Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 28 Jul 2008 11:59:20 +0900
Subject: [SCSI] qla2xxx: fix msleep compile error

drivers/scsi/qla2xxx/qla_attr.c: In function 'qla24xx_vport_delete':
drivers/scsi/qla2xxx/qla_attr.c:1184: error: implicit declaration of function 'msleep'
make[3]: *** [drivers/scsi/qla2xxx/qla_attr.o] Error 1
make[3]: *** Waiting for unfinished jobs....

Reported-by: David Miller <davem@davemloft.net>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 7a4409a..a319a20 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -8,6 +8,7 @@
 
 #include <linux/kthread.h>
 #include <linux/vmalloc.h>
+#include <linux/delay.h>
 
 static int qla24xx_vport_disable(struct fc_vport *, bool);
 
-- 
1.5.5.1



