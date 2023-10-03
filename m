Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E46DEE776DE
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 00:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238880AbjJCAo5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 20:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjJCAo4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 20:44:56 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22B7AD;
        Mon,  2 Oct 2023 17:44:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FABC433C8;
        Tue,  3 Oct 2023 00:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696293893;
        bh=yMvLQikaqxzhaRvjTGNUrSsM5nPuW71ThbZtpcdJAZQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=dCct7fa0qOzWwvNbH9z5woKHPKpUF9BoO6oxIY0xiIMWW1cJwWLVHsn1C4p+iRkr7
         ms5rHPTID11ZamAuHhlQoLeTYljFZB5yHytk9l/1NbauBx5ERUXo6miqYtbVtoYyyp
         fAFKzuWawVk3fNfWyI01Q97GqHhEG2qakRBDxKPwxn4i6lbUANFI7AYdy4XRGCAYSK
         qAIeqvIQ0vLCgql+wWlKsFdJc1sM/XURNUhZS7TwptAtHNh/q7eS3wwutR8cHrLHKC
         q9MHoIBKaRZyeUz8kTd+5EQcRhg5P+bScCPNTx2kkBBhsuQfzxBzYzQkI/aoGIv1t3
         yP0S2qyGywmSQ==
Message-ID: <269e2876-58fd-b73c-0c0d-1593c17c2809@kernel.org>
Date:   Tue, 3 Oct 2023 09:44:50 +0900
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
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <87h6n87dac.fsf@vps.thesusis.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/23 09:27, Phillip Susi wrote:
> 
> Phillip Susi <phill@thesusis.net> writes:
> 
>> I noticed though, that when entering system suspend, a disk that has
>> already been runtime suspended is resumed only to immediately be
>> suspended again before the system suspend.  That shouldn't happen should
>> it?
> 
> It seems that it is /sys/power/sync_on_suspend.  The problem went away
> when I unmounted the disk, or I could make the disk wake up by running
> sync.  I thought that it used to be that as long as you mounted an ext4
> filesystem with -o relatime, it wouldn't keep dirtying the cache as long
> as you weren't actually writing to the filesystem.  Either I'm
> misremembering something, or this is no longer the case.  Also if there
> are dirty pages in the cache, I thought the default was for them to be
> written out after 5 seconds, which would keep the disk awake, rather
> than waiting until system suspend to sync.
> 
> I guess I could mount the filesystem readonly.  It's probably not a good
> idea to disable sync_on_suspend for the whole system.

Hmmm... So this could be the fs suspend then, which issues a sync but the device
is already suspended and was synced already. In that case, we should turn that
sync into a nop to not wakeup the drive unnecessarily. The fix may be needed on
scsi sd side rather than libata.
Let me check.

-- 
Damien Le Moal
Western Digital Research

