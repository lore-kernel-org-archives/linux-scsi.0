Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA7DFC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 05:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C83760E96
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 05:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhJYFlI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Oct 2021 01:41:08 -0400
Received: from mga12.intel.com ([192.55.52.136]:1725 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229499AbhJYFlH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Oct 2021 01:41:07 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10147"; a="209668552"
X-IronPort-AV: E=Sophos;i="5.87,179,1631602800"; 
   d="scan'208";a="209668552"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2021 22:38:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,179,1631602800"; 
   d="scan'208";a="596341366"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by orsmga004.jf.intel.com with ESMTP; 24 Oct 2021 22:38:40 -0700
Subject: Re: [PATCH RESEND v2] scsi: ufs: clear doorbell for hibern8 errors
 when using ah8
To:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com,
        vkumar.1997@samsung.com
References: <CGME20211019051346epcas2p132d3b9c6a1c812f3132e913525235b83@epcas2p1.samsung.com>
 <1634619427-171880-1-git-send-email-kwmad.kim@samsung.com>
 <2e35d23b-babb-a617-d93e-ce9b522dafb3@intel.com>
 <029e01d7c66b$6f6e7830$4e4b6890$@samsung.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Cc:     Bart Van Assche <bvanassche@acm.org>
Message-ID: <6726fd8a-47f4-185d-e7a3-d006902d605c@intel.com>
Date:   Mon, 25 Oct 2021 08:38:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <029e01d7c66b$6f6e7830$4e4b6890$@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/10/2021 14:04, Kiwoong Kim wrote:
>> On 19/10/2021 07:57, Kiwoong Kim wrote:
>>> Changes from v1:
>>> * Change the time to requeue pended commands
>>>
>>> When an scsi command is dispatched right after host complete all the
>>> pended requests and ufs driver tries to ring a doorbell, host might be
>>> still during entering into hibern8.
>>> If the hibern8 error occurrs during that period, the doorbell might
>>> not be zero and clearing it should have done.
>>> But, current ufshcd_err_handler goes directly to reset w/o clearing
>>> the doorbell when the driver's link state is broken.
>>
>> So you mean HCE 1->0 does not clear the doorbell register?
>>
>>> This patch is to requeue pended commands after host reset.
>>
>> So you mean HCE 0->1 does clear the doorbell register?
> 
> 
> I talked about this again and maybe he didn't seem to accept its description like that
> Because he just focused on the term 'disable' in the description.
> Instead, there is an vendor sfr to clear all the contexts.
> 
> Yes, the description contains like this, but I think he could think it's done when setting one.
> --
> When HCE is ‘0’ and software writes ‘1’, the host 
> controller hardware shall execute the step 2 described in 7.1.1 of this standard, 
> including >>>>> reset <<<<< of the host UTP and UIC layers.
> 
> Of course, some statements, such as 8.2.2. UIC Error Handling, seems to show setting zero means clearing.
> But speaking the description, it's not quite clear to me.
> 
> Anyway, let me know how to deal with this.

It seems vendor-specific.  Perhaps export ufshcd_complete_requests()
and call it from vendor ops->hce_enable_notify(hba, POST_CHANGE) ?

Note that Bart submitted a patch to remove ufshcd_retry_aborted_requests().
