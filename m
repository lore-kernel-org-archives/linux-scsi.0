From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 3.16 051/192] scsi: virtio_scsi: let host do exception
 handling
Date: Mon, 09 Oct 2017 13:44:24 +0100
Message-ID: <lsq.1507553064.17481458@decadent.org.uk>
References: <lsq.1507553063.449494954@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <lsq.1507553063.449494954@decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Miller <dougmill@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-scsi@vger.kernel.org

3.16.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit e72c9a2a67a6400c8ef3d01d4c461dbbbfa0e1f0 upstream.

virtio_scsi tries to do exception handling after the default 30 seconds
timeout expires.  However, it's better to let the host control the
timeout, otherwise with a heavy I/O load it is likely that an abort will
also timeout.  This leads to fatal errors like filesystems going
offline.

Disable the 'sd' timeout and allow the host to do exception handling,
following the precedent of the storvsc driver.

Hannes has a proposal to introduce timeouts in virtio, but this provides
an immediate solution for stable kernels too.

[mkp: fixed typo]

Reported-by: Douglas Miller <dougmill@linux.vnet.ibm.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/virtio_scsi.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -686,6 +686,16 @@ static void virtscsi_target_destroy(stru
 	kfree(tgt);
 }
 
+/*
+ * The host guarantees to respond to each command, although I/O
+ * latencies might be higher than on bare metal.  Reset the timer
+ * unconditionally to give the host a chance to perform EH.
+ */
+static enum blk_eh_timer_return virtscsi_eh_timed_out(struct scsi_cmnd *scmnd)
+{
+	return BLK_EH_RESET_TIMER;
+}
+
 static struct scsi_host_template virtscsi_host_template_single = {
 	.module = THIS_MODULE,
 	.name = "Virtio SCSI HBA",
@@ -695,6 +705,7 @@ static struct scsi_host_template virtscs
 	.queuecommand = virtscsi_queuecommand_single,
 	.eh_abort_handler = virtscsi_abort,
 	.eh_device_reset_handler = virtscsi_device_reset,
+	.eh_timed_out = virtscsi_eh_timed_out,
 
 	.can_queue = 1024,
 	.dma_boundary = UINT_MAX,
@@ -712,6 +723,7 @@ static struct scsi_host_template virtscs
 	.queuecommand = virtscsi_queuecommand_multi,
 	.eh_abort_handler = virtscsi_abort,
 	.eh_device_reset_handler = virtscsi_device_reset,
+	.eh_timed_out = virtscsi_eh_timed_out,
 
 	.can_queue = 1024,
 	.dma_boundary = UINT_MAX,
