From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] [SCSI] wd719x: Avoid calling request_firmware under
 spinlock
Date: Thu, 15 Sep 2016 15:08:00 +0100
Message-ID: <b71b38ff-f0d0-83c6-6066-195180b08ea0@huawei.com>
References: <1473947311-9573-1-git-send-email-vaishali.thakkar@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:19957 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757233AbcIOOJz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2016 10:09:55 -0400
In-Reply-To: <1473947311-9573-1-git-send-email-vaishali.thakkar@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vaishali Thakkar <vaishali.thakkar@oracle.com>, jejb@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

On 15/09/2016 14:48, Vaishali Thakkar wrote:
> It is preferrable to use request_firmware where sleeping is
> allowed. Using it under spinlock can cause blocking. Here,
> the function wd719x_chip_init calls request_firmware while
> holding a spinlock. So, let's access it outside the spinlock.
>
> Coccinelle is used to detect the issue.
>
> Signed-off-by: Vaishali Thakkar <vaishali.thakkar@oracle.com>
> ---
> Please note that the patch is compile-tested only. And this change
> may require driver testing.
> ---
>  drivers/scsi/wd719x.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
> index e3da1a2..b8e57f3 100644
> --- a/drivers/scsi/wd719x.c
> +++ b/drivers/scsi/wd719x.c
> @@ -518,13 +518,14 @@ static int wd719x_host_reset(struct scsi_cmnd *cmd)
>  	int result;
>
>  	dev_info(&wd->pdev->dev, "host reset requested\n");
> -	spin_lock_irqsave(wd->sh->host_lock, flags);
> +

In the version of code I have flags is only used for this spinlock, so 
can flags be removed?

>  	/* Try to reinit the RISC */
>  	if (wd719x_chip_init(wd) == 0)
>  		result = SUCCESS;
>  	else
>  		result = FAILED;
>
> +	spin_lock_irqsave(wd->sh->host_lock, flags);
>  	/* flush all SCBs */
>  	list_for_each_entry_safe(scb, tmp, &wd->active_scbs, list) {
>  		struct scsi_cmnd *tmp_cmd = scb->cmd;
>


