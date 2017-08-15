From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: mpt3sas: fix pr_info message continuation
Date: Tue, 15 Aug 2017 14:51:45 +0100
Message-ID: <20170815135145.25792-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

An optional discovery status should be printed with a pr_cont
and needs a leading space to make it more readable. The final
new line should also be a pr_cont and the indentation is out
by one, so fix that too.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 8a44636ab0b5..87999905bca3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -615,9 +615,9 @@ _base_display_event_data(struct MPT3SAS_ADAPTER *ioc,
 		    (event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_STARTED) ?
 		    "start" : "stop");
 		if (event_data->DiscoveryStatus)
-			pr_info("discovery_status(0x%08x)",
+			pr_cont(" discovery_status(0x%08x)",
 			    le32_to_cpu(event_data->DiscoveryStatus));
-			pr_info("\n");
+		pr_cont("\n");
 		return;
 	}
 	case MPI2_EVENT_SAS_BROADCAST_PRIMITIVE:
-- 
2.11.0
