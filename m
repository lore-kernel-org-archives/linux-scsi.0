From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: sim710_device_remove seems buggy
Date: Tue, 17 Jul 2007 13:38:03 -0600
Message-ID: <20070717193802.GG14791@parisc-linux.org>
References: <20070717165521.GE14791@parisc-linux.org> <20070717185216.GF14791@parisc-linux.org> <1184698668.3378.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54477 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936031AbXGQTiE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 15:38:04 -0400
Content-Disposition: inline
In-Reply-To: <1184698668.3378.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Richard Hirst <rhirst@levanta.com>, linux-scsi@vger.kernel.org

On Tue, Jul 17, 2007 at 01:57:48PM -0500, James Bottomley wrote:
> That's certainly the way lasi700 does it ... so it makes sense that this
> driver should as well.

OK.  Here's a patch to fix all the other drivers that had copied this
one:

Fix drivers misusing dev_to_shost

Some drivers were using dev_to_shost to go from a struct device to the
corresponding shost.  Unfortunately, dev_to_shost only looks up the tree
to find an shost (it's designed to go from a scsi_device or a
scsi_target to the parent scsi_host), and these drivers were calling it
with the parent of the scsi_host.

I've fixed this by saving a pointer to the Scsi_Host in the drvdata,
which matches what most scsi drivers do.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/drivers/scsi/a4000t.c b/drivers/scsi/a4000t.c
index 6a57846..0c758d1 100644
--- a/drivers/scsi/a4000t.c
+++ b/drivers/scsi/a4000t.c
@@ -79,6 +79,7 @@ static int __devinit a4000t_probe(struct device *dev)
 		goto out_put_host;
 	}
 
+	dev_set_drvdata(dev, host);
 	scsi_scan_host(host);
 
 	return 0;
@@ -95,7 +96,7 @@ static int __devinit a4000t_probe(struct device *dev)
 
 static __devexit int a4000t_device_remove(struct device *dev)
 {
-	struct Scsi_Host *host = dev_to_shost(dev);
+	struct Scsi_Host *host = dev_get_drvdata(dev);
 	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
 
 	scsi_remove_host(host);
diff --git a/drivers/scsi/bvme6000_scsi.c b/drivers/scsi/bvme6000_scsi.c
index 012cdea..cac3540 100644
--- a/drivers/scsi/bvme6000_scsi.c
+++ b/drivers/scsi/bvme6000_scsi.c
@@ -74,6 +74,7 @@ bvme6000_probe(struct device *dev)
 		goto out_put_host;
 	}
 
+	dev_set_drvdata(dev, host);
 	scsi_scan_host(host);
 
 	return 0;
@@ -89,7 +90,7 @@ bvme6000_probe(struct device *dev)
 static __devexit int
 bvme6000_device_remove(struct device *dev)
 {
-	struct Scsi_Host *host = dev_to_shost(dev);
+	struct Scsi_Host *host = dev_get_drvdata(dev);
 	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
 
 	scsi_remove_host(host);
diff --git a/drivers/scsi/mvme16x_scsi.c b/drivers/scsi/mvme16x_scsi.c
index d6ef22a..1bdddad 100644
--- a/drivers/scsi/mvme16x_scsi.c
+++ b/drivers/scsi/mvme16x_scsi.c
@@ -89,6 +89,7 @@ mvme16x_probe(struct device *dev)
 		out_be32(0xfff4202c, v);
 	}
 
+	dev_set_drvdata(dev, host);
 	scsi_scan_host(host);
 
 	return 0;
@@ -104,7 +105,7 @@ mvme16x_probe(struct device *dev)
 static __devexit int
 mvme16x_device_remove(struct device *dev)
 {
-	struct Scsi_Host *host = dev_to_shost(dev);
+	struct Scsi_Host *host = dev_get_drvdata(dev);
 	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
 
 	/* Disable scsi chip ints */
diff --git a/drivers/scsi/sim710.c b/drivers/scsi/sim710.c
index 018c65f..6ab11b4 100644
--- a/drivers/scsi/sim710.c
+++ b/drivers/scsi/sim710.c
@@ -139,6 +139,7 @@ sim710_probe_common(struct device *dev, unsigned long base_addr,
 		goto out_put_host;
 	}
 
+	dev_set_drvdata(dev, host);
 	scsi_scan_host(host);
 
 	return 0;
@@ -156,7 +157,7 @@ sim710_probe_common(struct device *dev, unsigned long base_addr,
 static __devexit int
 sim710_device_remove(struct device *dev)
 {
-	struct Scsi_Host *host = dev_to_shost(dev);
+	struct Scsi_Host *host = dev_get_drvdata(dev);
 	struct NCR_700_Host_Parameters *hostdata =
 		(struct NCR_700_Host_Parameters *)host->hostdata[0];
 
diff --git a/drivers/scsi/zorro7xx.c b/drivers/scsi/zorro7xx.c
index 5070387..c822deb 100644
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -130,6 +130,7 @@ static int __devinit zorro7xx_init_one(struct zorro_dev *z,
 		goto out_put_host;
 	}
 
+	zorro_set_drvdata(z, host);
 	scsi_scan_host(host);
 
 	return 0;
@@ -148,7 +149,7 @@ static int __devinit zorro7xx_init_one(struct zorro_dev *z,
 
 static __devexit void zorro7xx_remove_one(struct zorro_dev *z)
 {
-	struct Scsi_Host *host = dev_to_shost(&z->dev);
+	struct Scsi_Host *host = zorro_get_drvdata(z);
 	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
 
 	scsi_remove_host(host);

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
