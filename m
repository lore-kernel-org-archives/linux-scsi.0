From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 03/12] hpsa: clear tmpdevice in scan thread
Date: Fri, 20 Oct 2017 16:51:20 -0500
Message-ID: <150853628024.28275.16848478856833596251.stgit@brunhilda>
References: <150853443786.28275.17878578984391668998.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0052.outbound.protection.outlook.com ([104.47.42.52]:5408
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753380AbdJTVvv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Oct 2017 17:51:51 -0400
In-Reply-To: <150853443786.28275.17878578984391668998.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Scott Teel <scott.teel@microsemi.com>

clean up stale information.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 76461c4..0330f17 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4258,6 +4258,8 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 		int phys_dev_index = i - (raid_ctlr_position == 0);
 		bool skip_device = false;
 
+		memset(tmpdevice, 0, sizeof(*tmpdevice));
+
 		physical_device = i < nphysicals + (raid_ctlr_position == 0);
 
 		/* Figure out where the LUN ID info is coming from */
