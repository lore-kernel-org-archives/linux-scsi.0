From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch] ibmvscsi.c: remove max-sectors module parm
Date: Thu, 30 Dec 2004 18:04:48 -0600
Message-ID: <1104451489.7580.27.camel@mulgrave>
References: <20041221223645.GA2736@cs.umn.edu>
	 <1103828621.5290.42.camel@mulgrave> <20041223200153.GA18386@cs.umn.edu>
	 <1103835435.5290.45.camel@mulgrave>  <20041224003620.GA31981@cs.umn.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:16560 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261761AbULaAFo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Dec 2004 19:05:44 -0500
In-Reply-To: <20041224003620.GA31981@cs.umn.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: boutcher@cs.umn.edu
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-12-23 at 18:36 -0600, Dave C Boutcher wrote:
> > Actually, just the limit size of I/O requests with the two patches
> > rolled together (or is there nothing left of this now?)
> 
> I'm not sure I parse that...but in any case, one of the four patches
> from November limited the size of the I/O requests based on information
> from the SCSI target, with a default value in case the target doesn't
> tell us.  I got overly clever and made the default value a module
> parameter. Jens pointed out that I was being redundant, since
> there are other ways to set max sectors.  The patch I submitted
> on Tuesday leaves the basic function intact (setting max I/O size
> based on input from the target) and just removes the redundant module
> parameter.

What I mean is that after there's been argument over a patch I want an
updated diff (like the one below) with a new change log containing the
resolution, not a diff to a previous patch.

Also, in the diff below (which is why it's a good idea to do it this
way) the static parameter max_sectors now looks to be superfluous, so
you can get rid of it. 

James
--- linux-2.6.10-rc1orig/drivers/scsi/ibmvscsi/ibmvscsi.c	2004-12-01 10:46:58.413032856 -0600
+++ linux-2.6.10-rc1/drivers/scsi/ibmvscsi/ibmvscsi.c	2004-12-01 10:46:34.616058720 -0600
@@ -86,8 +86,9 @@
 static int max_channel = 3;
 static int init_timeout = 5;
 static int max_requests = 50;
+static int max_sectors = 32 * 8; /* default max I/O 32 pages */
 
-#define IBMVSCSI_VERSION "1.5.1"
+#define IBMVSCSI_VERSION "1.5.2"
 
 MODULE_DESCRIPTION("IBM Virtual SCSI");
 MODULE_AUTHOR("Dave Boutcher");
@@ -641,11 +644,16 @@
 		       evt_struct->xfer_iu->mad.adapter_info.common.status);
 	} else {
 		printk("ibmvscsi: host srp version: %s, "
-		       "host partition %s (%d), OS %d\n",
+		       "host partition %s (%d), OS %d, max io %u\n",
 		       hostdata->madapter_info.srp_version,
 		       hostdata->madapter_info.partition_name,
 		       hostdata->madapter_info.partition_number,
-		       hostdata->madapter_info.os_type);
+		       hostdata->madapter_info.os_type,
+		       hostdata->madapter_info.port_max_txu[0]);
+
+		if (hostdata->madapter_info.port_max_txu[0]) 
+		    hostdata->host->max_sectors = 
+			hostdata->madapter_info.port_max_txu[0] >> 9;
 	}
 }
 
@@ -1295,6 +1303,7 @@
 	hostdata->host = host;
 	hostdata->dev = dev;
 	atomic_set(&hostdata->request_limit, -1);
+	hostdata->host->max_sectors = max_sectors; 
 
 	if (ibmvscsi_init_crq_queue(&hostdata->queue, hostdata,
 				    max_requests) != 0) {


