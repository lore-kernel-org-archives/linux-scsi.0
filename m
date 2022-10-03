Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D46D8C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 06:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiJCG2q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 02:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiJCG2o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 02:28:44 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D03F3DF1B
        for <linux-scsi@vger.kernel.org>; Sun,  2 Oct 2022 23:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664778524; x=1696314524;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qpw1DZhj2Bx90xCWUkN9iEIaqXwrK5wfIB34/UqmX3k=;
  b=OLynHriFwmjF+VSFw7EAEgiqSeWCPdUSna2KrJQ704fvMuAnOrAnVwMF
   PzjtZCFQO0pVeIGW/mV3r5UnjqA9ZRwEE+sYhWM2sZZHjfsNZUxrcj1bT
   aKfptmiQMgv7qocdfcTOqyG6GwaQmYPKUfH0t+rSQksgeFv4BGjlqV9a+
   CgZ8QgF7/ujxm0KQsN5DWJQ6bWM6PC4ZfXc4taG0wm596EvDAKIngYXh3
   24fSFB2wNMT2XAU5tl1uNnmTJnOgIL7Wdou/KK7cO9I7gdQFYTshHTPao
   sCnNCrlJn65mTQAaQpzU91AfTrKup0AYidXX+13+vkA8B81MQRqgzyGvp
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="303465633"
X-IronPort-AV: E=Sophos;i="5.93,364,1654585200"; 
   d="scan'208";a="303465633"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2022 23:28:37 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="952226897"
X-IronPort-AV: E=Sophos;i="5.93,364,1654585200"; 
   d="scan'208";a="952226897"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.60.77])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2022 23:28:34 -0700
Message-ID: <eb9eae96-f9fc-2c5b-4caf-6b5efc00d931@intel.com>
Date:   Mon, 3 Oct 2022 09:28:32 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v6 6/8] scsi: ufs: Simplify ufshcd_set_dev_pwr_mode()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20220929224421.587465-1-bvanassche@acm.org>
 <20220929224421.587465-7-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20220929224421.587465-7-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30/09/22 01:44, Bart Van Assche wrote:
> Simplify the code for incrementing the SCSI device reference count in
> ufshcd_set_dev_pwr_mode(). This patch removes one scsi_device_put() call
> that happens from atomic context.
> 
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Not sure what patch set "v6 6/8" refers to, nevertheless:

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/ufs/core/ufshcd.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 7c15cbc737b4..6e61372fe027 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8753,15 +8753,10 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
>  
>  	spin_lock_irqsave(hba->host->host_lock, flags);
>  	sdp = hba->ufs_device_wlun;
> -	if (sdp) {
> +	if (sdp && scsi_device_online(sdp))
>  		ret = scsi_device_get(sdp);
> -		if (!ret && !scsi_device_online(sdp)) {
> -			ret = -ENODEV;
> -			scsi_device_put(sdp);
> -		}
> -	} else {
> +	else
>  		ret = -ENODEV;
> -	}
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
>  
>  	if (ret)

