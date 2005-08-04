From: "Hmamouche, Youssef" <youssef@ece.utexas.edu>
Subject: [PATCH] [SCSI] megaraid: add check for NULL pointer
Date: Thu, 4 Aug 2005 01:07:50 -0500 (CDT)
Message-ID: <Pine.LNX.4.61.0508040023020.14176@linux08.ece.utexas.edu>
Reply-To: youssef@ece.utexas.edu
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hendrix.ece.utexas.edu ([128.83.59.42]:43405 "EHLO
	hendrix.ece.utexas.edu") by vger.kernel.org with ESMTP
	id S261852AbVHDGH6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2005 02:07:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, youssef@ece.utexas.edu


This patch adds a check for NULL return from kmalloc.

Signed-off-by: Youssef Hmamouche <hyoussef@gmail.com>


--- a/drivers/scsi/megaraid.c   2005-08-03 21:12:43.000000000 -0700
+++ b/drivers/scsi/megaraid.c   2005-08-03 21:14:37.000000000 -0700
@@ -4456,6 +4456,10 @@
         memset(scmd, 0, sizeof(Scsi_Cmnd));

         sdev = kmalloc(sizeof(struct scsi_device), GFP_KERNEL);
+       if(sdev == NULL) {
+               printk(KERN_WARNING "megaraid: out of RAM.\n");
+               return -ENOMEM;
+       }
         memset(sdev, 0, sizeof(struct scsi_device));
         scmd->device = sdev;

