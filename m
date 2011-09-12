From: Tim Gardner <tim.gardner@canonical.com>
Subject: [PATCH] isci: Make warning messages unique
Date: Mon, 12 Sep 2011 14:46:12 -0600
Message-ID: <4E6E6F94.4050502@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040509060600050303060808"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:1715 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab1ILUqP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2011 16:46:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dan.j.williams@intel.com, edmund.nadolski@intel.com, dave.jiang@intel.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------040509060600050303060808
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I've got a 2-way Sandybridge server with an 'Intel(R) C600 SAS 
Controller'. The driver makes a boatload of dmesg noise with non-unique 
messages distinguished only by the event code. For example, I've got 296 
of these in dmesg:

(NULL device *): sci_phy_event_handler:735: PHY starting substate 
machine received unexpected event_code b3402000

In an effort to discover which of the 9 places from which this message 
was emitted I added a line number.

The next step is to decide if all of these really need to be dev_warn().

rtg
-- 
Tim Gardner tim.gardner@canonical.com

--------------040509060600050303060808
Content-Type: text/x-patch;
 name="0001-isci-Make-warning-messages-unique.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-isci-Make-warning-messages-unique.patch"

>From dd6dc25630bb10e01b6c3133217d2dc987ab1ed0 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Mon, 12 Sep 2011 13:39:20 -0600
Subject: [PATCH] isci: Make warning messages unique

There are a number of warning messages that are identical. Make
them unique by adding a line number to the printed string.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/scsi/isci/phy.c |   43 ++++++++++++++++++++-----------------------
 1 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index 79313a7..33365f8 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -546,10 +546,9 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 			break;
 		default:
 			dev_dbg(sciphy_to_dev(iphy),
-				"%s: PHY starting substate machine received "
+				"%s:%d: PHY starting substate machine received "
 				"unexpected event_code %x\n",
-				__func__,
-				event_code);
+				__func__, __LINE__, event_code);
 			return SCI_FAILURE;
 		}
 		return SCI_SUCCESS;
@@ -587,9 +586,9 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 			break;
 		default:
 			dev_warn(sciphy_to_dev(iphy),
-				 "%s: PHY starting substate machine received "
+				 "%s:%d: PHY starting substate machine received "
 				 "unexpected event_code %x\n",
-				 __func__, event_code);
+				 __func__, __LINE__, event_code);
 
 			return SCI_FAILURE;
 			break;
@@ -616,9 +615,9 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 			break;
 		default:
 			dev_warn(sciphy_to_dev(iphy),
-				 "%s: PHY starting substate machine received "
+				 "%s:%d: PHY starting substate machine received "
 				 "unexpected event_code %x\n",
-				 __func__, event_code);
+				 __func__, __LINE__, event_code);
 			return SCI_FAILURE;
 		}
 		return SCI_SUCCESS;
@@ -630,9 +629,9 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 			break;
 		default:
 			dev_warn(sciphy_to_dev(iphy),
-				"%s: PHY starting substate machine received unexpected "
+				"%s:%d: PHY starting substate machine received unexpected "
 				"event_code %x\n",
-				__func__,
+				__func__, __LINE__,
 				event_code);
 			return SCI_FAILURE;
 		}
@@ -658,9 +657,9 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 
 		default:
 			dev_warn(sciphy_to_dev(iphy),
-				 "%s: PHY starting substate machine received "
+				 "%s:%d: PHY starting substate machine received "
 				 "unexpected event_code %x\n",
-				 __func__, event_code);
+				 __func__, __LINE__, event_code);
 
 			return SCI_FAILURE;
 		}
@@ -690,10 +689,9 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 			break;
 		default:
 			dev_warn(sciphy_to_dev(iphy),
-				 "%s: PHY starting substate machine received "
+				 "%s:%d: PHY starting substate machine received "
 				 "unexpected event_code %x\n",
-				 __func__,
-				 event_code);
+				 __func__, __LINE__, event_code);
 
 			return SCI_FAILURE;;
 		}
@@ -732,9 +730,9 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 			break;
 		default:
 			dev_warn(sciphy_to_dev(iphy),
-				 "%s: PHY starting substate machine received "
+				 "%s:%d: PHY starting substate machine received "
 				 "unexpected event_code %x\n",
-				 __func__, event_code);
+				 __func__, __LINE__, event_code);
 
 			return SCI_FAILURE;
 		}
@@ -754,10 +752,9 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 
 		default:
 			dev_warn(sciphy_to_dev(iphy),
-				 "%s: PHY starting substate machine received "
+				 "%s:%d: PHY starting substate machine received "
 				 "unexpected event_code %x\n",
-				 __func__,
-				 event_code);
+				 __func__, __LINE__, event_code);
 
 			return SCI_FAILURE;
 		}
@@ -777,9 +774,9 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 			break;
 		default:
 			dev_warn(sciphy_to_dev(iphy),
-				 "%sP SCIC PHY 0x%p ready state machine received "
+				 "%s:%d: SCIC PHY 0x%p ready state machine received "
 				 "unexpected event_code %x\n",
-				 __func__, iphy, event_code);
+				 __func__, __LINE__, iphy, event_code);
 			return SCI_FAILURE_INVALID_STATE;
 		}
 		return SCI_SUCCESS;
@@ -791,9 +788,9 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 			break;
 		default:
 			dev_warn(sciphy_to_dev(iphy),
-				 "%s: SCIC PHY 0x%p resetting state machine received "
+				 "%s:%d: SCIC PHY 0x%p resetting state machine received "
 				 "unexpected event_code %x\n",
-				 __func__, iphy, event_code);
+				 __func__, __LINE__, iphy, event_code);
 
 			return SCI_FAILURE_INVALID_STATE;
 			break;
-- 
1.7.0.4


--------------040509060600050303060808--
