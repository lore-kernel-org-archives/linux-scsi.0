Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF50C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 11:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F5BF610D1
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 11:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhJMLn6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 07:43:58 -0400
Received: from mga18.intel.com ([134.134.136.126]:43862 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229571AbhJMLn6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Oct 2021 07:43:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="214349532"
X-IronPort-AV: E=Sophos;i="5.85,370,1624345200"; 
   d="scan'208";a="214349532"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 04:41:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,370,1624345200"; 
   d="scan'208";a="570803894"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by fmsmga002.fm.intel.com with ESMTP; 13 Oct 2021 04:41:53 -0700
Subject: Re: [PATCH 0/1] scsi: ufs-pci: Force a full restore after
 suspend-to-disk
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20211012125914.21977-1-adrian.hunter@intel.com>
 <DM6PR04MB65752EF1F70EA5CF44F8AEAFFCB79@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <4b6b177e-2311-5c90-2eaa-e648aeaa5d72@intel.com>
Date:   Wed, 13 Oct 2021 14:41:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB65752EF1F70EA5CF44F8AEAFFCB79@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/10/2021 13:46, Avri Altman wrote:
>> Hi
>>
>> This patch ensures suspend-to-disk works with Host Performance Booster.
> What is "suspend-to-disk"?

Hibernation, refer kernel config CONFIG_HIBERNATION
i.e.

echo disk > /sys/power/state

> What power mode is used for that?

Same as spm_lvl except ufshcd_wl_poweroff() naturally uses the same as
shutdown i.e. POWERDOWN 

> 
> Thanks,
> Avri
> 
>> Since the Host Perfomance Booster feature was added in v5.15, please
>> consider this for v5.15 fixes.
>>
>>
>> Adrian Hunter (1):
>>       scsi: ufs-pci: Force a full restore after suspend-to-disk
>>
>>  drivers/scsi/ufs/ufshcd-pci.c | 31 ++++++++++++++++---------------
>>  1 file changed, 16 insertions(+), 15 deletions(-)
>>
>>
>> Regards
>> Adrian

