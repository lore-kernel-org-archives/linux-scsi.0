From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 3/8] Drivers: scsi: storvsc: Fix a bug in handling VMBUS
 protocol version
Date: Tue,  8 Jul 2014 17:46:47 -0700
Message-ID: <1404866812-26950-3-git-send-email-kys@microsoft.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1404866812-26950-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com, apw@canonical.com, linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Based on the negotiated VMBUS protocol version, we adjust the size of the storage
protocol messages. The two sizes we currently handle or pre-win8 and post-win8.
Win WS2012 R2, we are negotiating higher VMBUS protocol version than the win8
version. Make adjustments to correctly handle this.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/storvsc_drv.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 759853c..d9d8051 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1751,19 +1751,19 @@ static int storvsc_probe(struct hv_device *device,
 	 * set state to properly communicate with the host.
 	 */
 
-	if (vmbus_proto_version == VERSION_WIN8) {
-		sense_buffer_size = POST_WIN7_STORVSC_SENSE_BUFFER_SIZE;
-		vmscsi_size_delta = 0;
-		vmstor_current_major = VMSTOR_WIN8_MAJOR;
-		vmstor_current_minor = VMSTOR_WIN8_MINOR;
-	} else {
+	if ((vmbus_proto_version == VERSION_WS2008) ||
+	     (vmbus_proto_version == VERSION_WIN7)) {
 		sense_buffer_size = PRE_WIN8_STORVSC_SENSE_BUFFER_SIZE;
 		vmscsi_size_delta = sizeof(struct vmscsi_win8_extension);
 		vmstor_current_major = VMSTOR_WIN7_MAJOR;
 		vmstor_current_minor = VMSTOR_WIN7_MINOR;
+	} else {
+		sense_buffer_size = POST_WIN7_STORVSC_SENSE_BUFFER_SIZE;
+		vmscsi_size_delta = 0;
+		vmstor_current_major = VMSTOR_WIN8_MAJOR;
+		vmstor_current_minor = VMSTOR_WIN8_MINOR;
 	}
 
-
 	host = scsi_host_alloc(&scsi_driver,
 			       sizeof(struct hv_host_device));
 	if (!host)
-- 
1.7.4.1
