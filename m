From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci PATCH v2 04/18] isci: Don't filter BROADCAST CHANGE primitives
Date: Sat, 10 Mar 2012 23:28:05 -0800
Message-ID: <20120311072805.6320.80719.stgit@dwillia2-linux.jf.intel.com>
References: <20120311072518.6320.61717.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120311072518.6320.61717.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Tom Jackson <thomas.p.jackson@intel.com>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Tom Jackson <thomas.p.jackson@intel.com>

Per the SAS spec, several types of BROADCAST CHANGE primitives
must cause re-discovery of the originating expander.
Only the standard BROADCAST CHANGE primitive was being
sent to the LIBSAS layer.  The other BC primitives have been
added to the sci_phy_event_handler()

Signed-off-by: Tom Jackson <thomas.p.jackson@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/phy.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index c685ab0..474330f 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -875,12 +875,19 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 			sci_change_state(&iphy->sm, SCI_PHY_STARTING);
 			break;
 		case SCU_EVENT_BROADCAST_CHANGE:
+		case SCU_EVENT_BROADCAST_SES:
+		case SCU_EVENT_BROADCAST_RESERVED0:
+		case SCU_EVENT_BROADCAST_RESERVED1:
+		case SCU_EVENT_BROADCAST_EXPANDER:
+		case SCU_EVENT_BROADCAST_AEN:
 			/* Broadcast change received. Notify the port. */
 			if (phy_get_non_dummy_port(iphy) != NULL)
 				sci_port_broadcast_change_received(iphy->owning_port, iphy);
 			else
 				iphy->bcn_received_while_port_unassigned = true;
 			break;
+		case SCU_EVENT_BROADCAST_RESERVED3:
+		case SCU_EVENT_BROADCAST_RESERVED4:
 		default:
 			phy_event_warn(iphy, state, event_code);
 			return SCI_FAILURE_INVALID_STATE;

