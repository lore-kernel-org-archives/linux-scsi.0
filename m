From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] scsi: ufs: set host_byte to DID_REQUEUE when ocs =
 OCS_ABORTED
Date: Mon, 03 Jul 2017 14:28:55 -0700
Message-ID: <22074c5c51929db6c70d04f7b2b5dab2@codeaurora.org>
References: <20170624102722.4050-1-zangleigang@hisilicon.com>
 <7bb81ce8005715d416539754246b2989@codeaurora.org>
 <20170629022441.GA43315@kirin.host.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39784 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752406AbdGCV26 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jul 2017 17:28:58 -0400
In-Reply-To: <20170629022441.GA43315@kirin.host.huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zang Leigang <zangleigang@hisilicon.com>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2017-06-28 19:25, Zang Leigang wrote:
> On Wed, Jun 28, 2017 at 04:42:36PM -0700, Subhash Jadavani wrote:
>> On 2017-06-24 03:27, Zang Leigang wrote:
>> >Host set ocs to OCS_ABORTED when clear a doorbell in err handler.
>> 
>> OCS field is valid after host controller has cleared the
>> corresponding doorbell (UTRLDBR) bit to zero. And here HW would be
>> clearing the doorbell bit, not the SW. So I am not sure what do you
>> mean in sentence above? Can you please elaborate more on this?
>> 
> Err handler clear PENDING transfer requests with ufshcd_clear_cmd,
> and host set these requests's ocs to 6(OCS_ABORTED). I think it's

If we are saying that "Host controller setting the OCS to 6 when SW 
clears a tag in UTRLCLR" then it isn't a UFSHCI standard defined 
behavior instead this seems to be very specific to your UFS controller 
specific behavior. Ideally OCS shouldn't be modified by host in this 
case and as SW has set the OCS to OCS_INVALID_COMMAND_STATUS before the 
transfer, request will be re-queued. If you want to handle the 
OCS_ABORTED differently for your host controllers, you may have to add 
the host controller quirk and enable it for your controllers.

> better to let these request retry, because an err handler may fix
> the err condition.
>> 
>> >Then scsi_decide_disposition return SUCCESS. This may cause some
>> >filesystem panic because a FAILED REQUESET. Requeue and complete is
>> >better.
>> 
>> Why do you think retrying this HW aborted request will succeed next
>> time? Are we going to fix some request parameters before retrying?
>> If not, it will most likely fail again.
>> 
> HW aborted request commonly comes from err handler with 
> "ufshcd_clear_cmd",
> In fact, I never seen that host aborted a request on host's own 
> initiative.
> If err handler successfully re-link and fix the host or device, retry 
> will
> most likely success.
>> 
>> >
>> >Signed-off-by: Zang Leigang <zangleigang@hisilicon.com>
>> >
>> >diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> >index ffe8d8608818..e050dcea1bea 100644
>> >--- a/drivers/scsi/ufs/ufshcd.c
>> >+++ b/drivers/scsi/ufs/ufshcd.c
>> >@@ -4545,8 +4545,6 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba,
>> >struct ufshcd_lrb *lrbp)
>> > 		}
>> > 		break;
>> > 	case OCS_ABORTED:
>> >-		result |= DID_ABORT << 16;
>> >-		break;
>> > 	case OCS_INVALID_COMMAND_STATUS:
>> > 		result |= DID_REQUEUE << 16;
>> > 		break;
>> 
>> --
>> The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
>> a Linux Foundation Collaborative Project

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
