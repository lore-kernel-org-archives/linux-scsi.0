From: 'Andrew Vasquez' <andrew.vasquez@qlogic.com>
Subject: Re: [patch] fix unnecessary activation of blk tag queue for qla2x00
Date: Wed, 12 Oct 2005 14:34:52 -0700
Message-ID: <20051012213452.GL12468@plap.qlogic.org>
References: <20051012210930.GK12468@plap.qlogic.org> <200510122120.j9CLKVg29381@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:21939 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S932430AbVJLVey (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Oct 2005 17:34:54 -0400
Content-Disposition: inline
In-Reply-To: <200510122120.j9CLKVg29381@unix-os.sc.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Cc: 'Patrick Mansfield' <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

On Wed, 12 Oct 2005, Chen, Kenneth W wrote:

> Andrew Vasquez wrote on Wednesday, October 12, 2005 2:10 PM
> > On Wed, 12 Oct 2005, Chen, Kenneth W wrote:
> > > Yeah, that would indeed be a very good thing to do.  It reminds me
> > > a while back, I was investigating cache miss profile and we
> > > consistently see cache misses on tag[2] variable defined in
> > > qla2x00_start_scsi (used by scsi_populate_tag_msg).  Removing it
> > > would be a very good thing for driver performance.
> > > 
> > > Should I generate the patch?
> > 
> > Drop scsi_populate_tag_msg() interrogation.
> 
> Great! Got a couple "unused variable" compiler warning.  You forgot
> to delete the variable declaration in a hurry ;-)

I deserved that...

Updated patch...follows...

---

Drop scsi_populate_tag_msg() interrogation.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 37f82e2..4b57973 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -316,7 +316,6 @@ qla2x00_start_scsi(srb_t *sp)
 	uint16_t	req_cnt;
 	uint16_t	tot_dsds;
 	struct device_reg_2xxx __iomem *reg;
-	char		tag[2];
 
 	/* Setup device pointers. */
 	ret = 0;
@@ -401,18 +400,6 @@ qla2x00_start_scsi(srb_t *sp)
 
 	/* Update tagged queuing modifier */
 	cmd_pkt->control_flags = __constant_cpu_to_le16(CF_SIMPLE_TAG);
-	if (scsi_populate_tag_msg(cmd, tag)) {
-		switch (tag[0]) {
-		case MSG_HEAD_TAG:
-			cmd_pkt->control_flags =
-			    __constant_cpu_to_le16(CF_HEAD_TAG);
-			break;
-		case MSG_ORDERED_TAG:
-			cmd_pkt->control_flags =
-			    __constant_cpu_to_le16(CF_ORDERED_TAG);
-			break;
-		}
-	}
 
 	/* Load SCSI command packet. */
 	memcpy(cmd_pkt->scsi_cdb, cmd->cmnd, cmd->cmd_len);
@@ -749,7 +736,6 @@ qla24xx_start_scsi(srb_t *sp)
 	uint16_t	req_cnt;
 	uint16_t	tot_dsds;
 	struct device_reg_24xx __iomem *reg;
-	char		tag[2];
 
 	/* Setup device pointers. */
 	ret = 0;
@@ -824,6 +810,7 @@ qla24xx_start_scsi(srb_t *sp)
 	cmd_pkt->handle = handle;
 
 	/* Zero out remaining portion of packet. */
+	/*    tagged queuing modifier -- default is TSK_SIMPLE (0). */
 	clr_ptr = (uint32_t *)cmd_pkt + 2;
 	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
 	cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);
@@ -837,18 +824,6 @@ qla24xx_start_scsi(srb_t *sp)
 	cmd_pkt->lun[1] = LSB(sp->cmd->device->lun);
 	cmd_pkt->lun[2] = MSB(sp->cmd->device->lun);
 
-	/* Update tagged queuing modifier -- default is TSK_SIMPLE (0). */
-	if (scsi_populate_tag_msg(cmd, tag)) {
-		switch (tag[0]) {
-		case MSG_HEAD_TAG:
-			cmd_pkt->task = TSK_HEAD_OF_QUEUE;
-			break;
-		case MSG_ORDERED_TAG:
-			cmd_pkt->task = TSK_ORDERED;
-			break;
-		}
-	}
-
 	/* Load SCSI command packet. */
 	memcpy(cmd_pkt->fcp_cdb, cmd->cmnd, cmd->cmd_len);
 	host_to_fcp_swap(cmd_pkt->fcp_cdb, sizeof(cmd_pkt->fcp_cdb));
