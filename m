Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D884C432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 03:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A8792071B
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 03:49:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WoaoEDcd";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="NBobyruV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfKRDtM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Nov 2019 22:49:12 -0500
Received: from a27-188.smtp-out.us-west-2.amazonses.com ([54.240.27.188]:58134
        "EHLO a27-188.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726266AbfKRDtM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 17 Nov 2019 22:49:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574048951;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=BDrdFvKtIo++sKrKY935gXbudg7//mGUtoHgAcJpeyA=;
        b=WoaoEDcdrUFUyhwguuJ7hqaeBf55K6RD4ji7swRNPl1OB8dGmchavKpEvLiJ9U4h
        59DIGn9tKjl8Kr4nvOU0qAs7DA6yLlKVy71N0uVYb6Il+BV4eoeXwyeE/Cf5Dlu9cS8
        0z8bHVy+Do03w4aYucke32FLu1FUAdmra7Yi0CrA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574048951;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=BDrdFvKtIo++sKrKY935gXbudg7//mGUtoHgAcJpeyA=;
        b=NBobyruVqCyCvn9I2mCOAyk4gQRfRbcz6z6iDI8PIxlfSRwJ6UpDwMaVF3wII28B
        4/LL6RHr0qH9CLNEFoABZ9e8pXb8APwG7NTpVErtzwveOyE7Sr1qj3oUnmu2ca+mAwE
        PwGsscfsePezHjb2SASo0gTErQylJ3jxQBi/A/hM=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 18 Nov 2019 03:49:10 +0000
From:   cang@codeaurora.org
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>, stummala@codeaurora.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-scsi@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [EXT] Re: [PATCH v5 4/4] ufs: Simplify the clock scaling
 mechanism implementation
In-Reply-To: <425c127b-d8f9-0a96-64c1-4c9862ca5f43@acm.org>
References: <20191112173743.141503-1-bvanassche@acm.org>
 <20191112173743.141503-5-bvanassche@acm.org>
 <a26c719466edfd2c41eea789a6c908ab@codeaurora.org>
 <8acd9237-7414-5dce-5285-69ed3ce6f28c@acm.org>
 <BN7PR08MB56843E1941F42BEF8239B895DB760@BN7PR08MB5684.namprd08.prod.outlook.com>
 <ca27868b-9d25-36b9-7548-02252c293905@acm.org>
 <e0ab904e1413ae6a89cebbced22a6cf8@codeaurora.org>
 <425c127b-d8f9-0a96-64c1-4c9862ca5f43@acm.org>
Message-ID: <0101016e7ca0ea59-4d48f49b-bcf0-4466-9ace-f6229482a43f-000000@us-west-2.amazonses.com>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.11.18-54.240.27.188
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-16 00:23, Bart Van Assche wrote:
> On 11/14/19 10:01 PM, Can Guo wrote:
>> After ufshcd_clock_scaling_prepare() returns(no error), all request 
>> queues are frozen. If failure
>> happens(say power mode change command fails) after this point and 
>> error handler kicks off,
>> we need to send dev commands(in ufshcd_probe_hba()) to bring UFS back 
>> to functionality.
>> However, as the hba->cmd_queue is frozen, dev commands cannot be sent, 
>> the error handler shall fail.
> 
> Hi Can,
> 
> I think that's easy to address. How about replacing patch 4/4 with the
> patch below?
> 
> Thanks,
> 
> Bart.
> 
> 
> Subject: [PATCH] ufs: Simplify the clock scaling mechanism 
> implementation
> 
> Scaling the clock is only safe while no commands are in progress. Use
> blk_mq_{un,}freeze_queue() to block submission of new commands and to
> wait for ongoing commands to complete. This patch removes a semaphore
> down and up operation pair from the hot path.
> 
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 115 +++++++++++---------------------------
>  drivers/scsi/ufs/ufshcd.h |   1 -
>  2 files changed, 33 insertions(+), 83 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 5314e8bfeeb6..343f9b746b70 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -971,65 +971,6 @@ static bool
> ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
>  	return false;
>  }
> 
> -static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
> -					u64 wait_timeout_us)
> -{
> -	unsigned long flags;
> -	int ret = 0;
> -	u32 tm_doorbell;
> -	u32 tr_doorbell;
> -	bool timeout = false, do_last_check = false;
> -	ktime_t start;
> -
> -	ufshcd_hold(hba, false);
> -	spin_lock_irqsave(hba->host->host_lock, flags);
> -	/*
> -	 * Wait for all the outstanding tasks/transfer requests.
> -	 * Verify by checking the doorbell registers are clear.
> -	 */
> -	start = ktime_get();
> -	do {
> -		if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
> -			ret = -EBUSY;
> -			goto out;
> -		}
> -
> -		tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
> -		tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> -		if (!tm_doorbell && !tr_doorbell) {
> -			timeout = false;
> -			break;
> -		} else if (do_last_check) {
> -			break;
> -		}
> -
> -		spin_unlock_irqrestore(hba->host->host_lock, flags);
> -		schedule();
> -		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
> -		    wait_timeout_us) {
> -			timeout = true;
> -			/*
> -			 * We might have scheduled out for long time so make
> -			 * sure to check if doorbells are cleared by this time
> -			 * or not.
> -			 */
> -			do_last_check = true;
> -		}
> -		spin_lock_irqsave(hba->host->host_lock, flags);
> -	} while (tm_doorbell || tr_doorbell);
> -
> -	if (timeout) {
> -		dev_err(hba->dev,
> -			"%s: timedout waiting for doorbell to clear (tm=0x%x, tr=0x%x)\n",
> -			__func__, tm_doorbell, tr_doorbell);
> -		ret = -EBUSY;
> -	}
> -out:
> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
> -	ufshcd_release(hba);
> -	return ret;
> -}
> -
>  /**
>   * ufshcd_scale_gear - scale up/down UFS gear
>   * @hba: per adapter instance
> @@ -1079,27 +1020,49 @@ static int ufshcd_scale_gear(struct ufs_hba
> *hba, bool scale_up)
> 
>  static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
>  {
> -	#define DOORBELL_CLR_TOUT_US		(1000 * 1000) /* 1 sec */
> -	int ret = 0;
> +	unsigned long deadline = jiffies + HZ;
> +	struct scsi_device *sdev;
> +	int res = 0;
> +
>  	/*
>  	 * make sure that there are no outstanding requests when
>  	 * clock scaling is in progress
>  	 */
> -	ufshcd_scsi_block_requests(hba);
> -	down_write(&hba->clk_scaling_lock);
> -	if (ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
> -		ret = -EBUSY;
> -		up_write(&hba->clk_scaling_lock);
> -		ufshcd_scsi_unblock_requests(hba);
> +	shost_for_each_device(sdev, hba->host)
> +		blk_freeze_queue_start(sdev->request_queue);
> +	blk_freeze_queue_start(hba->cmd_queue);
> +	blk_freeze_queue_start(hba->tmf_queue);
> +	shost_for_each_device(sdev, hba->host) {
> +		if (blk_mq_freeze_queue_wait_timeout(sdev->request_queue,
> +				max_t(long, 0, deadline - jiffies)) <= 0) {
> +			goto err;
> +		}
>  	}
> +	if (blk_mq_freeze_queue_wait_timeout(hba->cmd_queue,
> +				max_t(long, 0, deadline - jiffies)) <= 0)
> +		goto err;
> +	if (blk_mq_freeze_queue_wait_timeout(hba->tmf_queue,
> +				max_t(long, 0, deadline - jiffies)) <= 0)
> +		goto err;
> 
> -	return ret;
> +out:
> +	blk_mq_unfreeze_queue(hba->tmf_queue);
> +	blk_mq_unfreeze_queue(hba->cmd_queue);

Hi Bart,

After this point, dev commands can be sent on hba->cmd_queue.
But there are multiple entries which users can send dev commands through 
in ufs-sysfs.c.
So the clock scaling sequence lost its protection from being disturbed.

Best Regards,
Can Guo.

> +	return res;
> +
> +err:
> +	shost_for_each_device(sdev, hba->host)
> +		blk_mq_unfreeze_queue(sdev->request_queue);
> +	res = -ETIMEDOUT;
> +	goto out;
>  }
> 
>  static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
>  {
> -	up_write(&hba->clk_scaling_lock);
> -	ufshcd_scsi_unblock_requests(hba);
> +	struct scsi_device *sdev;
> +
> +	shost_for_each_device(sdev, hba->host)
> +		blk_mq_unfreeze_queue(sdev->request_queue);
>  }
> 
>  /**
> @@ -2394,9 +2357,6 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
>  		BUG();
>  	}
> 
> -	if (!down_read_trylock(&hba->clk_scaling_lock))
> -		return SCSI_MLQUEUE_HOST_BUSY;
> -
>  	spin_lock_irqsave(hba->host->host_lock, flags);
>  	switch (hba->ufshcd_state) {
>  	case UFSHCD_STATE_OPERATIONAL:
> @@ -2462,7 +2422,6 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
>  out_unlock:
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
>  out:
> -	up_read(&hba->clk_scaling_lock);
>  	return err;
>  }
> 
> @@ -2616,8 +2575,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba 
> *hba,
>  	struct completion wait;
>  	unsigned long flags;
> 
> -	down_read(&hba->clk_scaling_lock);
> -
>  	/*
>  	 * Get free slot, sleep if slots are unavailable.
>  	 * Even though we use wait_event() which sleeps indefinitely,
> @@ -2653,7 +2610,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba 
> *hba,
> 
>  out_put_tag:
>  	blk_put_request(req);
> -	up_read(&hba->clk_scaling_lock);
>  	return err;
>  }
> 
> @@ -5771,8 +5727,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct
> ufs_hba *hba,
>  	unsigned long flags;
>  	u32 upiu_flags;
> 
> -	down_read(&hba->clk_scaling_lock);
> -
>  	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
>  	if (IS_ERR(req))
>  		return PTR_ERR(req);
> @@ -5854,7 +5808,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct
> ufs_hba *hba,
>  	}
> 
>  	blk_put_request(req);
> -	up_read(&hba->clk_scaling_lock);
>  	return err;
>  }
> 
> @@ -8323,8 +8276,6 @@ int ufshcd_init(struct ufs_hba *hba, void
> __iomem *mmio_base, unsigned int irq)
>  	/* Initialize mutex for device management commands */
>  	mutex_init(&hba->dev_cmd.lock);
> 
> -	init_rwsem(&hba->clk_scaling_lock);
> -
>  	ufshcd_init_clk_gating(hba);
> 
>  	ufshcd_init_clk_scaling(hba);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 5865e16f53a6..5ebb920ae874 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -724,7 +724,6 @@ struct ufs_hba {
>  	enum bkops_status urgent_bkops_lvl;
>  	bool is_urgent_bkops_lvl_checked;
> 
> -	struct rw_semaphore clk_scaling_lock;
>  	struct ufs_desc_size desc_size;
>  	atomic_t scsi_block_reqs_cnt;
