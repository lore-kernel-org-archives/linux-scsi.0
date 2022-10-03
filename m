Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34244C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 05:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiJCFzj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 01:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiJCFzh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 01:55:37 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C7C303CB
        for <linux-scsi@vger.kernel.org>; Sun,  2 Oct 2022 22:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664776536; x=1696312536;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qMUA6d2T7OCeLOCDpB0wjt0iWmgr3V0/ElC4fIFSGoU=;
  b=LIkY/jxLvfJSlMQfNX42tgRep3ftohEXidnTAj6/3CCYNaQCeTPmfit2
   kxnVqvUuHR5wPFw/v42sdI7fc/wkREpKujeEJVf5Jv0mR0jyv2BtCrP63
   XRabq8GHFZJqKoMhjHii9BANHCmxZwm3v/rrxHnTEr+c6CNgNCVvB/6rm
   iJq29Ky66q9wMR5PVF//oosLLnleKtqy/jITauWmPKduKznFohF4zt+X2
   GjHnsSEH+tvQ8RdFGSH75CMEUrOo+f9RdDGFfvR3PGHxw7N0RQLNd+fw4
   tJZGkPbT3IahXQWayYmcgSLl9aWsGBO3XnqpYXpUoqj7mZLyDZzfvsyoF
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="364399515"
X-IronPort-AV: E=Sophos;i="5.93,364,1654585200"; 
   d="scan'208";a="364399515"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2022 22:55:36 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="623412580"
X-IronPort-AV: E=Sophos;i="5.93,364,1654585200"; 
   d="scan'208";a="623412580"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.60.77])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2022 22:55:33 -0700
Message-ID: <2cbccba8-1616-3d64-f148-1a0b891431f7@intel.com>
Date:   Mon, 3 Oct 2022 08:55:30 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v3 4/8] scsi: ufs: Remove an outdated comment
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20220929220021.247097-1-bvanassche@acm.org>
 <20220929220021.247097-5-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20220929220021.247097-5-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30/09/22 01:00, Bart Van Assche wrote:
> Although the host lock had to be held by ufshcd_clk_scaling_start_busy()
> callers when that function was introduced, that is no longer the case
> today. Hence remove the comment that claims that callers of this function
> must hold the host lock.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/ufs/core/ufshcd.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 7c15cbc737b4..78c980585dc3 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2013,7 +2013,6 @@ static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
>  	destroy_workqueue(hba->clk_gating.clk_gating_workq);
>  }
>  
> -/* Must be called with host lock acquired */
>  static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
>  {
>  	bool queue_resume_work = false;

