Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5FDCC77B73
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Apr 2023 05:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbjDSFXi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Apr 2023 01:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjDSFXh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2023 01:23:37 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3F64697
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 22:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681881816; x=1713417816;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=J5H7IFGnCR0kozaUYwP5FGySFMAAB2iNX0WRFa92Eco=;
  b=emtZs1xVwukPcDIgNFmLn32evcrKUdDt59xIdtqB/xsqKWS8YaYczPH8
   XL4+2YDqJZUiTEDqfFV8eyKOEGJqh2JiH+lGIjhYUaGw5o3LGBYACHJis
   8eaQcfSXXBadif/8IaDtO7jFd9kNNYEF31jElrODt0bf3ugAHKy0VL9uF
   VAoERwhUpBA1BK+s1NKc5szOLY9KNL5VTwFFBZ+BAuqJQeupAArRDPc7W
   YK9d+Ql/ah/MrQ8lxLjtHiW/L1hY6sw6ZDtgi75DO1CW+gUbh8TF+HVWC
   zglPlQcZFdHZd8wEEzPrxIFSq/uBUypjkxsCLEA2QhrEqhnM3RKFEvWCf
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="334163253"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="334163253"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 22:23:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="835144249"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="835144249"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.58.77])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 22:23:31 -0700
Message-ID: <de72eb42-f0f9-99c3-2e14-e8ab00d3f39a@intel.com>
Date:   Wed, 19 Apr 2023 08:23:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH v2 2/4] scsi: ufs: Simplify ufshcd_wl_shutdown()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        Asutosh Das <asutoshd@codeaurora.org>,
        Tomas Henzl <thenzl@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@google.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
References: <20230417230656.523826-1-bvanassche@acm.org>
 <20230417230656.523826-3-bvanassche@acm.org>
 <74088d26-ac26-15ba-86a0-65d74a426a9c@intel.com>
 <0a2af553-9b37-d7b4-2fc2-6185c64e8663@acm.org>
 <4568ba8b-2dd8-b88c-fbfb-1b0a561e0b15@intel.com>
 <be06f246-a69e-ade7-0318-5a99d2d36216@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <be06f246-a69e-ade7-0318-5a99d2d36216@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/04/23 23:14, Bart Van Assche wrote:
> On 4/18/23 07:13, Adrian Hunter wrote:
>> On 18/04/23 17:06, Bart Van Assche wrote:
>>> On 4/18/23 06:45, Adrian Hunter wrote:
>>>> On 18/04/23 02:06, Bart Van Assche wrote:
>>>>> Now that sd_shutdown() fails future I/O the code for quiescing LUNs in
>>>>> ufshcd_wl_shutdown() is superfluous. Remove the code for quiescing LUNs.
>>>>> Also remove the ufshcd_rpm_get_sync() call because it is not necessary
>>>>> to resume a UFS device before submitting a START STOP UNIT command.
>>>>
>>>> What about the host controller hba->dev?
>>>
>>> The above question is not clear to me. Please elaborate.
>>
>> Does hba->dev need to be runtime resumed?
> 
> Hi Adrian,
> 
> I don't think so. Shutdown callback functions are expected to quiesce hardware activity. To me runtime resuming a device seems to contradict the goal of quiescing hardware activity.

I don't think the host controller can be used to submit a START STOP UNIT command if the host controller is runtime suspended.


