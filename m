From: Olaf Hering <olh@suse.de>
Subject: [PATCH] aic byteorder fixes after recent cleanup
Date: Tue, 19 Jul 2005 22:04:24 +0200
Message-ID: <20050719200424.GA12300@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32958 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S261603AbVGSUE0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2005 16:04:26 -0400
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 3385F1D104
	for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2005 22:04:25 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



 aic doesnt work anymore after this change which appeared int 2.6.13-rc1:
 [SCSI] aic7xxx/aic79xx: remove useless byte order macro cruft

 2 files did not include byteorder.h, aic died with panic
 "Unknown opcode encountered in seq program"
 This patch fixes it for me.


SCSI subsystem initialized
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec 2940B Ultra2 SCSI adapter>
        aic7890/91: Ultra2 Wide Channel A, SCSI Id=7, 32/253 SCBs

  Vendor: IBM       Model: DDRS-39130D       Rev: DC2A
  Type:   Direct-Access                      ANSI SCSI revision: 02
 target0:0:0: asynchronous.
scsi0:A:0:0: Tagged Queuing enabled.  Depth 32
 target0:0:0: Beginning Domain Validation
 target0:0:0: wide asynchronous.
 target0:0:0: Domain Validation skipping write tests
 target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 15)
 target0:0:0: Ending Domain Validation
SCSI device sda: 17850000 512-byte hdwr sectors (9139 MB)
SCSI device sda: drive cache: write back
SCSI device sda: 17850000 512-byte hdwr sectors (9139 MB)
SCSI device sda: drive cache: write back
 sda: [mac] sda1 sda2 sda3 sda4 sda5 sda6
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
  Vendor: IBM       Model: DNES-318350W      Rev: SA30
  Type:   Direct-Access                      ANSI SCSI revision: 03
 target0:0:2: asynchronous.
scsi0:A:2:0: Tagged Queuing enabled.  Depth 32
 target0:0:2: Beginning Domain Validation
 target0:0:2: wide asynchronous.
 target0:0:2: Domain Validation skipping write tests
 target0:0:2: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 31)
 target0:0:2: Ending Domain Validation
SCSI device sdb: 35843670 512-byte hdwr sectors (18352 MB)
SCSI device sdb: drive cache: write back
SCSI device sdb: 35843670 512-byte hdwr sectors (18352 MB)
SCSI device sdb: drive cache: write back
 sdb: [mac] sdb1 sdb2 sdb3 sdb4 sdb5 sdb6 sdb7 sdb8 sdb9 sdb10 sdb11 sdb12
Attached scsi disk sdb at scsi0, channel 0, id 2, lun 0



Signed-off-by: Olaf Hering <olh@suse.de>

 drivers/scsi/aic7xxx/aicasm/aicasm.c           |    4 ++--
 drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h |    8 +++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

Index: linux-2.6.12.aic-fixing/drivers/scsi/aic7xxx/aicasm/aicasm.c
===================================================================
--- linux-2.6.12.aic-fixing.orig/drivers/scsi/aic7xxx/aicasm/aicasm.c
+++ linux-2.6.12.aic-fixing/drivers/scsi/aic7xxx/aicasm/aicasm.c
@@ -369,7 +369,7 @@ output_code()
 
 		fprintf(ofile, "%s\t0x%02x, 0x%02x, 0x%02x, 0x%02x",
 			cur_instr == STAILQ_FIRST(&seq_program) ? "" : ",\n",
-#if BYTE_ORDER == LITTLE_ENDIAN
+#ifdef __LITTLE_ENDIAN
 			cur_instr->format.bytes[0],
 			cur_instr->format.bytes[1],
 			cur_instr->format.bytes[2],
@@ -613,7 +613,7 @@ output_listing(char *ifilename)
 				line++;
 		}
 		fprintf(listfile, "%03x %02x%02x%02x%02x", instrptr,
-#if BYTE_ORDER == LITTLE_ENDIAN
+#ifdef __LITTLE_ENDIAN
 			cur_instr->format.bytes[0],
 			cur_instr->format.bytes[1],
 			cur_instr->format.bytes[2],
Index: linux-2.6.12.aic-fixing/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
===================================================================
--- linux-2.6.12.aic-fixing.orig/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
+++ linux-2.6.12.aic-fixing/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
@@ -42,8 +42,10 @@
  * $FreeBSD$
  */
 
+#include <asm/byteorder.h>
+
 struct ins_format1 {
-#if BYTE_ORDER == LITTLE_ENDIAN
+#ifdef __LITTLE_ENDIAN
 	uint32_t	immediate	: 8,
 			source		: 9,
 			destination	: 9,
@@ -61,7 +63,7 @@ struct ins_format1 {
 };
 
 struct ins_format2 {
-#if BYTE_ORDER == LITTLE_ENDIAN
+#ifdef __LITTLE_ENDIAN
 	uint32_t	shift_control	: 8,
 			source		: 9,
 			destination	: 9,
@@ -79,7 +81,7 @@ struct ins_format2 {
 };
 
 struct ins_format3 {
-#if BYTE_ORDER == LITTLE_ENDIAN
+#ifdef __LITTLE_ENDIAN
 	uint32_t	immediate	: 8,
 			source		: 9,
 			address		: 10,
