From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 02/12] hpsa: cleanup sas_phy structures in sysfs when
 unloading
Date: Fri, 20 Oct 2017 16:51:14 -0500
Message-ID: <150853627417.28275.14954285884974003997.stgit@brunhilda>
References: <150853443786.28275.17878578984391668998.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0061.outbound.protection.outlook.com ([104.47.38.61]:64704
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753448AbdJTVvS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Oct 2017 17:51:18 -0400
In-Reply-To: <150853443786.28275.17878578984391668998.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.de>

I am resubmitting this patch on behalf of Martin Wilck
with his permission.

The original patch can be found here:
https://www.spinics.net/lists/linux-scsi/msg102083.html

This patch did not help until Hannes's
commit 9441284fbc39 ("scsi-fixup-kernel-warning-during-rmmod")
was applied to the kernel.

--------------------------------------
Original patch description from Martin:
--------------------------------------

When the hpsa module is unloaded using rmmod, dangling
symlinks remain under /sys/class/sas_phy. Fix this by
calling sas_phy_delete() rather than sas_phy_free (which,
according to comments, should not be called for PHYs that
have been set up successfully, anyway).

Tested-by: Don Brace <don.brace@microsemi.com>
Reviewed-by: Don Brace <don.brace@microsemi.com>
Signed-off-by: Martin Wilck <mwilck@xxxxxxx>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index aff4a4f..76461c4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -9207,9 +9207,9 @@ static void hpsa_free_sas_phy(struct hpsa_sas_phy *hpsa_sas_phy)
 	struct sas_phy *phy = hpsa_sas_phy->phy;
 
 	sas_port_delete_phy(hpsa_sas_phy->parent_port->port, phy);
-	sas_phy_free(phy);
 	if (hpsa_sas_phy->added_to_port)
 		list_del(&hpsa_sas_phy->phy_list_entry);
+	sas_phy_delete(phy);
 	kfree(hpsa_sas_phy);
 }
 
