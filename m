From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 1/2] scsi: storvsc: Install the storvsc specific timeout
 handler for FC devices
Date: Wed, 27 Jan 2016 18:22:44 -0800
Message-ID: <1453947765-28764-1-git-send-email-kys@microsoft.com>
References: <1453947739-28725-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1453947739-28725-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

The default timeout routine used for FC transport is not
suitable for FC devices managed by storvsc since FC devices
managed by storvsc driver do not have an rport associated
with them. Use the time out handler used for SCSI devices
for FC devices as well.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Alex Ng <alexng@microsoft.com>
Tested-by: Vivek Yadav <vyadav@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 41c115c..622f64a 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -42,6 +42,7 @@
 #include <scsi/scsi_devinfo.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_transport_fc.h>
+#include <scsi/scsi_transport.h>
 
 /*
  * All wire protocol details (storage protocol between the guest and the host)
@@ -1770,6 +1771,11 @@ static int __init storvsc_drv_init(void)
 	fc_transport_template = fc_attach_transport(&fc_transport_functions);
 	if (!fc_transport_template)
 		return -ENODEV;
+
+	/*
+	 * Install Hyper-V specific timeout handler.
+	 */
+	fc_transport_template->eh_timed_out = storvsc_eh_timed_out;
 #endif
 
 	ret = vmbus_driver_register(&storvsc_drv);
-- 
1.7.4.1
