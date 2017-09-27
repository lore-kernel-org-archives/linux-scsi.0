From: Zang Leigang <zangleigang@hisilicon.com>
Subject: Re: [PATCH] scsi: ufs: add ufs a command complete time stamp
Date: Wed, 27 Sep 2017 11:21:35 +0800
Message-ID: <20170927032135.GA34139@hisi.inhuawei.com>
References: <20170920103040.20613-1-zangleigang@hisilicon.com>
 <f65f3ffadb595304b6610fa24ed9ada4@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:7444 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031618AbdI0DVn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2017 23:21:43 -0400
Content-Disposition: inline
In-Reply-To: <f65f3ffadb595304b6610fa24ed9ada4@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

Hi, Subhash

I send a new patch, forget tag a "PATCH V2", pls check.

On Tue, Sep 26, 2017 at 02:39:06PM -0700, Subhash Jadavani wrote:
> On 2017-09-20 03:30, Zang Leigang wrote:
> >Signed-off-by: Zang Leigang <zangleigang@hisilicon.com>
> >
> >diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> >index 794a4600e952..2984f33095be 100644
> >--- a/drivers/scsi/ufs/ufshcd.c
> >+++ b/drivers/scsi/ufs/ufshcd.c
> >@@ -385,6 +385,8 @@ void ufshcd_print_trs(struct ufs_hba *hba,
> >unsigned long bitmap, bool pr_prdt)
> >
> > 		dev_err(hba->dev, "UPIU[%d] - issue time %lld us\n",
> > 				tag, ktime_to_us(lrbp->issue_time_stamp));
> >+		dev_err(hba->dev, "UPIU[%d] - complete time %lld us\n",
> >+				tag, ktime_to_us(lrbp->complete_time_stamp));
> > 		dev_err(hba->dev,
> > 			"UPIU[%d] - Transfer Request Descriptor phys@0x%llx\n",
> > 			tag, (u64)lrbp->utrd_dma_addr);
> >@@ -1746,6 +1748,7 @@ static inline
> > void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
> > {
> > 	hba->lrb[task_tag].issue_time_stamp = ktime_get();
> >+	hba->lrb[task_tag].complete_time_stamp.tv64 = 0UL;
> 
> can we use ktime_set(0, 0)?
> complete_time_stamp = ktime_set(0, 0);

Sure.

> 
> 
> > 	ufshcd_clk_scaling_start_busy(hba);
> > 	__set_bit(task_tag, &hba->outstanding_reqs);
> > 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> >@@ -4627,6 +4630,8 @@ static void __ufshcd_transfer_req_compl(struct
> >ufs_hba *hba,
> > 		}
> > 		if (ufshcd_is_clkscaling_supported(hba))
> > 			hba->clk_scaling.active_reqs--;
> >+
> >+		lrbp->complete_time_stamp = ktime_get();
> > 	}
> >
> > 	/* clear corresponding bits of completed commands */
> >diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> >index cdc8bd05f7df..67a8f8ef1b06 100644
> >--- a/drivers/scsi/ufs/ufshcd.h
> >+++ b/drivers/scsi/ufs/ufshcd.h
> >@@ -166,6 +166,7 @@ struct ufs_pm_lvl_states {
> >  * @lun: LUN of the command
> >  * @intr_cmd: Interrupt command (doesn't participate in interrupt
> >aggregation)
> >  * @issue_time_stamp: time stamp for debug purposes
> >+ * @complete_time_stamp: time stamp for statistics
> >  * @req_abort_skip: skip request abort task flag
> >  */
> > struct ufshcd_lrb {
> >@@ -189,6 +190,7 @@ struct ufshcd_lrb {
> > 	u8 lun; /* UPIU LUN id field is only 8-bit wide */
> > 	bool intr_cmd;
> > 	ktime_t issue_time_stamp;
> >+	ktime_t complete_time_stamp;
> 
> Just a suggestion for short name, s/complete/compl ? or s/complete/cmpl ?

Accept. compl look better.

> 
> >
> > 	bool req_abort_skip;
> > };
> 
> -- 
> The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> a Linux Foundation Collaborative Project

-- 
Thanks,
Zang Leigang

________________________________________________________________________________
本邮件及其附件含有华为公司的保密信息，仅限于发送给上面地址中列出的个人或群组。禁止任何其他人以任何形式使用（包括但不限于全部或部分地泄露、复制、或散发）本邮件中的信息。如果您错收了本邮件，请您立即电话或邮件通知发件人并删除本邮件！
This e-mail and its attachments contain confidential information from HUAWEI, which is intended only for the person or entity whose address is listed above. Any use of the information contained herein in any way (including, but not limited to, total or partial disclosure, reproduction, or dissemination) by persons other than the intended recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender by phone or email immediately and delete it!
