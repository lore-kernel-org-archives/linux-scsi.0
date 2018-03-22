From: Long Li <longli@linuxonhyperv.com>
Subject: [PATCH v2] storvsc: Set up correct queue depth values for IDE devices
Date: Thu, 22 Mar 2018 14:47:18 -0700
Message-ID: <20180322214718.29547-1-longli@linuxonhyperv.com>
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
To: "K . Y . Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, devel@linuxdriverproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Long Li <longli@microsoft.com>

Unlike SCSI and FC, we don't use multiple channels for IDE.
Also fix the calculation for sub-channels.

Change log:
v2: Addressed comment on incorrect number of sub-channels.
(Michael Kelley <Michael.H.Kelley@microsoft.com>)

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/storvsc_drv.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 8c51d628b52e..a2ec0bc9e9fa 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1722,11 +1722,14 @@ static int storvsc_probe(struct hv_device *device,
 		max_targets = STORVSC_MAX_TARGETS;
 		max_channels = STORVSC_MAX_CHANNELS;
 		/*
-		 * On Windows8 and above, we support sub-channels for storage.
+		 * On Windows8 and above, we support sub-channels for storage
+		 * on SCSI and FC controllers.
 		 * The number of sub-channels offerred is based on the number of
 		 * VCPUs in the guest.
 		 */
-		max_sub_channels = (num_cpus / storvsc_vcpus_per_sub_channel);
+		if (!dev_is_ide)
+			max_sub_channels =
+				(num_cpus - 1) / storvsc_vcpus_per_sub_channel;
 	}
 
 	scsi_driver.can_queue = (max_outstanding_req_per_channel *
-- 
2.14.1
