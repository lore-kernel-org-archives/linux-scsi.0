From: Cathy Avery <cavery@redhat.com>
Subject: [PATCH v3 1/2] scsi: scsi_transport_fc: Add dummy initiator role to
 rport
Date: Mon, 17 Apr 2017 14:37:45 -0400
Message-ID: <1492454266-24587-2-git-send-email-cavery@redhat.com>
References: <1492454266-24587-1-git-send-email-cavery@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1492454266-24587-1-git-send-email-cavery@redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: kys@microsoft.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, hch@infradead.org
Cc: devel@linuxdriverproject.org, haiyangz@microsoft.com, sthemmin@microsoft.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch allows scsi drivers that expose virturalized fibre channel
devices but that do not expose rports to successfully rescan the scsi
bus via echo "- - -" > /sys/class/scsi_host/hostX/scan.
Drivers can create a pseudo rport and indicate
FC_PORT_ROLE_FCP_DUMMY_INITIATOR as the rport's role in
fc_rport_identifiers. This insures that a valid scsi_target_id
is assigned to the newly created rport and it can meet the
requirements of fc_user_scan_tgt calling scsi_scan_target.

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 drivers/scsi/scsi_transport_fc.c | 10 ++++++----
 include/scsi/scsi_transport_fc.h |  1 +
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 2d753c9..de85602 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -289,9 +289,10 @@ static const struct {
 	u32 			value;
 	char			*name;
 } fc_port_role_names[] = {
-	{ FC_PORT_ROLE_FCP_TARGET,	"FCP Target" },
-	{ FC_PORT_ROLE_FCP_INITIATOR,	"FCP Initiator" },
-	{ FC_PORT_ROLE_IP_PORT,		"IP Port" },
+	{ FC_PORT_ROLE_FCP_TARGET,		"FCP Target" },
+	{ FC_PORT_ROLE_FCP_INITIATOR,		"FCP Initiator" },
+	{ FC_PORT_ROLE_IP_PORT,			"IP Port" },
+	{ FC_PORT_ROLE_FCP_DUMMY_INITIATOR,	"FCP Dummy Initiator" },
 };
 fc_bitfield_name_search(port_roles, fc_port_role_names)
 
@@ -2628,7 +2629,8 @@ fc_remote_port_create(struct Scsi_Host *shost, int channel,
 	spin_lock_irqsave(shost->host_lock, flags);
 
 	rport->number = fc_host->next_rport_number++;
-	if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
+	if ((rport->roles & FC_PORT_ROLE_FCP_TARGET) ||
+	    (rport->roles & FC_PORT_ROLE_FCP_DUMMY_INITIATOR))
 		rport->scsi_target_id = fc_host->next_target_id++;
 	else
 		rport->scsi_target_id = -1;
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index b21b8aa5..6e208bb 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -162,6 +162,7 @@ enum fc_tgtid_binding_type  {
 #define FC_PORT_ROLE_FCP_TARGET			0x01
 #define FC_PORT_ROLE_FCP_INITIATOR		0x02
 #define FC_PORT_ROLE_IP_PORT			0x04
+#define FC_PORT_ROLE_FCP_DUMMY_INITIATOR	0x08
 
 /* The following are for compatibility */
 #define FC_RPORT_ROLE_UNKNOWN			FC_PORT_ROLE_UNKNOWN
-- 
2.5.0
