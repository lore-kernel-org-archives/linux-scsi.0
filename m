From: akpm@osdl.org
Subject: [patch 18/19] NCR_D700 section fix
Date: Fri, 07 Jul 2006 00:02:18 -0700
Message-ID: <200607070702.k6772Ir6030657@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:11715 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751235AbWGGHCW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jul 2006 03:02:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org

From: Andrew Morton <akpm@osdl.org>

WARNING: drivers/scsi/NCR_D700.o - Section mismatch: reference to .init.data:id_array from .text after 'NCR_D700_probe' (at offset 0x2c1)

Not the right fix, really.  But the right fix isn't really feasible because
`struct mca_driver' contains pointers to probe functions (which want to be
__init) as well as containing things which need to live after initcall() time.
 Seems to be a general problem with struct device_driver.

Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/NCR_D700.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/NCR_D700.c~NCR_D700-section-fix drivers/scsi/NCR_D700.c
--- a/drivers/scsi/NCR_D700.c~NCR_D700-section-fix
+++ a/drivers/scsi/NCR_D700.c
@@ -114,7 +114,7 @@ MODULE_DESCRIPTION("NCR Dual700 SCSI Dri
 MODULE_LICENSE("GPL");
 module_param(NCR_D700, charp, 0);
 
-static __u8 __initdata id_array[2*(MCA_MAX_SLOT_NR + 1)] =
+static __u8 id_array[2*(MCA_MAX_SLOT_NR + 1)] =
 	{ [0 ... 2*(MCA_MAX_SLOT_NR + 1)-1] = 7 };
 
 #ifdef MODULE
_
