From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] qla2x: fix printk format warnings
Date: Wed, 18 Feb 2009 13:11:20 -0800
Message-ID: <20090218131120.d1beb9f7.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:47025 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbZBRVMg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Feb 2009 16:12:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, jejb <James.Bottomley@HansenPartnership.com>, linux-driver@qlogic.com

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix qla2xxx printk format warnings:

drivers/scsi/qla2xxx/qla_sup.c:915: warning: long long unsigned int format, u64 arg (arg 5)
drivers/scsi/qla2xxx/qla_sup.c:915: warning: long long unsigned int format, u64 arg (arg 6)
drivers/scsi/qla2xxx/qla_sup.c:923: warning: long long unsigned int format, u64 arg (arg 5)
drivers/scsi/qla2xxx/qla_sup.c:923: warning: long long unsigned int format, u64 arg (arg 6)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/qla2xxx/qla_sup.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- lnx2629-rc5-docsrc.orig/drivers/scsi/qla2xxx/qla_sup.c
+++ lnx2629-rc5-docsrc/drivers/scsi/qla2xxx/qla_sup.c
@@ -914,7 +914,9 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t 
 
 		DEBUG2(qla_printk(KERN_DEBUG, ha, "NPIV[%02x]: wwpn=%llx "
 			"wwnn=%llx vf_id=0x%x Q_qos=0x%x F_qos=0x%x.\n", cnt,
-			vid.port_name, vid.node_name, le16_to_cpu(entry->vf_id),
+			(unsigned long long)vid.port_name,
+			(unsigned long long)vid.node_name,
+			le16_to_cpu(entry->vf_id),
 			entry->q_qos, entry->f_qos));
 
 		if (i < QLA_PRECONFIG_VPORTS) {
@@ -923,7 +925,8 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t 
 				qla_printk(KERN_INFO, ha,
 				"NPIV-Config: Failed to create vport [%02x]: "
 				"wwpn=%llx wwnn=%llx.\n", cnt,
-				vid.port_name, vid.node_name);
+				(unsigned long long)vid.port_name,
+				(unsigned long long)vid.node_name);
 		}
 	}
 done:
