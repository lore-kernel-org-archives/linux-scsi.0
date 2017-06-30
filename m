From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 02/15] megaraid_sas: set minimum value of resetwaittime to be 1 secs
Date: Fri, 30 Jun 2017 01:29:56 -0700
Message-ID: <1498811409-11157-3-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Setting resetwaittime to 0 will result in driver not calling the OCR
during a FW fault state.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 316c3df..395c3aa 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5478,7 +5478,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		instance->throttlequeuedepth =
 				MEGASAS_THROTTLE_QUEUE_DEPTH;
 
-	if (resetwaittime > MEGASAS_RESET_WAIT_TIME)
+	if ((resetwaittime < 1) ||
+	    (resetwaittime > MEGASAS_RESET_WAIT_TIME))
 		resetwaittime = MEGASAS_RESET_WAIT_TIME;
 
 	if ((scmd_timeout < 10) || (scmd_timeout > MEGASAS_DEFAULT_CMD_TIMEOUT))
-- 
2.8.3
