From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 1/2] virtio-scsi: fix LUNs greater than 255
Date: Thu, 26 Jul 2012 15:28:07 +0200
Message-ID: <1343309288-32615-2-git-send-email-pbonzini@redhat.com>
References: <1343309288-32615-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1343309288-32615-1-git-send-email-pbonzini@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, JBottomley@parallels.com, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

virtio-scsi needs to report LUNs greater than 256 using the "flat"
format.  Because the Linux SCSI layer just maps the SCSI LUN to
an u32, without any parsing, these end up in the range from 16640
to 32767.  Fix max_lun to account for the possibility that logical
unit numbers are encoded with the "flat" format.

Cc: <stable@vger.kernel.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/virtio_scsi.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index c7030fb..8b6b927 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -677,7 +677,11 @@ static int __devinit virtscsi_probe(struct virtio_device *vdev)
 	cmd_per_lun = virtscsi_config_get(vdev, cmd_per_lun) ?: 1;
 	shost->cmd_per_lun = min_t(u32, cmd_per_lun, shost->can_queue);
 	shost->max_sectors = virtscsi_config_get(vdev, max_sectors) ?: 0xFFFF;
-	shost->max_lun = virtscsi_config_get(vdev, max_lun) + 1;
+
+	/* LUNs > 256 are reported with format 1, so they go in the range
+	 * 16640-32767.
+	 */
+	shost->max_lun = virtscsi_config_get(vdev, max_lun) + 1 + 0x4000;
 	shost->max_id = num_targets;
 	shost->max_channel = 0;
 	shost->max_cmd_len = VIRTIO_SCSI_CDB_SIZE;
-- 
1.7.1
