From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 4/6] scsi: storvsc: use correct defaults for values determined
 by protocol negotiation
Date: Fri, 29 May 2015 13:29:17 -0700
Message-ID: <1432931359-14473-4-git-send-email-kys@microsoft.com>
References: <1432931336-14434-1-git-send-email-kys@microsoft.com>
 <1432931359-14473-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1432931359-14473-1-git-send-email-kys@microsoft.com>
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
Cc: "keith.mange@microsoft.com" <keith.mange@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

From: keith.mange@microsoft.com <keith.mange@microsoft.com>

Use correct defaults for values determined by protocol negotiation,
instead of resetting them with every scsi controller.

Tested-by: Alex Ng <alexng@microsoft.com>
Signed-off-by: Keith Mange <keith.mange@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |   33 +++++++++++++++++++--------------
 1 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index f29871e..6f38cdf 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -151,19 +151,17 @@ struct hv_fc_wwn_packet {
 
 /*
  * Sense buffer size changed in win8; have a run-time
- * variable to track the size we should use.
+ * variable to track the size we should use.  This value will
+ * likely change during protocol negotiation but it is valid
+ * to start by assuming pre-Win8.
  */
-static int sense_buffer_size;
+static int sense_buffer_size = PRE_WIN8_STORVSC_SENSE_BUFFER_SIZE;
 
 /*
- * The size of the vmscsi_request has changed in win8. The
- * additional size is because of new elements added to the
- * structure. These elements are valid only when we are talking
- * to a win8 host.
- * Track the correction to size we need to apply.
- */
-
-static int vmscsi_size_delta;
+ * The storage protocol version is determined during the
+ * initial exchange with the host.  It will indicate which
+ * storage functionality is available in the host.
+*/
 static int vmstor_proto_version;
 
 struct vmscsi_win8_extension {
@@ -209,6 +207,17 @@ struct vmscsi_request {
 
 
 /*
+ * The size of the vmscsi_request has changed in win8. The
+ * additional size is because of new elements added to the
+ * structure. These elements are valid only when we are talking
+ * to a win8 host.
+ * Track the correction to size we need to apply. This value
+ * will likely change during protocol negotiation but it is
+ * valid to start by assuming pre-Win8.
+ */
+static int vmscsi_size_delta = sizeof(struct vmscsi_win8_extension);
+
+/*
  * The list of storage protocols in order of preference.
  */
 struct vmstor_protocol {
@@ -1810,14 +1819,10 @@ static int storvsc_probe(struct hv_device *device,
 	 */
 
 	if (vmbus_proto_version < VERSION_WIN8) {
-		sense_buffer_size = PRE_WIN8_STORVSC_SENSE_BUFFER_SIZE;
-		vmscsi_size_delta = sizeof(struct vmscsi_win8_extension);
 		max_luns_per_target = STORVSC_IDE_MAX_LUNS_PER_TARGET;
 		max_targets = STORVSC_IDE_MAX_TARGETS;
 		max_channels = STORVSC_IDE_MAX_CHANNELS;
 	} else {
-		sense_buffer_size = POST_WIN7_STORVSC_SENSE_BUFFER_SIZE;
-		vmscsi_size_delta = 0;
 		max_luns_per_target = STORVSC_MAX_LUNS_PER_TARGET;
 		max_targets = STORVSC_MAX_TARGETS;
 		max_channels = STORVSC_MAX_CHANNELS;
-- 
1.7.4.1
