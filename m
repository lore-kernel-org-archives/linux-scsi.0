Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B1E1E784A4
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 00:36:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjJCAgT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 20:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjJCAgQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 20:36:16 -0400
Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1FBA1;
        Mon,  2 Oct 2023 17:36:13 -0700 (PDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 962B713C9ED; Mon,  2 Oct 2023 20:36:11 -0400 (EDT)
References: <20230927141828.90288-1-dlemoal@kernel.org>
 <874jj8sia5.fsf@vps.thesusis.net>
User-agent: mu4e 1.7.12; emacs 27.1
From:   Phillip Susi <phill@thesusis.net>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: Re: [PATCH v8 00/23] Fix libata suspend/resume handling and code
 cleanup
Date:   Mon, 02 Oct 2023 20:27:12 -0400
In-reply-to: <874jj8sia5.fsf@vps.thesusis.net>
Message-ID: <87h6n87dac.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Phillip Susi <phill@thesusis.net> writes:

> I noticed though, that when entering system suspend, a disk that has
> already been runtime suspended is resumed only to immediately be
> suspended again before the system suspend.  That shouldn't happen should
> it?

It seems that it is /sys/power/sync_on_suspend.  The problem went away
when I unmounted the disk, or I could make the disk wake up by running
sync.  I thought that it used to be that as long as you mounted an ext4
filesystem with -o relatime, it wouldn't keep dirtying the cache as long
as you weren't actually writing to the filesystem.  Either I'm
misremembering something, or this is no longer the case.  Also if there
are dirty pages in the cache, I thought the default was for them to be
written out after 5 seconds, which would keep the disk awake, rather
than waiting until system suspend to sync.

I guess I could mount the filesystem readonly.  It's probably not a good
idea to disable sync_on_suspend for the whole system.

