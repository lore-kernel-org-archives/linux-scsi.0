From: Hifumi Hisashi <hifumi.hisashi@lab.ntt.co.jp>
Subject: [PATCH] sym2: Use ORDERED_QUEUE_TAG when barrier request is
  issued
Date: Tue, 14 Feb 2006 01:10:54 +0900
Message-ID: <6.0.0.20.2.20060214004351.0424e5a0@129.60.53.12>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:23180 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1750801AbWBMQKt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Feb 2006 11:10:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org

Hi.
I think using ORDERED_QUEUE_TAG is preferable instead of
SIMPLE_QUEUE_TAG when a request with barrier flag is
issued.

Thanks.

Signed-off-by: Hifumi Hisashi <hifumi.hisashi@lab.ntt.co.jp>

--- linux-2.6.16-rc3/drivers/scsi/sym53c8xx_2/sym_hipd.c	2006-02-13 
14:04:02.000000000 +0900
+++ linux-2.6.16-rc3_fix/drivers/scsi/sym53c8xx_2/sym_hipd.c	2006-02-13 
14:36:47.000000000 +0900
@@ -41,6 +41,7 @@
  #include <linux/slab.h>
  #include <asm/param.h>		/* for timeouts in units of HZ */
  #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_tcq.h>

  #include "sym_glue.h"
  #include "sym_nvram.h"
@@ -5109,6 +5110,9 @@
  			lp->tags_since = 0;
  		}
  #endif
+		if (cmd->request && cmd->request->flags & REQ_HARDBARRIER)
+                        order = M_ORDERED_TAG;
+
  		msgptr[msglen++] = order;

  		/* 

