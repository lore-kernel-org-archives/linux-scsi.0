From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/2]  qla2xxx: Correct short-WRITE status handling.
Date: Tue, 6 Dec 2005 10:58:06 -0800
Message-ID: <20051206185805.GF997@andrew-vasquezs-powerbook-g4-15.local>
References: <20051206185521.GD997@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:27976 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S965023AbVLFS6I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2005 13:58:08 -0500
Content-Disposition: inline
In-Reply-To: <20051206185521.GD997@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@steeleye.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

Properly check FC_RESID for any non-transfered bytes
regardless of firmware completion status.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_isr.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

cbf1620234849d5f2adc85e893f84877cd2e5296
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 09afc0f..5181d96 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -909,6 +909,21 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 			resid = resid_len;
 			cp->resid = resid;
 			CMD_RESID_LEN(cp) = resid;
+
+			if (!lscsi_status &&
+			    ((unsigned)(cp->request_bufflen - resid) <
+			     cp->underflow)) {
+				qla_printk(KERN_INFO, ha,
+				    "scsi(%ld:%d:%d:%d): Mid-layer underflow "
+				    "detected (%x of %x bytes)...returning "
+				    "error status.\n", ha->host_no,
+				    cp->device->channel, cp->device->id,
+				    cp->device->lun, resid,
+				    cp->request_bufflen);
+
+				cp->result = DID_ERROR << 16;
+				break;
+			}
 		}
 		cp->result = DID_OK << 16 | lscsi_status;
 
-- 
0.99.9.GIT
