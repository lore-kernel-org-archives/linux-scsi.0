From: Adrian Bunk <trivial@kernel.org>
Subject: [trivial patch] scsi/ultrastor: clean up inline asm warnings (fwd)
Date: Tue, 22 Jan 2008 20:47:20 +0200
Message-ID: <20080122184720.GG26556@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp5.pp.htv.fi ([213.243.153.39]:48796 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbYAVSsq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jan 2008 13:48:46 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, Frederik Deweerdt <deweerdt@free.fr>

James, can you review and apply this patch?

TIA
Adrian


----- Forwarded message from Frederik Deweerdt <deweerdt@free.fr> -----

Date: Wed, 16 Jan 2008 17:19:08 +0100
From: Frederik Deweerdt <deweerdt@free.fr>
To: linux-kernel@vger.kernel.org
Cc: bunk@kernel.org
Subject: [trivial patch] scsi/ultrastor: clean up inline asm warnings

Hi,

Compiling latest mainline with gcc 4.2.1 spews the following warnings:

drivers/scsi/ultrastor.c: In function 'find_and_clear_bit_16':
drivers/scsi/ultrastor.c:303: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:302: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c: At top level:
drivers/scsi/ultrastor.c:1202: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:1202: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c: In function 'ultrastor_queuecommand':
drivers/scsi/ultrastor.c:698: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:698: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:698: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:698: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:698: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:698: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:698: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:302: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:302: warning: matching constraint does not allow a register

The following patch fixes it by using the '+' operator on the (*field)
operand, marking it as read-write to gcc. I diffed the two resulting .s,
and gcc produced the same code. This was tested with gcc 4.2.1 and gcc 3.4.3

$ diff -u drivers/scsi/ultrastor.s{_,}
--- drivers/scsi/ultrastor.s_   2008-01-16 16:40:01.000000000 +0100
+++ drivers/scsi/ultrastor.s    2008-01-16 16:40:19.000000000 +0100
@@ -1457,7 +1457,7 @@
        je      .L268   #,
 #APP
        xorl %ebp,%ebp  # mscp_index
-0:     bsfw config+20,%bp      # config.mscp_free, mscp_index
+       0: bsfw config+20,%bp   # config.mscp_free, mscp_index
        btr %ebp,config+20      # mscp_index, config.mscp_free
        jnc 0b
 #NO_APP
@@ -1726,9 +1726,9 @@
        call    panic   #
        .size   ultrastor_queuecommand, .-ultrastor_queuecommand
        .section        .modinfo,"a",@progbits
-       .type   __mod_license1184, @object
-       .size   __mod_license1184, 12
-__mod_license1184:
+       .type   __mod_license1191, @object
+       .size   __mod_license1191, 12
+__mod_license1191:
        .string "license=GPL"
        .section        .rodata.str1.1
 .LC27:


Regards,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index 6d1f0ed..93c5a67 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -298,9 +298,16 @@ static inline int find_and_clear_bit_16(unsigned long *field)
 {
   int rv;
 
-  if (*field == 0) panic("No free mscp");
-  asm("xorl %0,%0\n0:\tbsfw %1,%w0\n\tbtr %0,%1\n\tjnc 0b"
-      : "=&r" (rv), "=m" (*field) : "1" (*field));
+  if (*field == 0)
+    panic("No free mscp");
+
+  asm volatile (
+	"xorl %0,%0\n\t"
+	"0: bsfw %1,%w0\n\t"
+	"btr %0,%1\n\t"
+	"jnc 0b"
+	: "=&r" (rv), "=m" (*field) :);
+
   return rv;
 }
 

----- End forwarded message -----

