From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] allow NULL dev argument to scsi_add_host
Date: Sat, 11 Jan 2003 20:33:17 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030111203317.A25836@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

We need scsi_add_host sometimes without having a struct device (i.e.
eisa/vlb drivers, ieee1394 storage), so handle that case gracefully.


--- 1.41/drivers/scsi/hosts.c	Mon Dec 16 10:59:41 2002
+++ edited/drivers/scsi/hosts.c	Sat Jan 11 19:06:56 2003
@@ -314,9 +314,10 @@
  **/
 int scsi_add_host(struct Scsi_Host *shost, struct device *dev)
 {
-	dev->class_data = shost;
-	shost->host_gendev = dev;
-
+	if (dev) {
+		dev->class_data = shost;
+		shost->host_gendev = dev;
+	}
 	return __scsi_add_host(shost);
 }
 
