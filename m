Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03C92C432BE
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 06:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D014C60FDA
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 06:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbhIBGCj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Sep 2021 02:02:39 -0400
Received: from mga12.intel.com ([192.55.52.136]:24322 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230215AbhIBGCi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Sep 2021 02:02:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10094"; a="198535421"
X-IronPort-AV: E=Sophos;i="5.84,371,1620716400"; 
   d="scan'208";a="198535421"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2021 23:01:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,371,1620716400"; 
   d="scan'208";a="499489430"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.174]) ([10.237.72.174])
  by fmsmga008.fm.intel.com with ESMTP; 01 Sep 2021 23:01:37 -0700
Subject: Re: [PATCH v3 16/18] scsi: ufs: Synchronize SCSI and UFS error
 handling
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20210722033439.26550-1-bvanassche@acm.org>
 <20210722033439.26550-17-bvanassche@acm.org>
 <88e0dc4c-34ff-6d87-fa9f-2fc924f50369@intel.com>
 <020bd6be-0944-8e25-c9fd-972cab5e6746@acm.org>
 <69fb9f57-54b6-072c-9f53-5da8b8e3202d@intel.com>
 <2719c43f-d56b-b2bb-0e34-53bcec74e0d9@acm.org>
 <77088200-5fab-78e9-777b-ceb259f44f03@intel.com>
 <c34be6af-6ba2-2ad5-bc51-69b2258dfd5b@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <e747f543-b4e0-cb3f-964f-f9269f71a211@intel.com>
Date:   Thu, 2 Sep 2021 09:02:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <c34be6af-6ba2-2ad5-bc51-69b2258dfd5b@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/09/21 11:46 pm, Bart Van Assche wrote:
> On 9/1/21 12:42 AM, Adrian Hunter wrote:
>> No it doesn't use host_sem.  The problem is with issuing requests to a blocked queue.
>> If the UFS device is in SLEEP state, runtime resume will try to do a
>> SCSI request to change to ACTIVE state.  That will block while the error
>> handler is running.  So if the error handler is waiting on runtime resume,
>> deadlock.
> 
> Please define "UFS device". Does this refer to the physical device or to a LUN?

UFS Device WLUN aka UFS Device Well-known LUN aka LUN 49488. It is in the spec.

> 
> I agree that suspending or resuming a LUN involves executing a SCSI command. See also __ufshcd_wl_suspend() and __ufshcd_wl_resume(). These functions are used to suspend or resume a LUN and not to suspend or resume the UFS device.

__ufshcd_wl_suspend() and __ufshcd_wl_resume() are for the UFS Device WLUN (what the wl stands for).  All other LUNs are device link consumers of it.

> 
> However, I don't see how the above scenario would lead to a deadlock? The UFS error handler (ufshcd_err_handler()) works at the link level and may resume the SCSI host and/or UFS device (hba->host and hba->dev). The UFS error handler must not try to resume any of the LUNs since that involves executing SCSI commands.

A detailed example was provided.
