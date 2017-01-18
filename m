From: Cathy Avery <cavery@redhat.com>
Subject: [PATCH 2/2] scsi: storvsc: Add support for FC lightweight host.
Date: Wed, 18 Jan 2017 15:28:58 -0500
Message-ID: <1484771338-8903-3-git-send-email-cavery@redhat.com>
References: <1484771338-8903-1-git-send-email-cavery@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1484771338-8903-1-git-send-email-cavery@redhat.com>
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

Enable FC lightweight host option so that the luns exposed by
the driver may be manually scanned.

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 drivers/scsi/storvsc_drv.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 888e16e..fc1d6ba 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1882,6 +1882,7 @@ static struct hv_driver storvsc_drv = {
 static struct fc_function_template fc_transport_functions = {
 	.show_host_node_name = 1,
 	.show_host_port_name = 1,
+	.lightweight_transport = 1,
 };
 #endif
 
@@ -1906,11 +1907,6 @@ static int __init storvsc_drv_init(void)
 	fc_transport_template = fc_attach_transport(&fc_transport_functions);
 	if (!fc_transport_template)
 		return -ENODEV;
-
-	/*
-	 * Install Hyper-V specific timeout handler.
-	 */
-	fc_transport_template->eh_timed_out = storvsc_eh_timed_out;
 #endif
 
 	ret = vmbus_driver_register(&storvsc_drv);
-- 
2.5.0
