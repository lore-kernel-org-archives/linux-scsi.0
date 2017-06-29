From: Zang Leigang <zangleigang@hisilicon.com>
Subject: Re: [PATCH] scsi: ufs: check link active or not after switch to HS
 mode
Date: Thu, 29 Jun 2017 11:04:50 +0800
Message-ID: <20170629030450.GA46969@kirin.host.huawei.com>
References: <20170624114405.18475-1-zangleigang@hisilicon.com>
 <0c41133960c09f1aac4c0abeb38afbfd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:9318 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751596AbdF2DFj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2017 23:05:39 -0400
Content-Disposition: inline
In-Reply-To: <0c41133960c09f1aac4c0abeb38afbfd@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On Wed, Jun 28, 2017 at 04:48:21PM -0700, Subhash Jadavani wrote:
> On 2017-06-24 04:44, Zang Leigang wrote:
> >Some device can successfully link and switch to HS mode. But failed
> >to do more. ufshcd_verify_dev_init can help to find this earlier.
> >
> >Signed-off-by: Zang Leigang <zangleigang@hisilicon.com>
> >
> >diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> >index ffe8d8608818..eb03388fc4bd 100644
> >--- a/drivers/scsi/ufs/ufshcd.c
> >+++ b/drivers/scsi/ufs/ufshcd.c
> >@@ -6373,6 +6373,14 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
> > 					__func__, ret);
> > 			goto out;
> > 		}
> >+
> >+		/*
> >+		 * Some device lost link after switch to HS mode. Check if
> >+		 * connect is established here.
> >+		 */
> 
> I have never across such failures. If this issue is limited to
> certain device vendors then I don't think if we want to do send NOP
> unconditionally for all the devices.
> We should probably add quirk for these failed devices and send NOP
> only for such devices.

I have double checked this issue, it's already fixed. This patch doesn't need
any more. Thanks.
> 
> 
> >+		ret = ufshcd_verify_dev_init(hba);
> >+		if (ret)
> >+			goto out;
> > 	}
> >
> > 	/* set the state as operational after switching to desired gear */
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
