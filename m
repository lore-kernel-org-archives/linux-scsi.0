From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] scsi: storvsc: Fix a bug in the handling of SRB status
 flags
Date: Tue,  6 Oct 2015 18:04:01 -0700
Message-ID: <1444179841-25411-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com
List-Id: linux-scsi@vger.kernel.org

SRB status can have additional information. Mask these out before processing SRB status.

This patch was sent as part of a collection of patches more than a year ago.
While the rest of the patches in the set were comitted, this patch was not.
I woulod like to thank Olaf for noticing that this patch was not committed
upstream.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 072c11e..face2e6 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -349,11 +349,14 @@ enum storvsc_request_type {
  */
 
 #define SRB_STATUS_AUTOSENSE_VALID	0x80
+#define SRB_STATUS_QUEUE_FROZEN		0x40
 #define SRB_STATUS_INVALID_LUN	0x20
 #define SRB_STATUS_SUCCESS	0x01
 #define SRB_STATUS_ABORTED	0x02
 #define SRB_STATUS_ERROR	0x04
 
+#define SRB_STATUS(status) \
+	(status & ~(SRB_STATUS_AUTOSENSE_VALID | SRB_STATUS_QUEUE_FROZEN))
 /*
  * This is the end of Protocol specific defines.
  */
@@ -858,7 +861,7 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 	void (*process_err_fn)(struct work_struct *work);
 	bool do_work = false;
 
-	switch (vm_srb->srb_status) {
+	switch (SRB_STATUS(vm_srb->srb_status)) {
 	case SRB_STATUS_ERROR:
 		/*
 		 * If there is an error; offline the device since all
-- 
1.7.4.1
