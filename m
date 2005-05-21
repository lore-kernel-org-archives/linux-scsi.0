From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC 1/2] add transport scan callout to fix sysfs layout
	when scanning from userspace
Date: Sat, 21 May 2005 14:37:11 -0700
Message-ID: <1116711431.6285.28.camel@mina>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:29928 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S261629AbVEUVhT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 May 2005 17:37:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi <open-iscsi@googlegroups.com>, linux-scsi@vger.kernel.org

When scanning hosts that implement FC rport support and
open-iscsi/linux-iscsi-5 hosts from userspace the sysfs
layout will end up placing the target's parent as the host
instead of some transport specific object. For FC the
target's parent should be the rport and for open-iscsi the
parent should be a session (that is if for open-iscsi our
using struct devices and our sysfs layout is correct).

The problem is due to the scsi host scan attribute calling
scsi_scan_host_selected, but the transports calling
scsi_scan_target. To further complicate matters iscsi does
not use a work queue for scanning since it initiates the
scanning from usersapce and it manages its channel and target
numbers from userspace. And, FC rport support is the opposite.

To fix this the inlined patch just adds a scan callout onto
the scsi_transport_template so scsi_sysfs can call it if set.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff -aurp linux-2.6.12-rc4/drivers/scsi/scsi_sysfs.c linux-2.6.12-rc4.work/drivers/scsi/scsi_sysfs.c
--- linux-2.6.12-rc4/drivers/scsi/scsi_sysfs.c	2005-05-06 22:20:31.000000000 -0700
+++ linux-2.6.12-rc4.work/drivers/scsi/scsi_sysfs.c	2005-05-20 23:08:08.000000000 -0700
@@ -80,7 +80,11 @@ static int scsi_scan(struct Scsi_Host *s
 		return -EINVAL;
 	if (check_set(&lun, s3))
 		return -EINVAL;
-	res = scsi_scan_host_selected(shost, channel, id, lun, 1);
+
+	if (shost->transportt->scan)
+		res = shost->transportt->scan(shost, channel, id, lun, 1);
+	else
+		res = scsi_scan_host_selected(shost, channel, id, lun, 1);
 	return res;
 }
 
diff -aurp linux-2.6.12-rc4/include/scsi/scsi_transport.h linux-2.6.12-rc4.work/include/scsi/scsi_transport.h
--- linux-2.6.12-rc4/include/scsi/scsi_transport.h	2005-05-06 22:20:31.000000000 -0700
+++ linux-2.6.12-rc4.work/include/scsi/scsi_transport.h	2005-05-20 23:12:38.000000000 -0700
@@ -39,6 +39,12 @@ struct scsi_transport_template {
 	 * True if the transport wants to use a host-based work-queue
 	 */
 	unsigned int create_work_queue : 1;
+
+	/*
+	 * optional transport specific scanning function
+	 */
+	int (* scan)(struct Scsi_Host *, unsigned int, unsigned int,
+		     unsigned int, int);
 };
 
 #define transport_class_to_shost(tc) \


