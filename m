Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB36CDB482
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 12:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbjJPMjR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 08:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjJPMjQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 08:39:16 -0400
Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5B59B;
        Mon, 16 Oct 2023 05:39:15 -0700 (PDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 927BD144DBF; Mon, 16 Oct 2023 08:39:14 -0400 (EDT)
From:   Phillip Susi <phill@thesusis.net>
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: Re: [PATCH v8 04/23] scsi: sd: Differentiate system and runtime
 start/stop management
In-Reply-To: <0177ab41-6a7b-42ff-bf84-97d173efb838@kernel.org>
References: <20230927141828.90288-1-dlemoal@kernel.org>
 <20230927141828.90288-5-dlemoal@kernel.org>
 <87v8b73lsh.fsf@vps.thesusis.net>
 <0177ab41-6a7b-42ff-bf84-97d173efb838@kernel.org>
Date:   Mon, 16 Oct 2023 08:39:14 -0400
Message-ID: <87r0luspvx.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Damien Le Moal <dlemoal@kernel.org> writes:

> Yes, correct, but this does not create any issues in practice beside the
> undesired disk spinup.

The issue it creates is the opposite of that: it breaks the desired spin
down.  After some period of inactivity, the disk should be suspended,
but after a system resume, the kernel thinks that it already is, and so
won't suspend it again.

> Fixing that is not trivial because using runtime suspend/resume on the SCSI disk
> is just that, it will affect *only* the SCSI disk and not the ATA device and its
> port. In other words, a runtime suspend of the SCSI disk will spin down the
> drive but it will not runtime suspend the ATA port. So if you suspend
> the

I tested this last week and it appeared to work.  I enabled runtime pm
on the disk, as well as the ata port, and as soon as the disk suspended,
the port did as well.

> system, on resume, the ATA port will not be runtime suspended and so it will be
> resumed. The SCSI disk will not be resumed, but the ATA port resume will have
> spun up the disk, which we do not really want in that case.

Right, I would rather the disk stay asleep if it has PuiS enabled, and
I'm working on a patch for that.  In the process of doing that though, I
noticed that despite waking the disk up, it does not inform runtime pm
about that.

> I am looking into this. Again, that is not a trivial fix. The other thing to
> notice here is that ATA port runtime suspend/resume is in fact broken: it does
> not track accesses to the device(s) connected to the port. And given that more
> than one device may be connected to a port, we need PM runtime reference
> counting to be done for this to work correctly. That is
> missing. Solutions are:

Again, it seems to me that the child reference counting IS working.

> fix everything or simply do not support ATA port runtime suspend/resume (i.e.
> remove code doing it). I am leaning toward the latter as it seems that no one
> actually noticed these issues because no one is actually using ATA port runtime
> suspend/resume...

Probably nobody is using it yes, but that doesn't mean we shouldn't try
to get it working.  It would be nice to have the drive go into deep
SLEEP instead of standby, as well as suspend the ata port, and possibly
even the whole AHCI controller rather than relying on the old APM drive
internal auto standby mode.

