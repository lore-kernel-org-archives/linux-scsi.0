Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 144C6C83F19
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Aug 2023 06:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbjH2GSF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Aug 2023 02:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbjH2GRo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2023 02:17:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96693BC;
        Mon, 28 Aug 2023 23:17:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25D2162EE3;
        Tue, 29 Aug 2023 06:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C33C433C7;
        Tue, 29 Aug 2023 06:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693289860;
        bh=JCl9J7Xgo9kbNS0rgmyb7ogDe0o01SQ/f7cIfSqnzvA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=TKFFuPPjS2ABgR0o1OwIZMaOn6GDPiW6GXXMeH7IlM7O8/UeVKie3MtM5m7M9K+Pw
         uidbE5xhQ05QwP04hjK8k6wgzKDNiyIv0xGacYI4ldhtDekQ8kB4HSNS/qR6me1xl6
         URQ6Y5tGFrorJ0qx8r9azND53VfhyW6Tn+TG8h4uKJscvtr7M7Nc67S55Gxh+/+rnD
         P8WlkowJnmEnVnAklYCBrBWLWr29w2ea8l7Ks/asHAoFOFkaJLIRfK2lhRuRQ1jYuO
         DIe/MFfSoIRLrv/TIMw59/QZ21d2CjsQ9hHl4rKc3wZnMXjz4xVWp1W48g8MwuOzQq
         sT/LZ17fCgaPg==
Message-ID: <ccf3d87c-6517-6f01-a32a-4c98b841c7d4@kernel.org>
Date:   Tue, 29 Aug 2023 15:17:38 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ata,scsi: do not issue START STOP UNIT on resume
Content-Language: en-US
To:     Rodrigo Vivi <rodrigo.vivi@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        TW <dalzot@gmail.com>, regressions@lists.linux.dev,
        Bart Van Assche <bvanassche@acm.org>
References: <20230731003956.572414-1-dlemoal@kernel.org>
 <ZOehTysWO+U3mVvK@rdvivi-mobl4>
 <40adc06d-0835-2786-0bfb-83239f546d92@kernel.org>
 <ZOjgJl4nlieu3+kL@rdvivi-mobl4>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZOjgJl4nlieu3+kL@rdvivi-mobl4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/26/23 02:09, Rodrigo Vivi wrote:
>>> So, maybe we have some kind of disks/configuration out there where this
>>> start upon resume is needed? Maybe it is just a matter of timming to
>>> ensure some firmware underneath is up and back to life?
>>
>> I do not think so. Suspend will issue a start stop unit command to put the drive
>> to sleep and resume will reset the port (which should wake up the drive) and
>> then issue an IDENTIFY command (which will also wake up the drive) and other
>> read logs etc to rescan the drive.
>> In both cases, if the commands do not complete, we would see errors/timeout and
>> likely port reset/drive gone events. So I think this is likely another subtle
>> race between scsi suspend and ata suspend that is causing a deadlock.
>>
>> The main issue I think is that there is no direct ancestry between the ata port
>> (device) and scsi device, so the change to scsi async pm ops made a mess of the
>> suspend/resume operations ordering. For suspend, scsi device (child of ata port)
>> should be first, then ata port device (parent). For resume, the reverse order is
>> needed. PM normally ensures that parent/child ordering, but we lack that
>> parent/child relationship. I am working on fixing that but it is very slow
>> progress because I have been so far enable to recreate any of the issues that
>> have been reported. I am patching "blind"...
> 
> I believe your suspicious makes sense. And on these lines, that patch you
> attached earlier would fix that. However my initial tries of that didn't
> help. I'm going to run more tests and get back to you.

Rodrigo,

I pushed the resume-v2 branch to libata tree:

git@gitolite.kernel.org:pub/scm/linux/kernel/git/dlemoal/libata
(or https://git.kernel.org/pub/scm/linux/kernel/git/dlemoal/libata.git)

This branch adds 13 patches on top of 6.5.0 to cleanup libata suspend/resume and
other device shutdown issues. The first 4 patches are the main ones to fix
suspend resume. I tested that on 2 different machines with different drives and
with qemu. All seems fine.

Could you try to run this through your CI ? I am very interested in seeing if it
survives your suspend/resume tests.

If you can confirm that all issues are fixed, I will rebase this on for-next and
post.

Thanks !


-- 
Damien Le Moal
Western Digital Research

