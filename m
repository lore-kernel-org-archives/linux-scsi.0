From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: sim710_device_remove seems buggy
Date: Tue, 17 Jul 2007 12:52:16 -0600
Message-ID: <20070717185216.GF14791@parisc-linux.org>
References: <20070717165521.GE14791@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:34540 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003AbXGQSwR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 14:52:17 -0400
Content-Disposition: inline
In-Reply-To: <20070717165521.GE14791@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Hirst <rhirst@levanta.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Jul 17, 2007 at 10:55:21AM -0600, Matthew Wilcox wrote:
> Unfortunately, I don't have a good idea about how to solve this.  The
> least lame perhaps is to have separate routines for EISA and MCA
> devices, each of which passes the shost to this routine.

I had an idea.  How does this look?  It's what I'm doing in advansys.
Note that I've not tested it more than compilation ... need to get the
EISA configurator running on parisc-linux in order to test it.

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
 

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
