Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84061C43381
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51F3664F1D
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581352AbhCBSug (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:50:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:56672 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376850AbhCBIPk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Mar 2021 03:15:40 -0500
IronPort-SDR: 5w1DZeJlsOW4YQb8Xmwz9ydz0LtQsmy4nsvooLC9e2M8jef5Pmt2km0u3o3HP+vjXUnn4HjKut
 WgrTaRT0Wp+w==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="173868697"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="173868697"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 00:14:32 -0800
IronPort-SDR: 2GxtmNGV3uMj/YVMpE11TbS3n2Qx84HRH7u3pRZAvxX6XDZ78+pJ/srDjbaB5GO/NzPUgL49WD
 wrBQ7v3YzCgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="585812058"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by orsmga005.jf.intel.com with ESMTP; 02 Mar 2021 00:14:29 -0800
Subject: Re: [PATCH] scsi: ufs: Fix incorrect ufshcd_state after
 ufshcd_reset_and_restore()
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
References: <20210301191940.15247-1-adrian.hunter@intel.com>
 <DM6PR04MB65753E738C556F035A56F77CFC999@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <5fe97f16-406c-c279-b108-d27bb2769ed6@intel.com>
Date:   Tue, 2 Mar 2021 10:14:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB65753E738C556F035A56F77CFC999@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/03/21 9:01 am, Avri Altman wrote:
>  
>> If ufshcd_probe_hba() fails it sets ufshcd_state to UFSHCD_STATE_ERROR,
>> however, if it is called again, as it is within a loop in
>> ufshcd_reset_and_restore(), and succeeds, then it will not set the state
>> back to UFSHCD_STATE_OPERATIONAL unless the state was
>> UFSHCD_STATE_RESET.
>>
>> That can result in the state being UFSHCD_STATE_ERROR even though
>> ufshcd_reset_and_restore() is successful and returns zero.
>>
>> Fix by initializing the state to UFSHCD_STATE_RESET in the start of each
>> loop in ufshcd_reset_and_restore().  If there is an error,
>> ufshcd_reset_and_restore() will change the state to UFSHCD_STATE_ERROR,
>> otherwise ufshcd_probe_hba() will have set the state appropriately.
>>
>> Fixes: 4db7a2360597 ("scsi: ufs: Fix concurrency of error handler and other
>> error recovery paths")
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> I think that CanG recent series addressed that issue as well, can you take a look?
> https://lore.kernel.org/lkml/1614145010-36079-2-git-send-email-cang@codeaurora.org/

Yes, there it is mixed in with other changes.  However it is probably better
as a separate patch.  Can Guo, what do you think?

> 
> 
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 77161750c9fb..91a403afe038 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -7031,6 +7031,8 @@ static int ufshcd_reset_and_restore(struct ufs_hba
>> *hba)
>>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>>
>>         do {
>> +               hba->ufshcd_state = UFSHCD_STATE_RESET;
>> +
>>                 /* Reset the attached device */
>>                 ufshcd_device_reset(hba);
>>
>> --
>> 2.17.1
> 

