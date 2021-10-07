Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DCD6C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20D2A61074
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbhJGUg3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:36:29 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:37626 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbhJGUg3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:36:29 -0400
Received: by mail-pg1-f174.google.com with SMTP id r201so932647pgr.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:34:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gETpgcryXTclxQDwE+7u7gIm4n1lVecMk4ciBWqP91I=;
        b=5uFC4kOH+THLDeOne/DK8EDL5iX1/LBvUDrfoSpUkgtmEkhYJGkxOh+i1fmwyJVpKF
         mp2HoEEC2xNY/+KDWWcQN0S5sxOarClvQKyPL4h0Yq6IEPG6DRtY8IQjif4tBSRoHxrV
         NyE3b8vPWHI79aiLwgzFSOprpLlpVhRd0yUi3brKg4wY2oa8WyWXWZom41QAAWIWLpV8
         TzzmKH2c7SUBvmdnv+YNhD78+401IAXNgud04sYnrKzQElkIllC+CHwolQ66NcJLVTLT
         RWSuz/+ATp/M6qz2+hnepmRcT/PxVRjwwizvQbTuqZSoVjDzTejbz9Bj8DPWbJCJsVTT
         e1Ow==
X-Gm-Message-State: AOAM530he/L8GiHdFADjTPA+FcbGh/FFRbrm/vkBm3rkGBs172wXmBrM
        PjWjvekvT2CuC+Iijnf/fAItN/MH2Z4=
X-Google-Smtp-Source: ABdhPJypAnW19UnI5KrxZ6DofwKvlsa3Ht4Uen82jv2D7nA4A6Mn99WXKfWFWX/V/kN39V0tRK51lw==
X-Received: by 2002:aa7:8b0d:0:b0:44c:89ca:7844 with SMTP id f13-20020aa78b0d000000b0044c89ca7844mr6095937pfd.19.1633638874466;
        Thu, 07 Oct 2021 13:34:34 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id w4sm297153pfb.3.2021.10.07.13.34.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 13:34:33 -0700 (PDT)
Subject: Re: [PATCH 3/3] scsi: pm: Only runtime resume if necessary
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20211006215453.3318929-1-bvanassche@acm.org>
 <20211006215453.3318929-4-bvanassche@acm.org>
 <20211007162408.GA692514@rowland.harvard.edu>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <7d4a6e84-dc20-5447-04c3-f1a2bb4abca8@acm.org>
Date:   Thu, 7 Oct 2021 13:34:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211007162408.GA692514@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/7/21 9:24 AM, Alan Stern wrote:
> On Wed, Oct 06, 2021 at 02:54:53PM -0700, Bart Van Assche wrote:
>> The following query shows which drivers define callbacks that are called
>> by the power management support code in the SCSI core (scsi_pm.c):
>>
>> $ git grep -nHEwA16 "$(echo $(git grep -h 'scsi_register_driver(&' |
>>        sed 's/.*&//;s/\..*//') | sed 's/ /|/g')" |
>>      grep '\.pm[[:blank:]]*=[[:blank:]]'
>> drivers/scsi/sd.c-620-		.pm		= &sd_pm_ops,
>> drivers/scsi/sr.c-100-		.pm		= &sr_pm_ops,
>> drivers/scsi/ufs/ufshcd.c-9765-		.pm = &ufshcd_wl_pm_ops,
>>
>> Since unconditionally runtime resuming a device during system resume is
>> not necessary, remove that code. Modify the SCSI disk (sd) driver such
>> that it follows the same approach as the UFS driver, namely to skip
>> system suspend and resume for devices that are runtime suspended. The
>> CD-ROM code does not need to be updated since its PM callbacks do not
>> affect the device power state.
> 
> You may already be aware of this, but in case you aren't...
> 
> The PM core already contains some provisions for handling these kinds
> of things.  They are described in
> Documentation/driver-api/pm/devices.rst.  See particularly the parts
> relating to the DPM_FLAG_NO_DIRECT_COMPLETE, DPM_FLAG_SMART_PREPARE,
> DPM_FLAG_SMART_SUSPEND, DPM_FLAG_MAY_SKIP_RESUME, and
> power.direct_complete flags.
> 
> A follow-up patch after this series might be able to take advantage of
> these facilities.

Hi Alan,

Thanks for the feedback. I was not yet aware of these flags. Since using 
these flags would make patch 3/3 only a few lines shorter and would make 
it harder to review for anyone who is not familiar with the DPM flags, 
I'm considering to keep patch 3/3 as is (this means not using the DPM 
flags).

Thanks,

Bart.
