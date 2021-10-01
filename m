Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F136FC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 17:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D48E661AED
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 17:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355288AbhJAR0r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Oct 2021 13:26:47 -0400
Received: from mga17.intel.com ([192.55.52.151]:2744 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353235AbhJAR0q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 Oct 2021 13:26:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10124"; a="205660415"
X-IronPort-AV: E=Sophos;i="5.85,339,1624345200"; 
   d="scan'208";a="205660415"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 10:25:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,339,1624345200"; 
   d="scan'208";a="540397479"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by fmsmga004.fm.intel.com with ESMTP; 01 Oct 2021 10:25:00 -0700
Subject: Re: [PATCH 2/2] scsi: ufs: Stop clearing unit attentions
To:     Bart Van Assche <bvanassche@acm.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     Bart Van Assche <bvanassche@google.com>
References: <20210930195237.1521436-1-jaegeuk@kernel.org>
 <20210930195237.1521436-2-jaegeuk@kernel.org>
 <12ba3462-ac6b-ef35-4b5e-e0de6086ab51@intel.com>
 <f2436720-16d5-58da-abcc-20fa1ed01fb9@intel.com>
 <5e087a0f-7ae0-41d1-c1f1-e5cc0ad2d38f@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <f7384200-ea7d-a418-3793-98083c6b425f@intel.com>
Date:   Fri, 1 Oct 2021 20:24:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <5e087a0f-7ae0-41d1-c1f1-e5cc0ad2d38f@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/10/2021 19:59, Bart Van Assche wrote:
> On 9/30/21 11:52 PM, Adrian Hunter wrote:
>> Finally, there is another thing to change.  The reason
>> ufshcd_suspend_prepare() does a runtime resume of sdev_rpmb is because the
>> UAC clear would wait for an async runtime resume, which will never happen
>> during system suspend because the PM workqueue gets frozen.  So with the
>> removal of UAC clear, ufshcd_suspend_prepare() and ufshcd_resume_complete()
>> should be updated also, to leave rpmb alone.
> 
> Is the following change what you have in mind?

Yes, exactly.

> 
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 0a28cc4c09d8..0743f54e55f9 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -9648,10 +9648,6 @@ void ufshcd_resume_complete(struct device *dev)
>          ufshcd_rpm_put(hba);
>          hba->complete_put = false;
>      }
> -    if (hba->rpmb_complete_put) {
> -        ufshcd_rpmb_rpm_put(hba);
> -        hba->rpmb_complete_put = false;
> -    }
>  }
>  EXPORT_SYMBOL_GPL(ufshcd_resume_complete);
> 
> @@ -9674,10 +9670,6 @@ int ufshcd_suspend_prepare(struct device *dev)
>          }
>          hba->complete_put = true;
>      }
> -    if (hba->sdev_rpmb) {
> -        ufshcd_rpmb_rpm_get_sync(hba);
> -        hba->rpmb_complete_put = true;
> -    }
>      return 0;
>  }
>  EXPORT_SYMBOL_GPL(ufshcd_suspend_prepare);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 86b615023ecb..5ecfcd8cae0a 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -921,7 +921,6 @@ struct ufs_hba {
>  #endif
>      u32 luns_avail;
>      bool complete_put;
> -    bool rpmb_complete_put;
>  };
> 
>  /* Returns true if clocks can be gated. Otherwise false */
> 
> 
> 
> Thanks,
> 
> Bart.

