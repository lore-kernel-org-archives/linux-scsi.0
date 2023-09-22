Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB72CD4853
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 19:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbjIVTKR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 15:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjIVTKQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 15:10:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E6FAC;
        Fri, 22 Sep 2023 12:10:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B7FC433C8;
        Fri, 22 Sep 2023 19:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695409809;
        bh=PxxJ5uhMTMxcZvzE3B+Ljv3jSEHCni1MO0GsigA7COI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ejzotZ/Y5R7Us7f0zjdMHtsyUYsI1ah+uK+md3hy4Ujd+ZW9ZHS2IxP2emw3XHWcv
         P4Nw+0IMDuWJNnfqueaHnbeAgehwu5mEm052FHRFNVPvTsbqzh1K+IfuFBFAhtXIGL
         zKhGI4BPg/oUIe92DXwDSRZdqi0SrmYLEDCbtdhl8pVY7QoUQElLloW+OeHu8NQUx4
         nzlJ1tXa8fSZTHJq3z8Mp1bQI5JnK01JQfzem5mrettN6VYU71rAfy4zxZJtlgj6VR
         UVJZ44nQVpfFCSF0Cfph2lbEL/y/KONMwH4dE3cwXmRxc2wGwDngJobHztwkj0MbWY
         P+vV7qCnCJU2w==
Message-ID: <1166d617-529f-a85b-eb51-427e8c2e8e45@kernel.org>
Date:   Fri, 22 Sep 2023 12:10:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v5 09/23] scsi: sd: Do not issue commands to suspended
 disks on shutdown
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
References: <20230921180758.955317-1-dlemoal@kernel.org>
 <20230921180758.955317-10-dlemoal@kernel.org>
 <49f609ca-f862-4dce-95d8-616acbbc3e0e@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <49f609ca-f862-4dce-95d8-616acbbc3e0e@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/09/22 11:14, Bart Van Assche wrote:
> On 9/21/23 11:07, Damien Le Moal wrote:
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 1d106c8ad5af..d86306d42445 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -3727,7 +3727,8 @@ static int sd_remove(struct device *dev)
>>   
>>   	device_del(&sdkp->disk_dev);
>>   	del_gendisk(sdkp->disk);
>> -	sd_shutdown(dev);
>> +	if (sdkp->device->sdev_state == SDEV_RUNNING)
>> +		sd_shutdown(dev);
>>   
>>   	put_disk(sdkp->disk);
>>   	return 0;
> 
> Doesn't this patch involve a behavior change? I'm concerned the above patch
> will always cause the sd_shutdown() call to be skipped if scsi_remove_host()
> is called, whether or not the scsi_remove_host() call is triggered by a
> resume failure.

I guess the point is: what are the possible states of the scsi device when
sd_remove() is called ? From what I have seen so far, it is RUNNING. But I am
not 100% sure this true all the time. But given that sd_shutdown() issues
commands, I would guess that it makes sense that it is always running.

Looking at the code, scsi_remove_host() calls scsi_forget_host() which calls
__scsi_remove_device() for any device that is not in the SDEV_DEL state.
__scsi_remove_device() then sets the state to SDEV_CANCEL. So it appears that
the state should always be CANCEL and not running. However, my tests showed it
to be running. I am not fully understanding how sd_remove() end up being called...

I will run tests again without this patch for libata suspend/resume. This patch
was added because of the hang I saw with the pm80xx driver (using libsas/libata)
failing to resume. That resume failure is fixed and libata does not need this
patch I think. But I will double check and drop it for now.

I think we should investigate this further though, to make sure that we can
always safely call sd_shutdown(). __scsi_remove_device() has this comment:

/*
 * If blocked, we go straight to DEL and restart the queue so
 * any commands issued during driver shutdown (like sync
 * cache) are errored immediately.
 */

Which kind of give a hint that we should probably not blindy always try to call
sd_shutdown().

-- 
Damien Le Moal
Western Digital Research

