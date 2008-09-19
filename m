From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 1/2] lld busy status exporting interface
Date: Fri, 19 Sep 2008 10:48:54 -0400 (EDT)
Message-ID: <20080919.104854.71084447.k-ueda@ct.jp.nec.com>
References: <20080919.104756.41628866.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080919.104756.41628866.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James.Bottomley@HansenPartnership.com
Cc: j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch adds an interface to check lld's busy status
from the block layer.
This resolves a performance problem on request stacking devices below.


Some drivers like scsi mid layer stop dispatching request when
they detect busy state on its low-level device like host/bus/device.
It allows other requests to stay in the I/O scheduler's queue
for a chance of merging.

Request stacking drivers like request-based dm should follow
the same logic.
However, there is no generic interface for the stacked device
to check if the underlying device(s) are busy.
If the request stacking driver dispatches and submits requests to
the busy underlying device, the requests will stay in
the underlying device's queue without a chance of merging.
This causes performance problem on burst I/O load.

With this patch, busy state of the underlying device is exported
via the state flag of queue's backing_dev_info.  So the request
stacking driver can check it and stop dispatching requests if busy.

The underlying device driver must set/clear the flag appropriately:
   ON:  when the device driver can't process requests immediately.
   OFF: when the device driver can process requests immediately,
        including abnormal situations where the device driver needs
        to kill all requests.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 include/linux/backing-dev.h |    8 ++++++++
 mm/backing-dev.c            |   12 ++++++++++++
 2 files changed, 20 insertions(+)

Index: scsi-misc-2.6/include/linux/backing-dev.h
===================================================================
--- scsi-misc-2.6.orig/include/linux/backing-dev.h
+++ scsi-misc-2.6/include/linux/backing-dev.h
@@ -26,6 +26,7 @@ enum bdi_state {
 	BDI_pdflush,		/* A pdflush thread is working this device */
 	BDI_write_congested,	/* The write queue is getting full */
 	BDI_read_congested,	/* The read queue is getting full */
+	BDI_lld_congested,	/* The device/host is busy */
 	BDI_unused,		/* Available bits start here */
 };
 
@@ -226,8 +227,15 @@ static inline int bdi_rw_congested(struc
 				  (1 << BDI_write_congested));
 }
 
+static inline int bdi_lld_congested(struct backing_dev_info *bdi)
+{
+	return bdi_congested(bdi, 1 << BDI_lld_congested);
+}
+
 void clear_bdi_congested(struct backing_dev_info *bdi, int rw);
 void set_bdi_congested(struct backing_dev_info *bdi, int rw);
+void clear_bdi_lld_congested(struct backing_dev_info *bdi);
+void set_bdi_lld_congested(struct backing_dev_info *bdi);
 long congestion_wait(int rw, long timeout);
 
 
Index: scsi-misc-2.6/mm/backing-dev.c
===================================================================
--- scsi-misc-2.6.orig/mm/backing-dev.c
+++ scsi-misc-2.6/mm/backing-dev.c
@@ -279,6 +279,18 @@ void set_bdi_congested(struct backing_de
 }
 EXPORT_SYMBOL(set_bdi_congested);
 
+void clear_bdi_lld_congested(struct backing_dev_info *bdi)
+{
+	clear_bit(BDI_lld_congested, &bdi->state);
+}
+EXPORT_SYMBOL_GPL(clear_bdi_lld_congested);
+
+void set_bdi_lld_congested(struct backing_dev_info *bdi)
+{
+	set_bit(BDI_lld_congested, &bdi->state);
+}
+EXPORT_SYMBOL_GPL(set_bdi_lld_congested);
+
 /**
  * congestion_wait - wait for a backing_dev to become uncongested
  * @rw: READ or WRITE
