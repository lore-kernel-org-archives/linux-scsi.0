Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04130C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 06:37:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9E9161029
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 06:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhJNGjt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Oct 2021 02:39:49 -0400
Received: from mga14.intel.com ([192.55.52.115]:18785 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhJNGjs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Oct 2021 02:39:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10136"; a="227894440"
X-IronPort-AV: E=Sophos;i="5.85,371,1624345200"; 
   d="scan'208";a="227894440"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 23:37:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,371,1624345200"; 
   d="scan'208";a="571133310"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by fmsmga002.fm.intel.com with ESMTP; 13 Oct 2021 23:37:41 -0700
Subject: Re: [PATCH 1/1] scsi: ufs-pci: Force a full restore after
 suspend-to-disk
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20211012125914.21977-1-adrian.hunter@intel.com>
 <20211012125914.21977-2-adrian.hunter@intel.com>
 <DM6PR04MB65755AE8057F920F2CB4F40EFCB89@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <af42f79f-4cb7-000d-b366-feac7b5f5c60@intel.com>
Date:   Thu, 14 Oct 2021 09:37:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB65755AE8057F920F2CB4F40EFCB89@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/10/2021 09:15, Avri Altman wrote:
>  
>> Implement the ->restore() PM operation and set the link to off, which
>> will force a full reset and restore.  This ensures that Host Performance
>> Booster is reset after suspend-to-disk.
>>
>> The Host Performance Booster feature caches logical-to-physical mapping
>> information in the host memory.  After suspend-to-disk, such information
>> is not valid, so a full reset and restore is needed.
>>
>> A full reset and restore is done if the SPM level is 5 or 6, but not for
>> other SPM levels, so this change fixes those cases.
> It is perfectly fine for you to do that on your platform, if you choose so - 
> Hence my reviewed-by.
> But the reasoning is a bit odd, because you already set SSU4 for your spm-lvl,
> And on SSU3 the device does not dump its internal tables.

Hibernation flow is:

	->freeze()
	create memory image
	->thaw()
	write image
	->poweroff()

	time passes
	someone presses the power button or something else activates the machine

	kernel boots
	detects restore image
	read image
	->freeze()
	restore memory image
	->restore()

It is up to ->restore() to ensure the device state matches the
memory state as it was when the hibernation image was made.

> 
> Thanks,
> Avri
> 
>> A full reset and restore also restores base address registers, so that
>> code is removed.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> 

