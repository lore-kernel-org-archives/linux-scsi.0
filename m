From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] 2.5.51 SCSI_IOCTL_GET_IDLUN + _GET_BUS_NUMBER
Date: Thu, 12 Dec 2002 18:44:15 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DF83E4F.8000704@torque.net>
Reply-To: dougg@torque.net, dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010106070402070300060507"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-93.triode.net.au [202.147.125.93])
	by iggy.triode.net.au (8.11.6/8.11.6) with ESMTP id gBC7fnB27055
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2002 18:41:50 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010106070402070300060507
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

For disks both the SCSI_IOCTL_GET_IDLUN and
SCSI_IOCTL_GET_BUS_NUMBER ioctls return the value
0 (type: int) in all cases. The attachment removes
the dummy definitions of these ioctls in
driver/block/scsi_ioctl.c so they fall through
to the scsi mid level which correctly implements
them (at least in terms of lk 2.4).

Doug Gilbert


--------------010106070402070300060507
Content-Type: text/plain;
 name="scsi_ioctl_blk2551.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_ioctl_blk2551.diff"

--- linux/drivers/block/scsi_ioctl.c	2002-11-29 09:27:35.000000000 +1100
+++ linux/drivers/block/scsi_ioctl.c2551xidlun	2002-12-12 18:19:23.000000000 +1100
@@ -73,16 +73,6 @@
 	return put_user(sg_version_num, p);
 }
 
-static int scsi_get_idlun(request_queue_t *q, int *p)
-{
-	return put_user(0, p);
-}
-
-static int scsi_get_bus(request_queue_t *q, int *p)
-{
-	return put_user(0, p);
-}
-
 static int sg_get_timeout(request_queue_t *q)
 {
 	return q->sg_timeout;
@@ -413,10 +403,6 @@
 		 */
 		case SG_GET_VERSION_NUM:
 			return sg_get_version((int *) arg);
-		case SCSI_IOCTL_GET_IDLUN:
-			return scsi_get_idlun(q, (int *) arg);
-		case SCSI_IOCTL_GET_BUS_NUMBER:
-			return scsi_get_bus(q, (int *) arg);
 		case SG_SET_TIMEOUT:
 			return sg_set_timeout(q, (int *) arg);
 		case SG_GET_TIMEOUT:

--------------010106070402070300060507--

