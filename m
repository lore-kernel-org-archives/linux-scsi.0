From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 17/41] scsi: isci: phy: Mark expected switch fall-through
Date: Tue, 27 Nov 2018 22:29:55 -0600
Message-ID: <c07224fd421852f2cb717e6a3e6180eacb5ba372.1543374820.git.gustavo@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 703127 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/isci/phy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index 1deca8c5a94f..7f9b3f20e5e4 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -778,6 +778,7 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 			break;
 		case SCU_EVENT_LINK_FAILURE:
 			scu_link_layer_set_txcomsas_timeout(iphy, SCU_SAS_LINK_LAYER_TXCOMSAS_NEGTIME_DEFAULT);
+			/* fall through */
 		case SCU_EVENT_HARD_RESET_RECEIVED:
 			/* Start the oob/sn state machine over again */
 			sci_change_state(&iphy->sm, SCI_PHY_STARTING);
-- 
2.17.1
