From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] 2.5.30 scsi_scan.c cleanup/rewrite
Date: Thu, 8 Aug 2002 22:30:27 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020808223027.A21774@eng2.beaverton.ibm.com>
References: <20020808140616.A28275@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020808140616.A28275@eng2.beaverton.ibm.com>; from patmans@us.ibm.com on Thu, Aug 08, 2002 at 02:06:16PM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Aug 08, 2002 at 02:06:16PM -0700, Patrick Mansfield wrote:
> Hi -
> 
> Attached is cleanup/rewrite patch for scsi_scan.c against 2.5.30.
> 

There's a bug for adapters with multiple channels (like the ServeRAID
with ips driver) not being properly scanned - it scans channel 0 again
rather than going to the next channel - patch on top of the original
patch:

--- 1.23/drivers/scsi/scsi_scan.c	Thu Aug  8 09:48:01 2002
+++ edited/drivers/scsi/scsi_scan.c	Thu Aug  8 16:19:31 2002
@@ -1939,6 +1939,7 @@
 
 	sdevscan->host = shost;
 	sdevscan->id = id;
+	sdevscan->channel = channel;
 	/*
 	 * Scan LUN 0, if there is some response, scan further. Ideally, we
 	 * would not configure LUN 0 until all LUNs are scanned.

Complete patch against 2.5.30 is now at:

http://www-124.ibm.com/storageio/gen-io/patch-scsi_scan-2.5.30-2.gz

The modified scsi_scan.c file:

http://www-124.ibm.com/storageio/gen-io/scsi_scan.c-2.5.30-2.gz

Thanks.

-- Patrick Mansfield
