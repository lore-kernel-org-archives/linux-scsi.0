From: Jamie Lenehan <lenehan@twibble.org>
Subject: Re: [PATCH] introduce scsi_host_alloc
Date: Fri, 6 Jun 2003 21:40:18 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030606114018.GA20458@twibble.org>
References: <20030606080103.GC18838@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charon.twibble.org ([203.217.29.134]:11439 "EHLO
	egwene.twibble.org") by vger.kernel.org with ESMTP id S261169AbTFFL0w
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jun 2003 07:26:52 -0400
Content-Disposition: inline
In-Reply-To: <20030606080103.GC18838@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, dc395x@twibble.org

On Fri, Jun 06, 2003 at 10:01:03AM +0200, Christoph Hellwig wrote:
> Rediffed version, with Mike's isp fix and taking the new
> scsi_add_host users in usb in account.
> 
> Currently this is juist a new name for scsi_register, but we make
> sure new-style drivers never call scsi_register/scsi_unregister
> but always scsi_host_alloc/scsi_host_put in this patch so the
> next patch can introduce code specific to legacy drivers in
> the former.  Also cleanup scsi_register/scsi_host_alloc a bit.

I think I made the dc395x driver new style init as of 2.5.70-bk9 (if
what scsi_mid_low_api.txt calls "hotplug" style is new style then it
is). So it'll need to be updated as well.

Patch against 2.5.70-bk9. Untested, just modified the names as per
your other changes.


diff -du -r a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	2003-06-06 21:27:00.000000000 +1000
+++ b/drivers/scsi/dc395x.c	2003-06-06 21:28:47.000000000 +1000
@@ -5726,9 +5726,9 @@
 	/*
 	 *$$$$$$$$$$$  MEMORY ALLOCATE FOR ADAPTER CONTROL BLOCK $$$$$$$$$$$$
 	 */
-	host = scsi_register(host_template, sizeof(struct AdapterCtlBlk));
+	host = scsi_host_alloc(host_template, sizeof(struct AdapterCtlBlk));
 	if (!host) {
-		dprintkl(KERN_INFO, "pSH scsi_register ERROR\n");
+		dprintkl(KERN_INFO, "pSH scsi_host_alloc ERROR\n");
 		return 0;
 	}
 	DC395x_print_eeprom_settings(index);
@@ -5736,7 +5736,7 @@
 	pACB = (struct AdapterCtlBlk *) host->hostdata;
 
 	if (DC395x_initACB(host, io_port, irq, index)) {
-		scsi_unregister(host);
+		scsi_host_put(host);
 		return 0;
 	}
 	DC395x_print_config(pACB);
@@ -5755,7 +5755,7 @@
 
 	} else {
 		dprintkl(KERN_INFO, "DC395x_initAdapter initial ERROR\n");
-		scsi_unregister(host);
+		scsi_host_put(host);
 		host = NULL;
 	}
 	return host;

-- 
 Jamie Lenehan              Work Phone: +61 3 9843 8817
 lenehan@twibble.org        Work Email: jamie.lenehan@activcard.com.au
