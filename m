Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8928C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 23:48:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbhKVXvn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 18:51:43 -0500
Received: from mail-pj1-f52.google.com ([209.85.216.52]:44646 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbhKVXvm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 18:51:42 -0500
Received: by mail-pj1-f52.google.com with SMTP id o6-20020a17090a0a0600b001a64b9a11aeso1278437pjo.3
        for <linux-scsi@vger.kernel.org>; Mon, 22 Nov 2021 15:48:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/kOq7/uRA2bkSIY8wz+YdZD0m9cuA7/6MIijWmv9Kok=;
        b=rlD3AvugGCJCzosXDxbuIX89CqKS3D8hnvfXoogdyRocA256bi4tDRBL1uSH0oiItF
         z0blKJg9KpaQtEFw3iS5tJ0F7o4Jx7PP6YFKHB3sYFFm6N8n/wS2xYfJJHotoibYiMp7
         jISh9z9863bJdONBVd+BFUvz5S2HSfP5TNFcW3/qA/it1Fg/qi4RNCTl3KA5NwohvZ/X
         0VWHjyrFav5bSnGXOUvgeo+WEc9PiIPNnzOXxmc4hN67s9rrtJTk2kjNo5qPHs7S4sfC
         yExDKyBv+RFIGrOac+T54x5xFUToktIkfZcqemR4j86cN0XWSz3jlb16Cv3q3LzrECpw
         wnuw==
X-Gm-Message-State: AOAM530rr0S1LkhYxZwgx0K6jDNdwAgkVC63Et2GuaoAAnJTwzEdl66m
        VrYoCPpVv5UVQ6fYC4Dh2/c=
X-Google-Smtp-Source: ABdhPJwPfe2VGTTaJnwev/Nkf9j/IJ6r5ALX7dDVQcVfkYDwn8RWtmddKF99q312vVHmLxrutgrVmw==
X-Received: by 2002:a17:90b:1a87:: with SMTP id ng7mr986703pjb.230.1637624915351;
        Mon, 22 Nov 2021 15:48:35 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3432:c377:2744:1125])
        by smtp.gmail.com with ESMTPSA id np1sm20590308pjb.22.2021.11.22.15.48.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 15:48:34 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 18/20] scsi: ufs: Optimize the command queueing code
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-19-bvanassche@acm.org>
 <a2599b2c-208c-3333-61f0-d61a269b53d4@codeaurora.org>
 <f6eb1b4c-ef73-7e34-cecd-fa0c9ce07a2f@acm.org>
 <2071f69b-885f-e0c5-3ded-9f0c39eb38ae@codeaurora.org>
Message-ID: <6dea2d9c-c04a-20a5-4292-e48badf89ba2@acm.org>
Date:   Mon, 22 Nov 2021 15:48:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <2071f69b-885f-e0c5-3ded-9f0c39eb38ae@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/22/21 3:02 PM, Asutosh Das (asd) wrote:
> Current code waits for the already issued requests to complete. It 
> doesn't issue the yet-to-be issued requests. Wouldn't freezing the queue 
> issue the requests in the context of scaling_{up/down}?
> If yes, I don't think the current code is doing that.

Hi Asutosh,

How about the patch below that preserves most of the existing code for
preparing for clock scaling?

Thanks,

Bart.


Subject: [PATCH] scsi: ufs: Optimize the command queueing code

Remove the clock scaling lock from ufshcd_queuecommand() since it is a
performance bottleneck. Instead, use synchronize_rcu_expedited() to wait
for ongoing ufshcd_queuecommand() calls.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  drivers/scsi/ufs/ufshcd.c | 12 +++++++-----
  drivers/scsi/ufs/ufshcd.h |  1 +
  2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5d214456bf82..1d929c28efaf 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1196,6 +1196,13 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
  	/* let's not get into low power until clock scaling is completed */
  	ufshcd_hold(hba, false);

+	/*
+	 * Wait for ongoing ufshcd_queuecommand() calls. Calling
+	 * synchronize_rcu_expedited() instead of synchronize_rcu() reduces the
+	 * waiting time from milliseconds to microseconds.
+	 */
+	synchronize_rcu_expedited();
+
  out:
  	return ret;
  }
@@ -2699,9 +2706,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)

  	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);

-	if (!down_read_trylock(&hba->clk_scaling_lock))
-		return SCSI_MLQUEUE_HOST_BUSY;
-
  	/*
  	 * Allows the UFS error handler to wait for prior ufshcd_queuecommand()
  	 * calls.
@@ -2790,8 +2794,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
  out:
  	rcu_read_unlock();

-	up_read(&hba->clk_scaling_lock);
-
  	if (ufs_trigger_eh()) {
  		unsigned long flags;

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c13ae56fbff8..695bede14dac 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -777,6 +777,7 @@ struct ufs_hba_monitor {
   * @clk_list_head: UFS host controller clocks list node head
   * @pwr_info: holds current power mode
   * @max_pwr_info: keeps the device max valid pwm
+ * @clk_scaling_lock: used to serialize device commands and clock scaling
   * @desc_size: descriptor sizes reported by device
   * @urgent_bkops_lvl: keeps track of urgent bkops level for device
   * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
