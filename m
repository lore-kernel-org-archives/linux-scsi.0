From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [scsi 6/7 RESEND] scsi_debug: fix REPORT LUNS Well Known LU
Date: Tue, 28 Jul 2015 16:54:25 +0300
Message-ID: <1438091666-18113-6-git-send-email-tomas.winkler@intel.com>
References: <1438091666-18113-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438091666-18113-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
List-Id: linux-scsi@vger.kernel.org

The use case to report 'REPORT LUNS WLUN' described
in scsi_debug documentation didn't work because:
scsi_scan_host_selected() checks for:
	 lun < shost->max_lun

To fix this we set:
	max_lun = SCSI_W_LUN_REPORT_LUNS + 1;

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index faa4ddd8decf..2e0b3d7dc40f 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -700,7 +700,7 @@ static void sdebug_max_tgts_luns(void)
 		else
 			hpnt->max_id = scsi_debug_num_tgts;
 		/* scsi_debug_max_luns; */
-		hpnt->max_lun = SCSI_W_LUN_REPORT_LUNS;
+		hpnt->max_lun = SCSI_W_LUN_REPORT_LUNS + 1;
 	}
 	spin_unlock(&sdebug_host_list_lock);
 }
@@ -5340,7 +5340,8 @@ static int sdebug_driver_probe(struct device * dev)
 		hpnt->max_id = scsi_debug_num_tgts + 1;
 	else
 		hpnt->max_id = scsi_debug_num_tgts;
-	hpnt->max_lun = SCSI_W_LUN_REPORT_LUNS;	/* = scsi_debug_max_luns; */
+	/* = scsi_debug_max_luns; */
+	hpnt->max_lun = SCSI_W_LUN_REPORT_LUNS + 1;
 
 	host_prot = 0;
 
-- 
2.4.3
