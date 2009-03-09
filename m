From: ib@wupperonline.de (Ingo Brueckl)
Subject: [PATCH] unnecessary SCSI module
Date: Mon, 09 Mar 2009 20:06:00 +0100
Message-ID: <49b5689f@wupperonline.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755312AbZCIUoV@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When configuring MODULES with the kernel to be able to load external drivers
coming as modules, but not using anything as module in the kernel itself, one
would expect to end up in a module-free kernel. Currently, you don't if you
use SCSI. You'll get one unnecessary module.

Please consider the attached patch.

Signed-off-by: Ingo Brueckl <ib@wupperonline.de>

--- linux-2.6.28/drivers/scsi/Kconfig.orig	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28/drivers/scsi/Kconfig	2009-03-06 22:49:40.000000000 +0100
@@ -259,7 +259,7 @@ config SCSI_SCAN_ASYNC
 config SCSI_WAIT_SCAN
 	tristate
 	default m
-	depends on SCSI
+	depends on SCSI = m || SCSI_SCAN_ASYNC = y
 	depends on MODULES

 menu "SCSI Transports"
