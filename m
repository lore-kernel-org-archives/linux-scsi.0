From: sullivan <sullivan@austin.ibm.com>
Subject: [PATCH] fix for sd removal loop
Date: Fri, 16 Aug 2002 12:52:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020816125256.E1216@austin.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="J5MfuwkIyy7RmF4Q"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from sullivan@localhost)
	by ibm.com (8.11.6/8.11.6) id g7GHquG16399
	for linux-scsi@vger.kernel.org; Fri, 16 Aug 2002 12:52:56 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--J5MfuwkIyy7RmF4Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Attached is a trivial fix for an excessive loop that is encountered in
removal of the sd module. This case is hit when sd is insmod'ed and rmmod'ed
without any scsi devices being registered. In this case, within exit_sd(), 
sd_template.dev_max remains at zero and the N_USED_SD_MAJORS macro yields an 
incorrect result since it is treating dev_max as an signed number. 



--J5MfuwkIyy7RmF4Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.5-devclass-hosts.patch"

diff -Nau --exclude='p.*' linux-2.5-devclass/drivers/scsi/hosts.h linux-2.5-devclass-mike/drivers/scsi/hosts.h
--- linux-2.5-devclass/drivers/scsi/hosts.h	Fri Aug 16 19:42:09 2002
+++ linux-2.5-devclass-mike/drivers/scsi/hosts.h	Wed Aug 14 23:32:55 2002
@@ -519,7 +519,7 @@
     unsigned int max_major;      /* Maximum major in range. */
     unsigned int nr_dev;	  /* Number currently attached */
     unsigned int dev_noticed;	  /* Number of devices detected. */
-    unsigned int dev_max;	  /* Current size of arrays */
+    signed int dev_max;	  /* Current size of arrays */
     unsigned blk:1;		  /* 0 if character device */
     int (*detect)(Scsi_Device *); /* Returns 1 if we can attach this device */
     int (*init)(void);		  /* Sizes arrays based upon number of devices

--J5MfuwkIyy7RmF4Q--
