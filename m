From: Long Li <longli@exchange.microsoft.com>
Subject: [PATCH 2/3] storvsc: properly handle SRB_ERROR when sense message is
 present
Date: Tue,  6 Sep 2016 14:25:42 -0700
Message-ID: <1473197143-16760-3-git-send-email-longli@exchange.microsoft.com>
References: <1473197143-16760-1-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1473197143-16760-1-git-send-email-longli@exchange.microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Long Li <longli@microsoft.com>

When sense message is present on error, we should pass along to the upper layer to decide how to deal with the error. This patch fixes connectivity issues with Fiber Channel devices.

---
 drivers/scsi/storvsc_drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index a8f3e4c..8328c87 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -890,6 +890,9 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 
 	switch (SRB_STATUS(vm_srb->srb_status)) {
 	case SRB_STATUS_ERROR:
+		/* Let upper layer deal with error when sense message is present */
+		if (vm_srb->srb_status & SRB_STATUS_AUTOSENSE_VALID)
+			break;
 		/*
 		 * If there is an error; offline the device since all
 		 * error recovery strategies would have already been
-- 
1.8.5.6
