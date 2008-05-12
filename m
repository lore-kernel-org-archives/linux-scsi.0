From: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH 1/5] [ARM] rpc: acornscsi: remove unused 'ADDR' macro
Date: Mon, 12 May 2008 18:02:13 +0100
Message-ID: <git-1210611733-c1d6fd45bee4baae1053913f93912b1a88d2706f@dyn-67.arm.linux.org.uk>
References: <20080512170914.GB25110@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39300 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbYELRNy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 May 2008 13:13:54 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LAK <linux-arm-kernel@lists.arm.linux.org.uk>

From: Russell King <rmk@dyn-67.arm.linux.org.uk>

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/scsi/arm/acornscsi-io.S |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/arm/acornscsi-io.S b/drivers/scsi/arm/acornscsi-io.S
index 93467e6..3c5d4f8 100644
--- a/drivers/scsi/arm/acornscsi-io.S
+++ b/drivers/scsi/arm/acornscsi-io.S
@@ -10,19 +10,6 @@
 #include <asm/assembler.h>
 #include <asm/hardware.h>
 
-#if (IO_BASE == (PCIO_BASE & 0xff000000))
-#define ADDR(off,reg)						\
-		tst	off, $0x80000000			;\
-		mov	reg, $IO_BASE				;\
-		orreq	reg, reg, $(PCIO_BASE & 0x00ff0000)
-#else
-#define ADDR(off,reg)						\
-		tst	off, $0x80000000			;\
-		movne	reg, $IO_BASE				;\
-		moveq	reg, $(PCIO_BASE & 0xff000000)		;\
-		orreq	reg, reg, $(PCIO_BASE & 0x00ff0000)
-#endif
-
 @ Purpose: transfer a block of data from the acorn scsi card to memory
 @ Proto  : void acornscsi_in(unsigned int addr_start, char *buffer, int length)
 @ Returns: nothing
