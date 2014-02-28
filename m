From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: [PATCH] scsi_dh_alua: Requeue another not ready check
 condition at ML
Date: Fri, 28 Feb 2014 00:14:20 +0000
Message-ID: <8255ED565A0EAA4A960625E27D49DBF24AC8B21D@SACEXCMBX04-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

This allows the sd driver to retry commands like read capacity until a
LUN is ready, rather than giving up after three retries.

In NetApp E-Series, a controller can return not ready like this when it
quiesces I/O on the controller that just came on the network, during a
firmware upgrade procedure, and retrying the command at the midlayer
will allow the discovery to complete, successfully.

Signed-off-by: Sean Stewart <sean.stewart@netapp.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 5248c88..95d87fe 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -454,6 +454,11 @@ static int alua_check_sense(struct scsi_device *sdev,
 {
 	switch (sense_hdr->sense_key) {
 	case NOT_READY:
+		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)
+			/*
+			 * LUN Not Ready -- In process of becoming ready
+			 */
+			return ADD_TO_MLQUEUE;
 		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a)
 			/*
 			 * LUN Not Accessible - ALUA state transition
-- 
1.8.3.1
