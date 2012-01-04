From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 11/15] isci: enable wide port targets
Date: Wed, 04 Jan 2012 01:33:20 -0800
Message-ID: <20120104093320.9147.43628.stgit@localhost6.localdomain6>
References: <20120104093015.9147.24234.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:35185 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab2ADJdV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jan 2012 04:33:21 -0500
In-Reply-To: <20120104093015.9147.24234.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bartek Nowakowski <bartek.nowakowski@intel.com>

From: Bartek Nowakowski <bartek.nowakowski@intel.com>

Arrange for task_contexts prepared for the wide targets to account for
all the attached phys in the port.

Signed-off-by: Bartek Nowakowski <bartek.nowakowski@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/port.c          |    2 +-
 drivers/scsi/isci/port.h          |    4 ++++
 drivers/scsi/isci/remote_device.c |   10 +++++++---
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 4cb071d..49e8a72 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -114,7 +114,7 @@ static u32 sci_port_get_phys(struct isci_port *iport)
  * value is returned if the specified port is not valid.  When this value is
  * returned, no data is copied to the properties output parameter.
  */
-static enum sci_status sci_port_get_properties(struct isci_port *iport,
+enum sci_status sci_port_get_properties(struct isci_port *iport,
 						struct sci_port_properties *prop)
 {
 	if (!iport || iport->logical_port_index == SCIC_SDS_DUMMY_PORT)
diff --git a/drivers/scsi/isci/port.h b/drivers/scsi/isci/port.h
index cb5ffbc..b3a7f12 100644
--- a/drivers/scsi/isci/port.h
+++ b/drivers/scsi/isci/port.h
@@ -250,6 +250,10 @@ bool sci_port_link_detected(
 	struct isci_port *iport,
 	struct isci_phy *iphy);
 
+enum sci_status sci_port_get_properties(
+	struct isci_port *iport,
+	struct sci_port_properties *prop);
+
 enum sci_status sci_port_link_up(struct isci_port *iport,
 				      struct isci_phy *iphy);
 enum sci_status sci_port_link_down(struct isci_port *iport,
diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index b207cd3..dd74b6c 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -53,6 +53,7 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 #include <scsi/sas.h>
+#include <linux/bitops.h>
 #include "isci.h"
 #include "port.h"
 #include "remote_device.h"
@@ -1101,6 +1102,7 @@ static enum sci_status sci_remote_device_da_construct(struct isci_port *iport,
 						       struct isci_remote_device *idev)
 {
 	enum sci_status status;
+	struct sci_port_properties properties;
 	struct domain_device *dev = idev->domain_dev;
 
 	sci_remote_device_construct(iport, idev);
@@ -1110,6 +1112,11 @@ static enum sci_status sci_remote_device_da_construct(struct isci_port *iport,
 	 * entries will be needed to store the remote node.
 	 */
 	idev->is_direct_attached = true;
+
+	sci_port_get_properties(iport, &properties);
+	/* Get accurate port width from port's phy mask for a DA device. */
+	idev->device_port_width = hweight32(properties.phy_mask);
+
 	status = sci_controller_allocate_remote_node_context(iport->owning_controller,
 								  idev,
 								  &idev->rnc.remote_node_index);
@@ -1125,9 +1132,6 @@ static enum sci_status sci_remote_device_da_construct(struct isci_port *iport,
 
 	idev->connection_rate = sci_port_get_max_allowed_speed(iport);
 
-	/* / @todo Should I assign the port width by reading all of the phys on the port? */
-	idev->device_port_width = 1;
-
 	return SCI_SUCCESS;
 }
 

