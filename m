From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [PATCH 63] drivers/scsi/pluto.c: mostly kmalloc + memset conversion to kcalloc
Date: Tue, 31 Jul 2007 23:46:40 +0200
Message-ID: <200707312346.41518.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3755 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396AbXGaVqm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jul 2007 17:46:42 -0400
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

This patch does kmalloc + memset conversion to kcalloc. Also the following warning is fixed.

  CC      drivers/scsi/pluto.o
  drivers/scsi/pluto.c: In function 'pluto_info':
  drivers/scsi/pluto.c:283: warning: unused variable 'p'

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/pluto.c | 8787 -> 8657 (-130 bytes)
 drivers/scsi/pluto.o | 125264 -> 124648 (-616 bytes)

 drivers/scsi/pluto.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/scsi/pluto.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/pluto.c	2007-07-31 18:18:38.000000000 +0200
@@ -111,13 +111,12 @@ int __init pluto_detect(struct scsi_host
 #endif
 			return 0;
 	}
-	fcs = kmalloc(sizeof (struct ctrl_inquiry) * fcscount, GFP_DMA);
+	fcs = kcalloc(fcscount, sizeof(struct ctrl_inquiry), GFP_DMA);
 	if (!fcs) {
 		printk ("PLUTO: Not enough memory to probe\n");
 		return 0;
 	}

-	memset (fcs, 0, sizeof (struct ctrl_inquiry) * fcscount);
 	memset (&dev, 0, sizeof(dev));
 	atomic_set (&fcss, fcscount);

@@ -211,12 +210,12 @@ int __init pluto_detect(struct scsi_host
 				char *p;
 				long *ages;

-				ages = kmalloc (((inq->channels + 1) * inq->targets) * sizeof(long), GFP_KERNEL);
-				if (!ages) continue;
+				ages = kcalloc((inq->channels + 1) * inq->targets, sizeof(long), GFP_KERNEL);
+				if (!ages)
+					continue;

 				host = scsi_register (tpnt, sizeof (struct pluto));
-				if(!host)
-				{
+				if (!host) {
 					kfree(ages);
 					continue;
 				}
@@ -238,7 +237,6 @@ int __init pluto_detect(struct scsi_host
 				fc->channels = inq->channels + 1;
 				fc->targets = inq->targets;
 				fc->ages = ages;
-				memset (ages, 0, ((inq->channels + 1) * inq->targets) * sizeof(long));

 				pluto->fc = fc;
 				memcpy (pluto->rev_str, inq->revision, 4);
@@ -260,7 +258,7 @@ int __init pluto_detect(struct scsi_host
 		} else
 			fc->fcp_register(fc, TYPE_SCSI_FCP, 1);
 	}
-	kfree((char *)fcs);
+	kfree(fcs);
 	if (nplutos)
 		printk ("PLUTO: Total of %d SparcSTORAGE Arrays found\n", nplutos);
 	return nplutos;
@@ -282,15 +280,19 @@ int pluto_release(struct Scsi_Host *host

 const char *pluto_info(struct Scsi_Host *host)
 {
-	static char buf[128], *p;
+	static char buf[128];
 	struct pluto *pluto = (struct pluto *) host->hostdata;

 	sprintf(buf, "SUN SparcSTORAGE Array %s fw %s serial %s %dx%d on %s",
 		pluto->rev_str, pluto->fw_rev_str, pluto->serial_str,
 		host->max_channel, host->max_id, pluto->fc->name);
 #ifdef __sparc__
-	p = strchr(buf, 0);
-	sprintf(p, " PROM node %x", pluto->fc->dev->prom_node);
+	{
+		char *p;
+
+		p = strchr(buf, 0);
+		sprintf(p, " PROM node %x", pluto->fc->dev->prom_node);
+	}
 #endif
 	return buf;
 }
