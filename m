Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94BFCE7A81
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 20:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjIVUg1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 16:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjIVUg1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 16:36:27 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0841A5;
        Fri, 22 Sep 2023 13:36:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19558C433C7;
        Fri, 22 Sep 2023 20:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695414979;
        bh=Wi3L0sijcSlAiyRKqOa9ZlXzCqSOzrmdLbG9R1tfvMw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=PE+zccALMxlUkS5aEZnsuf/i9pKkrRxZpjk/ukxtBbmAJV2ACkjmdpEW5KEfiHqB5
         amN45MUqneWlEn7RHB680QJDByjqBKIY3HaMjA8Vwb2aF/tfbsXI5KdCJS3GdO2M73
         v73cIVuWRUW04nbHuHBFMTMJy5It5f0bsY9Esh6VR5nZpGXhsSlyRYEJBs8kwPUttl
         xdMOJgRKzN0hGy+lrrHomaQwXiKBKyLgmAmAzDi8jRHt3YGpmAlKYcrX5+KpPzMZnQ
         Qyulm0FpLqD0FKIzlpXeY7OkVtXs0/ylZbNO8pHlzu5M22hBLrvc5eOK1Z2+bJJeI2
         6o09Dc+oDohwA==
Message-ID: <881dd17e-cc23-0cdc-f3bf-99bd571dbdf0@kernel.org>
Date:   Fri, 22 Sep 2023 13:36:18 -0700
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
 <1166d617-529f-a85b-eb51-427e8c2e8e45@kernel.org>
 <a745a2a7-e740-4bf3-a775-e22bc55dbe58@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <a745a2a7-e740-4bf3-a775-e22bc55dbe58@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/09/22 13:08, Bart Van Assche wrote:
> On 9/22/23 12:10, Damien Le Moal wrote:
>> Looking at the code, scsi_remove_host() calls scsi_forget_host() which calls
>> __scsi_remove_device() for any device that is not in the SDEV_DEL state.
>> __scsi_remove_device() then sets the state to SDEV_CANCEL. So it appears that
>> the state should always be CANCEL and not running. However, my tests showed it
>> to be running. I am not fully understanding how sd_remove() end up being called...
> 
> I think this is how sd_sync_cache() gets called from inside
> scsi_remove_host():
> 
> scsi_remove_host()
>    -> scsi_forget_host()
>      -> __scsi_remove_device()
>        -> device_del(&sdev->sdev_gendev)
>          -> bus_remove_device()
>            -> device_release_driver()
>              -> __device_release_driver()
>                -> sd_remove()
>                  -> sd_shutdown()
>                    -> sd_sync_cache()
> 
> In other words, it is guaranteed that scsi_device_set_state(sdev, 
> SDEV_CANCEL) has been called before sd_remove() if it is called by 
> scsi_remove_host().
> 
>> I think we should investigate this further though, to make sure that we can
>> always safely call sd_shutdown(). __scsi_remove_device() has this comment:
>>
>> /*
>>   * If blocked, we go straight to DEL and restart the queue so
>>   * any commands issued during driver shutdown (like sync
>>   * cache) are errored immediately.
>>   */
>>
>> Which kind of give a hint that we should probably not blindy always try to call
>> sd_shutdown().
> 
> Does that comment perhaps refer to the SDEV_BLOCK / SDEV_CREATED_BLOCK
> states? Anyway, I'm wondering whether there are better ways to prevent
> that it is attempted to queue SCSI commands if a SCSI device is
> suspended, e.g. by checking the suspended state from inside
> scsi_device_state_check() or scsi_dispatch_cmd().

Using information in the device ->power structure is not reliable without
holding the device lock(), so we should not do that. But we can add a
"suspended" scsi_device flag that we maintain on execution of
sd_suspend_system() and sd_resume_system(). Many drivers do that...
Thoughts ?


-- 
Damien Le Moal
Western Digital Research

