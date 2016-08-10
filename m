From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 01/10] zfcp: fix fc_host port_type with NPIV
Date: Wed, 10 Aug 2016 18:30:44 +0200
Message-ID: <1470846653-90691-2-git-send-email-maier@linux.vnet.ibm.com>
References: <1470846653-90691-1-git-send-email-maier@linux.vnet.ibm.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1470846653-90691-1-git-send-email-maier@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, "#2 . 6 . 30+" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

For an NPIV-enabled FCP device, zfcp can erroneously show
"NPort (fabric via point-to-point)" instead of "NPIV VPORT"
for the port_type sysfs attribute of the corresponding
fc_host.
s390-tools that can be affected are dbginfo.sh and ziomon.

zfcp_fsf_exchange_config_evaluate() ignores
fsf_qtcb_bottom_config.connection_features indicating NPIV
and only sets fc_host_port_type to FC_PORTTYPE_NPORT if
fsf_qtcb_bottom_config.fc_topology is FSF_TOPO_FABRIC.

Only the independent zfcp_fsf_exchange_port_evaluate()
evaluates connection_features to overwrite fc_host_port_type
to FC_PORTTYPE_NPIV in case of NPIV.
Code was introduced with upstream kernel 2.6.30
commit 0282985da5923fa6365adcc1a1586ae0c13c1617
("[SCSI] zfcp: Report fc_host_port_type as NPIV").

This works during FCP device recovery (such as set online)
because it performs FSF_QTCB_EXCHANGE_CONFIG_DATA followed by
FSF_QTCB_EXCHANGE_PORT_DATA in sequence.

However, the zfcp-specific scsi host sysfs attributes
"requests", "megabytes", or "seconds_active" trigger only
zfcp_fsf_exchange_config_evaluate() resetting fc_host
port_type to FC_PORTTYPE_NPORT despite NPIV.

The zfcp-specific scsi host sysfs attribute "utilization"
triggers only zfcp_fsf_exchange_port_evaluate() correcting
the fc_host port_type again in case of NPIV.

Evaluate fsf_qtcb_bottom_config.connection_features
in zfcp_fsf_exchange_config_evaluate() where it belongs to.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Fixes: 0282985da592 ("[SCSI] zfcp: Report fc_host_port_type as NPIV")
Cc: <stable@vger.kernel.org> #2.6.30+
Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 522a633c866a..84353f45cfe6 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -3,7 +3,7 @@
  *
  * Implementation of FSF commands.
  *
- * Copyright IBM Corp. 2002, 2013
+ * Copyright IBM Corp. 2002, 2015
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -508,7 +508,10 @@ static int zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *req)
 		fc_host_port_type(shost) = FC_PORTTYPE_PTP;
 		break;
 	case FSF_TOPO_FABRIC:
-		fc_host_port_type(shost) = FC_PORTTYPE_NPORT;
+		if (bottom->connection_features & FSF_FEATURE_NPIV_MODE)
+			fc_host_port_type(shost) = FC_PORTTYPE_NPIV;
+		else
+			fc_host_port_type(shost) = FC_PORTTYPE_NPORT;
 		break;
 	case FSF_TOPO_AL:
 		fc_host_port_type(shost) = FC_PORTTYPE_NLPORT;
@@ -613,7 +616,6 @@ static void zfcp_fsf_exchange_port_evaluate(struct zfcp_fsf_req *req)
 
 	if (adapter->connection_features & FSF_FEATURE_NPIV_MODE) {
 		fc_host_permanent_port_name(shost) = bottom->wwpn;
-		fc_host_port_type(shost) = FC_PORTTYPE_NPIV;
 	} else
 		fc_host_permanent_port_name(shost) = fc_host_port_name(shost);
 	fc_host_maxframe_size(shost) = bottom->maximum_frame_size;
-- 
2.6.6
