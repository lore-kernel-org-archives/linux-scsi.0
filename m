From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] 2.5.44 scsi-misc-2.5 fix queue depth setting
Date: Mon, 28 Oct 2002 15:08:02 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021028150802.A5891@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

James -

Here's a simple patch against your bk tree to not reset the desired
queue depth in scsi_release_commandblocks. Without this patch, if the
upper level drivers are inited after the adapters, the queue
depth is set to 1.

i.e.:

Current scsi-misc-2.5 gives me:

[patman@elm3a50 patman]$ ]$ cat /proc/scsi/sg/device_hdr /proc/scsi/sg/devices
host    chan    id      lun     type    opens   qdepth  busy    online
0       0       0       0       0       2       1       0       1
0       0       1       0       0       1       1       0       1
0       0       15      0       3       0       1       0       1

With this patch:

[patman@elm3a50 patman]$ cat /proc/scsi/sg/device_hdr /proc/scsi/sg/devices
host    chan    id      lun     type    opens   qdepth  busy    online
0       0       0       0       0       2       253     0       1
0       0       1       0       0       1       253     0       1
0       0       15      0       3       0       2       0       1

===== drivers/scsi/scsi.c 1.53 vs edited =====
--- 1.53/drivers/scsi/scsi.c	Mon Oct 28 08:54:38 2002
+++ edited/drivers/scsi/scsi.c	Mon Oct 28 13:40:22 2002
@@ -1517,7 +1517,6 @@
 		kfree((char *) SCpnt);
 	}
 	SDpnt->current_queue_depth = 0;
-	SDpnt->new_queue_depth = 0;
 	spin_unlock_irqrestore(&device_request_lock, flags);
 }
 
-- Patrick Mansfield
