Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E83A4CDB483
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Oct 2023 22:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjJOWoL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Oct 2023 18:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjJOWoK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Oct 2023 18:44:10 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A34A2;
        Sun, 15 Oct 2023 15:44:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66722C433C7;
        Sun, 15 Oct 2023 22:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697409846;
        bh=WrEHhBUJ/Q63FKEvjokbqK0S0M4CJZrRF4of9J7p8gk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=TvU4vTA74Qz/IpqUa1nOhVsxsajqAOCyYoGT3K5VKzT1So8w4O52it9uITa3slEnV
         CEYC+BkCZqvmILgd5PzSm0JoSmblZkSusvTgZfVWObR5bGXZsAMzODjUOUJsj5bvwU
         8SDUrih9sTTEiizDHcPC6pRynTUuDjp4Df1EuFdM1X67Yytdcvx0Hr4CFt30kQ/60X
         7YjTTlFjI/riPY/pR7UTPrhHj8r5p6G7koGv364tP5LEx7m362buoH7J59MdE+koiA
         aUtvLqSS0EqTZXwaeiI4RgOpfVtscoIwh0ZGTWwISBDbikyWa+SpQeOdZSXpYVvXe0
         eGqLxyEm+A6rA==
Message-ID: <0177ab41-6a7b-42ff-bf84-97d173efb838@kernel.org>
Date:   Mon, 16 Oct 2023 07:44:04 +0900
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
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <87v8b73lsh.fsf@vps.thesusis.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/16/23 01:14, Phillip Susi wrote:
> For SCSI disks that are runtime suspended, it looks like they skip
> waking the disk on system resume, leaving them in runtime suspend.
> After these patches, it looks like libata always wakes up the disk, but
> I don't see any calls to pm_runtime_disable/set_active/enable to mark
> the scsi disk as active after the system resume.  That should result in
> a disk that is spinning, but runtime pm thinks is not, and so will not
> put it into suspend after the inactivity timeout.

Yes, correct, but this does not create any issues in practice beside the
undesired disk spinup.

Fixing that is not trivial because using runtime suspend/resume on the SCSI disk
is just that, it will affect *only* the SCSI disk and not the ATA device and its
port. In other words, a runtime suspend of the SCSI disk will spin down the
drive but it will not runtime suspend the ATA port. So if you suspend the
system, on resume, the ATA port will not be runtime suspended and so it will be
resumed. The SCSI disk will not be resumed, but the ATA port resume will have
spun up the disk, which we do not really want in that case.

I am looking into this. Again, that is not a trivial fix. The other thing to
notice here is that ATA port runtime suspend/resume is in fact broken: it does
not track accesses to the device(s) connected to the port. And given that more
than one device may be connected to a port, we need PM runtime reference
counting to be done for this to work correctly. That is missing. Solutions are:
fix everything or simply do not support ATA port runtime suspend/resume (i.e.
remove code doing it). I am leaning toward the latter as it seems that no one
actually noticed these issues because no one is actually using ATA port runtime
suspend/resume...

-- 
Damien Le Moal
Western Digital Research

