Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FFF8EEAA78
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Sep 2023 22:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjINWFc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Sep 2023 18:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjINWFb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Sep 2023 18:05:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14A42120;
        Thu, 14 Sep 2023 15:05:27 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3786FC433C8;
        Thu, 14 Sep 2023 22:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694729127;
        bh=dqxLadDDqlEqKAnhOqY93jhLlIvNB3L/geA45dfoWLs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=S3aJl/oORremOBmAf5y4Jbd3ult6niD8HSVhbJUpCBZSiwDleETM8cVgzLvxiV+C9
         KyEw/jrTwHM0zUXZdb1riKVE0n8MdBgK1F7/BbfmXMTN4Y0egJOCHInH2eG4izmgpr
         A1NvIVLyCLs2crMIt7+lAXgIoy5c5sDMfxEvYynDQfvsm1w2tsuZhdhFafSVuof58Y
         opJilYdDkt84KMMGUV0lvtiILHhCQsaOu2SjyjFqKR0oGn5y3ykynPkyQmT4nvO8iP
         g97AVqrfdq1y2/jg3sYqfh5/gnYBq7R1hAnb1MWGW5DIYE6AMhhfyeX4Rg7IMqKZeY
         hOAChrpFBdYMA==
Message-ID: <bf2f2365-7c30-d6f0-ad13-8a0c85bb5e91@kernel.org>
Date:   Fri, 15 Sep 2023 07:05:25 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 05/19] ata: libata-scsi: Fix delayed scsi_rescan_device()
 execution
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-6-dlemoal@kernel.org>
 <f45fb721-aa64-4a10-952e-cf5236a5d1e3@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <f45fb721-aa64-4a10-952e-cf5236a5d1e3@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/15/23 02:25, Bart Van Assche wrote:
> On 9/10/23 21:02, Damien Le Moal wrote:
>> Commit 6aa0365a3c85 ("ata: libata-scsi: Avoid deadlock on rescan after
>> device resume") modified ata_scsi_dev_rescan() to check the scsi device
>> "is_suspended" power field to ensure that the scsi device associated
>> with an ATA device is fully resumed when scsi_rescan_device() is
>> executed. However, this fix is problematic as:
>> 1) it relies on a PM internal field that should not be used without PM
>>     device locking protection.
>> 2) The check for is_suspended and the call to ata_scsi_dev_rescan() are
>>     not atomic and a suspend PM even may be triggered between them,
>>     casuing ata_scsi_dev_rescan() to be called on a suspended device,
>>     resulting in that function blocking while holding the scsi device
>>     lock, which would deadlock a following resume operation.
>> These problems can trigger PM deadlocks on resume, especially with
>> resume operations triggered quickly after or during suspend operations.
>> E.g., a simple bash script like:
>>
>> for (( i=0; i<10; i++ )); do
>> 	echo "+2 > /sys/class/rtc/rtc0/wakealarm
>> 	echo mem > /sys/power/state
>> done
>>
>> that triggers a resume 2 seconds after starting suspending a system can
>> quickly lead to a PM deadlock preventing the system from correctly
>> resuming.
>>
>> Fix this by replacing the check on is_suspended with a check on the scsi
>> device state inside ata_scsi_dev_rescan(), while holding the scsi device
>> lock, thus making the device rescan atomic with regard to PM operations.
>> Additionnly, make sure that scheduled rescan tasks are first cancelled
>> before suspending an ata port.
> 
> One patch per subsystem please. I think this patch can be split easily 
> into an ATA patch and a SCSI core patch.

In general, I agree that should be done. But this is a bug fix and having it
split in 2 risks breaking something if only one is reverted and also potentially
give bad bisect results. So I would rather not do that.

> 
> Thanks,
> 
> Bart.

-- 
Damien Le Moal
Western Digital Research

