Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 794BFC7619A
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 08:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjDKIjf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 04:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjDKIje (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 04:39:34 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E500EAB
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2023 01:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681202373; x=1712738373;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=V5mA0UyCuzFlVyTia1rig5Ax2S4EC8JD0/fN+Cjw65s=;
  b=W2ir4z5yk0mBo9mWRzEUJDyu26mEdIVT0CkmaiDH/4T/Pq/3lC4vbUZY
   uYHMis2YUH3VuX1AKs8fQBw+6hxGQMrBVa6phuvXdCa6o+cc/EQcd3hW9
   AAj02u3wJj8Vqz/PkL6Z2iHK+NrhWKFhnjsqC4gUA6ES1xcFL5wDVjqvO
   RaUba6EEaE3i3QyGcHsMPPaPG1fvqhaxtncSBLgsav/uP9zgqo5o/6OEK
   jw2sirh3lsS6VZv7CNCMviVo0/vOVusZAA67YsxHtbYK10S3Nz/NleoJI
   yxCWcijf3pCo9xYwiC/yJORLzOPV/5H5v2bYUqeUgHNEZDvzEgO+hshjK
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="341048453"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="341048453"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 01:39:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="638735461"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="638735461"
Received: from bwerner1-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.44.57])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 01:39:27 -0700
Message-ID: <17217146-9c07-3963-fd32-02704632330d@intel.com>
Date:   Tue, 11 Apr 2023 11:39:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH] scsi: ufs: Increase the START STOP UNIT timeout from 1 s
 to 10 s
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20230411001132.1239225-1-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20230411001132.1239225-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/04/23 03:11, Bart Van Assche wrote:
> One UFS vendor asked to increase the UFS timeout from 1 s to 3 s.
> Another UFS vendor asked to increase the UFS timeout from 1 s to 10 s.
> Hence this patch that increases the UFS timeout to 10 s. This patch can
> cause the total timeout to exceed 20 s, the Android shutdown timeout.
> This is fine since the loop around ufshcd_execute_start_stop() exists to
> deal with unit attentions and because unit attentions are reported
> quickly.
> 
> Fixes: dcd5b7637c6d ("scsi: ufs: Reduce the START STOP UNIT timeout")

Did that commit (shown below) actually increase the timeout
because the previous commit (8f2c96420c6e) had put
"remaining / HZ" when it should have been just "remaining"?
Or am I misreading?

So maybe it also needs a fixes tag for 8f2c96420c6e.

commit dcd5b7637c6d442d957f73780a03047413ed3a10
Author: Bart Van Assche <bvanassche@acm.org>
Date:   Tue Oct 18 13:29:54 2022 -0700

    scsi: ufs: Reduce the START STOP UNIT timeout
    
    Reduce the START STOP UNIT command timeout to one second since on Android
    devices a kernel panic is triggered if an attempt to suspend the system
    takes more than 20 seconds. One second should be enough for the START STOP
    UNIT command since this command completes in less than a millisecond for
    the UFS devices I have access to.
    
    Signed-off-by: Bart Van Assche <bvanassche@acm.org>
    Link: https://lore.kernel.org/r/20221018202958.1902564-7-bvanassche@acm.org
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index db1997e99da2..f83a0045a129 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8746,8 +8746,6 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	struct scsi_device *sdp;
 	unsigned long flags;
 	int ret, retries;
-	unsigned long deadline;
-	int32_t remaining;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	sdp = hba->ufs_device_wlun;
@@ -8775,14 +8773,9 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
 	 * already suspended childs.
 	 */
-	deadline = jiffies + 10 * HZ;
 	for (retries = 3; retries > 0; --retries) {
-		ret = -ETIMEDOUT;
-		remaining = deadline - jiffies;
-		if (remaining <= 0)
-			break;
 		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-				   remaining / HZ, 0, 0, RQF_PM, NULL);
+				   HZ, 0, 0, RQF_PM, NULL);
 		if (!scsi_status_is_check_condition(ret) ||
 				!scsi_sense_valid(&sshdr) ||
 				sshdr.sense_key != UNIT_ATTENTION)



> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 03c47f9a2750..8363a1667feb 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -9181,7 +9181,8 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
>  	};
>  
>  	return scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, /*buffer=*/NULL,
> -			/*bufflen=*/0, /*timeout=*/HZ, /*retries=*/0, &args);
> +			/*bufflen=*/0, /*timeout=*/10 * HZ, /*retries=*/0,
> +			&args);
>  }
>  
>  /**

