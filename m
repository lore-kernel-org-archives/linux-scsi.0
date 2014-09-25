From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH] fcoe: extend ethtool to FC port speed mapping
Date: Thu, 25 Sep 2014 11:55:42 -0700
Message-ID: <20140925185542.4804.14268.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:46669 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbaIYSzp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 14:55:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: devel@open-fcoe.org, Chris Leech <cleech@redhat.com>, Vasu Dev <vasu.dev@intel.com>

From: Chris Leech <cleech@redhat.com>

add support for 20 Gbit and 40 Gbit links

Signed-off-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/fcoe/fcoe_transport.c |   39 ++++++++++++++++++++++++++++++------
 1 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index 74277c2..bdc8989 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -96,14 +96,32 @@ int fcoe_link_speed_update(struct fc_lport *lport)
 	struct ethtool_cmd ecmd;
 
 	if (!__ethtool_get_settings(netdev, &ecmd)) {
-		lport->link_supported_speeds &=
-			~(FC_PORTSPEED_1GBIT | FC_PORTSPEED_10GBIT);
+		lport->link_supported_speeds &= ~(FC_PORTSPEED_1GBIT  |
+		                                  FC_PORTSPEED_10GBIT |
+		                                  FC_PORTSPEED_20GBIT |
+		                                  FC_PORTSPEED_40GBIT);
+
 		if (ecmd.supported & (SUPPORTED_1000baseT_Half |
-				      SUPPORTED_1000baseT_Full))
+		                      SUPPORTED_1000baseT_Full |
+		                      SUPPORTED_1000baseKX_Full))
 			lport->link_supported_speeds |= FC_PORTSPEED_1GBIT;
-		if (ecmd.supported & SUPPORTED_10000baseT_Full)
-			lport->link_supported_speeds |=
-				FC_PORTSPEED_10GBIT;
+
+		if (ecmd.supported & (SUPPORTED_10000baseT_Full   |
+		                      SUPPORTED_10000baseKX4_Full |
+		                      SUPPORTED_10000baseKR_Full  |
+		                      SUPPORTED_10000baseR_FEC))
+			lport->link_supported_speeds |= FC_PORTSPEED_10GBIT;
+
+		if (ecmd.supported & (SUPPORTED_20000baseMLD2_Full |
+		                      SUPPORTED_20000baseKR2_Full))
+			lport->link_supported_speeds |= FC_PORTSPEED_20GBIT;
+
+		if (ecmd.supported & (SUPPORTED_40000baseKR4_Full |
+		                      SUPPORTED_40000baseCR4_Full |
+		                      SUPPORTED_40000baseSR4_Full |
+		                      SUPPORTED_40000baseLR4_Full))
+			lport->link_supported_speeds |= FC_PORTSPEED_40GBIT;
+
 		switch (ethtool_cmd_speed(&ecmd)) {
 		case SPEED_1000:
 			lport->link_speed = FC_PORTSPEED_1GBIT;
@@ -111,6 +129,15 @@ int fcoe_link_speed_update(struct fc_lport *lport)
 		case SPEED_10000:
 			lport->link_speed = FC_PORTSPEED_10GBIT;
 			break;
+		case 20000:
+			lport->link_speed = FC_PORTSPEED_20GBIT;
+			break;
+		case 40000:
+			lport->link_speed = FC_PORTSPEED_40GBIT;
+			break;
+		default:
+			lport->link_speed = FC_PORTSPEED_UNKNOWN;
+			break;
 		}
 		return 0;
 	}

