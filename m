Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EBD8C05027
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Feb 2023 07:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbjBBHwx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Feb 2023 02:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjBBHww (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2023 02:52:52 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB2644BF
        for <linux-scsi@vger.kernel.org>; Wed,  1 Feb 2023 23:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675324372; x=1706860372;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=i6+tP3D2TGh98JXO5uh77wrONpOtCnLHYBRLM/nCq9A=;
  b=j81hSPwYCkcSQ3Z6kCvgHhxZWU8e+tTUOuz6zyGR0D6Goko3ObDCKVti
   OzJo5iYG0J9m8sQnjyoTc0u0DmOARNmK3q1M4V3PeggeYWO50M0EhsgR4
   0fllKlyI4B7GAJZ+wCtTuZ4oM07nYY1xIT5bDO+ncSZUEDXv3FlXHMQy4
   AlOqV4PIAYYxLLwW4iOuChlf77OORK9mzpfrNFu6zL8yP0Dpla413rQhq
   9Vt0sPDgNuYzpBJT8vv1nLlblzBGPAVT08mPzIqzESbS0LH5Iau5Pn8eR
   YewNm6FmxDSuFCumPZxgO6Uvsy1N3qMOVAb3ZFgvNnOpHYD9zb7kjJs5O
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="329672120"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="329672120"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 23:52:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="807881057"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="807881057"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.60.179])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 23:52:48 -0800
Message-ID: <fdbaf66c-b04b-2477-e778-6f6f054f0db2@intel.com>
Date:   Thu, 2 Feb 2023 09:52:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.7.1
Subject: Re: [PATCH 2/2] scsi: ufs: Use SYNCHRONIZE CACHE instead of FUA
To:     Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20230201180637.2102556-1-bvanassche@acm.org>
 <20230201180637.2102556-3-bvanassche@acm.org>
Content-Language: en-US
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20230201180637.2102556-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/02/23 20:06, Bart Van Assche wrote:
> From: Asutosh Das <asutoshd@codeaurora.org>
> 
> UFS devices perform better when using SYNCHRONIZE CACHE command
> instead of the FUA flag. Hence this patch.

Hi

It would be nice to get some clarification on what is
going on for this case.

This includes with Data Reliability enabled?

In theory, WRITE+FUA should be at least as fast as
WRITE+SYNCHRONIZE CACHE, right?

Do we have any explanation for why that would not
be true?

In particular, is SYNCHRONIZE CACHE faster because
it is not, in fact, providing Reliable Writes?

> 
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> [ bvanassche: modified a source code comment ]
> ---
>  drivers/ufs/core/ufshcd.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index bf3cb12ef02f..461aa51cfccc 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5056,6 +5056,9 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
>  	/* WRITE_SAME command is not supported */
>  	sdev->no_write_same = 1;
>  
> +	/* Use SYNCHRONIZE CACHE instead of FUA to improve performance */
> +	sdev->sdev_bflags = BLIST_BROKEN_FUA;
> +
>  	ufshcd_lu_init(hba, sdev);
>  
>  	ufshcd_setup_links(hba, sdev);

