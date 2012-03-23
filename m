From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci-rnc PATCH v1 29/37] isci: Change the phy control and link
 reset interface for HW reasons.
Date: Thu, 22 Mar 2012 17:30:28 -0700
Message-ID: <20120323003028.18065.23922.stgit@dwillia2-linux.jf.intel.com>
References: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28579 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031572Ab2CWAPA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2012 20:15:00 -0400
In-Reply-To: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

There is an apparent HW lockup caused when the PE is disabled while there
is an outstanding TC in progress.  This change puts the link into OOB to
force the TC to end before the PE is disabled.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/phy.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index 474330f..6ef3b3e 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -1387,12 +1387,14 @@ int isci_phy_control(struct asd_sas_phy *sas_phy,
 	switch (func) {
 	case PHY_FUNC_DISABLE:
 		spin_lock_irqsave(&ihost->scic_lock, flags);
+		scu_link_layer_start_oob(iphy);
 		sci_phy_stop(iphy);
 		spin_unlock_irqrestore(&ihost->scic_lock, flags);
 		break;
 
 	case PHY_FUNC_LINK_RESET:
 		spin_lock_irqsave(&ihost->scic_lock, flags);
+		scu_link_layer_start_oob(iphy);
 		sci_phy_stop(iphy);
 		sci_phy_start(iphy);
 		spin_unlock_irqrestore(&ihost->scic_lock, flags);

