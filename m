From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/2] isci: fix missed unlock in apc_agent_timeout()
Date: Wed, 28 Sep 2011 18:35:32 -0700
Message-ID: <20110929013532.23410.10656.stgit@localhost6.localdomain6>
References: <20110929013227.23410.28489.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:2838 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab1I2Bfd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2011 21:35:33 -0400
In-Reply-To: <20110929013227.23410.28489.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, dmilburn@redhat.com, hare@suse.de, stable@kernel.org

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

Needed to jump to scic_lock unlock.

Also spotted by coccicheck.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/port_config.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/isci/port_config.c b/drivers/scsi/isci/port_config.c
index 486b113..38a99d2 100644
--- a/drivers/scsi/isci/port_config.c
+++ b/drivers/scsi/isci/port_config.c
@@ -678,7 +678,7 @@ static void apc_agent_timeout(unsigned long data)
 	configure_phy_mask = ~port_agent->phy_configured_mask & port_agent->phy_ready_mask;
 
 	if (!configure_phy_mask)
-		return;
+		goto done;
 
 	for (index = 0; index < SCI_MAX_PHYS; index++) {
 		if ((configure_phy_mask & (1 << index)) == 0)

