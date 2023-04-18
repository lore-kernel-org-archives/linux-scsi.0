Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AABF1C77B75
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 07:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbjDRHaf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 03:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjDRHad (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 03:30:33 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFB240D5
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 00:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681803029; x=1713339029;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nEpuEFJCSItlIZj86fTEnNc3HiNARjEBUxKSBEDC7Gs=;
  b=ZJ2hWDEyx80zHzUi5yGOlL9gNmLDYLAAjlHOTHEJ1tFDTb/X72F0ilbS
   AyoMGhzMqKrkvUtCLHSk+o9mpwkYnV3LjT8tyFJKKg1vNEmWltk4sFwi7
   8YHF5UmJDZP0wlxhMnN4T2zUBNIAMMfpVmzkHkuGmsJubcFfm/CtoyxDL
   Y9109yznjW7ViiIsT0GVN80M19Ao+MQSegCkdxgfsoldN1sCZ2WlF+7p8
   Qpt81BZm5nmAi9vAi/Q551pq5cKqZkTd+pJyXDch+yR9KvI3VpAqoGtA+
   P5bnyQw32z32bKn00zOCbA/Vq+5/9byRkafdQjVAdh/LoRedPntnFVxZf
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="407996965"
X-IronPort-AV: E=Sophos;i="5.99,206,1677571200"; 
   d="scan'208";a="407996965"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 00:30:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="815101708"
X-IronPort-AV: E=Sophos;i="5.99,206,1677571200"; 
   d="scan'208";a="815101708"
Received: from choiwony-mobl.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.32.90])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 00:30:16 -0700
Message-ID: <7caf7c60-40b6-4aef-63f1-e5598ebbd7f6@intel.com>
Date:   Tue, 18 Apr 2023 10:30:12 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH v2 3/4] scsi: ufs: Increase the START STOP UNIT timeout
 from one to ten seconds
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@google.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
References: <20230417230656.523826-1-bvanassche@acm.org>
 <20230417230656.523826-4-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20230417230656.523826-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/04/23 02:06, Bart Van Assche wrote:
> One UFS vendor asked to increase the UFS timeout from 1 s to 3 s.
> Another UFS vendor asked to increase the UFS timeout from 1 s to 10 s.
> Hence this patch that increases the UFS timeout to 10 s. This patch can
> cause the total timeout to exceed 20 s, the Android shutdown timeout.
> This is fine since the loop around ufshcd_execute_start_stop() exists to
> deal with unit attentions and because unit attentions are reported
> quickly.
> 
> Fixes: dcd5b7637c6d ("scsi: ufs: Reduce the START STOP UNIT timeout")
> Fixes: 8f2c96420c6e ("scsi: ufs: core: Reduce the power mode change timeout")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/ufs/core/ufshcd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 784787cf08c3..6831eb1afc30 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -9182,7 +9182,8 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
>  	};
>  
>  	return scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, /*buffer=*/NULL,
> -			/*bufflen=*/0, /*timeout=*/HZ, /*retries=*/0, &args);
> +			/*bufflen=*/0, /*timeout=*/10 * HZ, /*retries=*/0,
> +			&args);
>  }
>  
>  /**

