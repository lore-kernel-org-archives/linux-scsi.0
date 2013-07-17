From: Xinghai Yu <yuxinghai@cn.fujitsu.com>
Subject: [PATCH] scsi/isci/port_config: Fix a infinite loop.
Date: Wed, 17 Jul 2013 10:54:01 +0800
Message-ID: <1374029641-12649-1-git-send-email-yuxinghai@cn.fujitsu.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60441 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab3GQC5U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Jul 2013 22:57:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lukasz.dorau@intel.com, maciej.patelczyk@intel.com, dave.jiang@intel.com
Cc: linux-scsi@vger.kernel.org, Xinghai Yu <yuxinghai@cn.fujitsu.com>

It seems the "phy_index++;" have been placed in wrong place, without it
the while circle up will do a infinite loop.

Signed-off-by: Xinghai Yu <yuxinghai@cn.fujitsu.com>
---
 drivers/scsi/isci/port_config.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/isci/port_config.c b/drivers/scsi/isci/port_config.c
index cd962da..85c77f6 100644
--- a/drivers/scsi/isci/port_config.c
+++ b/drivers/scsi/isci/port_config.c
@@ -311,9 +311,9 @@ sci_mpc_agent_validate_phy_configuration(struct isci_host *ihost,
 					      &ihost->phys[phy_index]);
 
 			assigned_phy_mask |= (1 << phy_index);
+			phy_index++;
 		}
 
-		phy_index++;
 	}
 
 	return sci_port_configuration_agent_validate_ports(ihost, port_agent);
-- 
1.7.1

