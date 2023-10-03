Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E95E8FDC2
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 23:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238468AbjJCXrA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 19:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238629AbjJCXq7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 19:46:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D7690;
        Tue,  3 Oct 2023 16:46:56 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF154C433C7;
        Tue,  3 Oct 2023 23:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696376815;
        bh=5xKSNTSw2RYzEDddcwiPLExFg5N2zhaGw4448ZpIO8I=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=TVcmKVPPUhYCfhI1jUSw4Qn+voXTT74oWpLs4pogL5bsPPsE/TB+KxTwfP8oGIW2n
         5UmsKCdCBM+b9F0n8uv37yNMjZkzVWAixeDhrN+nMnG61vRdqHyTDzdvQGQfTP+tmq
         QnyUd4mso8XjGrtkDiOFI7T+wx7rHek4DzFUm7bl91QmOYyKdSjBv9IUOQqHQ2x3ZY
         ywlLaoQ3MDEZ+BWmRVBhNurRHES1Pt2DX6ZnrL9NeppqJLvROhLms+6bwC2fOeoxce
         yuaX3kFy059ma5xfVG6FGcYapFRn+wegt1Ncz4MI1SqNHUi6KmHHFz+phWRAE3a746
         98GZrzf5Z95hQ==
Message-ID: <3aae2b14-ce32-261a-46a4-cc8d5f3adab4@kernel.org>
Date:   Wed, 4 Oct 2023 08:46:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v8 00/23] Fix libata suspend/resume handling and code
 cleanup
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
References: <20230927141828.90288-1-dlemoal@kernel.org>
 <874jj8sia5.fsf@vps.thesusis.net> <87h6n87dac.fsf@vps.thesusis.net>
 <269e2876-58fd-b73c-0c0d-1593c17c2809@kernel.org>
 <ZRyGIE+NpmtMu7XK@thesusis.net>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZRyGIE+NpmtMu7XK@thesusis.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/4/23 06:22, Phillip Susi wrote:
> On Tue, Oct 03, 2023 at 09:44:50AM +0900, Damien Le Moal wrote:
>> Hmmm... So this could be the fs suspend then, which issues a sync but the device
>> is already suspended and was synced already. In that case, we should turn that
>> sync into a nop to not wakeup the drive unnecessarily. The fix may be needed on
>> scsi sd side rather than libata.
> 
> I did some tracing today on a test ext4 fs I created on a loopback device, and it
> seems that the superblocks are written every time you sync, even if no files on the
> filesystem have even been opened for read access.

OK. So a fix would need to be on the FS side then if one wants to avoid that
useless resume. However, this may clash with the FS need to record stuff in its
sb and so we may not be able to avoid that.

-- 
Damien Le Moal
Western Digital Research

