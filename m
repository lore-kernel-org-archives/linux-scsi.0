From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] 2.5 current bk fix setting scsi queue depths
Date: Wed, 30 Oct 2002 08:58:44 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20021030085844.A11040@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi -

This patch fixes a problem with the current linus bk tree setting
scsi queue depths to 1. Please apply.

Without the patch:

[patman@elm3a50 patman]$ cat /proc/scsi/sg/device_hdr /proc/scsi/sg/devices
host    chan    id      lun     type    opens   qdepth  busy    online
0       0       0       0       0       2       1       0       1
0       0       1       0       0       1       1       0       1
0       0       15      0       3       0       1       0       1

With the patch:

[patman@elm3a50 patman]$ cat /proc/scsi/sg/device_hdr /proc/scsi/sg/devices
host    chan    id      lun     type    opens   qdepth  busy    online
0       0       0       0       0       2       253     0       1
0       0       1       0       0       1       253     0       1
0       0       15      0       3       0       2       0       1


--- 1.51/drivers/scsi/scsi.c	Tue Oct 29 01:03:27 2002
+++ edited/drivers/scsi/scsi.c	Wed Oct 30 08:36:23 2002
@@ -1511,7 +1511,6 @@
 		kfree((char *) SCpnt);
 	}
 	SDpnt->current_queue_depth = 0;
-	SDpnt->new_queue_depth = 0;
 	spin_unlock_irqrestore(&device_request_lock, flags);
 }
 
-- Patrick Mansfield
