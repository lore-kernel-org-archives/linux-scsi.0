From: Adrian Bunk <bunk@fs.tum.de>
Subject: [2.6 patch] fix megaraid.c with PROC_FS=n
Date: Mon, 9 Aug 2004 17:43:09 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040809154308.GT26174@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:38132 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S266303AbUHIPnW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Aug 2004 11:43:22 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

I got the following compile error with CONFIG_PROC_FS=n:

<--  snip  -->

...
  LD      .tmp_vmlinux1
drivers/built-in.o(.text+0x524563): In function `megaraid_probe_one':
: undefined reference to `mega_create_proc_entry'
make: *** [.tmp_vmlinux1] Error 1

<--  snip  -->


The following patch fixes this issue:


Signed-off-by: Adrian Bunk <bunk@fs.tum.de>

--- linux-2.6.8-rc3-mm2-full/drivers/scsi/megaraid.c.old	2004-08-09 17:35:54.000000000 +0200
+++ linux-2.6.8-rc3-mm2-full/drivers/scsi/megaraid.c	2004-08-09 17:39:58.000000000 +0200
@@ -4905,7 +4905,9 @@
 
 	pci_set_drvdata(pdev, host);
 
+#ifdef CONFIG_PROC_FS
 	mega_create_proc_entry(hba_count, mega_proc_dir_entry);
+#endif
 
 	error = scsi_add_host(host, &pdev->dev);
 	if (error)


