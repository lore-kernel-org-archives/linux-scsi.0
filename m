From: Brian King <brking@us.ibm.com>
Subject: [PATCH 3/5] ipr fix for ioa reset timeout oops
Date: Sat, 22 May 2004 19:50:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40AFF56E.6050904@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000808070101010909060506"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:34984 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262020AbUEWAu4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 May 2004 20:50:56 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------000808070101010909060506
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------000808070101010909060506
Content-Type: text/plain;
 name="ipr_ioa_reset_timeout_oops-3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipr_ioa_reset_timeout_oops-3.patch"


This patch fixes an oops discovered in test which can occur
on bad hardware if the ipr adapter times out coming operational. 


---

 linux-2.6.6-bjking1/drivers/scsi/ipr.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/scsi/ipr.c~ipr_ioa_reset_timeout_oops drivers/scsi/ipr.c
--- linux-2.6.6/drivers/scsi/ipr.c~ipr_ioa_reset_timeout_oops	2004-05-22 14:49:44.000000000 -0500
+++ linux-2.6.6-bjking1/drivers/scsi/ipr.c	2004-05-22 17:17:47.000000000 -0500
@@ -3179,6 +3179,7 @@ static irqreturn_t ipr_handle_other_inte
 		writel(IPR_PCII_IOA_TRANS_TO_OPER, ioa_cfg->regs.clr_interrupt_reg);
 		int_reg = readl(ioa_cfg->regs.sense_interrupt_reg);
 
+		list_del(&ioa_cfg->reset_cmd->queue);
 		del_timer(&ioa_cfg->reset_cmd->timer);
 		ipr_reset_ioa_job(ioa_cfg->reset_cmd);
 	} else {
@@ -4806,6 +4807,7 @@ static int ipr_reset_enable_ioa(struct i
 	ipr_cmd->timer.expires = jiffies + IPR_OPERATIONAL_TIMEOUT;
 	ipr_cmd->timer.function = (void (*)(unsigned long))ipr_timeout;
 	add_timer(&ipr_cmd->timer);
+	list_add_tail(&ipr_cmd->queue, &ioa_cfg->pending_q);
 
 	LEAVE;
 	return IPR_RC_JOB_RETURN;

_

--------------000808070101010909060506--

