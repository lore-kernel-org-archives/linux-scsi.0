From: John Levon <levon@movementarian.org>
Subject: [TROLLPATCH] 2.5.44 - ncr didn't compile
Date: Sat, 19 Oct 2002 19:29:39 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021019182939.GD40605@compsoc.man.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from compsoc.umu.man.ac.uk
	([130.88.22.5] helo=mrtall.compsoc.man.ac.uk ident=exim)
	by probity.mcc.ac.uk with esmtp (Exim 2.05 #7)
	id 182yLz-000Pe0-00
	for linux-scsi@vger.kernel.org; Sat, 19 Oct 2002 19:29:39 +0100
Received: from moz by mrtall.compsoc.man.ac.uk with local (Exim 3.33 #1)
	id 182yLz-000Ac6-00
	for linux-scsi@vger.kernel.org; Sat, 19 Oct 2002 19:29:39 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This makes ncr53c8xx.c compile. I accidentally "fixed" the wrong driver,
so I'm not bothered whether it's right or not :)

regards
john


--- linux-linus/drivers/scsi/ncr53c8xx.c	Wed Oct 16 19:08:48 2002
+++ linux/drivers/scsi/ncr53c8xx.c	Sat Oct 19 18:59:21 2002
@@ -362,17 +362,6 @@
 #define NCR_SNOOP_TIMEOUT (1000000)
 
 /*
-**	Head of list of NCR boards
-**
-**	For kernel version < 1.3.70, host is retrieved by its irq level.
-**	For later kernels, the internal host control block address 
-**	(struct ncb) is used as device id parameter of the irq stuff.
-*/
-
-static struct Scsi_Host		*first_host	= NULL;
-static Scsi_Host_Template	*the_template	= NULL;	
-
-/*
 **	Other definitions
 */
 
@@ -3854,14 +3843,6 @@
 	np->order = M_SIMPLE_TAG;
 #endif
 
-	/*
-	**  Done.
-	*/
-        if (!the_template) {
-        	the_template = instance->hostt;
-        	first_host = instance;
-	}
-
 	NCR_UNLOCK_NCB(np, flags);
 
 	return 0;
@@ -9125,16 +9106,15 @@
 printk("ncr53c8xx_proc_info: hostno=%d, func=%d\n", hostno, func);
 #endif
 
-	for (host = first_host; host; host = host->next) {
-		if (host->hostt == the_template && host->host_no == hostno) {
-			host_data = (struct host_data *) host->hostdata;
-			ncb = host_data->ncb;
-			break;
-		}
-	}
-
-	if (!ncb)
+	host = scsi_host_hn_get(hostno);
+	if (!host)
 		return -EINVAL;
+ 
+	host_data = (struct host_data *)host->hostdata;
+	ncb = host_data->ncb;
+	retv = -EINVAL;
+	if (!ncb)
+		goto out;
 
 	if (func) {
 #ifdef	SCSI_NCR_USER_COMMAND_SUPPORT
@@ -9153,6 +9133,8 @@
 #endif
 	}
 
+out:
+	scsi_host_put(host);
 	return retv;
 }
 
