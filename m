From: Jens Axboe <axboe@suse.de>
Subject: [PATCH] ncr53c8xx bad queuecommand return
Date: Fri, 19 Nov 2004 09:56:01 +0100
Message-ID: <20041119085601.GA26240@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:7870 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261312AbUKSI42 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 03:56:28 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Hi,

One more case of returning non-zero with a completed command.

Signed-off-by: Jens Axboe <axboe@suse.de>

===== drivers/scsi/ncr53c8xx.c 1.50 vs edited =====
--- 1.50/drivers/scsi/ncr53c8xx.c	2004-11-11 09:43:34 +01:00
+++ edited/drivers/scsi/ncr53c8xx.c	2004-11-19 09:06:28 +01:00
@@ -7517,6 +7517,7 @@ printk("ncr53c8xx : command successfully
      if (sts != DID_OK) {
           unmap_scsi_data(np, cmd);
           done(cmd);
+	  sts = 0;
      }
 
      return sts;

-- 
Jens Axboe

