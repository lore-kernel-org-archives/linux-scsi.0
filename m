Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81EF1C43215
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 01:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C5172075C
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 01:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKZBFw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Nov 2019 20:05:52 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35364 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfKZBFw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Nov 2019 20:05:52 -0500
Received: by mail-pf1-f193.google.com with SMTP id q13so8294908pff.2
        for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2019 17:05:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CZ2rLuNTocnjT1sDOKKvcl25Cv14JvcCPZh7oYizLws=;
        b=TsBtwXMoJsRSBcDbJfHwm/MkFPfsjASMtCELglH1TuKEGRoUZ0PiRDPjApZFPK5D9U
         Ha/Nc0t6ult2dY0yhDeOLwdsVJa28kgCfYdylDgEU3SSVpK2RVhKVodbDsmpnYYbV7i8
         bLSbcfy8w0StjW94gwvQowZQH/wTsGEnd/08K3xMrsI/i1auujThrN6USW9u4HhroGQW
         h+D17B/p5ohGFgiElWJ8Z8BDPiV2apFZoxuWDaMH8papmzwN67miouhyioWYpNJXQWje
         3RY5IN8jUadUezbOEWoS26FSVHlVk4F4/KzmAtICVDEdPI8/WbH+7acnWX5eq5VCcRHa
         IsoA==
X-Gm-Message-State: APjAAAWYVgRe7H0gBfV7+hRKzv2ra7UzLFt/ZDGEj8lyv+XQbKtB6874
        Uoso3h+VNY0Rm9b6o3Gkbwxmtazi
X-Google-Smtp-Source: APXvYqwUuo3WhNzh7rHBH7vO35Yjq9ctkaSnRmZGEEEIhAdmIXVA0+PYWMOuUCfN5x2RRcIlQu6nPQ==
X-Received: by 2002:a63:1013:: with SMTP id f19mr20796671pgl.289.1574730351251;
        Mon, 25 Nov 2019 17:05:51 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id c13sm9801289pfi.0.2019.11.25.17.05.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2019 17:05:49 -0800 (PST)
Subject: Re: [PATCH v6 4/4] ufs: Simplify the clock scaling mechanism
 implementation
To:     cang@codeaurora.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-scsi@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
References: <20191121220850.16195-1-bvanassche@acm.org>
 <20191121220850.16195-5-bvanassche@acm.org>
 <0101016ea17f117f-41755175-dc9e-4454-bda6-3653b9aa31ff-000000@us-west-2.amazonses.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c26ba983-b166-785f-86e8-dd60c802fa77@acm.org>
Date:   Mon, 25 Nov 2019 17:05:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <0101016ea17f117f-41755175-dc9e-4454-bda6-3653b9aa31ff-000000@us-west-2.amazonses.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/24/19 11:38 PM, cang@codeaurora.org wrote:
> Sorry to bring back the old discussion we had on V5 of this series here.
> I spent some time understanding the mq freeze queue implementation but I
> still have the same concern regards the your new implementation of clock
> scaling prepare/unprepare.
> 
> I attached two logs I collected on my setups(the kernel is 5.4).
> 
> In log1.txt, I pretty much ported your changes to our code base and copy
> a large file to partition /dev/sde1(mounted to /mnt). You can see the
> debug logs I added show that the -ETIMEDOUT returned from ufshcd_devfreq_scale(),
> although scaling UP/DOWN succeed some times.
> 
> To make it more controllable, I made a new sysfs entry, namely freeze_sde_queue,
> so that I can freeze the queue of /dev/sde whenever I do "echo 1 > freeze_sde_queue".
> After call blk_freeze_queue_start(), call blk_mq_freeze_queue_wait_timeout() to wait for 1 sec.
> In the end, blk_mq_unfreeze_queue() would be called no matter timeout happened or not.
> 
> I also added a flag, called enable_print, to request_queue, and set it after I call
> blk_freeze_queue_start(). Block layer, when this flag is set, will print logs from
> blk_mq_start_request() and blk_mq_get_request().
> 
> I tried multiple times during copy large a file to partition /dev/sde1(mounted to /mnt).
> 
> In log2.txt, there are still wait timeout, and you can see after blk_freeze_queue_start()
> is called for request queue of /dev/sde, there still can be requests sent down to UFS driver
> and these requests are the "latency" that I mentioned in our previous discussion. I know
> these requests are not "new" requests reach block layer after freeze starts,  but the ones
> in the queue before freeze starts. However, they are the difference from the old implementation.
> When scaling up should happen, these requests are still sent through the lowest HS Gear,
> while when scaling down should happen, these requests are sent through the highest HS Gear.
> The former may cause performance issue while the later may cause power penalty, this is our
> major concern.

Hi Can,

Thank you for having taken the time to run these tests and to share the output
of these tests. If I understood you correctly the patch I posted works but
introduces a performance regression, namely that it takes longer to suspend
request processing for an UFS host. How about replacing patch 4/4 with the
patch below?

Thanks,

Bart.

Subject: [PATCH] ufs: Make clock scaling more robust

Scaling the clock is only safe while no commands are in progress. The
current clock scaling implementation uses hba->clk_scaling_lock to
serialize clock scaling against the following three functions:
* ufshcd_queuecommand()          (uses sdev->request_queue)
* ufshcd_exec_dev_cmd()          (uses hba->cmd_queue)
* ufshcd_issue_devman_upiu_cmd() (uses hba->cmd_queue)

__ufshcd_issue_tm_cmd(), which uses hba->tmf_queue, is not yet serialized
against clock scaling. Disallowing that TMFs are submitted as follows from
user space while clock scaling is in progress:

submit UPIU_TRANSACTION_TASK_REQ on an UFS BSG queue
-> ufs_bsg_request()
   -> ufshcd_exec_raw_upiu_cmd(msgcode = UPIU_TRANSACTION_TASK_REQ)
     -> ufshcd_exec_raw_upiu_cmd()
       -> __ufshcd_issue_tm_cmd()

Cc: Can Guo <cang@codeaurora.org>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  drivers/scsi/ufs/ufshcd.c | 36 +++++++++++++++++++++++++-----------
  1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 99337e0b54f6..631c588f279a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -972,14 +972,13 @@ static bool ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
  }

  static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
-					u64 wait_timeout_us)
+					unsigned long deadline)
  {
  	unsigned long flags;
  	int ret = 0;
  	u32 tm_doorbell;
  	u32 tr_doorbell;
  	bool timeout = false, do_last_check = false;
-	ktime_t start;

  	ufshcd_hold(hba, false);
  	spin_lock_irqsave(hba->host->host_lock, flags);
@@ -987,7 +986,6 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
  	 * Wait for all the outstanding tasks/transfer requests.
  	 * Verify by checking the doorbell registers are clear.
  	 */
-	start = ktime_get();
  	do {
  		if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
  			ret = -EBUSY;
@@ -1005,8 +1003,7 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,

  		spin_unlock_irqrestore(hba->host->host_lock, flags);
  		schedule();
-		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
-		    wait_timeout_us) {
+		if (time_after(jiffies, deadline)) {
  			timeout = true;
  			/*
  			 * We might have scheduled out for long time so make
@@ -1079,26 +1076,43 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)

  static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
  {
-	#define DOORBELL_CLR_TOUT_US		(1000 * 1000) /* 1 sec */
+	unsigned long deadline = jiffies + HZ /* 1 sec */;
  	int ret = 0;
  	/*
  	 * make sure that there are no outstanding requests when
  	 * clock scaling is in progress
  	 */
  	ufshcd_scsi_block_requests(hba);
+	blk_freeze_queue_start(hba->cmd_queue);
+	blk_freeze_queue_start(hba->tmf_queue);
+	if (blk_mq_freeze_queue_wait_timeout(hba->cmd_queue,
+				max_t(long, 1, deadline - jiffies)) <= 0)
+		goto unblock;
+	if (blk_mq_freeze_queue_wait_timeout(hba->tmf_queue,
+				max_t(long, 1, deadline - jiffies)) <= 0)
+		goto unblock;
  	down_write(&hba->clk_scaling_lock);
-	if (ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
-		ret = -EBUSY;
-		up_write(&hba->clk_scaling_lock);
-		ufshcd_scsi_unblock_requests(hba);
-	}
+	if (ufshcd_wait_for_doorbell_clr(hba, deadline))
+		goto up_write;

+out:
  	return ret;
+
+up_write:
+	up_write(&hba->clk_scaling_lock);
+unblock:
+	blk_mq_unfreeze_queue(hba->tmf_queue);
+	blk_mq_unfreeze_queue(hba->cmd_queue);
+	ufshcd_scsi_unblock_requests(hba);
+	ret = -EBUSY;
+	goto out;
  }

  static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
  {
  	up_write(&hba->clk_scaling_lock);
+	blk_mq_unfreeze_queue(hba->tmf_queue);
+	blk_mq_unfreeze_queue(hba->cmd_queue);
  	ufshcd_scsi_unblock_requests(hba);
  }

