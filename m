Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 363EFE6FE23
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 12:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbjIVMoM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 08:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjIVMoL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 08:44:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17107FB;
        Fri, 22 Sep 2023 05:44:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658C9C433C8;
        Fri, 22 Sep 2023 12:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695386645;
        bh=TIdQByut4wjwW55xeyxgf0ZMSIT9qeQLvR7FVRnp118=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=glgwwC97t0zSHWyZsa09bp7obmtwM/O8lkyMHFa4m95w+y378/4yGCQ1eRDBBPxCS
         9oMQco5qnY8yBpTzDKSd0MRbYUMs2l5gzI4nD918WFmKpaHNeNdGP0Hh3BKFNmytt3
         x5E8zLu8bQed1y0No7wNx3UlQRhcVTtCpdEi/86G5mAr0AlGWqX9g6LFnNXgA1KS8e
         gbwQDLRrjSgIAd6Mf/5bWc9btKZWu+iX7foSs4fMxDtUH0VPikQ5ciDc0MDaQniya8
         1P+0swivyeiLuyZhLox13oiiTqnGh8bU6K354Tcgj0RkO58tFWcI8wPmty/1XXzH7T
         jyg3uBsBFC8IQ==
Message-ID: <96d64bd4-8174-52f5-8e1a-c6acfc403cb3@kernel.org>
Date:   Fri, 22 Sep 2023 05:44:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v5 04/23] scsi: sd: Differentiate system and runtime
 start/stop management
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230921180758.955317-1-dlemoal@kernel.org>
 <20230921180758.955317-5-dlemoal@kernel.org>
 <yq18r8z57g6.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <yq18r8z57g6.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/09/21 18:25, Martin K. Petersen wrote:
> 
> Damien,
> 
> Just a few minor nits...
> 
>> The underlying device and driver of a scsi disk may have different
> 
> Maybe it's just me, but I always trip over lowercase "scsi". And you
> write ATA in upper case...
> 
>> device will also be suspended and resumed, with the resum operation
> 
> resume
> 
>> requiring re-validating the device link and the device itseld. In this
> 
> itself
> 
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index c92a317ba547..1d106c8ad5af 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -201,18 +201,50 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
>>  }
>>  
>>  static ssize_t
>> -manage_start_stop_show(struct device *dev, struct device_attribute *attr,
>> -		       char *buf)
> 
> Shouldn't we leave this for backwards compatibility?

Good point. But what should it show/control ? Both system & runtime flags (show
a AND of the flag and set/reset both flags ?). Or make it read-only and show a
AND of both flags ?

-- 
Damien Le Moal
Western Digital Research

