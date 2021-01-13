Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62767C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 14:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B8AA20658
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 14:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbhAMOyQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 09:54:16 -0500
Received: from mga07.intel.com ([134.134.136.100]:53443 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727041AbhAMOyP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Jan 2021 09:54:15 -0500
IronPort-SDR: fxRouFCrlRLTzqU1GvSXi2yReE8qK38AfldbKQIMpA0HxbTellqNgBdV2o44Gbo1JRAi7oMKRI
 eu2djEfgh/cw==
X-IronPort-AV: E=McAfee;i="6000,8403,9862"; a="242288236"
X-IronPort-AV: E=Sophos;i="5.79,344,1602572400"; 
   d="scan'208";a="242288236"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2021 06:53:34 -0800
IronPort-SDR: HzcL5yAEpBEgCs+I1a3Zyi5Mnl2vl1gGIreeiUkOSjuip/oBB8/sf2Kxd+FjwuXfwLRcW93BGq
 vCRseHr1fwrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,344,1602572400"; 
   d="scan'208";a="464925238"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.149]) ([10.237.72.149])
  by fmsmga001.fm.intel.com with ESMTP; 13 Jan 2021 06:53:29 -0800
Subject: Re: [PATCH v4 2/2] scsi: ufs: Protect PM ops and err_handler from
 user access through sysfs
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
References: <1610546230-14732-1-git-send-email-cang@codeaurora.org>
 <1610546230-14732-3-git-send-email-cang@codeaurora.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <b32a2064-4ff9-509c-cdaf-434264837917@intel.com>
Date:   Wed, 13 Jan 2021 16:53:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1610546230-14732-3-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/01/21 3:57 pm, Can Guo wrote:
> User layer may access sysfs nodes when system PM ops or error handling
> is running, which can cause various problems. Rename eh_sem to host_sem
> and use it to protect PM ops and error handling from user layer intervene.
> 
> Acked-by: Avri Altman <avri.altman@wdc.com>
> Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufs-sysfs.c | 106 ++++++++++++++++++++++++++++++++++++-------
>  drivers/scsi/ufs/ufshcd.c    |  42 ++++++++++-------
>  drivers/scsi/ufs/ufshcd.h    |  10 +++-
>  3 files changed, 125 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
> index 0e14384..7cafffc 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -154,18 +154,29 @@ static ssize_t auto_hibern8_show(struct device *dev,
>  				 struct device_attribute *attr, char *buf)
>  {
>  	u32 ahit;
> +	int ret;
>  	struct ufs_hba *hba = dev_get_drvdata(dev);
>  
>  	if (!ufshcd_is_auto_hibern8_supported(hba))
>  		return -EOPNOTSUPP;
>  
> +	down(&hba->host_sem);
> +	if (!ufshcd_is_sysfs_allowed(hba)) {

I expect debugfs has the same potential problem, so maybe
ufshcd_is_sysfs_allowed() is not quite the right name.

> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
