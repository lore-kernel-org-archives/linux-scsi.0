From: akpm@linux-foundation.org
Subject: [patch 14/15] qla2x: fix printk format warnings
Date: Wed, 04 Mar 2009 12:06:17 -0800
Message-ID: <200903042006.n24K6H1O029304@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756308AbZCDU0W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2009 15:26:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, randy.dunlap@oracle.com, seokmann.ju@qlogic.com

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix qla2xxx printk format warnings:

drivers/scsi/qla2xxx/qla_sup.c:915: warning: long long unsigned int format, u64 arg (arg 5)
drivers/scsi/qla2xxx/qla_sup.c:915: warning: long long unsigned int format, u64 arg (arg 6)
drivers/scsi/qla2xxx/qla_sup.c:923: warning: long long unsigned int format, u64 arg (arg 5)
drivers/scsi/qla2xxx/qla_sup.c:923: warning: long long unsigned int format, u64 arg (arg 6)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla2xxx/qla_sup.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_sup.c~qla2x-fix-printk-format-warnings drivers/scsi/qla2xxx/qla_sup.c
--- a/drivers/scsi/qla2xxx/qla_sup.c~qla2x-fix-printk-format-warnings
+++ a/drivers/scsi/qla2xxx/qla_sup.c
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
_
