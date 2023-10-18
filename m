Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E4FC41513
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Oct 2023 06:16:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjJRGQq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Oct 2023 02:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjJRGQp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Oct 2023 02:16:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11DBEA;
        Tue, 17 Oct 2023 23:16:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02590C433C8;
        Wed, 18 Oct 2023 06:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697609802;
        bh=VyCFMGnNO4dEej2M+2W9EIIrQCxbhF4GtjVh6dLwz+Y=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=qLmQKR+D5igbICtVZgbKnprjR/TZcsU51yvFJe5fuoEH7TjPkDEUiB7mxbJQYC9VX
         6MtDYEl+aKds1ct7sPW7OR3VHHsmUXFzBKh5hndMeARbVVpEmVe6F4zh7U6M6kr7Lg
         g+20iR6ZiktytkSL0AoL/5eAlYMoS8niRRnjRP1XrGgOJABtrALPJwkrzPftnHbIAh
         wwzOxmX+w4eM0llF/T8A8F17jDz+40MJCJWHCOy5rY/0KIQwrm+lA5QBf06XrdQxb4
         odePgcB1qJ6nDUEhjLkqlQeTsw8qOUtnasZ+eC7ZoK95u/29Wht9WLqDiYP8Ak9QbU
         CX7eSL6v6/MHA==
Message-ID: <e5a256fa-f1f6-4474-8e9e-b9f4bd6dced7@kernel.org>
Date:   Wed, 18 Oct 2023 15:16:21 +0900
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
> 
>> I am not sure of that, especially with cases of ATA ports with multiple disks
>> (e.g. pmp or IDE).
> 
> Good point.  I have an eSATA dock with PMP.  I'll check tonight if the
> children are counted properly.

On my system, I see:

cat /sys/class/ata_port/ata1/power/runtime_active_kids
0

and same for port 10 which is a PMP box with 3 drives. So it means that the
children will be ignored, which is wrong. Note that the corresponding scsi_host
device also shows 0. So to be safe with port runtime PM, we need to fix that
first. Otherwise, the port may end up being runtime suspended with running
drives still attached to it.

/sys/class/ata_port/ata1/power/control is set to "auto" by default.


-- 
Damien Le Moal
Western Digital Research

