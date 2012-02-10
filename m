From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v1 4/5] isci: improve phy event warnings
Date: Fri, 10 Feb 2012 01:18:49 -0800
Message-ID: <20120210091849.26719.66567.stgit@dwillia2-linux.jf.intel.com>
References: <20120210091814.26719.75603.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33945 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758465Ab2BJJDy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2012 04:03:54 -0500
In-Reply-To: <20120210091814.26719.75603.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

isci occasionally spews messages like:

isci 0000:03:00.0: sci_phy_event_handler: PHY starting substate machine received unexpected event_code b3940000

...which is not very helpful, since we don't know which controller,
which phy, the exact state, or a decode of the event.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/phy.c |  123 +++++++++++++++++++++++++++--------------------
 1 files changed, 71 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index 87064f1..fab3586 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -77,12 +77,17 @@ enum sas_linkrate sci_phy_linkrate(struct isci_phy *iphy)
 	return iphy->max_negotiated_speed;
 }
 
-static struct device *sciphy_to_dev(struct isci_phy *iphy)
+static struct isci_host *phy_to_host(struct isci_phy *iphy)
 {
 	struct isci_phy *table = iphy - iphy->phy_index;
 	struct isci_host *ihost = container_of(table, typeof(*ihost), phys[0]);
 
-	return &ihost->pdev->dev;
+	return ihost;
+}
+
+static struct device *sciphy_to_dev(struct isci_phy *iphy)
+{
+	return &phy_to_host(iphy)->pdev->dev;
 }
 
 static enum sci_status
@@ -609,6 +614,60 @@ static void sci_phy_complete_link_training(struct isci_phy *iphy,
 	sci_change_state(&iphy->sm, next_state);
 }
 
+static const char *phy_event_name(u32 event_code)
+{
+	switch (scu_get_event_code(event_code)) {
+	case SCU_EVENT_PORT_SELECTOR_DETECTED:
+		return "port selector";
+	case SCU_EVENT_SENT_PORT_SELECTION:
+		return "port selection";
+	case SCU_EVENT_HARD_RESET_TRANSMITTED:
+		return "tx hard reset";
+	case SCU_EVENT_HARD_RESET_RECEIVED:
+		return "rx hard reset";
+	case SCU_EVENT_RECEIVED_IDENTIFY_TIMEOUT:
+		return "identify timeout";
+	case SCU_EVENT_LINK_FAILURE:
+		return "link fail";
+	case SCU_EVENT_SATA_SPINUP_HOLD:
+		return "sata spinup hold";
+	case SCU_EVENT_SAS_15_SSC:
+	case SCU_EVENT_SAS_15:
+		return "sas 1.5";
+	case SCU_EVENT_SAS_30_SSC:
+	case SCU_EVENT_SAS_30:
+		return "sas 3.0";
+	case SCU_EVENT_SAS_60_SSC:
+	case SCU_EVENT_SAS_60:
+		return "sas 6.0";
+	case SCU_EVENT_SATA_15_SSC:
+	case SCU_EVENT_SATA_15:
+		return "sata 1.5";
+	case SCU_EVENT_SATA_30_SSC:
+	case SCU_EVENT_SATA_30:
+		return "sata 3.0";
+	case SCU_EVENT_SATA_60_SSC:
+	case SCU_EVENT_SATA_60:
+		return "sata 6.0";
+	case SCU_EVENT_SAS_PHY_DETECTED:
+		return "sas detect";
+	case SCU_EVENT_SATA_PHY_DETECTED:
+		return "sata detect";
+	default:
+		return "unknown";
+	}
+}
+
+#define phy_event_dbg(iphy, state, code) \
+	dev_dbg(sciphy_to_dev(iphy), "phy-%d:%d: %s event: %s (%x)\n", \
+		phy_to_host(iphy)->id, iphy->phy_index, \
+		phy_state_name(state), phy_event_name(code), code)
+
+#define phy_event_warn(iphy, state, code) \
+	dev_warn(sciphy_to_dev(iphy), "phy-%d:%d: %s event: %s (%x)\n", \
+		phy_to_host(iphy)->id, iphy->phy_index, \
+		phy_state_name(state), phy_event_name(code), code)
+
 enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 {
 	enum sci_phy_states state = iphy->sm.current_state_id;
@@ -625,11 +684,7 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 			iphy->is_in_link_training = true;
 			break;
 		default:
-			dev_dbg(sciphy_to_dev(iphy),
-				"%s: PHY starting substate machine received "
-				"unexpected event_code %x\n",
-				__func__,
-				event_code);
+			phy_event_dbg(iphy, state, event_code);
 			return SCI_FAILURE;
 		}
 		return SCI_SUCCESS;
@@ -666,11 +721,7 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 			sci_change_state(&iphy->sm, SCI_PHY_STARTING);
 			break;
 		default:
-			dev_warn(sciphy_to_dev(iphy),
-				 "%s: PHY starting substate machine received "
-				 "unexpected event_code %x\n",
-				 __func__, event_code);
-
+			phy_event_warn(iphy, state, event_code);
 			return SCI_FAILURE;
 			break;
 		}
@@ -695,10 +746,7 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 			sci_change_state(&iphy->sm, SCI_PHY_STARTING);
 			break;
 		default:
-			dev_warn(sciphy_to_dev(iphy),
-				 "%s: PHY starting substate machine received "
-				 "unexpected event_code %x\n",
-				 __func__, event_code);
+			phy_event_warn(iphy, state, event_code);
 			return SCI_FAILURE;
 		}
 		return SCI_SUCCESS;
@@ -709,11 +757,7 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 			sci_change_state(&iphy->sm, SCI_PHY_STARTING);
 			break;
 		default:
-			dev_warn(sciphy_to_dev(iphy),
-				"%s: PHY starting substate machine received unexpected "
-				"event_code %x\n",
-				__func__,
-				event_code);
+			phy_event_warn(iphy, state, event_code);
 			return SCI_FAILURE;
 		}
 		return SCI_SUCCESS;
@@ -737,11 +781,7 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 			break;
 
 		default:
-			dev_warn(sciphy_to_dev(iphy),
-				 "%s: PHY starting substate machine received "
-				 "unexpected event_code %x\n",
-				 __func__, event_code);
-
+			phy_event_warn(iphy, state, event_code);
 			return SCI_FAILURE;
 		}
 		return SCI_SUCCESS;
@@ -769,12 +809,7 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 			sci_phy_start_sas_link_training(iphy);
 			break;
 		default:
-			dev_warn(sciphy_to_dev(iphy),
-				 "%s: PHY starting substate machine received "
-				 "unexpected event_code %x\n",
-				 __func__,
-				 event_code);
-
+			phy_event_warn(iphy, state, event_code);
 			return SCI_FAILURE;
 		}
 		return SCI_SUCCESS;
@@ -811,11 +846,7 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 			sci_phy_start_sas_link_training(iphy);
 			break;
 		default:
-			dev_warn(sciphy_to_dev(iphy),
-				 "%s: PHY starting substate machine received "
-				 "unexpected event_code %x\n",
-				 __func__, event_code);
-
+			phy_event_warn(iphy, state, event_code);
 			return SCI_FAILURE;
 		}
 
@@ -833,12 +864,7 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 			break;
 
 		default:
-			dev_warn(sciphy_to_dev(iphy),
-				 "%s: PHY starting substate machine received "
-				 "unexpected event_code %x\n",
-				 __func__,
-				 event_code);
-
+			phy_event_warn(iphy, state, event_code);
 			return SCI_FAILURE;
 		}
 		return SCI_SUCCESS;
@@ -856,10 +882,7 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 				iphy->bcn_received_while_port_unassigned = true;
 			break;
 		default:
-			dev_warn(sciphy_to_dev(iphy),
-				 "%sP SCIC PHY 0x%p ready state machine received "
-				 "unexpected event_code %x\n",
-				 __func__, iphy, event_code);
+			phy_event_warn(iphy, state, event_code);
 			return SCI_FAILURE_INVALID_STATE;
 		}
 		return SCI_SUCCESS;
@@ -870,11 +893,7 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 			sci_change_state(&iphy->sm, SCI_PHY_STARTING);
 			break;
 		default:
-			dev_warn(sciphy_to_dev(iphy),
-				 "%s: SCIC PHY 0x%p resetting state machine received "
-				 "unexpected event_code %x\n",
-				 __func__, iphy, event_code);
-
+			phy_event_warn(iphy, state, event_code);
 			return SCI_FAILURE_INVALID_STATE;
 			break;
 		}

