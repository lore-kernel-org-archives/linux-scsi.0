From: akpm@osdl.org
Subject: [patch 19/36] ioremap balanced with iounmap for drivers/scsi/qlogicpti.c
Date: Tue, 10 Oct 2006 14:41:36 -0700
Message-ID: <200610102141.k9ALfaDM025417@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:60318 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030470AbWJJVmx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Oct 2006 17:42:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, amol@verismonetworks.com

From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result in a
memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/qlogicpti.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/scsi/qlogicpti.c~ioremap-balanced-with-iounmap-drivers-scsi-qlogicptic drivers/scsi/qlogicpti.c
--- a/drivers/scsi/qlogicpti.c~ioremap-balanced-with-iounmap-drivers-scsi-qlogicptic
+++ a/drivers/scsi/qlogicpti.c
@@ -699,6 +699,7 @@ static int __init qpti_map_regs(struct q
 					  "PTI Qlogic/ISP statreg");
 		if (!qpti->sreg) {
 			printk("PTI: Qlogic/ISP status register is unmappable\n");
+			sbus_iounmap(qpti->qregs, qpti->sdev->reg_addrs[0].reg_size);
 			return -1;
 		}
 	}
_
