Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CBD9CDB474
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 23:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbjJQXcP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 19:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234819AbjJQXcO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 19:32:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CF893;
        Tue, 17 Oct 2023 16:32:12 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB4DC433C7;
        Tue, 17 Oct 2023 23:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697585532;
        bh=VHN2NjRcVJC0+/skQntQTR2Y2jVEs9N3Yhiohr/OmiI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=cTkTWK8Vj38ueMpqogqSR/n1ATRctZSWd8vz62yEC+k5gTIbEisASB8M6QQ33lX2l
         Me+tjjM8NodY4or83BIEGe0fVHU2xMfZLdywpJtoOCPSpO+8Fgr57C1L455nc2aJrU
         udiqLxfC55LIrpPBmvOyoX1TXdGeayiLGMNS3E7/BNTxCQ2DIeTkYlDG5nU2wfWOOw
         qEiIWhU33aZ/ABzSLZlp2cAxxrZ0wlbir1YcoI0S1sFMiFbMQjA/1ZZTyOqmirf/4Q
         41TBoO2fuRhZjDnXjNBqfr/qLcK3oVcPHCIctqcqlXoOB5msIf+jH0hwJeMi4+V6V1
         INQNeRg42Na1Q==
Message-ID: <26de72d5-02d3-489c-a789-b2b709ae073e@kernel.org>
Date:   Wed, 18 Oct 2023 08:32:10 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/23] scsi: sd: Differentiate system and runtime
 start/stop management
Content-Language: en-US
To:     Phillip Susi <phill@thesusis.net>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230927141828.90288-1-dlemoal@kernel.org>
 <20230927141828.90288-5-dlemoal@kernel.org> <87v8b73lsh.fsf@vps.thesusis.net>
 <0177ab41-6a7b-42ff-bf84-97d173efb838@kernel.org>
 <87r0luspvx.fsf@vps.thesusis.net>
 <1a6f1768-fd48-42df-9f1a-4b203baf6ddf@kernel.org>
 <87y1g1unwg.fsf@vps.thesusis.net>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <87y1g1unwg.fsf@vps.thesusis.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/18/23 03:03, Phillip Susi wrote:
> Damien Le Moal <dlemoal@kernel.org> writes:
> 
>> That one should be fixable, though it I do not see an elegant method to do it.
>> It would be easy with ugly code, e.g. tweaking the scsi device runtime pm state
>> from libata... Not great.
> 
> What would be not great about it?  libata already takes over the system

To have to add code in libata that touches the scsi device PM status is what's
not going to be great. Such code should stay in sd.c and scsi_pm.c. But not sure
we actually need anything.

> suspend/resume from sd.  I'm currently testing having libata do just
> this right now.  I just got ahold of some jumpers today to put the
> drives back into PuiS and do some further testing tonight.
> 
>> Never saw that in my tests when enabling runtime pm on the scsi disk only. Which
>> is the important point here: there is no propagation of the suspend state down
>> to the device parent it seems.
> 
> Last night I again saw the port auto suspend when the scsi disk was
> runtime suspended.  Tonight I'll test with PuiS, as well as with system
> resume while runtime suspended.  Maybe I'll even try to get the whole
> AHCI controller to auto suspend.  It seems like it should once all of
> the ports do.

With my tests, I never set the ata port power/control to "auto", which may be
why I did not see the port being runtime suspended when the scsi disk was
runtime suspended. Will try again.

>> I am not sure of that, especially with cases of ATA ports with multiple disks
>> (e.g. pmp or IDE).
> 
> Good point.  I have an eSATA dock with PMP.  I'll check tonight if the
> children are counted properly.

With the device links in place between port and scsi devices, we should be OK.
But still need to check that we do not need runtime_get/put calls added.
Ideally, we should have the chain:

scsi disk -> scsi target -> scsi host -> ata port

for runtime suspend, and the reverse for runtime resume. If there is a system
suspend/resume between runtime suspend/resume, the port should not be resumed if
it is runtime suspended.


-- 
Damien Le Moal
Western Digital Research

