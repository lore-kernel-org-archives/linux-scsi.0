From: akpm@linux-foundation.org
Subject: [patch 6/9] qla2x: fix printk format warnings
Date: Tue, 12 May 2009 13:49:47 -0700
Message-ID: <200905122109.n4CL92Ln011431@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755241AbZELVNJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 May 2009 17:13:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com, seokmann.ju@qlogic.com

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
@@ -943,7 +943,9 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t 
 
 		DEBUG2(qla_printk(KERN_DEBUG, ha, "NPIV[%02x]: wwpn=%llx "
 			"wwnn=%llx vf_id=0x%x Q_qos=0x%x F_qos=0x%x.\n", cnt,
-			vid.port_name, vid.node_name, le16_to_cpu(entry->vf_id),
+			(unsigned long long)vid.port_name,
+			(unsigned long long)vid.node_name,
+			le16_to_cpu(entry->vf_id),
 			entry->q_qos, entry->f_qos));
 
 		if (i < QLA_PRECONFIG_VPORTS) {
@@ -952,7 +954,8 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t 
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
