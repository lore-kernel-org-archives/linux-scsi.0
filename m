Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D1A3C76196
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 18:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjDKSb5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 14:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDKSb4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 14:31:56 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7D3BD
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2023 11:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681237915; x=1712773915;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UHwmQ79Oqpg7oz32BZdFtPLYPd+ql/+zIfHuydrVszo=;
  b=C9yr8A+rb2TjsLyBbSOMpmTGi1KMZ+kNpgmAT3/T+ddUW8Ik7KyUVJLX
   2obacZakepUS66cjlu2nEgLi8HTE9cmdDzB+gYAmc667GyXTNLZcoI5O/
   /PP92Syvd1ka9Ep5Aq638BIvzSA+n1eXTLl4niqBjORxjk/Zg9mPvQAND
   UmNL0qVhQCd22kOChZzxRx+0TGgV0QQcH+q0LUCMaqCGn8wn4/KoLgDC9
   rT2kiF6x6G6X+/iyXYYZysKloSUC7IyWrYEqv3DDgVc9CeMusZs9QSGrg
   fNvU2VmbEAT5iqvIQuWfk4fq1AcAqDoLLTflt9PzTj3HIj60rXPzvHNXA
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="341192244"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="341192244"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 11:31:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="753241820"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="753241820"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.44.57])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 11:31:52 -0700
Message-ID: <a71dc651-a306-eebe-968e-0d9e56f44a76@intel.com>
Date:   Tue, 11 Apr 2023 21:31:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH] scsi: ufs: Increase the START STOP UNIT timeout from 1 s
 to 10 s
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20230411001132.1239225-1-bvanassche@acm.org>
 <17217146-9c07-3963-fd32-02704632330d@intel.com>
 <0c8b4904-31f4-d21a-7554-6525a264293b@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <0c8b4904-31f4-d21a-7554-6525a264293b@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/04/23 20:31, Bart Van Assche wrote:
> On 4/11/23 01:39, Adrian Hunter wrote:
>> On 11/04/23 03:11, Bart Van Assche wrote:
>>> One UFS vendor asked to increase the UFS timeout from 1 s to 3 s.
>>> Another UFS vendor asked to increase the UFS timeout from 1 s to 10 s.
>>> Hence this patch that increases the UFS timeout to 10 s. This patch can
>>> cause the total timeout to exceed 20 s, the Android shutdown timeout.
>>> This is fine since the loop around ufshcd_execute_start_stop() exists to
>>> deal with unit attentions and because unit attentions are reported
>>> quickly.
>>>
>>> Fixes: dcd5b7637c6d ("scsi: ufs: Reduce the START STOP UNIT timeout")
>>
>> Did that commit (shown below) actually increase the timeout
>> because the previous commit (8f2c96420c6e) had put
>> "remaining / HZ" when it should have been just "remaining"?
>> Or am I misreading?
>>
>> So maybe it also needs a fixes tag for 8f2c96420c6e.
> 
> Commit 8f2c96420c6e ("scsi: ufs: core: Reduce the power mode change timeout") changed the START STOP UNIT timeout from START_STOP_TIMEOUT into "remaining / HZ" (should have been "remaining") and hence passed a smaller value than intended to scsi_execute(). Commit dcd5b7637c6d changed the timeout from remaining / HZ into one second. Both values are too small. I'm not sure a second Fixes: tag would help since the above Fixes: tag should be sufficient to make this patch land in all relevant stable trees.

It would be better not to assume current stable trees are the only consumers of fixes.  Presumably adding the extra Fixes tag does no harm.

