From: Zang Leigang <zangleigang@hisilicon.com>
Subject: Re: [PATCH] scsi: ufs: set host_byte to DID_REQUEUE when ocs =
 OCS_ABORTED
Date: Thu, 29 Jun 2017 10:25:30 +0800
Message-ID: <20170629022441.GA43315@kirin.host.huawei.com>
References: <20170624102722.4050-1-zangleigang@hisilicon.com>
 <7bb81ce8005715d416539754246b2989@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:9316 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751614AbdF2C0Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2017 22:26:25 -0400
Content-Disposition: inline
In-Reply-To: <7bb81ce8005715d416539754246b2989@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On Wed, Jun 28, 2017 at 04:42:36PM -0700, Subhash Jadavani wrote:
> On 2017-06-24 03:27, Zang Leigang wrote:
> >Host set ocs to OCS_ABORTED when clear a doorbell in err handler.
> 
> OCS field is valid after host controller has cleared the
> corresponding doorbell (UTRLDBR) bit to zero. And here HW would be
> clearing the doorbell bit, not the SW. So I am not sure what do you
> mean in sentence above? Can you please elaborate more on this?
> 
Err handler clear PENDING transfer requests with ufshcd_clear_cmd,
and host set these requests's ocs to 6(OCS_ABORTED). I think it's
better to let these request retry, because an err handler may fix
the err condition.
> 
> >Then scsi_decide_disposition return SUCCESS. This may cause some
> >filesystem panic because a FAILED REQUESET. Requeue and complete is
> >better.
> 
> Why do you think retrying this HW aborted request will succeed next
> time? Are we going to fix some request parameters before retrying?
> If not, it will most likely fail again.
> 
HW aborted request commonly comes from err handler with "ufshcd_clear_cmd",
In fact, I never seen that host aborted a request on host's own initiative.
If err handler successfully re-link and fix the host or device, retry will
most likely success.
> 
> >
> >Signed-off-by: Zang Leigang <zangleigang@hisilicon.com>
> >
> >diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> >index ffe8d8608818..e050dcea1bea 100644
> >--- a/drivers/scsi/ufs/ufshcd.c
> >+++ b/drivers/scsi/ufs/ufshcd.c
> >@@ -4545,8 +4545,6 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba,
> >struct ufshcd_lrb *lrbp)
> > 		}
> > 		break;
> > 	case OCS_ABORTED:
> >-		result |= DID_ABORT << 16;
> >-		break;
> > 	case OCS_INVALID_COMMAND_STATUS:
> > 		result |= DID_REQUEUE << 16;
> > 		break;
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
