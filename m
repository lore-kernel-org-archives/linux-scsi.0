Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A5CDE776D4
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 23:42:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjJBXmq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 19:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjJBXmq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 19:42:46 -0400
Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C82B8;
        Mon,  2 Oct 2023 16:42:43 -0700 (PDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 9FDC513C9CC; Mon,  2 Oct 2023 19:42:42 -0400 (EDT)
References: <20230927141828.90288-1-dlemoal@kernel.org>
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
Date:   Mon, 02 Oct 2023 19:39:03 -0400
In-reply-to: <20230927141828.90288-1-dlemoal@kernel.org>
Message-ID: <874jj8sia5.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


I went to test these patches tonight and it looks like Linus already
merged them ( or mostly? ).  I enabled runtime pm on the scsi target and
the ata port, and the disk spins down and the port does too.

I noticed though, that when entering system suspend, a disk that has
already been runtime suspended is resumed only to immediately be
suspended again before the system suspend.  That shouldn't happen should
it?

