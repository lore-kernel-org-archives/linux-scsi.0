From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH 1/1] scsi: ufs: fix exception event handling
Date: Thu, 08 Feb 2018 09:53:21 -0800
Message-ID: <6c0b3d7d1c38ecb993125bc8e2b85799@codeaurora.org>
References: <1517200492-2941-1-git-send-email-asutoshd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50568 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752448AbeBHRxX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Feb 2018 12:53:23 -0500
In-Reply-To: <1517200492-2941-1-git-send-email-asutoshd@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Asutosh Das <asutoshd@codeaurora.org>
Cc: cang@codeaurora.org, vivek.gautam@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Maya Erez <merez@codeaurora.org>, linux-kernel@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2018-01-28 20:34, Asutosh Das wrote:
> From: Maya Erez <merez@codeaurora.org>
> 
> The device can set the exception event bit in one of the response UPIU,
> for example to notify the need for urgent BKOPs operation.
> In such a case the host driver calls ufshcd_exception_event_handler to
> handle this notification.
> When trying to check the exception event status (for finding the cause 
> for
> the exception event), the device may be busy with additional SCSI 
> commands
> handling and may not respond within the 100ms timeout.
> 
> To prevent that, we need to block SCSI commands during handling of
> exception events and allow retransmissions of the query requests,
> in case of timeout.
> 
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 8af2af3..2dd488f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4955,6 +4955,7 @@ static void
> ufshcd_exception_event_handler(struct work_struct *work)
>  	hba = container_of(work, struct ufs_hba, eeh_work);
> 
>  	pm_runtime_get_sync(hba->dev);
> +	scsi_block_requests(hba->host);
>  	err = ufshcd_get_ee_status(hba, &status);
>  	if (err) {
>  		dev_err(hba->dev, "%s: failed to get exception status %d\n",
> @@ -4968,6 +4969,7 @@ static void
> ufshcd_exception_event_handler(struct work_struct *work)
>  		ufshcd_bkops_exception_event_handler(hba);
> 
>  out:
> +	scsi_unblock_requests(hba->host);
>  	pm_runtime_put_sync(hba->dev);
>  	return;
>  }

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
