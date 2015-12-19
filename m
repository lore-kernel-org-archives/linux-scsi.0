From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.4-rc5
Date: Fri, 18 Dec 2015 18:09:36 -0800
Message-ID: <1450490976.2364.4.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Three fixes this time, two in SES picked up by KASAN for various types
of buffer overrun.  The first is a USB array which returns page 8
whatever is asked for and causes us to overrun with incorrect data
format assumptions and the second is an invalid iteration of page 10
(the additional information page).  The final one is a reversion of a
NULL deref fix which caused suspend/resume not to be called in pairs
leading to incorrect device operation (Jens has queued a more proper
fix for the problem in block).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

James Bottomley (2):
      ses: fix additional element traversal bug
      ses: Fix problems with simple enclosures

Ken Xue (1):
      Revert "SCSI: Fix NULL pointer dereference in runtime PM"

With the diffstat:

 drivers/scsi/scsi_pm.c    | 20 ++++++++++----------
 drivers/scsi/ses.c        | 30 ++++++++++++++++++++++++++++--
 include/linux/enclosure.h |  4 ++++
 3 files changed, 42 insertions(+), 12 deletions(-)

And full diffs below.

James

---

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index dcb0d76..044d064 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -84,6 +84,7 @@ static void init_device_slot_control(unsigned char *dest_desc,
 static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 			 void *buf, int bufflen)
 {
+	int ret;
 	unsigned char cmd[] = {
 		RECEIVE_DIAGNOSTIC,
 		1,		/* Set PCV bit */
@@ -92,9 +93,26 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 		bufflen & 0xff,
 		0
 	};
+	unsigned char recv_page_code;
 
-	return scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
+	ret =  scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
 				NULL, SES_TIMEOUT, SES_RETRIES, NULL);
+	if (unlikely(!ret))
+		return ret;
+
+	recv_page_code = ((unsigned char *)buf)[0];
+
+	if (likely(recv_page_code == page_code))
+		return ret;
+
+	/* successful diagnostic but wrong page code.  This happens to some
+	 * USB devices, just print a message and pretend there was an error */
+
+	sdev_printk(KERN_ERR, sdev,
+		    "Wrong diagnostic page; asked for %d got %u\n",
+		    page_code, recv_page_code);
+
+	return -EINVAL;
 }
 
 static int ses_send_diag(struct scsi_device *sdev, int page_code,
@@ -541,7 +559,15 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 			if (desc_ptr)
 				desc_ptr += len;
 
-			if (addl_desc_ptr)
+			if (addl_desc_ptr &&
+			    /* only find additional descriptions for specific devices */
+			    (type_ptr[0] == ENCLOSURE_COMPONENT_DEVICE ||
+			     type_ptr[0] == ENCLOSURE_COMPONENT_ARRAY_DEVICE ||
+			     type_ptr[0] == ENCLOSURE_COMPONENT_SAS_EXPANDER ||
+			     /* these elements are optional */
+			     type_ptr[0] == ENCLOSURE_COMPONENT_SCSI_TARGET_PORT ||
+			     type_ptr[0] == ENCLOSURE_COMPONENT_SCSI_INITIATOR_PORT ||
+			     type_ptr[0] == ENCLOSURE_COMPONENT_CONTROLLER_ELECTRONICS))
 				addl_desc_ptr += addl_desc_ptr[1] + 2;
 
 		}
diff --git a/include/linux/enclosure.h b/include/linux/enclosure.h
index 7be22da..a4cf57c 100644
--- a/include/linux/enclosure.h
+++ b/include/linux/enclosure.h
@@ -29,7 +29,11 @@
 /* A few generic types ... taken from ses-2 */
 enum enclosure_component_type {
 	ENCLOSURE_COMPONENT_DEVICE = 0x01,
+	ENCLOSURE_COMPONENT_CONTROLLER_ELECTRONICS = 0x07,
+	ENCLOSURE_COMPONENT_SCSI_TARGET_PORT = 0x14,
+	ENCLOSURE_COMPONENT_SCSI_INITIATOR_PORT = 0x15,
 	ENCLOSURE_COMPONENT_ARRAY_DEVICE = 0x17,
+	ENCLOSURE_COMPONENT_SAS_EXPANDER = 0x18,
 };
 
 /* ses-2 common element status */
