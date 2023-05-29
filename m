Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CBB8C77B7E
	for <linux-scsi@archiver.kernel.org>; Mon, 29 May 2023 06:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjE2Gvd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 May 2023 02:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbjE2Gvc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2023 02:51:32 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA71AF
        for <linux-scsi@vger.kernel.org>; Sun, 28 May 2023 23:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685343090; x=1716879090;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HgLxPbUZFljPYS9SY4TIjCMVyCgWizBvXy0jkrXetjc=;
  b=U8oG2hBWZtRCJ2zHA+AkMC4Whh0uDw3Lnbg432RxFLZbCxwBJnsElCxJ
   zot2FFVBoMQwd1Xuoa9j2NKMGvS3oAnArDeMossfY2gdtRpM8V9Eeg6g7
   0OyEvlcLZbUtf53E4T3BZvk12KAUyKVm+vnkLl071qyVj7ZiMHcWpm9Wy
   OhIZhgxL2YkQLvFEI93rp9fNNB1mXgdbVc7C6DnwsPVEyXitNMdQuzpLn
   Cwe+QPk4xwtIXn4XdNqvyzL9NHWHr4GACn7IPXZ4qAqTspn6ZSO571BX1
   ZYiIQroQ8FEmioYzFaNdTyh2LledDbJo9amLdqkVpGO63yF3yAaddtNK9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="339223131"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="339223131"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 23:51:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="705946140"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="705946140"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.251.208.110])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 23:51:24 -0700
Message-ID: <b2d59318-1e83-ec68-bdfa-653ad862320a@intel.com>
Date:   Mon, 29 May 2023 09:51:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
Subject: Re: [PATCH v3 3/4] scsi: ufs: Conditionally enable the
 BLK_MQ_F_BLOCKING flag
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Adrien Thierry <athierry@redhat.com>
References: <20230526173007.1627017-1-bvanassche@acm.org>
 <20230526173007.1627017-4-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20230526173007.1627017-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 26/05/23 20:29, Bart Van Assche wrote:
> Prepare for adding code in ufshcd_queuecommand() that may sleep.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/ufs/core/ufshcd.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index abe9a430cc37..c2d9109102f3 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10187,6 +10187,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>  	host->max_channel = UFSHCD_MAX_CHANNEL;
>  	host->unique_id = host->host_no;
>  	host->max_cmd_len = UFS_CDB_SIZE;
> +	host->queuecommand_may_block = !!(hba->caps & UFSHCD_CAP_CLK_GATING);
>  
>  	hba->max_pwr_info.is_valid = false;
>  

