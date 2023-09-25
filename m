Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC24CE7AB2
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Sep 2023 17:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbjIYRdU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Sep 2023 13:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjIYRdT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Sep 2023 13:33:19 -0400
Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C00510D;
        Mon, 25 Sep 2023 10:33:12 -0700 (PDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 75A4713B36A; Mon, 25 Sep 2023 13:33:11 -0400 (EDT)
References: <20230923002932.1082348-1-dlemoal@kernel.org>
 <20230923002932.1082348-20-dlemoal@kernel.org>
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
Subject: Re: [PATCH v6 19/23] ata: libata-core: Do not resume runtime
 suspended ports
Date:   Mon, 25 Sep 2023 13:26:09 -0400
In-reply-to: <20230923002932.1082348-20-dlemoal@kernel.org>
Message-ID: <87msxaupig.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien Le Moal <dlemoal@kernel.org> writes:

> The scsi disk driver does not resume disks that have been runtime
> suspended by the user. To be consistent with this behavior, do the same
> for ata ports and skip the PM request in ata_port_pm_resume() if the
> port was already runtime suspended. With this change, it is no longer
> necessary to force the PM state of the port to ACTIVE as the PM core
> code will take care of that when handling runtime resume.

The problem with this is that ATA disks normally spin up on their own
after system resume.  As a result, if the disk was put to sleep with
runtime pm before the system suspend, then after resume, the kernel will
still show that it is runtime suspended, even though it is not.  Then
the disk will keep spinning forever.

We need to check the drive on system resume to see if it is in standby
or not, and force the runtime pm state to match.  I couldn't quite work
out how to do that properly before.  I dug up my old patch series and
have been reviewing it.  If you are interested, it can be found here:

https://lore.kernel.org/all/1387236657-4852-5-git-send-email-psusi@ubuntu.com/
