From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 1/6] mpt fusion - fibre channel target discovery prematurely
 terminates
Date: Thu, 18 May 2006 14:59:32 -0500
Message-ID: <446CD224.6060806@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080107000802040209070808"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:26553 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1750923AbWERT7e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 15:59:34 -0400
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [192.26.80.2])
	by omx2.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k4IMHKrw010242
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 15:17:20 -0700
Received: from [128.162.233.78] (hd28.americas.sgi.com [128.162.233.78])
	by cthulhu.engr.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id k4IJxX4126256152
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 12:59:33 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------080107000802040209070808
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

mpt_config() can return EAGAIN.  When this happens, fibre channel target
discovery can prematurely terminate with fewer than the total number of
targets discovered.  This patch detects EAGAIN and reschedules the scan
work.

Generally, this situation only occurs when the lsiutil program is being
used to reset the board.

Signed-off-by: Michael Reed <mdr@sgi.com>




--------------080107000802040209070808
Content-Type: text/x-patch;
 name="01-mptfc_eagain.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01-mptfc_eagain.patch"

mpt_config() can return EAGAIN.  When this happens, fibre channel target
discovery can prematurely terminate with fewer than the total number of
targets discovered.  This patch detects EAGAIN and reschedules the scan
work.

Generally, this situation only occurs when the lsiutil program is being
used to reset the board.

Signed-off-by: Michael Reed <mdr@sgi.com>


--- rc3u/drivers/message/fusion/mptfc.c	2006-05-01 16:06:13.311966423 -0500
+++ rc3/drivers/message/fusion/mptfc.c	2006-05-03 14:16:47.669834844 -0500
@@ -634,6 +634,7 @@
 	MPT_ADAPTER		*ioc = (MPT_ADAPTER *)arg;
 	int			ii;
 	int			work_to_do;
+	int			rc=0;
 	u64			pn;
 	unsigned long		flags;
 	struct mptfc_rport_info *ri;
@@ -651,9 +652,13 @@
 		 * will reregister existing rports
 		 */
 		for (ii=0; ii < ioc->facts.NumberOfPorts; ii++) {
-			(void) mptbase_GetFcPortPage0(ioc, ii);
+			rc = mptbase_GetFcPortPage0(ioc, ii);
+			if (rc == -EAGAIN)
+				break;
 			mptfc_init_host_attr(ioc,ii);	/* refresh */
-			mptfc_GetFcDevPage0(ioc,ii,mptfc_register_dev);
+			rc = mptfc_GetFcDevPage0(ioc,ii,mptfc_register_dev);
+			if (rc == -EAGAIN)
+				break;
 		}
 
 		/* delete devices still missing */
@@ -686,6 +691,20 @@
 		work_to_do = --ioc->fc_rescan_work_count;
 		spin_unlock_irqrestore(&ioc->fc_rescan_work_lock, flags);
 	} while (work_to_do);
+
+	/* if last pass failed with EAGAIN, reschedule work for a later attempt */
+	if (rc == -EAGAIN) {
+		spin_lock_irqsave(&ioc->fc_rescan_work_lock, flags);
+		if (ioc->fc_rescan_work_q) {
+			queue_delayed_work(ioc->fc_rescan_work_q, &ioc->fc_rescan_work, HZ);
+			ioc->fc_rescan_work_count = 1;
+		}
+		spin_unlock_irqrestore(&ioc->fc_rescan_work_lock, flags);
+		dfcprintk ((MYIOC_s_INFO_FMT
+			"mptfc_rescan.%d: rescheduling work\n",
+			ioc->name,
+			ioc->sh->host_no));
+	}
 }
 
 static int
@@ -981,6 +1000,7 @@
 		spin_lock_irqsave(&ioc->fc_rescan_work_lock, flags);
 		ioc->fc_rescan_work_q = NULL;
 		spin_unlock_irqrestore(&ioc->fc_rescan_work_lock, flags);
+		cancel_delayed_work(&ioc->fc_rescan_work);
 		destroy_workqueue(work_q);
 	}
 

--------------080107000802040209070808--
