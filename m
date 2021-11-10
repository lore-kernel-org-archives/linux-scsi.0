Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C04AEC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 08:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A9A46112F
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 08:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhKJIHL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 03:07:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:2481 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229613AbhKJIHK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Nov 2021 03:07:10 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10163"; a="219827041"
X-IronPort-AV: E=Sophos;i="5.87,223,1631602800"; 
   d="scan'208";a="219827041"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 00:04:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,223,1631602800"; 
   d="scan'208";a="492000839"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by orsmga007.jf.intel.com with ESMTP; 10 Nov 2021 00:04:19 -0800
Subject: Re: [PATCH 10/11] scsi: ufs: Optimize the command queueing code
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Keoseong Park <keosung.park@samsung.com>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-11-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <bd2cdc84-3776-a08c-dc41-272719097c83@intel.com>
Date:   Wed, 10 Nov 2021 10:04:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211110004440.3389311-11-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/11/2021 02:44, Bart Van Assche wrote:
> Remove the clock scaling lock from ufshcd_queuecommand() since it is a
> performance bottleneck. As requested by Asutosh Das, change the behavior
> of ufshcd_clock_scaling_prepare() from waiting until all pending
> commands have finished into quiescing request queues. Insert a
> rcu_read_lock() / rcu_read_unlock() pair in ufshcd_queuecommand() and also
> in __ufshcd_issue_tm_cmd(). Use synchronize_rcu_expedited() to wait for
> ongoing command and TMF queueing.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 121 +++++++++++++-------------------------
>  drivers/scsi/ufs/ufshcd.h |   1 +
>  2 files changed, 42 insertions(+), 80 deletions(-)
> 

<SNIP>

> @@ -2698,8 +2653,11 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  
>  	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
>  
> -	if (!down_read_trylock(&hba->clk_scaling_lock))
> -		return SCSI_MLQUEUE_HOST_BUSY;
> +	/*
> +	 * Allows ufshcd_clock_scaling_prepare() and also the UFS error handler
> +	 * to wait for prior ufshcd_queuecommand() calls.
> +	 */
> +	rcu_read_lock();

The improvement to flush/drain ufshcd_queuecommand() via RCU should
be a separate patch because it is not dependent on the other changes.

<SNIP>
