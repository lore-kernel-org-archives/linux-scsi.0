From: Nick Krause <xerofoiify@gmail.com>
Subject: [PATCH] scsi: Check if WSR already defined
Date: Thu,  7 Aug 2014 07:38:37 +0200
Message-ID: <1407389918-10463-1-git-send-email-xerofoiify@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, "James E.J. Bottomley" <JBottomley@parallels.com>, "open list:LSILOGIC/SYMBIOS/..." <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On xtensa arch there is this warning

drivers/scsi/sym53c8xx_2/sym_defs.h:109:0: warning: "WSR" redefined [enabled by default]
arch/xtensa/include/asm/processor.h:188:0: note: this is the location of the previous definition

I can remove WSR since it is not being used but more documentation purpose, so
undefining is enough.

Signed-off-by: Nick Krause <xerofoify@gmail.com>
---
 drivers/scsi/sym53c8xx_2/sym_defs.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/sym53c8xx_2/sym_defs.h b/drivers/scsi/sym53c8xx_2/sym_defs.h
index defccc4..68334a5 100644
--- a/drivers/scsi/sym53c8xx_2/sym_defs.h
+++ b/drivers/scsi/sym53c8xx_2/sym_defs.h
@@ -91,6 +91,10 @@ struct sym_chip {
 #define FE_CACHE0_SET	(FE_CACHE_SET & ~FE_ERL)
 };
 
+#ifdef WSR
+#undef WSR
+#endif
+
 /*
  *	SYM53C8XX IO register data structure.
  */
-- 
2.0.1
