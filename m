Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB601C43219
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 12:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C830661A04
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 12:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349489AbhI3MrA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 08:47:00 -0400
Received: from mga03.intel.com ([134.134.136.65]:31650 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351044AbhI3Mq6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 08:46:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10122"; a="225253671"
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="225253671"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 05:45:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="479880484"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by fmsmga007.fm.intel.com with ESMTP; 30 Sep 2021 05:44:57 -0700
Subject: Re: [PATCH V5 1/3] scsi: ufs: Fix error handler clear ua deadlock
To:     Kiwoong Kim <kwmad.kim@samsung.com>
Cc:     alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        avri.altman@wdc.com, bvanassche@acm.org, cang@codeaurora.org,
        huobean@gmail.com, jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        liwei213@huawei.com, manivannan.sadhasivam@linaro.org,
        martin.petersen@oracle.com
References: <20210922093842.18025-2-adrian.hunter@intel.com>
 <CGME20210928071133epcas2p28e00e20bbebbb5c1920933204f91743b@epcas2p2.samsung.com>
 <1632812120-27857-1-git-send-email-kwmad.kim@samsung.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <1f66d232-0e15-c546-ac03-c56a291e33b8@intel.com>
Date:   Thu, 30 Sep 2021 15:44:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1632812120-27857-1-git-send-email-kwmad.kim@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/09/2021 09:55, Kiwoong Kim wrote:
>> +static int ufshcd_request_sense_direct(struct ufs_hba *hba, u8 wlun)
> ..
> 
> How about using ufshcd_compose_dev_cmd w/ modifying the function,
> ufshcd_prepare_utp_scsi_cmd_upiu and something ? I think it can be made
> w/ small changes. And for prdt, it seems to be good because it's tiny.
> 

I have done that in V6
