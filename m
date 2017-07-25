From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.12 042/196] scsi: virtio_scsi: let host do exception handling
Date: Tue, 25 Jul 2017 12:20:41 -0700
Message-ID: <20170725192048.698195861@linuxfoundation.org>
References: <20170725192046.422343510@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170725192046.422343510@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Douglas Miller <dougmill@linux.vnet.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-scsi@vger.kernel.org

4.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/virtio_scsi.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -796,6 +796,16 @@ static int virtscsi_map_queues(struct Sc
 	return blk_mq_virtio_map_queues(&shost->tag_set, vscsi->vdev, 2);
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
@@ -806,6 +816,7 @@ static struct scsi_host_template virtscs
 	.change_queue_depth = virtscsi_change_queue_depth,
 	.eh_abort_handler = virtscsi_abort,
 	.eh_device_reset_handler = virtscsi_device_reset,
+	.eh_timed_out = virtscsi_eh_timed_out,
 	.slave_alloc = virtscsi_device_alloc,
 
 	.can_queue = 1024,
@@ -826,6 +837,7 @@ static struct scsi_host_template virtscs
 	.change_queue_depth = virtscsi_change_queue_depth,
 	.eh_abort_handler = virtscsi_abort,
 	.eh_device_reset_handler = virtscsi_device_reset,
+	.eh_timed_out = virtscsi_eh_timed_out,
 
 	.can_queue = 1024,
 	.dma_boundary = UINT_MAX,
