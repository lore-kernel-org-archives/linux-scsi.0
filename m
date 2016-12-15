From: kys@exchange.microsoft.com
Subject: [PATCH 4/6] storvsc: use tagged SRB requests if supported by the
 device
Date: Wed, 14 Dec 2016 18:46:01 -0800
Message-ID: <1481769963-2069-4-git-send-email-kys@exchange.microsoft.com>
References: <1481769928-2026-1-git-send-email-kys@exchange.microsoft.com>
 <1481769963-2069-1-git-send-email-kys@exchange.microsoft.com>
Reply-To: kys@microsoft.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1481769963-2069-1-git-send-email-kys@exchange.microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com, hare@suse.de, James.Bottomley@HansenPartnership.com
Cc: stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Long Li <longli@microsoft.com>

Properly set SRB flags when hosting device supports tagged queuing.
This patch improves the performance on Fiber Channel disks.

Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/storvsc_drv.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 63f6b1a..3209387 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -136,6 +136,8 @@ struct hv_fc_wwn_packet {
 #define SRB_FLAGS_PORT_DRIVER_RESERVED		0x0F000000
 #define SRB_FLAGS_CLASS_DRIVER_RESERVED		0xF0000000
 
+#define SP_UNTAGGED			((unsigned char) ~0)
+#define SRB_SIMPLE_TAG_REQUEST		0x20
 
 /*
  * Platform neutral description of a scsi request -
@@ -1549,6 +1551,13 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	vm_srb->win8_extension.srb_flags |=
 		SRB_FLAGS_DISABLE_SYNCH_TRANSFER;
 
+	if (scmnd->device->tagged_supported) {
+		vm_srb->win8_extension.srb_flags |=
+		(SRB_FLAGS_QUEUE_ACTION_ENABLE | SRB_FLAGS_NO_QUEUE_FREEZE);
+		vm_srb->win8_extension.queue_tag = SP_UNTAGGED;
+		vm_srb->win8_extension.queue_action = SRB_SIMPLE_TAG_REQUEST;
+	}
+
 	/* Build the SRB */
 	switch (scmnd->sc_data_direction) {
 	case DMA_TO_DEVICE:
-- 
1.7.4.1
