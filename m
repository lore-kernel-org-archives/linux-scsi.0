From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] scsi: storvsc: Support manual scan of FC hosts on Hyper-V
Date: Sat, 12 Mar 2016 13:52:48 -0800
Message-ID: <1457819568-6586-1-git-send-email-kys@microsoft.com>
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
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

The default user scan function associated with FC (fc_user_scan)
is not suitable for FC hosts on Hyper-V since we don't have
an rport associated with FC host on Hyper-V . Set it to NULL so we can
support manual scan of FC targets on Hyper-V.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Tested-by: Long Li <longli@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 132b168..8aec590 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1776,6 +1776,12 @@ static int __init storvsc_drv_init(void)
 	 * Install Hyper-V specific timeout handler.
 	 */
 	fc_transport_template->eh_timed_out = storvsc_eh_timed_out;
+	/*
+	 * The default user scan function associated with FC (fc_user_scan)
+	 * is not suitable for FC hosts on Hyper-V. Set it to NULL so we can
+	 * support manual scan of FC targets on Hyper-V.
+	 */
+	fc_transport_template->user_scan = NULL;
 #endif
 
 	ret = vmbus_driver_register(&storvsc_drv);
-- 
1.7.4.1
