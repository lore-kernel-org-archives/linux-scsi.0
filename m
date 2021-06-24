Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EAC2C48BDF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 11:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10BC0613C7
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 11:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhFXLsF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 07:48:05 -0400
Received: from mga07.intel.com ([134.134.136.100]:59479 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhFXLsE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Jun 2021 07:48:04 -0400
IronPort-SDR: DtRH+tJHV728X3wNWWua2nCcDwUAEh4oWKa9mTUhcxPo1WpxcpfyHRHzrXBvt8KWsyccacUd0D
 +GxT8dohxckA==
X-IronPort-AV: E=McAfee;i="6200,9189,10024"; a="271299477"
X-IronPort-AV: E=Sophos;i="5.83,296,1616482800"; 
   d="scan'208";a="271299477"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2021 04:45:45 -0700
IronPort-SDR: G/x/Aj4ZfK6zrckJse1ZzlSVn5Arrtq/Y3Huf2aZZ5c3UOL8GRzgC/ju8hgpINp0HQ4cADtBjo
 bc6+VzipzOMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,296,1616482800"; 
   d="scan'208";a="406617865"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.79]) ([10.237.72.79])
  by orsmga006.jf.intel.com with ESMTP; 24 Jun 2021 04:45:40 -0700
Subject: Re: [PATCH] scsi: ufs: Refactor ufshcd_is_intr_aggr_allowed()
To:     keosung.park@samsung.com, "joe@perches.com" <joe@perches.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "satyat@google.com" <satyat@google.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joao Pinto <jpinto@synopsys.com>,
        Pedro Sousa <sousa@synopsys.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>
References: <42c2978f-f0ca-3efb-7762-cac813a0a5fe@intel.com>
 <ed6d8c44-295e-aaa7-4b5f-7929c1c797d1@intel.com>
 <1891546521.01624267081897.JavaMail.epsvc@epcpadp4>
 <37380050.31624517282371.JavaMail.epsvc@epcpadp4>
 <CGME20210621085158epcms2p46170ba48174547df00b9720dbc843110@epcms2p1>
 <1891546521.01624533302400.JavaMail.epsvc@epcpadp3>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <abd587ed-6666-34b8-b545-8ea97bcf0515@intel.com>
Date:   Thu, 24 Jun 2021 14:46:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1891546521.01624533302400.JavaMail.epsvc@epcpadp3>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/06/21 1:44 pm, Keoseong Park wrote:
>> On 24/06/21 9:41 am, Keoseong Park wrote:
>>>> On 21/06/21 11:51 am, Keoseong Park wrote:
>>>>> Change conditional compilation to IS_ENABLED macro,
>>>>> and simplify if else statement to return statement.
>>>>> No functional change.
>>>>>
>>>>> Signed-off-by: Keoseong Park <keosung.park@samsung.com>
>>>>> ---
>>>>>  drivers/scsi/ufs/ufshcd.h | 17 ++++++++---------
>>>>>  1 file changed, 8 insertions(+), 9 deletions(-)
>>>>>
>>>>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>>>>> index c98d540ac044..6d239a855753 100644
>>>>> --- a/drivers/scsi/ufs/ufshcd.h
>>>>> +++ b/drivers/scsi/ufs/ufshcd.h
>>>>> @@ -893,16 +893,15 @@ static inline bool ufshcd_is_rpm_autosuspend_allowed(struct ufs_hba *hba)
>>>>>  
>>>>>  static inline bool ufshcd_is_intr_aggr_allowed(struct ufs_hba *hba)
>>>>>  {
>>>>> -/* DWC UFS Core has the Interrupt aggregation feature but is not detectable*/
>>>>> -#ifndef CONFIG_SCSI_UFS_DWC
>>>>> -	if ((hba->caps & UFSHCD_CAP_INTR_AGGR) &&
>>>>> -	    !(hba->quirks & UFSHCD_QUIRK_BROKEN_INTR_AGGR))
>>>>> +	/*
>>>>> +	 * DWC UFS Core has the Interrupt aggregation feature
>>>>> +	 * but is not detectable.
>>>>> +	 */
>>>>> +	if (IS_ENABLED(CONFIG_SCSI_UFS_DWC))
>>>>
>>>> Why is this needed?  It seems like you could just set UFSHCD_CAP_INTR_AGGR
>>>> and clear UFSHCD_QUIRK_BROKEN_INTR_AGGR instead?
>>>
>>> Hello Adrian,
>>> Sorry for late reply.
>>>
>>> The code that returns true when CONFIG_SCSI_UFS_DWC is set in the original code 
>>> is only changed using the IS_ENABLED macro.
>>> (Linux kernel coding style, 21) Conditional Compilation)
>>>
>>> When CONFIG_SCSI_UFS_DWC is not defined, the code for checking quirk 
>>> and caps has been moved to the newly added return statement below.
>>
>> Looking closer I cannot find CONFIG_SCSI_UFS_DWC at all.  It seems like it
>> never existed.
>>
>> Why should we not remove the code related to CONFIG_SCSI_UFS_DWC entirely?
> 
> You're right. What do you think of deleting the code related to CONFIG_SCSI_UFS_DWC 
> and changing it to the patch below?

Yes, but cc Joao Pinto <jpinto@synopsys.com> who introduced the code

> 
> ---
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index c98d540ac044..c9faca237290 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -893,16 +893,8 @@ static inline bool ufshcd_is_rpm_autosuspend_allowed(struct ufs_hba *hba)
> 
>  static inline bool ufshcd_is_intr_aggr_allowed(struct ufs_hba *hba)
>  {
> -/* DWC UFS Core has the Interrupt aggregation feature but is not detectable*/
> -#ifndef CONFIG_SCSI_UFS_DWC
> -       if ((hba->caps & UFSHCD_CAP_INTR_AGGR) &&
> -           !(hba->quirks & UFSHCD_QUIRK_BROKEN_INTR_AGGR))
> -               return true;
> -       else
> -               return false;
> -#else
> -return true;
> -#endif
> +       return (hba->caps & UFSHCD_CAP_INTR_AGGR) &&
> +               !(hba->quirks & UFSHCD_QUIRK_BROKEN_INTR_AGGR);
>  }
> 
>>
>>
>>>
>>> Thanks,
>>> Keoseong
>>>
>>>>
>>>>>  		return true;
>>>>> -	else
>>>>> -		return false;
>>>>> -#else
>>>>> -return true;
>>>>> -#endif
>>>>> +
>>>>> +	return (hba->caps & UFSHCD_CAP_INTR_AGGR) &&
>>>>> +		!(hba->quirks & UFSHCD_QUIRK_BROKEN_INTR_AGGR);
>>>>>  }
>>>>>  
>>>>>  static inline bool ufshcd_can_aggressive_pc(struct ufs_hba *hba)
>>>>>
>>>>
>>

