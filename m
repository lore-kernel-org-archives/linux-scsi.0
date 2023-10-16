Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFDA1CDB482
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 12:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbjJPM4E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 08:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233501AbjJPM4D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 08:56:03 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A510AD;
        Mon, 16 Oct 2023 05:56:01 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42A9C433C7;
        Mon, 16 Oct 2023 12:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697460960;
        bh=659l+cz6qcNGGpHPccDq5p1cqkPcaNzpdmWAwoKEYN8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=TWzxV8a+w4lWsn19i5tM0Sl1FCBoVqHfIw+wPt+ur0IeBW7V6tSvH8s+C5tTZpxHL
         SAkE7cmKU3RHjYHk+7yAvX4LJvyq+qoWuvl2f4v5l+YzhbLZAr1jSL1FyaTb0QQCqC
         J8re0qRK6n46NHoQj/oIkDq7DlJSCVeGnpgOCr++0tBEQGopNIe5Havh+Vje1CHamd
         rdeAsDu/OBCSbqf+wJX0P5E/GGRDcwTxnrVhdvaIQgS1I3W2FRdG4bLPf5J6exPNqg
         t/rk/PqDd34dAH7CRdwVkzNejMd4iTKp+YKCYUFOdE1LRb5whWIyrYsE2Go/blmFby
         EfcwpqlzH28/g==
Message-ID: <1a6f1768-fd48-42df-9f1a-4b203baf6ddf@kernel.org>
Date:   Mon, 16 Oct 2023 21:55:57 +0900
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
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <87r0luspvx.fsf@vps.thesusis.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/16/23 21:39, Phillip Susi wrote:
> Damien Le Moal <dlemoal@kernel.org> writes:
> 
>> Yes, correct, but this does not create any issues in practice beside the
>> undesired disk spinup.
> 
> The issue it creates is the opposite of that: it breaks the desired spin
> down.  After some period of inactivity, the disk should be suspended,
> but after a system resume, the kernel thinks that it already is, and so
> won't suspend it again.

That one should be fixable, though it I do not see an elegant method to do it.
It would be easy with ugly code, e.g. tweaking the scsi device runtime pm state
from libata... Not great.

> 
>> Fixing that is not trivial because using runtime suspend/resume on the SCSI disk
>> is just that, it will affect *only* the SCSI disk and not the ATA device and its
>> port. In other words, a runtime suspend of the SCSI disk will spin down the
>> drive but it will not runtime suspend the ATA port. So if you suspend
>> the
> 
> I tested this last week and it appeared to work.  I enabled runtime pm
> on the disk, as well as the ata port, and as soon as the disk suspended,
> the port did as well.

Never saw that in my tests when enabling runtime pm on the scsi disk only. Which
is the important point here: there is no propagation of the suspend state down
to the device parent it seems.

> 
>> system, on resume, the ATA port will not be runtime suspended and so it will be
>> resumed. The SCSI disk will not be resumed, but the ATA port resume will have
>> spun up the disk, which we do not really want in that case.
> 
> Right, I would rather the disk stay asleep if it has PuiS enabled, and
> I'm working on a patch for that.  In the process of doing that though, I
> noticed that despite waking the disk up, it does not inform runtime pm
> about that.

But there are no runtime PM operations defined for ATA devices, only for ports.
So not sure that matters... I am probably still missing something about runtime
PM and devices ancestry. I focused a lot on system suspend/resume to fix the
issues. runtime suspend/resume is next.

> 
>> I am looking into this. Again, that is not a trivial fix. The other thing to
>> notice here is that ATA port runtime suspend/resume is in fact broken: it does
>> not track accesses to the device(s) connected to the port. And given that more
>> than one device may be connected to a port, we need PM runtime reference
>> counting to be done for this to work correctly. That is
>> missing. Solutions are:
> 
> Again, it seems to me that the child reference counting IS working.

I am not sure of that, especially with cases of ATA ports with multiple disks
(e.g. pmp or IDE).

> 
>> fix everything or simply do not support ATA port runtime suspend/resume (i.e.
>> remove code doing it). I am leaning toward the latter as it seems that no one
>> actually noticed these issues because no one is actually using ATA port runtime
>> suspend/resume...
> 
> Probably nobody is using it yes, but that doesn't mean we shouldn't try
> to get it working.  It would be nice to have the drive go into deep
> SLEEP instead of standby, as well as suspend the ata port, and possibly
> even the whole AHCI controller rather than relying on the old APM drive
> internal auto standby mode.
> 

-- 
Damien Le Moal
Western Digital Research

