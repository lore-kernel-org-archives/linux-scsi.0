Return-Path: <SRS0=lopX=ZY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB973C432C3
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 05:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9721C20675
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 05:39:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="d1a5RpY4";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="LqIWO9ul"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfLBFjS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Dec 2019 00:39:18 -0500
Received: from a27-11.smtp-out.us-west-2.amazonses.com ([54.240.27.11]:47520
        "EHLO a27-11.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725838AbfLBFjS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Dec 2019 00:39:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575265156;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=RGmBhQnmE8F4F3WL4KZFEgah0ivIKolaA6DyZoXxYjE=;
        b=d1a5RpY402oAVKrn3+1wt38ttGtjMZJ7HzE7ujRtokQZ6T/5YBSafS+ko+Dky/sV
        PnY7VdEUCB4W2OxemR6uJPXX/D0vLrpfcOgP0PRA/qJXjvY/BEorL3GFWcSrkyZOJCf
        VeyHr8FA95Pwk67DEJlTL519YDyp4NsRP5da6cg8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575265156;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=RGmBhQnmE8F4F3WL4KZFEgah0ivIKolaA6DyZoXxYjE=;
        b=LqIWO9ulFJ6qL0u+BGR+Mm9LRWvWIpQIqLepr1iTEORZAVuzkMwKV/HTz0B9Xve1
        b3kboESJxb39PLmbyk49prKO3eDjezPhMyihUnuugpveDPwecyI74B/2l5PbLUvu1a7
        z/OHdmeEpXlPZOheoKF1TCYygAHhpASyL4rj7Xcw=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 2 Dec 2019 05:39:16 +0000
From:   cang@codeaurora.org
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-scsi@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH v6 4/4] ufs: Simplify the clock scaling mechanism
 implementation
In-Reply-To: <c26ba983-b166-785f-86e8-dd60c802fa77@acm.org>
References: <20191121220850.16195-1-bvanassche@acm.org>
 <20191121220850.16195-5-bvanassche@acm.org>
 <0101016ea17f117f-41755175-dc9e-4454-bda6-3653b9aa31ff-000000@us-west-2.amazonses.com>
 <c26ba983-b166-785f-86e8-dd60c802fa77@acm.org>
Message-ID: <0101016ec51ebe20-b7589799-14d6-4b9d-9df0-0c4e31b90c04-000000@us-west-2.amazonses.com>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.12.02-54.240.27.11
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-26 09:05, Bart Van Assche wrote:
> On 11/24/19 11:38 PM, cang@codeaurora.org wrote:
>> Sorry to bring back the old discussion we had on V5 of this series 
>> here.
>> I spent some time understanding the mq freeze queue implementation but 
>> I
>> still have the same concern regards the your new implementation of 
>> clock
>> scaling prepare/unprepare.
>> 
>> I attached two logs I collected on my setups(the kernel is 5.4).
>> 
>> In log1.txt, I pretty much ported your changes to our code base and 
>> copy
>> a large file to partition /dev/sde1(mounted to /mnt). You can see the
>> debug logs I added show that the -ETIMEDOUT returned from 
>> ufshcd_devfreq_scale(),
>> although scaling UP/DOWN succeed some times.
>> 
>> To make it more controllable, I made a new sysfs entry, namely 
>> freeze_sde_queue,
>> so that I can freeze the queue of /dev/sde whenever I do "echo 1 > 
>> freeze_sde_queue".
>> After call blk_freeze_queue_start(), call 
>> blk_mq_freeze_queue_wait_timeout() to wait for 1 sec.
>> In the end, blk_mq_unfreeze_queue() would be called no matter timeout 
>> happened or not.
>> 
>> I also added a flag, called enable_print, to request_queue, and set it 
>> after I call
>> blk_freeze_queue_start(). Block layer, when this flag is set, will 
>> print logs from
>> blk_mq_start_request() and blk_mq_get_request().
>> 
>> I tried multiple times during copy large a file to partition 
>> /dev/sde1(mounted to /mnt).
>> 
>> In log2.txt, there are still wait timeout, and you can see after 
>> blk_freeze_queue_start()
>> is called for request queue of /dev/sde, there still can be requests 
>> sent down to UFS driver
>> and these requests are the "latency" that I mentioned in our previous 
>> discussion. I know
>> these requests are not "new" requests reach block layer after freeze 
>> starts,  but the ones
>> in the queue before freeze starts. However, they are the difference 
>> from the old implementation.
>> When scaling up should happen, these requests are still sent through 
>> the lowest HS Gear,
>> while when scaling down should happen, these requests are sent through 
>> the highest HS Gear.
>> The former may cause performance issue while the later may cause power 
>> penalty, this is our
>> major concern.
> 
> Hi Can,
> 
> Thank you for having taken the time to run these tests and to share the 
> output
> of these tests. If I understood you correctly the patch I posted works 
> but
> introduces a performance regression, namely that it takes longer to 
> suspend
> request processing for an UFS host. How about replacing patch 4/4 with 
> the
> patch below?
> 
> Thanks,
> 
> Bart.
> 
> Subject: [PATCH] ufs: Make clock scaling more robust
> 
> Scaling the clock is only safe while no commands are in progress. The
> current clock scaling implementation uses hba->clk_scaling_lock to
> serialize clock scaling against the following three functions:
> * ufshcd_queuecommand()          (uses sdev->request_queue)
> * ufshcd_exec_dev_cmd()          (uses hba->cmd_queue)
> * ufshcd_issue_devman_upiu_cmd() (uses hba->cmd_queue)
> 
> __ufshcd_issue_tm_cmd(), which uses hba->tmf_queue, is not yet 
> serialized
> against clock scaling. Disallowing that TMFs are submitted as follows 
> from
> user space while clock scaling is in progress:
> 
> submit UPIU_TRANSACTION_TASK_REQ on an UFS BSG queue
> -> ufs_bsg_request()
>   -> ufshcd_exec_raw_upiu_cmd(msgcode = UPIU_TRANSACTION_TASK_REQ)
>     -> ufshcd_exec_raw_upiu_cmd()
>       -> __ufshcd_issue_tm_cmd()
> 
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 36 +++++++++++++++++++++++++-----------
>  1 file changed, 25 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 99337e0b54f6..631c588f279a 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -972,14 +972,13 @@ static bool
> ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
>  }
> 
>  static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
> -					u64 wait_timeout_us)
> +					unsigned long deadline)
>  {
>  	unsigned long flags;
>  	int ret = 0;
>  	u32 tm_doorbell;
>  	u32 tr_doorbell;
>  	bool timeout = false, do_last_check = false;
> -	ktime_t start;
> 
>  	ufshcd_hold(hba, false);
>  	spin_lock_irqsave(hba->host->host_lock, flags);
> @@ -987,7 +986,6 @@ static int ufshcd_wait_for_doorbell_clr(struct 
> ufs_hba *hba,
>  	 * Wait for all the outstanding tasks/transfer requests.
>  	 * Verify by checking the doorbell registers are clear.
>  	 */
> -	start = ktime_get();
>  	do {
>  		if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
>  			ret = -EBUSY;
> @@ -1005,8 +1003,7 @@ static int ufshcd_wait_for_doorbell_clr(struct
> ufs_hba *hba,
> 
>  		spin_unlock_irqrestore(hba->host->host_lock, flags);
>  		schedule();
> -		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
> -		    wait_timeout_us) {
> +		if (time_after(jiffies, deadline)) {
>  			timeout = true;
>  			/*
>  			 * We might have scheduled out for long time so make
> @@ -1079,26 +1076,43 @@ static int ufshcd_scale_gear(struct ufs_hba
> *hba, bool scale_up)
> 
>  static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
>  {
> -	#define DOORBELL_CLR_TOUT_US		(1000 * 1000) /* 1 sec */
> +	unsigned long deadline = jiffies + HZ /* 1 sec */;
>  	int ret = 0;
>  	/*
>  	 * make sure that there are no outstanding requests when
>  	 * clock scaling is in progress
>  	 */
>  	ufshcd_scsi_block_requests(hba);
> +	blk_freeze_queue_start(hba->cmd_queue);
> +	blk_freeze_queue_start(hba->tmf_queue);
> +	if (blk_mq_freeze_queue_wait_timeout(hba->cmd_queue,
> +				max_t(long, 1, deadline - jiffies)) <= 0)
> +		goto unblock;
> +	if (blk_mq_freeze_queue_wait_timeout(hba->tmf_queue,
> +				max_t(long, 1, deadline - jiffies)) <= 0)
> +		goto unblock;
>  	down_write(&hba->clk_scaling_lock);

Hi Bart,

It looks better, but there is a race condition here. Consider below 
sequence,
thread A takes the clk_scaling_lock and waiting on blk_get_request(), 
while
thread B has frozen the queue and waiting for the lock.

Thread A
     Call ufshcd_exec_dev_cmd() or ufshcd_issue_devman_upiu_cmd()
     [a] down_write(hba->clk_scaling_lock)
     [d] blk_get_request()

Thread B
     Call ufshcd_clock_scaling_prepare()
     [b] blk_freeze_queue_start(hba->cmd_queue)
     [c] blk_mq_freeze_queue_wait_timeout(hba->cmd_queue) returns > 0
     [e] down_write(hba->clk_scaling_lock)

BTW, I see no needs to freeze the hba->cmd_queue in scaling_prepare.
I went through our previous discussions and you mentioned freezing 
hba->cmd_queue
can serialize scaling and err handler.
However, it is not necessary and not 100% true. We've already have 
ufshcd_eh_in_progress()
check in ufshcd_devfreq_target() before call ufshcd_devfreq_scale().
If you think this is not enough(err handler may kick off after this 
check), having
hba->cmd_queue frozen in scaling_prepare() does not mean the err handler 
is finished either,
because device management commands are only used in certain steps during 
err handler.
Actually, with the original design, we don't see any problems caused by
concurrency of scaling and err handler, and if the concurrency really 
happens,
scaling would just fail.

Thanks,

Can Guo.

> -	if (ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
> -		ret = -EBUSY;
> -		up_write(&hba->clk_scaling_lock);
> -		ufshcd_scsi_unblock_requests(hba);
> -	}
> +	if (ufshcd_wait_for_doorbell_clr(hba, deadline))
> +		goto up_write;
> 
> +out:
>  	return ret;
> +
> +up_write:
> +	up_write(&hba->clk_scaling_lock);
> +unblock:
> +	blk_mq_unfreeze_queue(hba->tmf_queue);
> +	blk_mq_unfreeze_queue(hba->cmd_queue);
> +	ufshcd_scsi_unblock_requests(hba);
> +	ret = -EBUSY;
> +	goto out;
>  }
> 
>  static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
>  {
>  	up_write(&hba->clk_scaling_lock);
> +	blk_mq_unfreeze_queue(hba->tmf_queue);
> +	blk_mq_unfreeze_queue(hba->cmd_queue);
>  	ufshcd_scsi_unblock_requests(hba);
>  }
