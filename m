From: Dave Young <hidave.darkstar@gmail.com>
Subject: [PATCH 5/7] scsi : use class iteration api
Date: Sat, 12 Jan 2008 17:55:17 +0800
Message-ID: <20080112095517.GE2893@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:16895 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762408AbYALJvz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Jan 2008 04:51:55 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1455493fga.17
        for <linux-scsi@vger.kernel.org>; Sat, 12 Jan 2008 01:51:54 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Convert to use the class iteration api.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
 drivers/scsi/hosts.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff -upr linux/drivers/scsi/hosts.c linux.new/drivers/scsi/hosts.c
--- linux/drivers/scsi/hosts.c	2008-01-12 15:54:16.000000000 +0800
+++ linux.new/drivers/scsi/hosts.c	2008-01-12 15:54:16.000000000 +0800
@@ -429,6 +429,17 @@ void scsi_unregister(struct Scsi_Host *s
 }
 EXPORT_SYMBOL(scsi_unregister);
 
+static int __scsi_host_match(struct class_device *cdev, void *data)
+{
+	struct Scsi_Host *p;
+	unsigned short *hostnum = (unsigned short *)data;
+
+	p = class_to_shost(cdev);
+	if (p->host_no == *hostnum)
+		return 1;
+	return 0;
+}
+
 /**
  * scsi_host_lookup - get a reference to a Scsi_Host by host no
  *
@@ -439,19 +450,12 @@ EXPORT_SYMBOL(scsi_unregister);
  **/
 struct Scsi_Host *scsi_host_lookup(unsigned short hostnum)
 {
-	struct class *class = &shost_class;
 	struct class_device *cdev;
-	struct Scsi_Host *shost = ERR_PTR(-ENXIO), *p;
+	struct Scsi_Host *shost = ERR_PTR(-ENXIO);
 
-	down(&class->sem);
-	list_for_each_entry(cdev, &class->children, node) {
-		p = class_to_shost(cdev);
-		if (p->host_no == hostnum) {
-			shost = scsi_host_get(p);
-			break;
-		}
-	}
-	up(&class->sem);
+	cdev = class_find_child(&shost_class, &hostnum, __scsi_host_match);
+	if (cdev)
+		shost = scsi_host_get(class_to_shost(cdev));
 
 	return shost;
 }
