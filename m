From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] aic7xxx_Makefile fix
Date: Mon, 16 Dec 2002 21:52:46 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021216210038.2142D2C273@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Kai Germaschewski <kai@tp1.ruhr-uni-bochum.de>, linux-scsi@vger.kernel.org

From:  junio@siamese.dyndns.org

  Patch against 2.4.19.  If you are in a (good) habit of making
  all the upstream sources read-only before starting your build,
  generation of the firmware code fails because it tries to write
  into read-only files.  This bites only in configurations where
  CONFIG_AIC7XXX_BUILD_FIRMWARE is set to 'y'. 
  

--- trivial-2.4.21-pre1/drivers/scsi/aic7xxx/Makefile.orig	2002-12-16 17:22:40.000000000 +1100
+++ trivial-2.4.21-pre1/drivers/scsi/aic7xxx/Makefile	2002-12-16 17:22:40.000000000 +1100
@@ -39,6 +39,7 @@
 $(obj-aic7xxx): aic7xxx_reg.h
 
 aic7xxx_seq.h aic7xxx_reg.h: aic7xxx.seq aic7xxx.reg aicasm/aicasm
+	rm -f aic7xxx_seq.h aic7xxx_reg.h
 	aicasm/aicasm -I. -r aic7xxx_reg.h -o aic7xxx_seq.h aic7xxx.seq
 endif
 
-- 
  Don't blame me: the Monkey is driving
  File: junio@siamese.dyndns.org: [TRIVIAL] aic7xxx_Makefile fix
