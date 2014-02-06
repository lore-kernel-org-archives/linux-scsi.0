From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 1/4] isci: fix reset timeout handling
Date: Thu, 06 Feb 2014 12:23:01 -0800
Message-ID: <20140206202301.5227.92580.stgit@viggo.jf.intel.com>
References: <20140206202151.5227.12582.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20140206202151.5227.12582.stgit@viggo.jf.intel.com>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dave.jiang@intel.com, Maciej Patelczyk <maciej.patelczyk@intel.com>, stable@vger.kernel.org, David Milburn <dmilburn@redhat.com>, artur.paszkiewicz@intel.com, lukasz.dorau@intel.com, JBottomley@Parallels.com, Xun Ni <xun.ni@intel.com>
List-Id: linux-scsi@vger.kernel.org

Remove an erroneous BUG_ON() in the case of a hard reset timeout.  The
reset timeout handler puts the port into the "awaiting link-up" state.
The timeout causes the device to be disconnected and we need to be in
the awaiting link-up state to re-connect the port.  The BUG_ON() made
the incorrect assumption that resets never timeout and we always
complete the reset in the "resetting" state.

Testing this patch also uncovered that libata continues to attempt to
reset the port long after the driver has torn down the context.  Once
the driver has committed to abandoning the link it must indicate to
libata that recovery ends by returning -ENODEV from
->lldd_I_T_nexus_reset().

Cc: <stable@vger.kernel.org>
Cc: Maciej Patelczyk <maciej.patelczyk@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Acked-by: Lukasz Dorau <lukasz.dorau@intel.com>
Reported-by: David Milburn <dmilburn@redhat.com>
Reported-by: Xun Ni <xun.ni@intel.com>
Tested-by: Xun Ni <xun.ni@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/port_config.c |    7 -------
 drivers/scsi/isci/task.c        |    2 +-
 2 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/isci/port_config.c b/drivers/scsi/isci/port_config.c
index 85c77f6b802b..ac879745ef80 100644
--- a/drivers/scsi/isci/port_config.c
+++ b/drivers/scsi/isci/port_config.c
@@ -615,13 +615,6 @@ static void sci_apc_agent_link_up(struct isci_host *ihost,
 					  SCIC_SDS_APC_WAIT_LINK_UP_NOTIFICATION);
 	} else {
 		/* the phy is already the part of the port */
-		u32 port_state = iport->sm.current_state_id;
-
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
 
