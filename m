From: Dave Young <hidave.darkstar@gmail.com>
Subject: [PATCH 10/12] scsi : Use mutex instead of semaphore in driver core
Date: Sat, 29 Dec 2007 09:17:07 +0800
Message-ID: <20071229011707.GK2883@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:28780 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbXL2BNU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Dec 2007 20:13:20 -0500
Received: by fg-out-1718.google.com with SMTP id e21so2033935fga.17
        for <linux-scsi@vger.kernel.org>; Fri, 28 Dec 2007 17:13:19 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
drivers/scsi/hosts.c |    4 ++--
1 file changed, 2 insertions(+), 2 deletions(-)

diff -upr linux/drivers/scsi/hosts.c linux.new/drivers/scsi/hosts.c
--- linux/drivers/scsi/hosts.c	2007-12-28 10:45:46.000000000 +0800
+++ linux.new/drivers/scsi/hosts.c	2007-12-28 10:46:19.000000000 +0800
@@ -441,7 +441,7 @@ struct Scsi_Host *scsi_host_lookup(unsig
 	struct class_device *cdev;
 	struct Scsi_Host *shost = ERR_PTR(-ENXIO), *p;
 
-	down(&class->sem);
+	mutex_lock(&class->mutex);
 	list_for_each_entry(cdev, &class->children, node) {
 		p = class_to_shost(cdev);
 		if (p->host_no == hostnum) {
@@ -449,7 +449,7 @@ struct Scsi_Host *scsi_host_lookup(unsig
 			break;
 		}
 	}
-	up(&class->sem);
+	mutex_unlock(&class->mutex);
 
 	return shost;
 }
