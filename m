From: Colin King <colin.king@canonical.com>
Subject: [PATCH][V2] isci: Fix infinite loop in while loop
Date: Fri, 20 Apr 2018 10:57:16 +0100
Message-ID: <20180420095716.2143-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

In the case when the phy_mask is bitwise anded with the
phy_index bit is zero the continue statement currently jumps
to the next iteration of the while loop and phy_index is
never actually incremented, potentially causing an infinite
loop if phy_index is less than SCI_MAX_PHS. Fix this by turning
the while loop into a for loop.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/isci/port_config.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/port_config.c b/drivers/scsi/isci/port_config.c
index edb7be786c65..9e8de1462593 100644
--- a/drivers/scsi/isci/port_config.c
+++ b/drivers/scsi/isci/port_config.c
@@ -291,7 +291,7 @@ sci_mpc_agent_validate_phy_configuration(struct isci_host *ihost,
 		 * Note: We have not moved the current phy_index so we will actually
 		 *       compare the startting phy with itself.
 		 *       This is expected and required to add the phy to the port. */
-		while (phy_index < SCI_MAX_PHYS) {
+		for (; phy_index < SCI_MAX_PHYS; phy_index++) {
 			if ((phy_mask & (1 << phy_index)) == 0)
 				continue;
 			sci_phy_get_sas_address(&ihost->phys[phy_index],
@@ -311,7 +311,6 @@ sci_mpc_agent_validate_phy_configuration(struct isci_host *ihost,
 					      &ihost->phys[phy_index]);
 
 			assigned_phy_mask |= (1 << phy_index);
-			phy_index++;
 		}
 
 	}
-- 
2.17.0
