From: Cong Meng <mc@linux.vnet.ibm.com>
Subject: [PATCH] SCSI: Add SG_GET_SG_MAX_SEGMENT_SIZE ioctl to sg device
Date: Mon,  2 Jul 2012 17:20:57 +0800
Message-ID: <1341220857-1205-1-git-send-email-mc@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: stefanha@linux.vnet.ibm.com, linuxram@us.ibm.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, senwang@linux.vnet.ibm.com, Cong Meng <mc@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Add a new ioctl cmd to get the max segment size. It's useful in
virtualization environment for guest to know the queue limits, so
that the guest kicks off legal scsi command to a sg device.

Signed-off-by: Cong Meng <mc@linux.vnet.ibm.com>
---
 drivers/scsi/sg.c |    2 ++
 include/scsi/sg.h |    3 +++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index eacd46b..bdcdc9d 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -913,6 +913,8 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 		return put_user(val, ip);
 	case SG_GET_SG_TABLESIZE:
 		return put_user(sdp->sg_tablesize, ip);
+	case SG_GET_SG_MAX_SEGMENT_SIZE:
+		return put_user(queue_max_segment_size(sdp->device->request_queue), ip);
 	case SG_SET_RESERVED_SIZE:
 		result = get_user(val, ip);
 		if (result)
diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index a9f3c6f..76d94c1 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -200,6 +200,9 @@ typedef struct sg_req_info { /* used by SG_GET_REQUEST_TABLE ioctl() */
 /* Yields max scatter gather tablesize allowed by current host adapter */
 #define SG_GET_SG_TABLESIZE 0x227F  /* 0 implies can't do scatter gather */
 
+/* Yidld max size of scatter gather element by current host adapter */
+#define SG_GET_SG_MAX_SEGMENT_SIZE 0x2280
+
 #define SG_GET_VERSION_NUM 0x2282 /* Example: version 2.1.34 yields 20134 */
 
 /* Returns -EBUSY if occupied. 3rd argument pointer to int (see next) */
-- 
1.7.7.6
