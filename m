From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/scsi/ibmmca.c: fix a NULL pointer dereference
Date: Fri, 10 Mar 2006 23:24:47 +0100
Message-ID: <20060310222447.GX21864@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:10756 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1752197AbWCJWYr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Mar 2006 17:24:47 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: langa2@kph.uni-mainz.de
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The variable was dereferenced only if it was NULL (sic)...

Spotted by the Coverity checker.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.16-rc5-mm3-full/drivers/scsi/ibmmca.c.old	2006-03-10 20:39:03.000000000 +0100
+++ linux-2.6.16-rc5-mm3-full/drivers/scsi/ibmmca.c	2006-03-10 20:41:47.000000000 +0100
@@ -2357,8 +2357,7 @@ static int ibmmca_proc_info(struct Scsi_
 	spin_lock_irqsave(hosts[i]->host_lock, flags);	/* Check it */
 	host_index = i;
 	if (!shpnt) {
-		len += sprintf(buffer + len, "\nIBM MCA SCSI: Can't find adapter for host number %d\n",
-				shpnt->host_no);
+		len += sprintf(buffer + len, "\nIBM MCA SCSI: Can't find adapter");
 		return len;
 	}
 	max_pun = subsystem_maxid(host_index);

