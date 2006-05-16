From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH] fusion - doesn't compile when CONFIG_PM disabled
Date: Tue, 16 May 2006 17:32:15 -0600
Message-ID: <20060516233215.GA28891@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:23038 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932077AbWEPXgl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 19:36:41 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com

The fusion driver fail to compile when CONFIG_PM is disabled.
This is due to a recent patch I posted to handle dv after resume.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

diff -uarN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2006-05-16 15:45:41.000000000 -0600
+++ a/drivers/message/fusion/mptspi.c	2006-05-16 15:46:37.000000000 -0600
@@ -834,6 +834,7 @@
 /*
  * spi module resume handler
  */
+#ifdef CONFIG_PM
 static int
 mptspi_resume(struct pci_dev *pdev)
 {
@@ -846,6 +847,7 @@
 
 	return rc;
 }
+#endif
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
