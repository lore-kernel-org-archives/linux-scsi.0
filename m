From: akpm@linux-foundation.org
Subject: [patch 10/12] lkdtm: fix for CONFIG_SCSI=n
Date: Wed, 30 Jul 2008 12:44:28 -0700
Message-ID: <200807301944.m6UJiSab012906@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754124AbYG3TxQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2008 15:53:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, randy.dunlap@oracle.com, ankita@in.ibm.com

From: Randy Dunlap <randy.dunlap@oracle.com>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix lkdtm test code for case of CONFIG_SCSI=n, to avoid build errors:

In file included from linux-next-20080618/tests/lkdtm.c:55:
linux-next-20080618/include/scsi/scsi_cmnd.h:28:25: warning: "BLK_MAX_CDB" is not defined
linux-next-20080618/include/scsi/scsi_cmnd.h:29:3: error: #error MAX_COMMAND_SIZE can not be bigger than BLK_MAX_CDB
In file included from linux-next-20080618/tests/lkdtm.c:55:
linux-next-20080618/include/scsi/scsi_cmnd.h: In function 'scsi_bidi_cmnd':
linux-next-20080618/include/scsi/scsi_cmnd.h:183: error: implicit declaration of function 'blk_bidi_rq'
linux-next-20080618/include/scsi/scsi_cmnd.h:184: error: dereferencing pointer to incomplete type
linux-next-20080618/include/scsi/scsi_cmnd.h: In function 'scsi_in':
linux-next-20080618/include/scsi/scsi_cmnd.h:190: error: dereferencing pointer to incomplete type
make[2]: *** [tests/lkdtm.o] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Ankita Garg <ankita@in.ibm.com> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tests/lkdtm.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN tests/lkdtm.c~lkdtm-fix-for-config_scsi=n tests/lkdtm.c
--- a/tests/lkdtm.c~lkdtm-fix-for-config_scsi=n
+++ a/tests/lkdtm.c
@@ -53,7 +53,9 @@
 #include <linux/interrupt.h>
 #include <linux/hrtimer.h>
 #include <linux/ide.h>
+#ifdef CONFIG_SCSI
 #include <scsi/scsi_cmnd.h>
+#endif
 
 #define NUM_CPOINTS 8
 #define NUM_CPOINT_TYPES 5
@@ -172,12 +174,14 @@ static int jp_hrtimer_start(struct hrtim
 	return 0;
 }
 
+#ifdef CONFIG_SCSI
 static int jp_scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 {
 	lkdtm_handler();
 	jprobe_return();
 	return 0;
 }
+#endif
 
 #ifdef CONFIG_IDE
 int jp_generic_ide_ioctl(ide_drive_t *drive, struct file *file,
@@ -304,8 +308,12 @@ static int __init lkdtm_module_init(void
 		lkdtm.entry = (kprobe_opcode_t*) jp_hrtimer_start;
 		break;
 	case SCSI_DISPATCH_CMD:
+#ifdef CONFIG_SCSI
 		lkdtm.kp.symbol_name = "scsi_dispatch_cmd";
 		lkdtm.entry = (kprobe_opcode_t*) jp_scsi_dispatch_cmd;
+#else
+		printk(KERN_INFO "lkdtm : Crash point not available\n");
+#endif
 		break;
 	case IDE_CORE_CP:
 #ifdef CONFIG_IDE
_
