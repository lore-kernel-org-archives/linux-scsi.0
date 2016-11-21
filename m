From: Martin Wilck <mwilck@suse.de>
Subject: [PATCH 1/2] hpsa: cleanup sas_phy structures in sysfs when unloading
Date: Mon, 21 Nov 2016 15:04:28 +0100
Message-ID: <20161121140429.12788-2-mwilck@suse.de>
References: <20161121140429.12788-1-mwilck@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35709 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753215AbcKUOE6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Nov 2016 09:04:58 -0500
In-Reply-To: <20161121140429.12788-1-mwilck@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: don.brace@pmcs.com
Cc: storagedev@pmcs.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, JBottomley@odin.com, hch@lst.de, hare@suse.de, Martin Wilck <mwilck@suse.de>

When the hpsa module is unloaded using rmmod, dangling
symlinks remain under /sys/class/sas_phy. Fix this by
calling sas_phy_delete() rather than sas_phy_free (which,
according to comments, should not be called for PHYs that
have been set up successfully, anyway).

References: bsc#1010946.
Signed-off-by: Martin Wilck <mwilck@suse.de>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index efe2f36..8ec77c3 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -9547,9 +9547,9 @@ static void hpsa_free_sas_phy(struct hpsa_sas_phy *hpsa_sas_phy)
 	struct sas_phy *phy = hpsa_sas_phy->phy;
 
 	sas_port_delete_phy(hpsa_sas_phy->parent_port->port, phy);
-	sas_phy_free(phy);
 	if (hpsa_sas_phy->added_to_port)
 		list_del(&hpsa_sas_phy->phy_list_entry);
+	sas_phy_delete(phy);
 	kfree(hpsa_sas_phy);
 }
 
-- 
2.10.1

