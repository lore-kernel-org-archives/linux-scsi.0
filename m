From: akpm@osdl.org
Subject: [patch 23/31] Add scsi_add_host() failure handling for nsp32
Date: Thu, 08 Jun 2006 22:23:54 -0700
Message-ID: <200606090523.k595Ntpp032334@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:43997 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965204AbWFIFY0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2006 01:24:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, gotom@sanori.org, jesper.juhl@gmail.com


From: GOTO Masanori <gotom@sanori.org>

Add scsi_add_host() failure handling for nsp32
and silence warning.
  drivers/scsi/nsp32.c:2888: warning: ignoring return value of 'Scsi_add_host', declared with attribute warn_unused_result

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: GOTO Masanori <gotom@sanori.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/nsp32.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/nsp32.c~add-scsi_add_host-failure-handling-for-nsp32 drivers/scsi/nsp32.c
--- devel/drivers/scsi/nsp32.c~add-scsi_add_host-failure-handling-for-nsp32	2006-06-01 20:41:52.000000000 -0700
+++ devel-akpm/drivers/scsi/nsp32.c	2006-06-01 20:41:52.000000000 -0700
@@ -2885,12 +2885,19 @@ static int nsp32_detect(struct scsi_host
         }
 
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
-	scsi_add_host (host, &PCIDEV->dev);
+	ret = scsi_add_host(host, &PCIDEV->dev);
+	if (ret) {
+		nsp32_msg(KERN_ERR, "failed to add scsi host");
+		goto free_region;
+	}
 	scsi_scan_host(host);
 #endif
 	pci_set_drvdata(PCIDEV, host);
 	return DETECT_OK;
 
+ free_region:
+	release_region(host->io_port, host->n_io_port);
+
  free_irq:
 	free_irq(host->irq, data);
 
_
