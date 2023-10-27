Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20330C25B67
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Oct 2023 00:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjJ0A0d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Oct 2023 20:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjJ0A0c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2023 20:26:32 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E961B6;
        Thu, 26 Oct 2023 17:26:30 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279AAC433C7;
        Fri, 27 Oct 2023 00:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698366389;
        bh=dYAPMHXfp0M1sGQU7Ep3XWBYD8n+9zR+Mp4Hd77alKE=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=ad1XrJKF0hFRQDaQ/hrWwTzQqoojMgVmT1ZfUD1MQ64wMIuSBuwWJ33Z4Bn38gmLK
         1hT9LTkMOja5sH8fpiyeBzoNvpowKqs6pI+Lo+Lfba5mz5KiB5Y8DsgtlRG1lW+qtS
         RDt1DfYjvTyXif/Yy0l2C/NgBAakiUvvQl/eVigaAjtm0M3pN+TyXlZvs4bDC/3hIf
         G/AxeE9Xe45bRcKchZKPO/G95YEvqgz8RTPy0U0xdm/MZTZkycdsEHAxn8FGtbzPu1
         AfqDWcueoeyOFcRmtrlg39HqcB4IUuQKeDMDiYx8FsGRHXmSJiSYefP1Df721rrdjS
         lyVqaAaSX6JsA==
Message-ID: <84139e3b-15d4-4368-a6d6-77bba5555aac@kernel.org>
Date:   Fri, 27 Oct 2023 09:26:27 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd: Introduce manage_shutdown device flag
To:     Bart Van Assche <bvanassche@acm.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <20231025070117.464903-1-dlemoal@kernel.org>
 <39fef5f8e090d50eb22d73d6bb39b21edf62b565.camel@HansenPartnership.com>
 <bf780d7a-30f3-4744-adde-73b4c2723d6b@kernel.org>
 <c3dfca871ddddfeef004fdb74432630a148300f2.camel@HansenPartnership.com>
 <23f25e02-a451-4ad4-bb04-e3449a1e6dea@acm.org>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <23f25e02-a451-4ad4-bb04-e3449a1e6dea@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/27/23 06:36, Bart Van Assche wrote:
> On 10/26/23 05:01, James Bottomley wrote:
>> Heh, well, I was going to say we should still point to the doc, but I
>> simply can't find it, so the above is perhaps the best we can do,
>> thanks!
> 
> I think this should be documented in the Documentation/power directory.
> After having taken another look at that directory, I see that there
> is only detailed documentation and no overview documentation. Maybe I
> overlooked something but I couldn't find an explanation of the system
> suspend/resume nor of the runtime power management concepts in that
> directory. My understanding is that system suspend/resume is about
> system-wide power state changes (hibernation and suspend-to-RAM) and
> also that runtime power management is about changing the power state of
> a single device or bus if no activity has happened within a certain
> time.

I actually thought that James wanted a reference to scsi sysfs attributes
documentation, which is also not in the best of shape, to say the least...

In any case, I would like to push this fix for 6.6-final as this is a tracked
regression. Martin, James, are you OK with this patch ?


-- 
Damien Le Moal
Western Digital Research

