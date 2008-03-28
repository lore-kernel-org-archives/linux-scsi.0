From: akpm@linux-foundation.org
Subject: [patch 12/17] ips.c: fix build warning
Date: Fri, 28 Mar 2008 14:48:40 -0700
Message-ID: <200803282148.m2SLmeDg012249@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757407AbYC1VtW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2008 17:49:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, Mark_Salyzyn@adaptec.com, aacraid@adaptec.com, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org

From: Andrew Morton <akpm@linux-foundation.org>

powerpc:

drivers/scsi/ips.c: In function 'ips_issue_copperhead':
drivers/scsi/ips.c:5436: warning: large integer implicitly truncated to unsigned type

it doesn't seem necessary to do outw(cpu_to_le32(...), ...) anyway.

Acked-by: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: <aacraid@adaptec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ips.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ips.c~ipsc-fix-build-warning drivers/scsi/ips.c
--- a/drivers/scsi/ips.c~ipsc-fix-build-warning
+++ a/drivers/scsi/ips.c
@@ -5399,7 +5399,7 @@ ips_issue_copperhead(ips_ha_t * ha, ips_
 	}			/* end while */
 
 	outl(cpu_to_le32(scb->scb_busaddr), ha->io_addr + IPS_REG_CCSAR);
-	outw(cpu_to_le32(IPS_BIT_START_CMD), ha->io_addr + IPS_REG_CCCR);
+	outw(cpu_to_le16(IPS_BIT_START_CMD), ha->io_addr + IPS_REG_CCCR);
 
 	return (IPS_SUCCESS);
 }
_
