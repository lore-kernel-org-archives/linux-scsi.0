Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 033C0C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 19:15:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245742AbhK3TSq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 14:18:46 -0500
Received: from mga17.intel.com ([192.55.52.151]:28835 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245720AbhK3TSp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Nov 2021 14:18:45 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="216993771"
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="216993771"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 11:15:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="540533066"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by orsmga001.jf.intel.com with ESMTP; 30 Nov 2021 11:15:22 -0800
Subject: Re: [PATCH v2 11/20] scsi: ufs: Switch to
 scsi_(get|put)_internal_cmd()
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-12-bvanassche@acm.org>
 <6bfb59ef-4f00-3918-59e6-3c9569f6adc6@intel.com>
 <bc19f55f-a3e9-a3fe-437d-57b9e077f532@acm.org>
 <1a9cddd9-b67a-be4b-4c83-3636f37e6769@intel.com>
 <2cb66e0a-df1e-0825-67b9-cbd2f116fe92@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <e214da03-ce47-9987-09d9-2bbf125b59bf@intel.com>
Date:   Tue, 30 Nov 2021 21:15:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <2cb66e0a-df1e-0825-67b9-cbd2f116fe92@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30/11/2021 19:51, Bart Van Assche wrote:
> On 11/29/21 10:41 PM, Adrian Hunter wrote:
>> On 29/11/2021 21:32, Bart Van Assche wrote:
>>> * The code in blk_cleanup_queue() that waits for pending requests to finish
>>>    before resources associated with the request queue are freed.
>>>    ufshcd_remove() calls blk_cleanup_queue(hba->cmd_queue) and hence waits until
>>>    pending device management commands have finished. That would no longer be the
>>>    case if the block layer is bypassed to submit device management commands.
>>
>> cmd_queue is used only by the UFS driver, so if the driver is racing with
>> itself at "remove", then that should be fixed. The risk is not that the UFS
>> driver might use requests, but that it might still be operating when hba or
>> other resources get freed.
>>
>> So the question remains, for device commands, we do not need the block
>> layer, nor SCSI commands which still begs the question, why involve them
>> at all?
> 
> By using the block layer request allocation functions the block layer guarantees
> that each tag is in use in only one context. When bypassing the block layer code
> would have to be inserted in ufshcd_exec_dev_cmd() and ufshcd_issue_devman_upiu_cmd()
> to serialize these functions.

They already are serialized, but you are essentially saying the functionality
being duplicated is just a lock.  What you are proposing seems awfully
complicated just to get the functionality of a lock.

> In other words, we would be duplicating existing
> functionality if we bypass the block layer. The recommended approach in the Linux
> kernel is not to duplicate existing functionality.

More accurately, the functionality would not be being used at all, so not
really any duplication.


