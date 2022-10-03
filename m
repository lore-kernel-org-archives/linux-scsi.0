Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14AF4C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 05:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiJCF6O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 01:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiJCF6M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 01:58:12 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9DC3C150
        for <linux-scsi@vger.kernel.org>; Sun,  2 Oct 2022 22:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664776691; x=1696312691;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6b8sQM3CFmeU8M5pNrichAjgKEaGCvz4f9IKXrlkSDY=;
  b=N+Sd79MoX5j+zzKsvIHS/rnkebjjp44tTexKiWomaYlYRzZ7p9orD6IU
   W2774YjE3oHe5ZRl6FCaBuV6xjK0SIpJ4RTEwkpF+cJrEyg0nn9zfHBgM
   4ayi36KLxWUMeuWNLMWgXI4C5mFYD8mlnSkpNSCUo6HC/M3UvSD4AOt6g
   aDoV8uwdHnoZEhJ/zbsYnHoJLvaXhO5Ushop16lOdr/ofyThMBX+YAvhT
   1mU91easgPDeujcFv5TQTT9TwsRRiTM+20FGkUbk+yOT3ECXfSJN3J2fh
   8xv4Khkc0IvJ/nrML2QYO1ZBHgrnBvkvTo0yqL/gKLtyUavA/vhCGfeyA
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="304043459"
X-IronPort-AV: E=Sophos;i="5.93,364,1654585200"; 
   d="scan'208";a="304043459"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2022 22:58:11 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="765792704"
X-IronPort-AV: E=Sophos;i="5.93,364,1654585200"; 
   d="scan'208";a="765792704"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.60.77])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2022 22:58:08 -0700
Message-ID: <a163edd8-e1d7-6985-6c2e-1426a1742df8@intel.com>
Date:   Mon, 3 Oct 2022 08:58:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v3 5/8] scsi: ufs: Use 'else' in ufshcd_set_dev_pwr_mode()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20220929220021.247097-1-bvanassche@acm.org>
 <20220929220021.247097-6-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20220929220021.247097-6-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30/09/22 01:00, Bart Van Assche wrote:
> Convert if (ret) { ... } if (!ret) { ... } into
> if (ret) { ... } else { ... }.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/ufs/core/ufshcd.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 78c980585dc3..02e73208b921 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8798,10 +8798,9 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
>  				scsi_print_sense_hdr(sdp, NULL, &sshdr);
>  			ret = -EIO;
>  		}
> -	}
> -
> -	if (!ret)
> +	} else {
>  		hba->curr_dev_pwr_mode = pwr_mode;
> +	}
>  
>  	scsi_device_put(sdp);
>  	hba->host->eh_noresume = 0;

