From: Nishanth Aravamudan <nacc@us.ibm.com>
Subject: [PATCH] scsi_debug: dev_size_mb <= 0 fix
Date: Thu, 5 Aug 2004 14:35:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040805213547.GA3856@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:17552 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S267983AbUHEVfy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Aug 2004 17:35:54 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

Hi,

While working on getting 10000 scsi_debug disks working simultaneously,
I came across a problem with the driver. According to the webpage,

``All simulated dummy devices share the same RAM. If a value of 0 or
less is given then dev_size_mb is forced to 1 so 1 MB of RAM is used.''

However, when I sent in dev_size_mb=0, the module would return an "Out
of memory" error. I discovered that there was no check for a
zero/negative value for dev_size_mb and thus a vmalloc(0) resulted,
which apparently results in a NULL pointer and the driver thinks there
is no memory available.

I believe the patch below fixes this.


Applys-to: 2.6.7

Description: Adds check for non-positive value of
scsi_debug_dev_size_mb, as per the description on the scsi_debug web
page. If the parameter is given as 0 or less, then the size of the
reserved RAM is defaulted to 1MB. Compile-tested and run-tested.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>

--- linux-vanilla/drivers/scsi/scsi_debug.c	2004-06-15 22:19:37.000000000 -0700
+++ linux-dev/drivers/scsi/scsi_debug.c	2004-08-05 14:16:47.000000000 -0700
@@ -1491,6 +1491,10 @@ static int __init scsi_debug_init(void)
 	int host_to_add;
 	int k;
 
+	/* if dev_size_mb is passed as <= 0, then it is forced to 1. */
+	if (scsi_debug_dev_size_mb <= 0)
+		scsi_debug_dev_size_mb = 1;
+
 	sdebug_store_size = (unsigned long)scsi_debug_dev_size_mb * 1048576;
 	sdebug_capacity = sdebug_store_size / SECT_SIZE;
 
