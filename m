Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3E50CD80DB
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Oct 2023 14:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbjJJOFA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Oct 2023 10:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232043AbjJJOE7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2023 10:04:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9462E91;
        Tue, 10 Oct 2023 07:04:58 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5DBC433C8;
        Tue, 10 Oct 2023 14:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696946698;
        bh=zUhbdN9nVVfVsfr3rJHLzA5Y1RLueOJc008EuoPaLRk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=B6AdMpukbK64fsP7Qhtkxg+1G4pr4K+lGrDzf/pR3Tm2ZLbHLF+yWzl7eWokZSZO7
         pMQhPyWJgDAFFoj5RYu71WXSsKXmM5k+t+CEZwZtHBjkSFJwJGV1XjYPDWaLUmlQuK
         1lKA82DDtm7UCEXnvTKFD651Hz+3BOeNNLmFHVISS0514USEhC5sNfU+51mvji5+5H
         TwEWhRKRYjuWQsEceYyw8fQLkG4Qg2xXBZsAF9nWXkQ1jdWtLrZIlG4rW86+DFzqeZ
         dhc/hEmlJQAu5Svrki9QGMI6IwYedrySUtuLMkrSEWYiVvZ1WfU9aJ/Mp48rV41+qT
         sZt5yuGEFir4w==
Message-ID: <c0b086ab-dcd5-4b7b-b931-4d407dd7ad47@kernel.org>
Date:   Tue, 10 Oct 2023 23:04:55 +0900
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
 <20230927141828.90288-5-dlemoal@kernel.org> <874jiybp3s.fsf@vps.thesusis.net>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <874jiybp3s.fsf@vps.thesusis.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/10/23 22:09, Phillip Susi wrote:
> Damien Le Moal <dlemoal@kernel.org> writes:
> 
>> system suspend/resume operations, the ATA port used to connect the
>> device will also be suspended and resumed, with the resume operation
>> requiring re-validating the device link and the device itself. In this
>> case, issuing a VERIFY command to spinup the disk must be done before
>> starting to revalidate the device, when the ata port is being resumed.
>> In such case, we must not allow the SCSI disk driver to issue START STOP
>> UNIT commands.
> 
> Why must a VERIFY be issued to spinup the disk before revalidating?

We can most likely move that VERIFY to after revalidation. That should shorten
delays on first access after resume as many drive do actually spinup with the
reset done before revalidating (but note that the specs say that even a reset
shall not take a drive out of standby mode, without specifying the reset type,
so this is rather loosely defined).

> Before these patches, by default, manage_start_stop was on, and so sd
> would cause a VERIFY in the system resume path.  That resume however (
> sd and its issuing START UNIT ), would have happened AFTER the link was
> resumed and the ATA device was revalidated, woudldn't it?  So at that

In theory, yes, that was the intent. In practice, the verify was issued from
scsi PM resume context while the actual drive port reset + revalidation is done
in libata EH context, triggered from ATA port resume context which itself was
not synchronized/ordered with the scsi disk resume. So we ended up with the
verify command execution sometimes being attempted with the drive not even
revalidated yet, or with the port/link not even active sometimes (depending on
timing). So problems all over and deadlocks due to scsi revalidate using the
device lock, which PM use too.

> point, the drive would already be spinning.  And if manage_start_stop
> was disabled, then there would be no VERIFY at all, and this did not
> seem to cause a problem before.

See above. With the switch to async PM ops in scsi in kernel 5.16, things broke
badly due to the lack of synchronization that sync PM provided before that.

> 
> If this VERIFY were skipped, the next thing that would happen is for
> ata_dev_revalidate() to issue IDENTIFY, which would wait for the drive
> to spin up before returning wouldn't it? ( unless the drive has PuiS
> enabled ).

ACS defines that only media access commands can get a drive out of standby mode
back into active mode. So an IDENTIFY command would not (normally) spinup a
drive. Nor would READ LOG. Normally, IDENTIFY, READ LOG etc done in revalidate
can be processed with the drive spun down (*but* I have seen drives that react
badly to some of these commands when spun down). Hence why I put it first,
before revalidate. Now that all the synchronization is in place and libata EH
does its own manage_start_stop for system suspend/resume, I will see if moving
the verify to the end of revalidate works.


-- 
Damien Le Moal
Western Digital Research

