Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA6A6C77B73
	for <linux-scsi@archiver.kernel.org>; Tue, 30 May 2023 09:48:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjE3JsV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 May 2023 05:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbjE3JsU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 May 2023 05:48:20 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D8DF9
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2023 02:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685440098; x=1716976098;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mYxzCwavp+2UVrbEVFAooXmSp3Wz//xLzYAx3rdKIwg=;
  b=crDucUCjUL8r/ElsLyXy1yQdje9Wpvf2uEoDrbB44pqzmBKtdaPWiV1z
   sU3zPtUwJMh2phO3z5dc9KtXLTrWC9DiKkyddsxI4PKLmLg4lCXR5N9Ji
   MDAs9HlCaPISgeh78U7M6josSYCX6G20d5p1HihV90zizfuAByVEhf6vb
   KHIDOvcwL9l6Bj8YFH6Gx2YLwxjGdZto2cHna0OigkrDhdh/CstcdoMvE
   Y2+Mz5qukkOxXtthEFlqv9gWUQuO2nxyiD+HWM23rL9ONyPfn/GxQUi00
   ng90fVBOQD3M/5cyD8GlbVBzTcuzNFlGZIJFUeaA2lh3JXvOIwZfOQj5G
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="418351501"
X-IronPort-AV: E=Sophos;i="6.00,203,1681196400"; 
   d="scan'208";a="418351501"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 02:48:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="739451724"
X-IronPort-AV: E=Sophos;i="6.00,203,1681196400"; 
   d="scan'208";a="739451724"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.46.19])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 02:48:13 -0700
Message-ID: <0130e6e7-bf86-eae0-ac25-3755798a5703@intel.com>
Date:   Tue, 30 May 2023 12:48:08 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
Subject: Re: [PATCH v4 4/5] scsi: ufs: Declare ufshcd_{hold,release}() once
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Avri Altman <avri.altman@wdc.com>
References: <20230529202640.11883-1-bvanassche@acm.org>
 <20230529202640.11883-5-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20230529202640.11883-5-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 29/05/23 23:26, Bart Van Assche wrote:
> ufshcd_hold() and ufshcd_release are declared twice: once in
> drivers/ufs/core/ufshcd-priv.h and a second time in include/ufs/ufshcd.h.
> Remove the declarations from ufshcd-priv.h.
> 
> Fixes: dd11376b9f1b ("scsi: ufs: Split the drivers/scsi/ufs directory")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/ufs/core/ufshcd-priv.h | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
> index d53b93c21a0c..8f58c2169398 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -84,9 +84,6 @@ unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
>  int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
>  			    u8 **buf, bool ascii);
>  
> -int ufshcd_hold(struct ufs_hba *hba, bool async);
> -void ufshcd_release(struct ufs_hba *hba);
> -
>  int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd);
>  
>  int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,

