From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [PATCH] zfcp: Remove scsi_cmnd->serial_number from debug traces
Date: Tue, 28 Sep 2010 10:11:06 +0200
Message-ID: <20100928081103.GA3790@schmichrtp.mainz.de.ibm.com>
References: <1284747709-20862-1-git-send-email-nab@linux-iscsi.org>
 <4C93BB8E.2080501@cisco.com>
 <4C9427B6.9050404@cs.wisc.edu>
 <1284839878.13344.300.camel@haakon2.linux-iscsi.org>
 <20100927140551.GB8473@schmichrtp.mainz.de.ibm.com>
 <1285628548.8880.64.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1285628548.8880.64.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Joe Eykholt <jeykholt@cisco.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Christof Schmitt <christof.schmitt@de.ibm.com>

With the change that drivers have to explicitly request the serial
number for SCSI commands, this field should not be part of the zfcp
traces. It is not worth the effort to request the serial number only
for tracing purposes, so simply remove this field from the debug
traces.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |    4 ----
 drivers/s390/scsi/zfcp_dbf.h |    2 --
 2 files changed, 6 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -154,7 +154,6 @@ void _zfcp_dbf_hba_fsf_response(const ch
 		scsi_cmnd = (struct scsi_cmnd *)fsf_req->data;
 		if (scsi_cmnd) {
 			response->u.fcp.cmnd = (unsigned long)scsi_cmnd;
-			response->u.fcp.serial = scsi_cmnd->serial_number;
 			response->u.fcp.data_dir =
 				qtcb->bottom.io.data_direction;
 		}
@@ -330,7 +329,6 @@ static void zfcp_dbf_hba_view_response(c
 			break;
 		zfcp_dbf_out(p, "data_direction", "0x%04x", r->u.fcp.data_dir);
 		zfcp_dbf_out(p, "scsi_cmnd", "0x%0Lx", r->u.fcp.cmnd);
-		zfcp_dbf_out(p, "scsi_serial", "0x%016Lx", r->u.fcp.serial);
 		*p += sprintf(*p, "\n");
 		break;
 
@@ -881,7 +879,6 @@ void _zfcp_dbf_scsi(const char *tag, con
 				}
 				rec->scsi_result = scsi_cmnd->result;
 				rec->scsi_cmnd = (unsigned long)scsi_cmnd;
-				rec->scsi_serial = scsi_cmnd->serial_number;
 				memcpy(rec->scsi_opcode, scsi_cmnd->cmnd,
 					min((int)scsi_cmnd->cmd_len,
 						ZFCP_DBF_SCSI_OPCODE));
@@ -950,7 +947,6 @@ static int zfcp_dbf_scsi_view_format(deb
 	zfcp_dbf_out(&p, "scsi_lun", "0x%08x", r->scsi_lun);
 	zfcp_dbf_out(&p, "scsi_result", "0x%08x", r->scsi_result);
 	zfcp_dbf_out(&p, "scsi_cmnd", "0x%0Lx", r->scsi_cmnd);
-	zfcp_dbf_out(&p, "scsi_serial", "0x%016Lx", r->scsi_serial);
 	zfcp_dbf_outd(&p, "scsi_opcode", r->scsi_opcode, ZFCP_DBF_SCSI_OPCODE,
 		      0, ZFCP_DBF_SCSI_OPCODE);
 	zfcp_dbf_out(&p, "scsi_retries", "0x%02x", r->scsi_retries);
--- a/drivers/s390/scsi/zfcp_dbf.h
+++ b/drivers/s390/scsi/zfcp_dbf.h
@@ -110,7 +110,6 @@ struct zfcp_dbf_hba_record_response {
 	union {
 		struct {
 			u64 cmnd;
-			u64 serial;
 			u32 data_dir;
 		} fcp;
 		struct {
@@ -206,7 +205,6 @@ struct zfcp_dbf_scsi_record {
 	u32 scsi_lun;
 	u32 scsi_result;
 	u64 scsi_cmnd;
-	u64 scsi_serial;
 #define ZFCP_DBF_SCSI_OPCODE	16
 	u8 scsi_opcode[ZFCP_DBF_SCSI_OPCODE];
 	u8 scsi_retries;
