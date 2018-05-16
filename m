From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v2 04/10] scsi: ufs: fix exception event handling
Date: Wed, 16 May 2018 14:12:02 -0700
Message-ID: <b8288f705c8829b144ad568784372fc9@codeaurora.org>
References: <cover.1525343531.git.asutoshd@codeaurora.org>
 <01e6421c38e4eb1f67f3c98a8dab44a85f791ef2.1525343531.git.asutoshd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <01e6421c38e4eb1f67f3c98a8dab44a85f791ef2.1525343531.git.asutoshd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Asutosh Das <asutoshd@codeaurora.org>
Cc: cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, Maya Erez <merez@codeaurora.org>, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2018-05-03 04:07, Asutosh Das wrote:
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
> index 6dabce8..838ba8f0 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4967,6 +4967,7 @@ static void
> ufshcd_exception_event_handler(struct work_struct *work)
>  	hba = container_of(work, struct ufs_hba, eeh_work);
> 
>  	pm_runtime_get_sync(hba->dev);
> +	scsi_block_requests(hba->host);
>  	err = ufshcd_get_ee_status(hba, &status);
>  	if (err) {
>  		dev_err(hba->dev, "%s: failed to get exception status %d\n",
> @@ -4980,6 +4981,7 @@ static void
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
