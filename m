Return-Path: <SRS0=IzRR=ZR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0606AC432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 07:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A68E820748
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 07:38:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DK0WPRws";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="OFmzhUL7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbfKYHiR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Nov 2019 02:38:17 -0500
Received: from a27-185.smtp-out.us-west-2.amazonses.com ([54.240.27.185]:48222
        "EHLO a27-185.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725535AbfKYHiR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Nov 2019 02:38:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574667495;
        h=MIME-Version:Content-Type:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=UKAeBH8gOB/wISZkeASJ6SU/v2zjHMHeNzFI7Du55a0=;
        b=DK0WPRwsEUe0d0RoNphTgul0VkBlhtMFpNZAlVuiR22BMBjl7dtvJf4IFCjW5NeY
        3j/Wu6SFXV0rQNvKEbG706zaxFZsT9DkrVrDXbzryRPUmUA6TNTI2uH44AgF18cOBHW
        m9ALOxNsy6VEKH3/CVon6jUpN+yQJNkdqkDY07k0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574667495;
        h=MIME-Version:Content-Type:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=UKAeBH8gOB/wISZkeASJ6SU/v2zjHMHeNzFI7Du55a0=;
        b=OFmzhUL7KJWwQMcJFjzoaQazzvXsBu/LAea/gxpRDiNQOXPakZrPw+6Rhgnhj2kc
        uGBMWHfASVtTmHZBTAW3D1w5WgTaxYrcBklnj01qGiapPjwqtPkxaOX8fxDv65s3fv+
        dW9syZCAd/+ZRPRKcoc0pHS3O3oF/OdhVqbIGmzs=
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_60ee798d9da7eb0c68ce6980a5ca6e85"
Date:   Mon, 25 Nov 2019 07:38:14 +0000
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
In-Reply-To: <20191121220850.16195-5-bvanassche@acm.org>
References: <20191121220850.16195-1-bvanassche@acm.org>
 <20191121220850.16195-5-bvanassche@acm.org>
Message-ID: <0101016ea17f238f-1a330681-50e4-4b4d-8d4e-6d65cd0397c2-000000@us-west-2.amazonses.com>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.11.25-54.240.27.185
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--=_60ee798d9da7eb0c68ce6980a5ca6e85
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII;
 format=flowed

On 2019-11-22 06:08, Bart Van Assche wrote:
> Scaling the clock is only safe while no commands are in progress. The
> current clock scaling implementation uses hba->clk_scaling_lock to
> serialize clock scaling against the following three functions:
> * ufshcd_queuecommand()          (uses sdev->request_queue)
> * ufshcd_exec_dev_cmd()          (uses hba->cmd_queue)
> * ufshcd_issue_devman_upiu_cmd() (uses hba->cmd_queue)
> 
> __ufshcd_issue_tm_cmd(), which uses hba->tmf_queue, is not yet 
> serialized
> against clock scaling.
> 
> Use blk_mq_{un,}freeze_queue() to block submission of new commands and 
> to
> wait for ongoing commands to complete. This patch removes a semaphore
> down and up operation pair from the hot path. This patch fixes a bug by
> disallowing that TMFs are submitted as follows from user space while
> clock scaling is in progress:
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
>  drivers/scsi/ufs/ufshcd.c | 124 ++++++++++++--------------------------
>  drivers/scsi/ufs/ufshcd.h |   1 -
>  2 files changed, 40 insertions(+), 85 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 99337e0b54f6..472d164f6ae6 100644
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
> @@ -1079,27 +1020,54 @@ static int ufshcd_scale_gear(struct ufs_hba
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
> -	 * make sure that there are no outstanding requests when
> -	 * clock scaling is in progress
> +	 * Make sure that no requests are outstanding while clock scaling is 
> in
> +	 * progress. If SCSI error recovery would start while this function 
> is
> +	 * in progress then
> +	 * blk_mq_freeze_queue_wait_timeout(sdev->request_queue) will either
> +	 * wait until error handling has finished or will time out.
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
> +	return res;
> +
> +err:
> +	blk_mq_unfreeze_queue(hba->tmf_queue);
> +	blk_mq_unfreeze_queue(hba->cmd_queue);
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
> +	blk_mq_unfreeze_queue(hba->tmf_queue);
> +	blk_mq_unfreeze_queue(hba->cmd_queue);
> +	shost_for_each_device(sdev, hba->host)
> +		blk_mq_unfreeze_queue(sdev->request_queue);
>  }
> 
>  /**
> @@ -2394,9 +2362,6 @@ static int ufshcd_queuecommand(struct Scsi_Host
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
> @@ -2462,7 +2427,6 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
>  out_unlock:
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
>  out:
> -	up_read(&hba->clk_scaling_lock);
>  	return err;
>  }
> 
> @@ -2616,8 +2580,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba 
> *hba,
>  	struct completion wait;
>  	unsigned long flags;
> 
> -	down_read(&hba->clk_scaling_lock);
> -
>  	/*
>  	 * Get free slot, sleep if slots are unavailable.
>  	 * Even though we use wait_event() which sleeps indefinitely,
> @@ -2653,7 +2615,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba 
> *hba,
> 
>  out_put_tag:
>  	blk_put_request(req);
> -	up_read(&hba->clk_scaling_lock);
>  	return err;
>  }
> 
> @@ -5845,8 +5806,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct
> ufs_hba *hba,
>  	unsigned long flags;
>  	u32 upiu_flags;
> 
> -	down_read(&hba->clk_scaling_lock);
> -
>  	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
>  	if (IS_ERR(req))
>  		return PTR_ERR(req);
> @@ -5928,7 +5887,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct
> ufs_hba *hba,
>  	}
> 
>  	blk_put_request(req);
> -	up_read(&hba->clk_scaling_lock);
>  	return err;
>  }
> 
> @@ -8397,8 +8355,6 @@ int ufshcd_init(struct ufs_hba *hba, void
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
> index 53bfe175342c..bbdef1153257 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -724,7 +724,6 @@ struct ufs_hba {
>  	enum bkops_status urgent_bkops_lvl;
>  	bool is_urgent_bkops_lvl_checked;
> 
> -	struct rw_semaphore clk_scaling_lock;
>  	struct ufs_desc_size desc_size;
>  	atomic_t scsi_block_reqs_cnt;

Hi Bart,

Sorry to bring back the old discussion we had on V5 of this series here.
I spent some time understanding the mq freeze queue implementation but I
still have the same concern regards the your new implementation of clock
scaling prepare/unprepare.

I attached two logs I collected on my setups(the kernel is 5.4).

In log1.txt, I pretty much ported your changes to our code base and copy
a large file to partition /dev/sde1(mounted to /mnt). You can see the
debug logs I added show that the -ETIMEDOUT returned from 
ufshcd_devfreq_scale(),
although scaling UP/DOWN succeed some times.

To make it more controllable, I made a new sysfs entry, namely 
freeze_sde_queue,
so that I can freeze the queue of /dev/sde whenever I do "echo 1 > 
freeze_sde_queue".
After call blk_freeze_queue_start(), call 
blk_mq_freeze_queue_wait_timeout() to wait for 1 sec.
In the end, blk_mq_unfreeze_queue() would be called no matter timeout 
happened or not.

I also added a flag, called enable_print, to request_queue, and set it 
after I call
blk_freeze_queue_start(). Block layer, when this flag is set, will print 
logs from
blk_mq_start_request() and blk_mq_get_request().

I tried multiple times during copy large a file to partition 
/dev/sde1(mounted to /mnt).

In log2.txt, there are still wait timeout, and you can see after 
blk_freeze_queue_start()
is called for request queue of /dev/sde, there still can be requests 
sent down to UFS driver
and these requests are the "latency" that I mentioned in our previous 
discussion. I know
these requests are not "new" requests reach block layer after freeze 
starts,  but the ones
in the queue before freeze starts. However, they are the difference from 
the old implementation.
When scaling up should happen, these requests are still sent through the 
lowest HS Gear,
while when scaling down should happen, these requests are sent through 
the highest HS Gear.
The former may cause performance issue while the later may cause power 
penalty, this is our
major concern.

Regards,

Can Guo
--=_60ee798d9da7eb0c68ce6980a5ca6e85
Content-Transfer-Encoding: base64
Content-Type: text/plain;
 name=log1.txt
Content-Disposition: attachment;
 filename=log1.txt;
 size=6921

LyAjIG1rZGlyIG1udA0KLyAjIG1vdW50IC10IGV4dDIgL2Rldi9zZGUxIC9tbnQNClsgIDE5OC43
NTQ0NThdIEVYVDQtZnMgKHNkZTEpOiBtb3VudGluZyBleHQyIGZpbGUgc3lzdGVtIHVzaW5nIHRo
ZSBleHQ0IHN1YnN5c3RlbQ0KWyAgMTk4LjgyMjQyN10gdWZzaGNkLXFjb20gdWZzaGM6IF9fdWZz
aGNkX3N1c3BlbmRfY2xrc2NhbGluZzogc3VzcGVuZCBzY2FsaW5nDQpbICAxOTguOTc1MDkzXSB1
ZnNoY2QtcWNvbSB1ZnNoYzogX191ZnNoY2Rfc3VzcGVuZF9jbGtzY2FsaW5nOiBzdXNwZW5kIHNj
YWxpbmcNClsgIDE5OS4wNTk2MzVdIEVYVDQtZnMgKHNkZTEpOiBtb3VudGVkIGZpbGVzeXN0ZW0g
d2l0aG91dCBqb3VybmFsLiBPcHRzOiAobnVsbCkNCi8gIyBkZCBpZj0vZGV2L3plcm8gb2Y9L21u
dC9vdXQuYmluIGJzPTRrIGNvdW50PTIwMDAwMDANClsgIDIyMC4xMzg2NDVdIHVmc2hjZC1xY29t
IHVmc2hjOiBfX3Vmc2hjZF9zdXNwZW5kX2Nsa3NjYWxpbmc6IHN1c3BlbmQgc2NhbGluZw0KWyAg
MjI0LjU5NDQ3OV0gdWZzaGNkLXFjb20gdWZzaGM6IHVmc2hjZF9kZXZmcmVxX3RhcmdldDogc2Nh
bGluZyBVUA0KWyAgMjI1LjYyNjEzNV0gdWZzaGNkLXFjb20gdWZzaGM6IHVmc2hjZF9kZXZmcmVx
X3RhcmdldDogc2NhbGluZyBVUCByZXR1cm4gMA0KWyAgMjI5LjM1OTQyN10gdWZzaGNkLXFjb20g
dWZzaGM6IF9fdWZzaGNkX3N1c3BlbmRfY2xrc2NhbGluZzogc3VzcGVuZCBzY2FsaW5nDQpbICAy
MjkuNDM4NTYyXSB1ZnNoY2QtcWNvbSB1ZnNoYzogdWZzaGNkX2RldmZyZXFfdGFyZ2V0OiBzY2Fs
aW5nIERPV04NClsgIDIyOS41ODc0MTZdIHVmc2hjZC1xY29tIHVmc2hjOiB1ZnNoY2RfZGV2ZnJl
cV90YXJnZXQ6IHNjYWxpbmcgRE9XTiByZXR1cm4gMA0KWyAgMjMwLjk2MjY3N10gdWZzaGNkLXFj
b20gdWZzaGM6IF9fdWZzaGNkX3N1c3BlbmRfY2xrc2NhbGluZzogc3VzcGVuZCBzY2FsaW5nDQpb
ICAyNDQuOTU5ODg1XSB1ZnNoY2QtcWNvbSB1ZnNoYzogX191ZnNoY2Rfc3VzcGVuZF9jbGtzY2Fs
aW5nOiBzdXNwZW5kIHNjYWxpbmcNClsgIDI1OC43OTE1ODNdIHVmc2hjZC1xY29tIHVmc2hjOiB1
ZnNoY2RfZGV2ZnJlcV90YXJnZXQ6IHNjYWxpbmcgVVANClsgIDI1OS45Nzg3NTBdIHVmc2hjZC1x
Y29tIHVmc2hjOiB1ZnNoY2RfZGV2ZnJlcV90YXJnZXQ6IHNjYWxpbmcgVVAgcmV0dXJuIC0xMTAN
ClsgIDI2MC4xMzA4MDJdIGRldmZyZXEgZGV2ZnJlcTA6IGR2ZnMgZmFpbGVkIHdpdGggKC0xMTAp
IGVycm9yDQpbICAyNjAuMzA0MTg3XSB1ZnNoY2QtcWNvbSB1ZnNoYzogdWZzaGNkX2RldmZyZXFf
dGFyZ2V0OiBzY2FsaW5nIFVQDQpbICAyNjEuNDQ2NDM3XSB1ZnNoY2QtcWNvbSB1ZnNoYzogdWZz
aGNkX2RldmZyZXFfdGFyZ2V0OiBzY2FsaW5nIFVQIHJldHVybiAtMTEwDQpbICAyNjEuNjY2MzMz
XSBkZXZmcmVxIGRldmZyZXEwOiBkdmZzIGZhaWxlZCB3aXRoICgtMTEwKSBlcnJvcg0KWyAgMjYx
Ljg5MDU2Ml0gdWZzaGNkLXFjb20gdWZzaGM6IHVmc2hjZF9kZXZmcmVxX3RhcmdldDogc2NhbGlu
ZyBVUA0KWyAgMjYzLjEwNzUzMV0gdWZzaGNkLXFjb20gdWZzaGM6IHVmc2hjZF9kZXZmcmVxX3Rh
cmdldDogc2NhbGluZyBVUCByZXR1cm4gLTExMA0KWyAgMjYzLjMyMjMzM10gZGV2ZnJlcSBkZXZm
cmVxMDogZHZmcyBmYWlsZWQgd2l0aCAoLTExMCkgZXJyb3INClsgIDI2My41NDYzOTVdIHVmc2hj
ZC1xY29tIHVmc2hjOiB1ZnNoY2RfZGV2ZnJlcV90YXJnZXQ6IHNjYWxpbmcgVVANClsgIDI2NC43
NDIxMjVdIHVmc2hjZC1xY29tIHVmc2hjOiB1ZnNoY2RfZGV2ZnJlcV90YXJnZXQ6IHNjYWxpbmcg
VVAgcmV0dXJuIC0xMTANClsgIDI2NC45MTAyNjBdIGRldmZyZXEgZGV2ZnJlcTA6IGR2ZnMgZmFp
bGVkIHdpdGggKC0xMTApIGVycm9yDQpbICAyNjUuMDgyNzA4XSB1ZnNoY2QtcWNvbSB1ZnNoYzog
dWZzaGNkX2RldmZyZXFfdGFyZ2V0OiBzY2FsaW5nIFVQDQpbICAyNjYuMjQzMTc3XSB1ZnNoY2Qt
cWNvbSB1ZnNoYzogdWZzaGNkX2RldmZyZXFfdGFyZ2V0OiBzY2FsaW5nIFVQIHJldHVybiAtMTEw
DQpbICAyNjYuMzk0MTk3XSBkZXZmcmVxIGRldmZyZXEwOiBkdmZzIGZhaWxlZCB3aXRoICgtMTEw
KSBlcnJvcg0KWyAgMjY2LjU2MzcyOV0gdWZzaGNkLXFjb20gdWZzaGM6IHVmc2hjZF9kZXZmcmVx
X3RhcmdldDogc2NhbGluZyBVUA0KWyAgMjY3Ljg1ODM5NV0gdWZzaGNkLXFjb20gdWZzaGM6IHVm
c2hjZF9kZXZmcmVxX3RhcmdldDogc2NhbGluZyBVUCByZXR1cm4gLTExMA0KWyAgMjY4LjAxNDIw
OF0gZGV2ZnJlcSBkZXZmcmVxMDogZHZmcyBmYWlsZWQgd2l0aCAoLTExMCkgZXJyb3INClsgIDI2
OC4xODI2NzddIHVmc2hjZC1xY29tIHVmc2hjOiB1ZnNoY2RfZGV2ZnJlcV90YXJnZXQ6IHNjYWxp
bmcgVVANClsgIDI2OS4zMTUxNjZdIHVmc2hjZC1xY29tIHVmc2hjOiB1ZnNoY2RfZGV2ZnJlcV90
YXJnZXQ6IHNjYWxpbmcgVVAgcmV0dXJuIC0xMTANClsgIDI2OS40NzA3NjBdIGRldmZyZXEgZGV2
ZnJlcTA6IGR2ZnMgZmFpbGVkIHdpdGggKC0xMTApIGVycm9yDQpbICAyNjkuNjM4NjM1XSB1ZnNo
Y2QtcWNvbSB1ZnNoYzogdWZzaGNkX2RldmZyZXFfdGFyZ2V0OiBzY2FsaW5nIFVQDQpbICAyNzAu
Nzg2OTg5XSB1ZnNoY2QtcWNvbSB1ZnNoYzogdWZzaGNkX2RldmZyZXFfdGFyZ2V0OiBzY2FsaW5n
IFVQIHJldHVybiAtMTEwDQpbICAyNzEuMDA1OTc5XSBkZXZmcmVxIGRldmZyZXEwOiBkdmZzIGZh
aWxlZCB3aXRoICgtMTEwKSBlcnJvcg0KWyAgMjcxLjIzMDU3Ml0gdWZzaGNkLXFjb20gdWZzaGM6
IHVmc2hjZF9kZXZmcmVxX3RhcmdldDogc2NhbGluZyBVUA0KWyAgMjcyLjM4NzEwNF0gdWZzaGNk
LXFjb20gdWZzaGM6IHVmc2hjZF9kZXZmcmVxX3RhcmdldDogc2NhbGluZyBVUCByZXR1cm4gLTEx
MA0KWyAgMjcyLjYxMjc3MF0gZGV2ZnJlcSBkZXZmcmVxMDogZHZmcyBmYWlsZWQgd2l0aCAoLTEx
MCkgZXJyb3INClsgIDI3Mi44MzQ5NzldIHVmc2hjZC1xY29tIHVmc2hjOiB1ZnNoY2RfZGV2ZnJl
cV90YXJnZXQ6IHNjYWxpbmcgVVANClsgIDI3NC4wNTEyOTFdIHVmc2hjZC1xY29tIHVmc2hjOiB1
ZnNoY2RfZGV2ZnJlcV90YXJnZXQ6IHNjYWxpbmcgVVAgcmV0dXJuIC0xMTANClsgIDI3NC4yNzgx
ODddIGRldmZyZXEgZGV2ZnJlcTA6IGR2ZnMgZmFpbGVkIHdpdGggKC0xMTApIGVycm9yDQpbICAy
NzQuNDk0NjA0XSB1ZnNoY2QtcWNvbSB1ZnNoYzogdWZzaGNkX2RldmZyZXFfdGFyZ2V0OiBzY2Fs
aW5nIFVQDQpbICAyNzYuMTI1NzM5XSB1ZnNoY2QtcWNvbSB1ZnNoYzogdWZzaGNkX2RldmZyZXFf
dGFyZ2V0OiBzY2FsaW5nIFVQIHJldHVybiAtMTEwDQpbICAyNzYuMzMzOTM3XSBkZXZmcmVxIGRl
dmZyZXEwOiBkdmZzIGZhaWxlZCB3aXRoICgtMTEwKSBlcnJvcg0KWyAgMjc2LjUwNjM0M10gdWZz
aGNkLXFjb20gdWZzaGM6IHVmc2hjZF9kZXZmcmVxX3RhcmdldDogc2NhbGluZyBVUA0KWyAgMjc3
LjY1MjcxOF0gdWZzaGNkLXFjb20gdWZzaGM6IHVmc2hjZF9kZXZmcmVxX3RhcmdldDogc2NhbGlu
ZyBVUCByZXR1cm4gLTExMA0KWyAgMjc3Ljg3NzkwNl0gZGV2ZnJlcSBkZXZmcmVxMDogZHZmcyBm
YWlsZWQgd2l0aCAoLTExMCkgZXJyb3INClsgIDI3OC4xMDIzNDNdIHVmc2hjZC1xY29tIHVmc2hj
OiB1ZnNoY2RfZGV2ZnJlcV90YXJnZXQ6IHNjYWxpbmcgVVANClsgIDI3OS4yOTkwMzFdIHVmc2hj
ZC1xY29tIHVmc2hjOiB1ZnNoY2RfZGV2ZnJlcV90YXJnZXQ6IHNjYWxpbmcgVVAgcmV0dXJuIC0x
MTANClsgIDI3OS41MTgxOTddIGRldmZyZXEgZGV2ZnJlcTA6IGR2ZnMgZmFpbGVkIHdpdGggKC0x
MTApIGVycm9yDQpbICAyNzkuNzgzNjM1XSB1ZnNoY2QtcWNvbSB1ZnNoYzogdWZzaGNkX2RldmZy
ZXFfdGFyZ2V0OiBzY2FsaW5nIFVQDQpbICAyODAuOTMxMDEwXSB1ZnNoY2QtcWNvbSB1ZnNoYzog
dWZzaGNkX2RldmZyZXFfdGFyZ2V0OiBzY2FsaW5nIFVQIHJldHVybiAtMTEwDQpbICAyODEuMTk4
MTk3XSBkZXZmcmVxIGRldmZyZXEwOiBkdmZzIGZhaWxlZCB3aXRoICgtMTEwKSBlcnJvcg0KWyAg
MjgxLjM3OTE4N10gdWZzaGNkLXFjb20gdWZzaGM6IHVmc2hjZF9kZXZmcmVxX3RhcmdldDogc2Nh
bGluZyBVUA0KWyAgMjgyLjU5NTE4N10gdWZzaGNkLXFjb20gdWZzaGM6IHVmc2hjZF9kZXZmcmVx
X3RhcmdldDogc2NhbGluZyBVUCByZXR1cm4gLTExMA0KWyAgMjgyLjgxODE2Nl0gZGV2ZnJlcSBk
ZXZmcmVxMDogZHZmcyBmYWlsZWQgd2l0aCAoLTExMCkgZXJyb3INClsgIDI4My4wNDYyMDhdIHVm
c2hjZC1xY29tIHVmc2hjOiB1ZnNoY2RfZGV2ZnJlcV90YXJnZXQ6IHNjYWxpbmcgVVANClsgIDI4
NC4yOTA5NjhdIHVmc2hjZC1xY29tIHVmc2hjOiB1ZnNoY2RfZGV2ZnJlcV90YXJnZXQ6IHNjYWxp
bmcgVVAgcmV0dXJuIC0xMTANClsgIDI4NC41MDk5NzldIGRldmZyZXEgZGV2ZnJlcTA6IGR2ZnMg
ZmFpbGVkIHdpdGggKC0xMTApIGVycm9yDQpbICAyODQuNzcwNTIwXSB1ZnNoY2QtcWNvbSB1ZnNo
YzogdWZzaGNkX2RldmZyZXFfdGFyZ2V0OiBzY2FsaW5nIFVQDQpbICAyODUuOTg2OTE2XSB1ZnNo
Y2QtcWNvbSB1ZnNoYzogdWZzaGNkX2RldmZyZXFfdGFyZ2V0OiBzY2FsaW5nIFVQIHJldHVybiAt
MTEwDQpbICAyODYuMjc0MTg3XSBkZXZmcmVxIGRldmZyZXEwOiBkdmZzIGZhaWxlZCB3aXRoICgt
MTEwKSBlcnJvcg0KWyAgMjg2LjQ5NDM0M10gdWZzaGNkLXFjb20gdWZzaGM6IHVmc2hjZF9kZXZm
cmVxX3RhcmdldDogc2NhbGluZyBVUA0KWyAgMjg3LjY4Mjk0N10gdWZzaGNkLXFjb20gdWZzaGM6
IHVmc2hjZF9kZXZmcmVxX3RhcmdldDogc2NhbGluZyBVUCByZXR1cm4gLTExMA0KWyAgMjg3Ljkx
NDE1Nl0gZGV2ZnJlcSBkZXZmcmVxMDogZHZmcyBmYWlsZWQgd2l0aCAoLTExMCkgZXJyb3INClsg
IDI4OC4xNzkwMDBdIHVmc2hjZC1xY29tIHVmc2hjOiB1ZnNoY2RfZGV2ZnJlcV90YXJnZXQ6IHNj
YWxpbmcgVVANClsgIDI4OS4zMTQ4MzNdIHVmc2hjZC1xY29tIHVmc2hjOiB1ZnNoY2RfZGV2ZnJl
cV90YXJnZXQ6IHNjYWxpbmcgVVAgcmV0dXJuIC0xMTANClsgIDI4OS41OTgxNDVdIGRldmZyZXEg
ZGV2ZnJlcTA6IGR2ZnMgZmFpbGVkIHdpdGggKC0xMTApIGVycm9yDQpbICAyODkuODE4MzEyXSB1
ZnNoY2QtcWNvbSB1ZnNoYzogdWZzaGNkX2RldmZyZXFfdGFyZ2V0OiBzY2FsaW5nIFVQDQpbICAy
OTEuMDQyODg1XSB1ZnNoY2QtcWNvbSB1ZnNoYzogdWZzaGNkX2RldmZyZXFfdGFyZ2V0OiBzY2Fs
aW5nIFVQIHJldHVybiAtMTEwDQpbICAyOTEuMjY1OTM3XSBkZXZmcmVxIGRldmZyZXEwOiBkdmZz
IGZhaWxlZCB3aXRoICgtMTEwKSBlcnJvcg0KWyAgMjkxLjQ4NjI3MF0gdWZzaGNkLXFjb20gdWZz
aGM6IHVmc2hjZF9kZXZmcmVxX3RhcmdldDogc2NhbGluZyBVUA0KWyAgMjkyLjcwNjg4NV0gdWZz
aGNkLXFjb20gdWZzaGM6IHVmc2hjZF9kZXZmcmVxX3RhcmdldDogc2NhbGluZyBVUCByZXR1cm4g
LTExMA0KWyAgMjkyLjkyOTkzN10gZGV2ZnJlcSBkZXZmcmVxMDogZHZmcyBmYWlsZWQgd2l0aCAo
LTExMCkgZXJyb3INClsgIDI5My4xNzQ1NDFdIHVmc2hjZC1xY29tIHVmc2hjOiB1ZnNoY2RfZGV2
ZnJlcV90YXJnZXQ6IHNjYWxpbmcgVVANClsgIDI5NC4zMzg5MDZdIHVmc2hjZC1xY29tIHVmc2hj
OiB1ZnNoY2RfZGV2ZnJlcV90YXJnZXQ6IHNjYWxpbmcgVVAgcmV0dXJuIC0xMTANClsgIDI5NC42
MjU5MjddIGRldmZyZXEgZGV2ZnJlcTA6IGR2ZnMgZmFpbGVkIHdpdGggKC0xMTApIGVycm9yDQpb
ICAyOTQuODE4NTYyXSB1ZnNoY2QtcWNvbSB1ZnNoYzogdWZzaGNkX2RldmZyZXFfdGFyZ2V0OiBz
Y2FsaW5nIFVQDQpbICAyOTUuOTcwNzI5XSB1ZnNoY2QtcWNvbSB1ZnNoYzogdWZzaGNkX2RldmZy
ZXFfdGFyZ2V0OiBzY2FsaW5nIFVQIHJldHVybiAtMTEwDQpbICAyOTYuMTE4MTg3XSBkZXZmcmVx
IGRldmZyZXEwOiBkdmZzIGZhaWxlZCB3aXRoICgtMTEwKSBlcnJvcg0KWyAgMjk2LjI5MDUzMV0g
dWZzaGNkLXFjb20gdWZzaGM6IHVmc2hjZF9kZXZmcmVxX3RhcmdldDogc2NhbGluZyBVUA0KWyAg
Mjk3LjQ0MjY4N10gdWZzaGNkLXFjb20gdWZzaGM6IHVmc2hjZF9kZXZmcmVxX3RhcmdldDogc2Nh
bGluZyBVUCByZXR1cm4gLTExMA0KWyAgMjk3LjU5MDE2Nl0gZGV2ZnJlcSBkZXZmcmVxMDogZHZm
cyBmYWlsZWQgd2l0aCAoLTExMCkgZXJyb3INClsgIDI5Ny43NTg1ODNdIHVmc2hjZC1xY29tIHVm
c2hjOiB1ZnNoY2RfZGV2ZnJlcV90YXJnZXQ6IHNjYWxpbmcgVVANClsgIDI5OC45MTQ5MjddIHVm
c2hjZC1xY29tIHVmc2hjOiB1ZnNoY2RfZGV2ZnJlcV90YXJnZXQ6IHNjYWxpbmcgVVAgcmV0dXJu
IC0xMTANClsgIDI5OS4wNTgxNjZdIGRldmZyZXEgZGV2ZnJlcTA6IGR2ZnMgZmFpbGVkIHdpdGgg
KC0xMTApIGVycm9yDQpbICAyOTkuMjI2NTAwXSB1ZnNoY2QtcWNvbSB1ZnNoYzogdWZzaGNkX2Rl
dmZyZXFfdGFyZ2V0OiBzY2FsaW5nIFVQDQpbICAyOTkuMzk2NDQ3XSB1ZnNoY2QtcWNvbSB1ZnNo
YzogdWZzaGNkX2RldmZyZXFfdGFyZ2V0OiBzY2FsaW5nIFVQIHJldHVybiAwDQpbICAyOTkuNjAy
ODk1XSB1ZnNoY2QtcWNvbSB1ZnNoYzogX191ZnNoY2Rfc3VzcGVuZF9jbGtzY2FsaW5nOiBzdXNw
ZW5kIHNjYWxpbmcNClsgIDI5OS42NzI1MzFdIHVmc2hjZC1xY29tIHVmc2hjOiB1ZnNoY2RfZGV2
ZnJlcV90YXJnZXQ6IHNjYWxpbmcgRE9XTg0KWyAgMjk5Ljk4NjIxOF0gdWZzaGNkLXFjb20gdWZz
aGM6IHVmc2hjZF9kZXZmcmVxX3RhcmdldDogc2NhbGluZyBET1dOIHJldHVybiAwDQpbICAzMDAu
MjcwNDM3XSB1ZnNoY2QtcWNvbSB1ZnNoYzogdWZzaGNkX2RldmZyZXFfdGFyZ2V0OiBzY2FsaW5n
IFVQDQpbICAzMDEuNDc0MjI5XSB1ZnNoY2QtcWNvbSB1ZnNoYzogdWZzaGNkX2RldmZyZXFfdGFy
Z2V0OiBzY2FsaW5nIFVQIHJldHVybiAw
--=_60ee798d9da7eb0c68ce6980a5ca6e85
Content-Transfer-Encoding: base64
Content-Type: text/plain;
 name=log2.txt
Content-Disposition: attachment;
 filename=log2.txt;
 size=14868

LyAjIG1rZGlyIG1udA0KLyAjIG1vdW50IC10IGV4dDIgL2Rldi9zZGUxIC9tbnQNClsgIDE4MS4x
NjM0NThdIEVYVDQtZnMgKHNkZTEpOiBtb3VudGluZyBleHQyIGZpbGUgc3lzdGVtIHVzaW5nIHRo
ZSBleHQ0IHN1YnN5c3RlbQ0KWyAgMTgxLjMxOTE2Nl0gRVhUNC1mcyAoc2RlMSk6IG1vdW50ZWQg
ZmlsZXN5c3RlbSB3aXRob3V0IGpvdXJuYWwuIE9wdHM6IChudWxsKQ0KLyAjIGRkIGlmPS9kZXYv
emVybyBvZj0vbW50L291dC5iaW4gYnM9NGsgY291bnQ9MTAwMDAwMCAmDQovICMgY2Qgc3lzL2Rl
dmljZXMvcGxhdGZvcm0vc29jL3Vmc2hjLw0KL3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NvYy91ZnNo
YyAjIGVjaG8gMSA+IGZyZWV6ZV9zZGVfcXVldWUNClsgIDIyMy41MjMyMjldIHVmc2hjZC1xY29t
IHVmc2hjOiBiZWZvcmUgc3RhcnQsIHF1ZXVlIGhjdHggcXVldWVkIDIzNQ0KWyAgMjIzLjY1MDYy
NV0gdWZzaGNkLXFjb20gdWZzaGM6IGZyZWV6ZSBxdWV1ZSBvZiBzZGV2IDA6MDowOjQgc3RhcnQN
ClsgIDIyMy43Nzg4MDJdIHVmc2hjZC1xY29tIHVmc2hjOiBhZnRlciBzdGFydCwgcXVldWUgaGN0
eCBxdWV1ZWQgMjM1DQpbICAyMjMuOTEwMzU0XSB1ZnNoY2QtcWNvbSB1ZnNoYzogcXVldWUgZm9y
emVuLCBxdWV1ZSB1c2FnZSBjb3VudGVyOiAwDQpbICAyMjQuMDM4NzI5XSB1ZnNoY2QtcWNvbSB1
ZnNoYzogYWZ0ZXIgcXVldWUgZnJvemVuLCBxdWV1ZSBoY3R4IHF1ZXVlZCAyMzUNClsgIDIyNC4x
Nzg2MjVdIHVmc2hjZC1xY29tIHVmc2hjOiB1bmZyZWV6ZSBpdA0KWyAgMjI0LjI3NDM2NF0gdWZz
aGNkLXFjb20gdWZzaGM6IHF1ZXVlIHVuZm9yemVuDQovc3lzL2RldmljZXMvcGxhdGZvcm0vc29j
L3Vmc2hjICMgZWNobyAxID4gZnJlZXplX3NkZV9xdWV1ZQ0KWyAgMjI3LjQ5MjYwNF0gdWZzaGNk
LXFjb20gdWZzaGM6IGJlZm9yZSBzdGFydCwgcXVldWUgaGN0eCBxdWV1ZWQgMjM1DQpbICAyMjcu
NjI2NjM1XSB1ZnNoY2QtcWNvbSB1ZnNoYzogZnJlZXplIHF1ZXVlIG9mIHNkZXYgMDowOjA6NCBz
dGFydA0KWyAgMjI3LjcyMjI5MV0gdWZzaGNkLXFjb20gdWZzaGM6IGFmdGVyIHN0YXJ0LCBxdWV1
ZSBoY3R4IHF1ZXVlZCAyMzYNClsgIDIyNy44NTAxNTZdIHVmc2hjZC1xY29tIHVmc2hjOiBxdWV1
ZSBmb3J6ZW4sIHF1ZXVlIHVzYWdlIGNvdW50ZXI6IDANClsgIDIyNy45Nzg2MDRdIHVmc2hjZC1x
Y29tIHVmc2hjOiBhZnRlciBxdWV1ZSBmcm96ZW4sIHF1ZXVlIGhjdHggcXVldWVkIDIzNg0KWyAg
MjI4LjExODU4M10gdWZzaGNkLXFjb20gdWZzaGM6IHVuZnJlZXplIGl0DQpbICAyMjguMjEwMjUw
XSB1ZnNoY2QtcWNvbSB1ZnNoYzogcXVldWUgdW5mb3J6ZW4NCi9zeXMvZGV2aWNlcy9wbGF0Zm9y
bS9zb2MvdWZzaGMgIyBlY2hvIDEgPiBmcmVlemVfc2RlX3F1ZXVlDQpbICAyMzQuMTA0MDgzXSB1
ZnNoY2QtcWNvbSB1ZnNoYzogYmVmb3JlIHN0YXJ0LCBxdWV1ZSBoY3R4IHF1ZXVlZCAyMzYNClsg
IDIzNC4yNDIwMzFdIHVmc2hjZC1xY29tIHVmc2hjOiBmcmVlemUgcXVldWUgb2Ygc2RldiAwOjA6
MDo0IHN0YXJ0DQpbICAyMzQuMzY2MjkxXSB1ZnNoY2QtcWNvbSB1ZnNoYzogYWZ0ZXIgc3RhcnQs
IHF1ZXVlIGhjdHggcXVldWVkIDIzNg0KWyAgMjM0LjQ5NDExNF0gdWZzaGNkLXFjb20gdWZzaGM6
IHF1ZXVlIGZvcnplbiwgcXVldWUgdXNhZ2UgY291bnRlcjogMA0KWyAgMjM0LjYyNjEwNF0gdWZz
aGNkLXFjb20gdWZzaGM6IGFmdGVyIHF1ZXVlIGZyb3plbiwgcXVldWUgaGN0eCBxdWV1ZWQgMjM2
DQpbICAyMzQuNzYyMDIwXSB1ZnNoY2QtcWNvbSB1ZnNoYzogdW5mcmVlemUgaXQNClsgIDIzNC44
NTA5MjddIHVmc2hjZC1xY29tIHVmc2hjOiBxdWV1ZSB1bmZvcnplbg0KL3N5cy9kZXZpY2VzL3Bs
YXRmb3JtL3NvYy91ZnNoYyAjIGVjaG8gMSA+IGZyZWV6ZV9zZGVfcXVldWUNClsgIDIzNi42MTU1
NjJdIHVmc2hjZC1xY29tIHVmc2hjOiBiZWZvcmUgc3RhcnQsIHF1ZXVlIGhjdHggcXVldWVkIDIz
Ng0KWyAgMjM2Ljc0NjA0MV0gdWZzaGNkLXFjb20gdWZzaGM6IGZyZWV6ZSBxdWV1ZSBvZiBzZGV2
IDA6MDowOjQgc3RhcnQNClsgIDIzNi44NzAyOTFdIHVmc2hjZC1xY29tIHVmc2hjOiBhZnRlciBz
dGFydCwgcXVldWUgaGN0eCBxdWV1ZWQgMjM2DQpbICAyMzcuMDAyMTU2XSB1ZnNoY2QtcWNvbSB1
ZnNoYzogcXVldWUgZm9yemVuLCBxdWV1ZSB1c2FnZSBjb3VudGVyOiAwDQpbICAyMzcuMTMwNjA0
XSB1ZnNoY2QtcWNvbSB1ZnNoYzogYWZ0ZXIgcXVldWUgZnJvemVuLCBxdWV1ZSBoY3R4IHF1ZXVl
ZCAyMzYNClsgIDIzNy4yNjYwNDFdIHVmc2hjZC1xY29tIHVmc2hjOiB1bmZyZWV6ZSBpdA0KWyAg
MjM3LjM1NDIwOF0gdWZzaGNkLXFjb20gdWZzaGM6IHF1ZXVlIHVuZm9yemVuDQovc3lzL2Rldmlj
ZXMvcGxhdGZvcm0vc29jL3Vmc2hjICMgZWNobyAxID4gZnJlZXplX3NkZV9xdWV1ZQ0KWyAgMjQw
LjkwMzAxMF0gdWZzaGNkLXFjb20gdWZzaGM6IGJlZm9yZSBzdGFydCwgcXVldWUgaGN0eCBxdWV1
ZWQgMzE4DQpbICAyNDEuMDQyMDUyXSB1ZnNoY2QtcWNvbSB1ZnNoYzogZnJlZXplIHF1ZXVlIG9m
IHNkZXYgMDowOjA6NCBzdGFydA0KWyAgMjQxLjE3MDMyMl0gdWZzaGNkLXFjb20gdWZzaGM6IGFm
dGVyIHN0YXJ0LCBxdWV1ZSBoY3R4IHF1ZXVlZCAzMTgNClsgIDI0MS4yMzY2MjVdIGJsa19tcV9z
dGFydF9yZXF1ZXN0OiBJc3N1ZSBycSB0YWcgIzYsIGludGVybmFsLXRhZyAjNjIgb24gcXVldWUg
MDowOjA6NA0KWyAgMjQxLjMxMTgwMl0gYmxrX21xX3N0YXJ0X3JlcXVlc3Q6IElzc3VlIHJxIHRh
ZyAjNywgaW50ZXJuYWwtdGFnICM2MyBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNDEuMzg2NDg5XSBi
bGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICM4LCBpbnRlcm5hbC10YWcgIzAgb24g
cXVldWUgMDowOjA6NA0KWyAgMjQxLjQ2MjAzMV0gYmxrX21xX3N0YXJ0X3JlcXVlc3Q6IElzc3Vl
IHJxIHRhZyAjOSwgaW50ZXJuYWwtdGFnICMxIG9uIHF1ZXVlIDA6MDowOjQNClsgIDI0MS41NDc3
MzldIGJsa19tcV9zdGFydF9yZXF1ZXN0OiBJc3N1ZSBycSB0YWcgIzEwLCBpbnRlcm5hbC10YWcg
IzIgb24gcXVldWUgMDowOjA6NA0KWyAgMjQxLjYzNTA2Ml0gYmxrX21xX3N0YXJ0X3JlcXVlc3Q6
IElzc3VlIHJxIHRhZyAjMTEsIGludGVybmFsLXRhZyAjMyBvbiBxdWV1ZSAwOjA6MDo0DQpbICAy
NDEuNzIyMTE0XSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMxMiwgaW50ZXJu
YWwtdGFnICM0IG9uIHF1ZXVlIDA6MDowOjQNClsgIDI0MS44MDg0ODldIGJsa19tcV9zdGFydF9y
ZXF1ZXN0OiBJc3N1ZSBycSB0YWcgIzEzLCBpbnRlcm5hbC10YWcgIzUgb24gcXVldWUgMDowOjA6
NA0KWyAgMjQxLjg5NTcwOF0gYmxrX21xX3N0YXJ0X3JlcXVlc3Q6IElzc3VlIHJxIHRhZyAjMTQs
IGludGVybmFsLXRhZyAjNiBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNDEuOTc1MjM5XSBibGtfbXFf
Z2V0X3JlcXVlc3Q6IENyZWF0ZSBuZXcgcnEgdGFnICMtMSwgaW50ZXJuYWwtdGFnICMzMiBvbiBx
dWV1ZSAwOjA6MDo0DQpbICAyNDIuMDUyMjE4XSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUg
cnEgdGFnICMxNSwgaW50ZXJuYWwtdGFnICM3IG9uIHF1ZXVlIDA6MDowOjQNClsgIDI0Mi4xMjYy
NTBdIGJsa19tcV9zdGFydF9yZXF1ZXN0OiBJc3N1ZSBycSB0YWcgIzE2LCBpbnRlcm5hbC10YWcg
Izggb24gcXVldWUgMDowOjA6NA0KWyAgMjQyLjIwMDU4M10gYmxrX21xX3N0YXJ0X3JlcXVlc3Q6
IElzc3VlIHJxIHRhZyAjMTcsIGludGVybmFsLXRhZyAjOSBvbiBxdWV1ZSAwOjA6MDo0DQpbICAy
NDIuMjc0NTcyXSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMxOCwgaW50ZXJu
YWwtdGFnICMxMCBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNDIuMzUyMzc1XSBibGtfbXFfc3RhcnRf
cmVxdWVzdDogSXNzdWUgcnEgdGFnICMxOSwgaW50ZXJuYWwtdGFnICMxMSBvbiBxdWV1ZSAwOjA6
MDo0DQpbICAyNDIuNDI2NzgxXSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMy
MCwgaW50ZXJuYWwtdGFnICMxMiBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNDIuNTA4MDkzXSBibGtf
bXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMyMSwgaW50ZXJuYWwtdGFnICMxMyBvbiBx
dWV1ZSAwOjA6MDo0DQpbICAyNDIuNTk1MjE4XSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUg
cnEgdGFnICMyMiwgaW50ZXJuYWwtdGFnICMxNCBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNDIuNjgy
NDc5XSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMyMywgaW50ZXJuYWwtdGFn
ICMyMCBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNDIuNzY4Njc3XSBibGtfbXFfc3RhcnRfcmVxdWVz
dDogSXNzdWUgcnEgdGFnICMyOSwgaW50ZXJuYWwtdGFnICMxNSBvbiBxdWV1ZSAwOjA6MDo0DQpb
ICAyNDIuODU1ODQzXSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMzMSwgaW50
ZXJuYWwtdGFnICMyMSBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNDIuOTMwMDEwXSB1ZnNoY2QtcWNv
bSB1ZnNoYzogd2FpdGluZyB0aW1lZCBvdXQhIHF1ZXVlIHVzYWdlIGNvdW50ZXI6IDQxLCBoY3R4
IHF1ZXVlZCAzMTgsIHVuZnJlZXplIGl0DQpbICAyNDMuMDI0NTYyXSBibGtfbXFfc3RhcnRfcmVx
dWVzdDogSXNzdWUgcnEgdGFnICMyNCwgaW50ZXJuYWwtdGFnICMyMiBvbiBxdWV1ZSAwOjA6MDo0
DQpbICAyNDMuMDk5NDU4XSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMyNSwg
aW50ZXJuYWwtdGFnICMyMyBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNDMuMTc0NDI3XSBibGtfbXFf
c3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMyNiwgaW50ZXJuYWwtdGFnICMyNCBvbiBxdWV1
ZSAwOjA6MDo0DQpbICAyNDMuMjQ4MDIwXSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEg
dGFnICMyNywgaW50ZXJuYWwtdGFnICMyNSBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNDMuMzI0MDMx
XSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMyOCwgaW50ZXJuYWwtdGFnICMy
NiBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNDMuMzk4MjI5XSBibGtfbXFfc3RhcnRfcmVxdWVzdDog
SXNzdWUgcnEgdGFnICMzMCwgaW50ZXJuYWwtdGFnICMyNyBvbiBxdWV1ZSAwOjA6MDo0DQpbICAy
NDMuNDcyMzY0XSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMwLCBpbnRlcm5h
bC10YWcgIzI4IG9uIHF1ZXVlIDA6MDowOjQNClsgIDI0My41NTU0MjddIGJsa19tcV9zdGFydF9y
ZXF1ZXN0OiBJc3N1ZSBycSB0YWcgIzEsIGludGVybmFsLXRhZyAjMzIgb24gcXVldWUgMDowOjA6
NA0KWyAgMjQzLjcxMzg2NF0gdWZzaGNkLXFjb20gdWZzaGM6IHF1ZXVlIHVuZm9yemVuDQovc3lz
L2RldmljZXMvcGxhdGZvcm0vc29jL3Vmc2hjICMgZWNobyAxID4gZnJlZXplX3NkZV9xdWV1ZQ0K
WyAgMjUyLjU3MTg2NF0gdWZzaGNkLXFjb20gdWZzaGM6IGJlZm9yZSBzdGFydCwgcXVldWUgaGN0
eCBxdWV1ZWQgNDQ5DQpbICAyNTIuNzAyMzQzXSB1ZnNoY2QtcWNvbSB1ZnNoYzogZnJlZXplIHF1
ZXVlIG9mIHNkZXYgMDowOjA6NCBzdGFydA0KWyAgMjUyLjg3MDI5MV0gdWZzaGNkLXFjb20gdWZz
aGM6IGFmdGVyIHN0YXJ0LCBxdWV1ZSBoY3R4IHF1ZXVlZCA0NTINClsgIDI1Mi45MzY1MzFdIGJs
a19tcV9zdGFydF9yZXF1ZXN0OiBJc3N1ZSBycSB0YWcgIzEyLCBpbnRlcm5hbC10YWcgIzYwIG9u
IHF1ZXVlIDA6MDowOjQNClsgIDI1My4wMTIwNTJdIGJsa19tcV9zdGFydF9yZXF1ZXN0OiBJc3N1
ZSBycSB0YWcgIzEzLCBpbnRlcm5hbC10YWcgIzYxIG9uIHF1ZXVlIDA6MDowOjQNClsgIDI1My4w
ODc1NjJdIGJsa19tcV9zdGFydF9yZXF1ZXN0OiBJc3N1ZSBycSB0YWcgIzE0LCBpbnRlcm5hbC10
YWcgIzYyIG9uIHF1ZXVlIDA6MDowOjQNClsgIDI1My4xNjIxMjVdIGJsa19tcV9zdGFydF9yZXF1
ZXN0OiBJc3N1ZSBycSB0YWcgIzE1LCBpbnRlcm5hbC10YWcgIzYzIG9uIHF1ZXVlIDA6MDowOjQN
ClsgIDI1My4yNDM2NzddIGJsa19tcV9zdGFydF9yZXF1ZXN0OiBJc3N1ZSBycSB0YWcgIzI0LCBp
bnRlcm5hbC10YWcgIzIgb24gcXVldWUgMDowOjA6NA0KWyAgMjUzLjMzMTA2Ml0gYmxrX21xX3N0
YXJ0X3JlcXVlc3Q6IElzc3VlIHJxIHRhZyAjMTYsIGludGVybmFsLXRhZyAjOSBvbiBxdWV1ZSAw
OjA6MDo0DQpbICAyNTMuNDE5Mzk1XSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFn
ICMxNywgaW50ZXJuYWwtdGFnICMxMCBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNTMuNTA2NTUyXSBi
bGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMxOCwgaW50ZXJuYWwtdGFnICMxMSBv
biBxdWV1ZSAwOjA6MDo0DQpbICAyNTMuNTkzODMzXSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNz
dWUgcnEgdGFnICMyNSwgaW50ZXJuYWwtdGFnICM0OCBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNTMu
NjgwNDc5XSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMyNiwgaW50ZXJuYWwt
dGFnICM0OSBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNTMuNzY3NzUwXSBibGtfbXFfc3RhcnRfcmVx
dWVzdDogSXNzdWUgcnEgdGFnICMyOSwgaW50ZXJuYWwtdGFnICM1MCBvbiBxdWV1ZSAwOjA6MDo0
DQpbICAyNTMuODU1ODg1XSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMzMSwg
aW50ZXJuYWwtdGFnICM1MSBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNTMuOTQzNTEwXSBibGtfbXFf
c3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMxOSwgaW50ZXJuYWwtdGFnICMxMiBvbiBxdWV1
ZSAwOjA6MDo0DQpbICAyNTQuMDMwODEyXSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEg
dGFnICMyMCwgaW50ZXJuYWwtdGFnICMyNiBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNTQuMTE4NTAw
XSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMyMSwgaW50ZXJuYWwtdGFnICMy
NyBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNTQuMjA0MjgxXSBibGtfbXFfc3RhcnRfcmVxdWVzdDog
SXNzdWUgcnEgdGFnICMyMiwgaW50ZXJuYWwtdGFnICMxMyBvbiBxdWV1ZSAwOjA6MDo0DQpbICAy
NTQuMjkxNDc5XSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMyMywgaW50ZXJu
YWwtdGFnICMxNCBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNTQuMzc5NTMxXSBibGtfbXFfc3RhcnRf
cmVxdWVzdDogSXNzdWUgcnEgdGFnICMyNywgaW50ZXJuYWwtdGFnICMxNSBvbiBxdWV1ZSAwOjA6
MDo0DQpbICAyNTQuNDY3MjkxXSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMy
OCwgaW50ZXJuYWwtdGFnICM1MiBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNTQuNTU0NDg5XSBibGtf
bXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMzMCwgaW50ZXJuYWwtdGFnICM1MyBvbiBx
dWV1ZSAwOjA6MDo0DQpbICAyNTQuNjQxNzkxXSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUg
cnEgdGFnICMwLCBpbnRlcm5hbC10YWcgIzU0IG9uIHF1ZXVlIDA6MDowOjQNClsgIDI1NC43Mjgw
NDFdIGJsa19tcV9zdGFydF9yZXF1ZXN0OiBJc3N1ZSBycSB0YWcgIzEsIGludGVybmFsLXRhZyAj
OCBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNTQuODE1NTcyXSBibGtfbXFfc3RhcnRfcmVxdWVzdDog
SXNzdWUgcnEgdGFnICMyLCBpbnRlcm5hbC10YWcgIzMgb24gcXVldWUgMDowOjA6NA0KWyAgMjU0
LjkwMzY5N10gYmxrX21xX3N0YXJ0X3JlcXVlc3Q6IElzc3VlIHJxIHRhZyAjMywgaW50ZXJuYWwt
dGFnICM0IG9uIHF1ZXVlIDA6MDowOjQNClsgIDI1NC45OTExMTRdIGJsa19tcV9zdGFydF9yZXF1
ZXN0OiBJc3N1ZSBycSB0YWcgIzQsIGludGVybmFsLXRhZyAjNSBvbiBxdWV1ZSAwOjA6MDo0DQpb
ICAyNTUuMDYyOTE2XSB1ZnNoY2QtcWNvbSB1ZnNoYzogd2FpdGluZyB0aW1lZCBvdXQhIHF1ZXVl
IHVzYWdlIGNvdW50ZXI6IDM0LCBoY3R4IHF1ZXVlZCA0NTIsIHVuZnJlZXplIGl0DQpbICAyNTUu
MTU2MjgxXSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICM1LCBpbnRlcm5hbC10
YWcgIzYgb24gcXVldWUgMDowOjA6NA0KWyAgMjU1LjIyODQ1OF0gYmxrX21xX3N0YXJ0X3JlcXVl
c3Q6IElzc3VlIHJxIHRhZyAjNiwgaW50ZXJuYWwtdGFnICM3IG9uIHF1ZXVlIDA6MDowOjQNClsg
IDI1NS40MDE5MDZdIHVmc2hjZC1xY29tIHVmc2hjOiBxdWV1ZSB1bmZvcnplbg0KL3N5cy9kZXZp
Y2VzL3BsYXRmb3JtL3NvYy91ZnNoYyAjIGVjaG8gMSA+IGZyZWV6ZV9zZGVfcXVldWUNClsgIDI2
OS43NDQzOTVdIHVmc2hjZC1xY29tIHVmc2hjOiBiZWZvcmUgc3RhcnQsIHF1ZXVlIGhjdHggcXVl
dWVkIDY2MQ0KWyAgMjY5Ljg4MzMwMl0gdWZzaGNkLXFjb20gdWZzaGM6IGZyZWV6ZSBxdWV1ZSBv
ZiBzZGV2IDA6MDowOjQgc3RhcnQNClsgIDI3MC4wMTQ5NThdIHVmc2hjZC1xY29tIHVmc2hjOiBh
ZnRlciBzdGFydCwgcXVldWUgaGN0eCBxdWV1ZWQgNjYxDQpbICAyNzAuMTQ2MDMxXSBibGtfbXFf
c3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMyMiwgaW50ZXJuYWwtdGFnICM0IG9uIHF1ZXVl
IDA6MDowOjQNClsgIDI3MC4yODYyODFdIGJsa19tcV9zdGFydF9yZXF1ZXN0OiBJc3N1ZSBycSB0
YWcgIzI3LCBpbnRlcm5hbC10YWcgIzUyIG9uIHF1ZXVlIDA6MDowOjQNClsgIDI3MC4zNTkyMDhd
IGJsa19tcV9zdGFydF9yZXF1ZXN0OiBJc3N1ZSBycSB0YWcgIzIzLCBpbnRlcm5hbC10YWcgIzUz
IG9uIHF1ZXVlIDA6MDowOjQNClsgIDI3MC40MzQ0NThdIGJsa19tcV9zdGFydF9yZXF1ZXN0OiBJ
c3N1ZSBycSB0YWcgIzI4LCBpbnRlcm5hbC10YWcgIzE0IG9uIHF1ZXVlIDA6MDowOjQNClsgIDI3
MC41MDY2MDRdIGJsa19tcV9zdGFydF9yZXF1ZXN0OiBJc3N1ZSBycSB0YWcgIzMwLCBpbnRlcm5h
bC10YWcgIzQwIG9uIHF1ZXVlIDA6MDowOjQNClsgIDI3MC41ODU3ODFdIGJsa19tcV9zdGFydF9y
ZXF1ZXN0OiBJc3N1ZSBycSB0YWcgIzAsIGludGVybmFsLXRhZyAjNDcgb24gcXVldWUgMDowOjA6
NA0KWyAgMjcwLjY1ODI1MF0gYmxrX21xX3N0YXJ0X3JlcXVlc3Q6IElzc3VlIHJxIHRhZyAjMSwg
aW50ZXJuYWwtdGFnICMzMiBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNzAuNzMxMzY0XSBibGtfbXFf
c3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMyLCBpbnRlcm5hbC10YWcgIzMzIG9uIHF1ZXVl
IDA6MDowOjQNClsgIDI3MC44NjY5MzddIGJsa19tcV9zdGFydF9yZXF1ZXN0OiBJc3N1ZSBycSB0
YWcgIzMsIGludGVybmFsLXRhZyAjMzQgb24gcXVldWUgMDowOjA6NA0KWyAgMjcxLjAwNjAxMF0g
YmxrX21xX3N0YXJ0X3JlcXVlc3Q6IElzc3VlIHJxIHRhZyAjNCwgaW50ZXJuYWwtdGFnICM1NCBv
biBxdWV1ZSAwOjA6MDo0DQpbICAyNzEuMDc2NTQxXSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNz
dWUgcnEgdGFnICM1LCBpbnRlcm5hbC10YWcgIzE2IG9uIHF1ZXVlIDA6MDowOjQNClsgIDI3MS4x
NTU3MjldIGJsa19tcV9zdGFydF9yZXF1ZXN0OiBJc3N1ZSBycSB0YWcgIzYsIGludGVybmFsLXRh
ZyAjMTcgb24gcXVldWUgMDowOjA6NA0KWyAgMjcxLjIzMDA4M10gYmxrX21xX3N0YXJ0X3JlcXVl
c3Q6IElzc3VlIHJxIHRhZyAjNywgaW50ZXJuYWwtdGFnICMxOCBvbiBxdWV1ZSAwOjA6MDo0DQpb
ICAyNzEuMzA0NjM1XSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICM4LCBpbnRl
cm5hbC10YWcgIzE5IG9uIHF1ZXVlIDA6MDowOjQNClsgIDI3MS4zNzkzODVdIGJsa19tcV9zdGFy
dF9yZXF1ZXN0OiBJc3N1ZSBycSB0YWcgIzksIGludGVybmFsLXRhZyAjMjAgb24gcXVldWUgMDow
OjA6NA0KWyAgMjcxLjUxNDgyMl0gYmxrX21xX3N0YXJ0X3JlcXVlc3Q6IElzc3VlIHJxIHRhZyAj
MTAsIGludGVybmFsLXRhZyAjMzUgb24gcXVldWUgMDowOjA6NA0KWyAgMjcxLjU4Njc4MV0gYmxr
X21xX3N0YXJ0X3JlcXVlc3Q6IElzc3VlIHJxIHRhZyAjMTEsIGludGVybmFsLXRhZyAjNTUgb24g
cXVldWUgMDowOjA6NA0KWyAgMjcxLjcyNDU5M10gYmxrX21xX3N0YXJ0X3JlcXVlc3Q6IElzc3Vl
IHJxIHRhZyAjMTIsIGludGVybmFsLXRhZyAjMzYgb24gcXVldWUgMDowOjA6NA0KWyAgMjcxLjc5
ODkxNl0gYmxrX21xX3N0YXJ0X3JlcXVlc3Q6IElzc3VlIHJxIHRhZyAjMTMsIGludGVybmFsLXRh
ZyAjMzcgb24gcXVldWUgMDowOjA6NA0KWyAgMjcxLjg3MDY5N10gYmxrX21xX3N0YXJ0X3JlcXVl
c3Q6IElzc3VlIHJxIHRhZyAjMTQsIGludGVybmFsLXRhZyAjMzggb24gcXVldWUgMDowOjA6NA0K
WyAgMjcxLjk0MzgxMl0gdWZzaGNkLXFjb20gdWZzaGM6IHdhaXRpbmcgdGltZWQgb3V0ISBxdWV1
ZSB1c2FnZSBjb3VudGVyOiA0MiwgaGN0eCBxdWV1ZWQgNjYxLCB1bmZyZWV6ZSBpdA0KWyAgMjcy
LjA0MDYxNF0gYmxrX21xX3N0YXJ0X3JlcXVlc3Q6IElzc3VlIHJxIHRhZyAjMTYsIGludGVybmFs
LXRhZyAjNTYgb24gcXVldWUgMDowOjA6NA0KWyAgMjcyLjExNTE0NV0gYmxrX21xX3N0YXJ0X3Jl
cXVlc3Q6IElzc3VlIHJxIHRhZyAjMjQsIGludGVybmFsLXRhZyAjNTcgb24gcXVldWUgMDowOjA6
NA0KWyAgMjcyLjE4NzI2MF0gYmxrX21xX3N0YXJ0X3JlcXVlc3Q6IElzc3VlIHJxIHRhZyAjMTUs
IGludGVybmFsLXRhZyAjNTggb24gcXVldWUgMDowOjA6NA0KWyAgMjcyLjMyMzA3Ml0gYmxrX21x
X3N0YXJ0X3JlcXVlc3Q6IElzc3VlIHJxIHRhZyAjMTcsIGludGVybmFsLXRhZyAjMCBvbiBxdWV1
ZSAwOjA6MDo0DQpbICAyNzIuMzkzODc1XSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEg
dGFnICMxOCwgaW50ZXJuYWwtdGFnICMyMSBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNzIuNDY2NTUy
XSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMxOSwgaW50ZXJuYWwtdGFnICM1
OSBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNzIuNTQwMTU2XSBibGtfbXFfZ2V0X3JlcXVlc3Q6IENy
ZWF0ZSBuZXcgcnEgdGFnICMtMSwgaW50ZXJuYWwtdGFnICMyMyBvbiBxdWV1ZSAwOjA6MDo0DQpb
ICAyNzIuNjE3ODc1XSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMyNSwgaW50
ZXJuYWwtdGFnICM2MCBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNzIuNjkxMTM1XSBibGtfbXFfc3Rh
cnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMyNiwgaW50ZXJuYWwtdGFnICMyMiBvbiBxdWV1ZSAw
OjA6MDo0DQpbICAyNzIuNzY2Njg3XSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFn
ICMyMCwgaW50ZXJuYWwtdGFnICMyMyBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNzMuMDAyMDYyXSB1
ZnNoY2QtcWNvbSB1ZnNoYzogcXVldWUgdW5mb3J6ZW4NCi9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9z
b2MvdWZzaGMgIyBlY2hvIDEgPiBmcmVlemVfc2RlX3F1ZXVlDQpbICAyNzUuMzUwNzM5XSB1ZnNo
Y2QtcWNvbSB1ZnNoYzogYmVmb3JlIHN0YXJ0LCBxdWV1ZSBoY3R4IHF1ZXVlZCA3MjMNClsgIDI3
NS40ODY2NDVdIHVmc2hjZC1xY29tIHVmc2hjOiBmcmVlemUgcXVldWUgb2Ygc2RldiAwOjA6MDo0
IHN0YXJ0DQpbICAyNzUuNjE4NDM3XSB1ZnNoY2QtcWNvbSB1ZnNoYzogYWZ0ZXIgc3RhcnQsIHF1
ZXVlIGhjdHggcXVldWVkIDcyMw0KWyAgMjc1Ljc0NjUwMF0gYmxrX21xX3N0YXJ0X3JlcXVlc3Q6
IElzc3VlIHJxIHRhZyAjMjcsIGludGVybmFsLXRhZyAjMzEgb24gcXVldWUgMDowOjA6NA0KWyAg
Mjc1Ljg4MjA2Ml0gYmxrX21xX3N0YXJ0X3JlcXVlc3Q6IElzc3VlIHJxIHRhZyAjMjIsIGludGVy
bmFsLXRhZyAjMTYgb24gcXVldWUgMDowOjA6NA0KWyAgMjc1Ljk1NTA2Ml0gYmxrX21xX3N0YXJ0
X3JlcXVlc3Q6IElzc3VlIHJxIHRhZyAjMjgsIGludGVybmFsLXRhZyAjMTcgb24gcXVldWUgMDow
OjA6NA0KWyAgMjc2LjAzNTE4N10gYmxrX21xX3N0YXJ0X3JlcXVlc3Q6IElzc3VlIHJxIHRhZyAj
MzAsIGludGVybmFsLXRhZyAjMTggb24gcXVldWUgMDowOjA6NA0KWyAgMjc2LjEwOTgxMl0gYmxr
X21xX3N0YXJ0X3JlcXVlc3Q6IElzc3VlIHJxIHRhZyAjMjMsIGludGVybmFsLXRhZyAjNTQgb24g
cXVldWUgMDowOjA6NA0KWyAgMjc2LjE4NDQzN10gYmxrX21xX3N0YXJ0X3JlcXVlc3Q6IElzc3Vl
IHJxIHRhZyAjMCwgaW50ZXJuYWwtdGFnICM4IG9uIHF1ZXVlIDA6MDowOjQNClsgIDI3Ni4yNTYw
NDFdIGJsa19tcV9zdGFydF9yZXF1ZXN0OiBJc3N1ZSBycSB0YWcgIzEsIGludGVybmFsLXRhZyAj
OSBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNzYuMzkwNDM3XSBibGtfbXFfc3RhcnRfcmVxdWVzdDog
SXNzdWUgcnEgdGFnICMyLCBpbnRlcm5hbC10YWcgIzEwIG9uIHF1ZXVlIDA6MDowOjQNClsgIDI3
Ni40NjI3NjBdIGJsa19tcV9zdGFydF9yZXF1ZXN0OiBJc3N1ZSBycSB0YWcgIzMsIGludGVybmFs
LXRhZyAjMTEgb24gcXVldWUgMDowOjA6NA0KWyAgMjc2LjU0MDQxNl0gYmxrX21xX3N0YXJ0X3Jl
cXVlc3Q6IElzc3VlIHJxIHRhZyAjNCwgaW50ZXJuYWwtdGFnICMxOSBvbiBxdWV1ZSAwOjA6MDo0
DQpbICAyNzYuNjE0NjM1XSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICM1LCBp
bnRlcm5hbC10YWcgIzIwIG9uIHF1ZXVlIDA6MDowOjQNClsgIDI3Ni42ODc1OTNdIGJsa19tcV9z
dGFydF9yZXF1ZXN0OiBJc3N1ZSBycSB0YWcgIzYsIGludGVybmFsLXRhZyAjMTIgb24gcXVldWUg
MDowOjA6NA0KWyAgMjc2Ljc1ODQ3OV0gYmxrX21xX3N0YXJ0X3JlcXVlc3Q6IElzc3VlIHJxIHRh
ZyAjNywgaW50ZXJuYWwtdGFnICMxMyBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNzYuODMxNTIwXSBi
bGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICM4LCBpbnRlcm5hbC10YWcgIzE0IG9u
IHF1ZXVlIDA6MDowOjQNClsgIDI3Ni45MDY0NThdIGJsa19tcV9zdGFydF9yZXF1ZXN0OiBJc3N1
ZSBycSB0YWcgIzksIGludGVybmFsLXRhZyAjMTUgb24gcXVldWUgMDowOjA6NA0KWyAgMjc2Ljk3
OTU2Ml0gYmxrX21xX3N0YXJ0X3JlcXVlc3Q6IElzc3VlIHJxIHRhZyAjMTAsIGludGVybmFsLXRh
ZyAjNTUgb24gcXVldWUgMDowOjA6NA0KWyAgMjc3LjExNTMzM10gYmxrX21xX3N0YXJ0X3JlcXVl
c3Q6IElzc3VlIHJxIHRhZyAjMTEsIGludGVybmFsLXRhZyAjNTYgb24gcXVldWUgMDowOjA6NA0K
WyAgMjc3LjI0Mzc5MV0gYmxrX21xX3N0YXJ0X3JlcXVlc3Q6IElzc3VlIHJxIHRhZyAjMTIsIGlu
dGVybmFsLXRhZyAjMCBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNzcuMzE2MjE4XSBibGtfbXFfc3Rh
cnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMxMywgaW50ZXJuYWwtdGFnICMzNSBvbiBxdWV1ZSAw
OjA6MDo0DQpbICAyNzcuMzkxNjU2XSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFn
ICMxNiwgaW50ZXJuYWwtdGFnICMzNiBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNzcuNDY1NzA4XSBi
bGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMxNCwgaW50ZXJuYWwtdGFnICMzNyBv
biBxdWV1ZSAwOjA6MDo0DQpbICAyNzcuNTQ0MTI1XSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNz
dWUgcnEgdGFnICMyNCwgaW50ZXJuYWwtdGFnICMzOCBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNzcu
NjE5NTUyXSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMxNSwgaW50ZXJuYWwt
dGFnICM1NyBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNzcuNjk0NTQxXSBibGtfbXFfc3RhcnRfcmVx
dWVzdDogSXNzdWUgcnEgdGFnICMxNywgaW50ZXJuYWwtdGFnICMyMSBvbiBxdWV1ZSAwOjA6MDo0
DQpbICAyNzcuNzY3Njc3XSB1ZnNoY2QtcWNvbSB1ZnNoYzogd2FpdGluZyB0aW1lZCBvdXQhIHF1
ZXVlIHVzYWdlIGNvdW50ZXI6IDM2LCBoY3R4IHF1ZXVlZCA3MjMsIHVuZnJlZXplIGl0DQpbICAy
NzcuOTIwMDQxXSBibGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMxOCwgaW50ZXJu
YWwtdGFnICM1OCBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNzcuOTkyMzU0XSBibGtfbXFfc3RhcnRf
cmVxdWVzdDogSXNzdWUgcnEgdGFnICMxOSwgaW50ZXJuYWwtdGFnICM1OSBvbiBxdWV1ZSAwOjA6
MDo0DQpbICAyNzguMDY3MjUwXSBibGtfbXFfZ2V0X3JlcXVlc3Q6IENyZWF0ZSBuZXcgcnEgdGFn
ICMtMSwgaW50ZXJuYWwtdGFnICMyMiBvbiBxdWV1ZSAwOjA6MDo0DQpbICAyNzguMjAyNzYwXSBi
bGtfbXFfc3RhcnRfcmVxdWVzdDogSXNzdWUgcnEgdGFnICMyNSwgaW50ZXJuYWwtdGFnICMyMiBv
biBxdWV1ZSAwOjA6MDo0DQpbICAyNzguMzIwNDQ3XSB1ZnNoY2QtcWNvbSB1ZnNoYzogcXVldWUg
dW5mb3J6ZW4NCi9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9zb2MvdWZzaGMgIyBlY2hvIDEgPiBmcmVl
emVfc2RlX3F1ZXVlDQpbICAyODEuMTEyMDUyXSB1ZnNoY2QtcWNvbSB1ZnNoYzogYmVmb3JlIHN0
YXJ0LCBxdWV1ZSBoY3R4IHF1ZXVlZCA3MzANClsgIDI4MS4yNjY0NjhdIHVmc2hjZC1xY29tIHVm
c2hjOiBmcmVlemUgcXVldWUgb2Ygc2RldiAwOjA6MDo0IHN0YXJ0DQpbICAyODEuMzc0MzY0XSB1
ZnNoY2QtcWNvbSB1ZnNoYzogYWZ0ZXIgc3RhcnQsIHF1ZXVlIGhjdHggcXVldWVkIDczMA0KWyAg
MjgxLjUwMjEwNF0gdWZzaGNkLXFjb20gdWZzaGM6IHF1ZXVlIGZvcnplbiwgcXVldWUgdXNhZ2Ug
Y291bnRlcjogMA0KWyAgMjgxLjYzODEyNV0gdWZzaGNkLXFjb20gdWZzaGM6IGFmdGVyIHF1ZXVl
IGZyb3plbiwgcXVldWUgaGN0eCBxdWV1ZWQgNzMwDQpbICAyODEuNzcwMDEwXSB1ZnNoY2QtcWNv
bSB1ZnNoYzogdW5mcmVlemUgaXQNClsgIDI4MS44NjIxODddIHVmc2hjZC1xY29tIHVmc2hjOiBx
dWV1ZSB1bmZvcnplbg0KL3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NvYy91ZnNoYyAj
--=_60ee798d9da7eb0c68ce6980a5ca6e85--
