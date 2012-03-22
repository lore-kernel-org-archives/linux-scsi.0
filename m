From: Dan Williams <dan.j.williams@intel.com>
Subject: [libsas PATCH v12 07/11] libsas: fix false positive 'device
 attached' conditions
Date: Wed, 21 Mar 2012 23:32:29 -0700
Message-ID: <20120322063229.22036.39829.stgit@dwillia2-linux.jf.intel.com>
References: <20120322063127.22036.23206.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:14542 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030862Ab2CVGRD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2012 02:17:03 -0400
In-Reply-To: <20120322063127.22036.23206.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Andrzej Jakowski <andrzej.jakowski@intel.com>

Normalize phy->attached_sas_addr to return a zero-address in the case
when device-type == NO_DEVICE or the linkrate is invalid to handle
expanders that put non-zero sas addresses in the discovery response:

 sas: ex 5001b4da000f903f phy02:U:0 attached: 0100000000000000 (no device)
 sas: ex 5001b4da000f903f phy01:U:0 attached: 0100000000000000 (no device)
 sas: ex 5001b4da000f903f phy03:U:0 attached: 0100000000000000 (no device)
 sas: ex 5001b4da000f903f phy00:U:0 attached: 0100000000000000 (no device)

Reported-by: Andrzej Jakowski <andrzej.jakowski@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_expander.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 5874c7be..48d7ce9 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -240,7 +240,14 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 	phy->attached_sata_ps   = dr->attached_sata_ps;
 	phy->attached_iproto = dr->iproto << 1;
 	phy->attached_tproto = dr->tproto << 1;
-	memcpy(phy->attached_sas_addr, dr->attached_sas_addr, SAS_ADDR_SIZE);
+	/* help some expanders that fail to zero sas_address in the 'no
+	 * device' case
+	 */
+	if (phy->attached_dev_type == NO_DEVICE ||
+	    phy->linkrate < SAS_LINK_RATE_1_5_GBPS)
+		memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
+	else
+		memcpy(phy->attached_sas_addr, dr->attached_sas_addr, SAS_ADDR_SIZE);
 	phy->attached_phy_id = dr->attached_phy_id;
 	phy->phy_change_count = dr->change_count;
 	phy->routing_attr = dr->routing_attr;

