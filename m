Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DAD9C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 07:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiBPH5E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 02:57:04 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:59258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiBPH5D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 02:57:03 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA4963C9
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2022 23:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644998212; x=1676534212;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kSDPeo5IUYpNhkE/If/1vs/jBrIKlb55tNk7CQWj9s0=;
  b=irKm9ZF3ffK4aAiz0uFMlEbbtwHvmnNcdUppNooIIspjnW9021Cap+zJ
   6QdCPdV8fiFwuvXt3SOp/b6Z0pt2EMobRuW/anOwiTPEpCY2XP9FjuXRk
   kK92hpp/YHqAMNTmXACO/L2RruosobkQK3GSDs6mcMpL9N8jeHNqDsQNt
   CWyBHYMRN5jW0AhnPPWsgSrNQRDa1K2vLB+aUaPqAW/Rg2P/IUnOW8IMK
   FT3Z6HtZV0RhGZjJbqQYKESBcyrW6slFM5dMJcWzUIC5ElwTpSGBV3ozb
   9tQTE1Q6EyU7EIUX++upffg20EX3bmy3L7O9Th+BbHvbRV52cXtOCmw00
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="237950731"
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="237950731"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 23:56:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="704195999"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.92]) ([10.237.72.92])
  by orsmga005.jf.intel.com with ESMTP; 15 Feb 2022 23:56:49 -0800
Message-ID: <0144a0d9-6ba4-c621-7f0c-9109b7fd4cfd@intel.com>
Date:   Wed, 16 Feb 2022 09:56:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH V2] scsi: ufs: Fix runtime PM messages never-ending cycle
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
References: <20220214121941.296034-1-adrian.hunter@intel.com>
 <yq14k50n7b0.fsf@ca-mkp.ca.oracle.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <yq14k50n7b0.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 15/02/2022 05:29, Martin K. Petersen wrote:
> 
> Adrian,
> 
>> Kernel messages produced during runtime PM can cause a never-ending
>> cycle because user space utilities (e.g. journald or rsyslog) write the
>> messages back to storage, causing runtime resume, more messages, and so
>> on.
>>
>> Messages that tell of things that are expected to happen, are arguably
>> unnecessary, so suppress them.
> 
> I don't have a major objection to the sd_suspend changes although I
> wonder if there is a log level configuration problem with these systems?
> Would KERN_INFO instead of KERN_NOTICE help?

I tried KERN_DEBUG but it did not help, but we also do not want to produce
large numbers of unnecessary messages.

> 
> I do not like the report sense change. We see this message all the time
> in the field and it is very useful for debugging problems. So that
> message should be made conditional based on PM state.

It can happen after runtime PM when a LUN is accessed, so a flag set by
the driver seems better.  Please see V3.

> 
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index 60a6ae9d1219..e177dc5cc69a 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -484,8 +484,14 @@ static void scsi_report_sense(struct scsi_device *sdev,
>>  
>>  		if (sshdr->asc == 0x29) {
>>  			evt_type = SDEV_EVT_POWER_ON_RESET_OCCURRED;
>> -			sdev_printk(KERN_WARNING, sdev,
>> -				    "Power-on or device reset occurred\n");
>> +			/*
>> +			 * Do not print a message here because reset can be an
>> +			 * expected side-effect of runtime PM. Do not print
>> +			 * messages due to runtime PM to avoid never-ending
>> +			 * cycles of messages written back to storage by user
>> +			 * space causing runtime resume, causing more messages
>> +			 * and so on.
>> +			 */
>>  		}
>>  
>>  		if (sshdr->asc == 0x2a && sshdr->ascq == 0x01) {
> 

