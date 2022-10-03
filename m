Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51BC9C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 06:10:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiJCGKS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 02:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiJCGKO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 02:10:14 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD281928F
        for <linux-scsi@vger.kernel.org>; Sun,  2 Oct 2022 23:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664777411; x=1696313411;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=g4L1sKMdhkdkr9gkBQQqYNY7a9xVcG7sfRSNMJ5Oh+Y=;
  b=VJrzdK8/y+HaWxhA6LMWoZXcL43/obMVZX/LVLm4XzYdxB9nKUcExQfW
   2I3S3k6gYqHVETx0WTqgFphDiT0TbbyXUCyoQjrVs0EsKgp5xVcUciL9j
   x0fP34C07ZREPgPa5d74LmRR92VUjmYR6gZ/QgQLRuRTeVQFFRn/ffBn2
   IEEOJVz4pq6iIQ/3tNrc1JgZ++UnUDDUYMz3lazzsNar2DvnesaQtE7Ff
   zXU+rjvV0wWZmLeklXO8Or8Ww+oseWmOnamDG2PviF0K0MB8S9kE358iG
   pej4Vtdk6emiDeM22bzV1/UGPOYYnxH3NcG8y0nZVzqPWyW14LGYHxojD
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="304045304"
X-IronPort-AV: E=Sophos;i="5.93,364,1654585200"; 
   d="scan'208";a="304045304"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2022 23:10:11 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="618621651"
X-IronPort-AV: E=Sophos;i="5.93,364,1654585200"; 
   d="scan'208";a="618621651"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.60.77])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2022 23:10:08 -0700
Message-ID: <1ebd2cff-d73b-2d6d-ec93-80133f93e57c@intel.com>
Date:   Mon, 3 Oct 2022 09:10:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v3 6/8] scsi: ufs: Try harder to change the power mode
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20220929220021.247097-1-bvanassche@acm.org>
 <20220929220021.247097-7-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20220929220021.247097-7-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30/09/22 01:00, Bart Van Assche wrote:
> Instead of only retrying the START STOP UNIT command if a unit attention
> is reported, repeat it if any SCSI error is reported by the device or if
> the command timed out.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 02e73208b921..e8c0504e9e83 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8784,9 +8784,9 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
>  	for (retries = 3; retries > 0; --retries) {
>  		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
>  				START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
> -		if (!scsi_status_is_check_condition(ret) ||
> -				!scsi_sense_valid(&sshdr) ||
> -				sshdr.sense_key != UNIT_ATTENTION)
> +		if (ret < 0)
> +			break;

Could use a comment to answer: why not retry if ret < 0 ?

> +		if (host_byte(ret) == 0 && scsi_status_is_good(ret))
>  			break;

Also could use a comment: why not just "if (!ret)" ?

>  	}
>  	if (ret) {

