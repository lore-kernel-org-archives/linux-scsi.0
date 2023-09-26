Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B6F7E8181F
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 06:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbjIZG1x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 02:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjIZG1w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 02:27:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D77092;
        Mon, 25 Sep 2023 23:27:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA28C433CA;
        Tue, 26 Sep 2023 06:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695709666;
        bh=N1BRTfWkQpgy/pXSQhXr3dDTjienhVtgUmbsufUDkF0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=WyydKJorPIWdyYQyYZFhQXtn3wQNo/aw1wa1qPLZ4C0s3AKqhQyhs0rpYiYvp673s
         6AkbS6ImvmeyxqGRCk4LP3wQAdObOWgGC4h09XilVhIhH9HAIA+fcCVGRVLfOGUhuF
         8LmKRodl2/R2SXZaaJxGLsXaNnEwCT8AnlJ7LgU1eczs0dVvAQ0cXeSWnmvw0njbAt
         7T4Cyf5nsIOywUVbYCpd7FePFy/u0Lu5WfU/9kEEnjt3gQw7BEc4Z0yLD2Pvy7hVmt
         YtFxweqILknilEokUGJzU6kM4qovGASScQPpiUASdyeqGeMOH34mzPsTwf9EJFv2kv
         p/8NxmLUUjNog==
Message-ID: <e3ddb272-4ff6-e5a7-7a4e-cb2acf0595d7@kernel.org>
Date:   Tue, 26 Sep 2023 08:27:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v6 19/23] ata: libata-core: Do not resume runtime
 suspended ports
Content-Language: en-US
To:     Phillip Susi <phill@thesusis.net>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230923002932.1082348-1-dlemoal@kernel.org>
 <20230923002932.1082348-20-dlemoal@kernel.org>
 <87msxaupig.fsf@vps.thesusis.net>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <87msxaupig.fsf@vps.thesusis.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/09/25 19:26, Phillip Susi wrote:
> 
> Damien Le Moal <dlemoal@kernel.org> writes:
> 
>> The scsi disk driver does not resume disks that have been runtime
>> suspended by the user. To be consistent with this behavior, do the same
>> for ata ports and skip the PM request in ata_port_pm_resume() if the
>> port was already runtime suspended. With this change, it is no longer
>> necessary to force the PM state of the port to ACTIVE as the PM core
>> code will take care of that when handling runtime resume.
> 
> The problem with this is that ATA disks normally spin up on their own
> after system resume.  As a result, if the disk was put to sleep with
> runtime pm before the system suspend, then after resume, the kernel will
> still show that it is runtime suspended, even though it is not.  Then
> the disk will keep spinning forever.

I suspect you are talking about resume from hybernation here, where the drive
may have been completely powered off... Yes, in such case, the drive will
spinup, unless you have PUIS and enabled it.

> We need to check the drive on system resume to see if it is in standby
> or not, and force the runtime pm state to match.  I couldn't quite work
> out how to do that properly before.  I dug up my old patch series and
> have been reviewing it.  If you are interested, it can be found here:
> 
> https://lore.kernel.org/all/1387236657-4852-5-git-send-email-psusi@ubuntu.com/

Sure, but please do not have this delay this patch series. The problem you are
describing above exists today already. This patch series is not making it worse,
nor is it trying to solve it. And note that this issue is not just for ATA. SCSI
devices locally attached to a machine that you hybernate will end up doing the
same and spinup when power is restored...

-- 
Damien Le Moal
Western Digital Research

