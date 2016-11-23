From: Cathy Avery <cavery@redhat.com>
Subject: [PATCH v2] [hv] storvsc: Payload buffer incorrectly sized for 32 bit
 kernels.
Date: Wed, 23 Nov 2016 08:46:33 -0500
Message-ID: <1479908793-19872-1-git-send-email-cavery@redhat.com>
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
To: kys@microsoft.com, haiyangz@microsoft.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On a 32 bit kernel sizeof(void *) is not 64 bits as hv_mpb_array
requires. Also the buffer needs to be cleared or the upper bytes
will contain junk.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Cathy Avery <cavery@redhat.com>

ChangeLog:

v1) Initial submission
v2) Remove memset and replace kmalloc with kzalloc.
---
 drivers/scsi/storvsc_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 8ccfc9e..05526b7 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1495,9 +1495,9 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	if (sg_count) {
 		if (sg_count > MAX_PAGE_BUFFER_COUNT) {
 
-			payload_sz = (sg_count * sizeof(void *) +
+			payload_sz = (sg_count * sizeof(u64) +
 				      sizeof(struct vmbus_packet_mpb_array));
-			payload = kmalloc(payload_sz, GFP_ATOMIC);
+			payload = kzalloc(payload_sz, GFP_ATOMIC);
 			if (!payload)
 				return SCSI_MLQUEUE_DEVICE_BUSY;
 		}
-- 
2.5.0
