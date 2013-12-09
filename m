From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] isci: fix reset timeout handling
Date: Mon, 09 Dec 2013 11:47:09 -0800
Message-ID: <20131209194650.27687.56358.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Xun Ni <xun.ni@intel.com>, dave.jiang@intel.com, lukasz.dorau@intel.com, stable@vger.kernel.org, maciej.patelczyk@intel.com
List-Id: linux-scsi@vger.kernel.org

Remove an erroneous BUG_ON() in the case of a hard reset timeout.  If a
SATA device is unable to restore the link in time we expect the port to
go back to the "awaiting link-up" state.  Since the timeout path
notified libsas that the port is down, we want to notify libsas when it
returns and expect that the port may not be in the "resetting" state.

Also, once we have notified that the port is down, in-progress resets should
abort immediately.  Return -ENODEV from ->lldd_I_T_nexus_reset() to indicate
that libata error handling should end.

Cc: <stable@vger.kernel.org>
Reported-by: Xun Ni <xun.ni@intel.com>
Tested-by: Xun Ni <xun.ni@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/port_config.c |    5 -----
 drivers/scsi/isci/task.c        |    2 +-
 2 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/isci/port_config.c b/drivers/scsi/isci/port_config.c
index 85c77f6b802b..4b84d204db01 100644
--- a/drivers/scsi/isci/port_config.c
+++ b/drivers/scsi/isci/port_config.c
@@ -617,11 +617,6 @@ static void sci_apc_agent_link_up(struct isci_host *ihost,
 		/* the phy is already the part of the port */
 		u32 port_state = iport->sm.current_state_id;
 
-		/* if the PORT'S state is resetting then the link up is from
-		 * port hard reset in this case, we need to tell the port
-		 * that link up is recieved
-		 */
-		BUG_ON(port_state != SCI_PORT_RESETTING);
 		port_agent->phy_ready_mask |= 1 << phy_index;
 		sci_port_link_up(iport, iphy);
 	}
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 0d30ca849e8f..5d6fda72d659 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -801,7 +801,7 @@ int isci_task_I_T_nexus_reset(struct domain_device *dev)
 		/* XXX: need to cleanup any ireqs targeting this
 		 * domain_device
 		 */
-		ret = TMF_RESP_FUNC_COMPLETE;
+		ret = -ENODEV;
 		goto out;
 	}
 
