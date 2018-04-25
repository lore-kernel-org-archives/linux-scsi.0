From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: isci: remove redundant check on in_connection_align_insertion_frequency
Date: Wed, 25 Apr 2018 11:58:43 +0100
Message-ID: <20180425105843.8607-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The sanity check on u->in_connection_align_insertion_frequency is being
performed twice and hence the first check can be removed since it is
redundant. Cleans up cppcheck warning:

drivers/scsi/ibmvscsi/ibmvscsi.c:1711: (warning) Identical inner 'if'
condition is always true.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/isci/init.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 922e3e56c90d..05cf4daf8788 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -433,9 +433,6 @@ static enum sci_status sci_user_parameters_set(struct isci_host *ihost,
 		      (u->max_speed_generation > SCIC_SDS_PARM_NO_SPEED)))
 			return SCI_FAILURE_INVALID_PARAMETER_VALUE;
 
-		if (u->in_connection_align_insertion_frequency < 3)
-			return SCI_FAILURE_INVALID_PARAMETER_VALUE;
-
 		if ((u->in_connection_align_insertion_frequency < 3) ||
 		    (u->align_insertion_frequency == 0) ||
 		    (u->notify_enable_spin_up_insertion_frequency == 0))
-- 
2.17.0
