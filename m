Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42903CD4847
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 17:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbjIVRA2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 13:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjIVRA0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 13:00:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26139198;
        Fri, 22 Sep 2023 10:00:21 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E59EC433C7;
        Fri, 22 Sep 2023 17:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695402020;
        bh=gNJdx2KEzg/GbGHrx6/0KklUJxm7urAUi4uZrKp0uAA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=IwkkXt1425A30Tfwm7LCROzVDxS8DJyflGF3Fk0MWpg8grkolMjM7thmfEm3eHVII
         ynnw4slSrgAqteX+ps7n8Na9yrxp8MNB2E+21f0aESSti1dFzvB8kGEIRbaU7ElaWQ
         a9QTpDUfktkkeJNMwFZT57iUUvAxTgryr3qibQ7YM0bVh2n+0QJFCyTT6ym+VfIg8J
         XwrQ0ctbzCidhcvY9cKIt3/TvOXH8SF4W76PgAkBpxq925C2tfpqZNXWeZiIqwlgnk
         Oh+Gkb+lQXrvbCj3+IG8qzXJyL6JYtbc+4yDz/bSiOlX1uBSPcwEQurEn9QkyBaUMD
         FIBcE5WPDSyow==
Message-ID: <dc0defb8-6520-508d-9dbc-b81a7861bc08@kernel.org>
Date:   Fri, 22 Sep 2023 10:00:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v4 04/23] scsi: sd: Differentiate system and runtime
 start/stop management
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230920135439.929695-1-dlemoal@kernel.org>
 <20230920135439.929695-5-dlemoal@kernel.org>
 <3cfe137b-59f5-434f-a40b-2ed14b4aa408@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <3cfe137b-59f5-434f-a40b-2ed14b4aa408@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/09/21 14:45, Bart Van Assche wrote:
> On 9/20/23 06:54, Damien Le Moal wrote:
>> The underlying device and driver of a scsi disk may have different
>> system and runtime power mode control requirements. This is because
>> runtime power management affects only the scsi disk, while sustem level
>> power management affects all devices, including the controller for the
>> scsi disk.
>>
>> For instance, issuing a START STOP UNIT command when a scsi disk is
>> runtime suspended and resumed is fine: the command is translated to a
>> STANDBY IMMEDIATE command to spin down the ATA disk and to a VERIFY
>> command to wake it up. The scsi disk runtime operations have no effect
>> on the ata port device used to connect the ATA disk. However, for
>> system suspend/resume operations, the ATA port used to connect the
>> device will also be suspended and resumed, with the resum operation
> 
> resum -> resume
> 
>> requiring re-validating the device link and the device itseld. In this
> 
> itseld -> itself
> 
>> -static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
>> +static inline bool sd_do_start_stop(struct scsi_device *sdev, bool runtime)
>> +{
>> +	return (sdev->manage_system_start_stop && !runtime) ||
>> +		(sdev->manage_runtime_start_stop && runtime);
>> +}
> 
> This function wouldn't be necessary if the sd_suspend_common() callers 
> would pass sdev->manage_system_start_stop / 
> sdev->manage_runtime_start_stop as an additional argument to 
> sd_suspend_common().

Sure, but then we need to get the sdkp for the struct device and use
sdkp->device in both sd_suspend_runtime() and sd_suspend_system(). This is in my
opinion not as clean as the little inline helper. But if you insist, I can make
that change.

> 
>> -		if (ignore_stop_errors)
>> +		if (!runtime)
>>   			ret = 0;
>>   	}
> 
> The old code was self-documenting. If the name of the "runtime" argument 
> is retained, a comment above this if-statement that explains why stop 
> errors are ignored during a system suspend would be welcome.

There is a comment already (unchanged) above the call to sd_start_stop_device(),
one line above the "if".

> 
> Otherwise this patch looks good to me.
> 
> Thanks,
> 
> Bart.
> 
> 

-- 
Damien Le Moal
Western Digital Research

