From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH]Add scsi_add_host() failure handling for nsp32
Date: Tue, 10 Jan 2006 14:11:52 +0100
Message-ID: <200601101411.52585.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751000AbWAJNME@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, GOTO Masanori <gotom@debian.or.jp>, gotom@debian.org
List-Id: linux-scsi@vger.kernel.org

From: Jesper Juhl <jesper.juhl@gmail.com>

Add scsi_add_host() failure handling for nsp32
and silence warning.
  drivers/scsi/nsp32.c:2888: warning: ignoring return value of csi_add_host', declared with attribute warn_unused_result

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/scsi/nsp32.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

--- linux-2.6.15-mm2-orig/drivers/scsi/nsp32.c	2006-01-07 14:46:18.000000000 +0100
+++ linux-2.6.15-mm2/drivers/scsi/nsp32.c	2006-01-10 14:07:00.000000000 +0100
@@ -2885,7 +2885,12 @@ static int nsp32_detect(struct scsi_host
         }
 
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
-	scsi_add_host (host, &PCIDEV->dev);
+	ret = scsi_add_host (host, &PCIDEV->dev);
+	if (ret) {
+		printk(KERN_WARNING "nsp32: scsi_add_host failed\n");
+		scsi_host_put(host);
+		return ret;
+	}
 	scsi_scan_host(host);
 #endif
 	pci_set_drvdata(PCIDEV, host);





PS. Please CC me on replies from linux-scsi since I'm not subscribed there.

-- 
Jesper Juhl
