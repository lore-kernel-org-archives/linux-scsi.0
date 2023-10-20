Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F346CC0032E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Oct 2023 19:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjJTTA1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Oct 2023 15:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjJTTA0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Oct 2023 15:00:26 -0400
Received: from vps.thesusis.net (vps.thesusis.net [IPv6:2600:1f18:60b9:2f00:6f85:14c6:952:bad3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CA1114;
        Fri, 20 Oct 2023 12:00:23 -0700 (PDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id C3506145852; Fri, 20 Oct 2023 15:00:22 -0400 (EDT)
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
In-Reply-To: <26de72d5-02d3-489c-a789-b2b709ae073e@kernel.org>
References: <20230927141828.90288-1-dlemoal@kernel.org>
 <20230927141828.90288-5-dlemoal@kernel.org>
 <87v8b73lsh.fsf@vps.thesusis.net>
 <0177ab41-6a7b-42ff-bf84-97d173efb838@kernel.org>
 <87r0luspvx.fsf@vps.thesusis.net>
 <1a6f1768-fd48-42df-9f1a-4b203baf6ddf@kernel.org>
 <87y1g1unwg.fsf@vps.thesusis.net>
 <26de72d5-02d3-489c-a789-b2b709ae073e@kernel.org>
Date:   Fri, 20 Oct 2023 15:00:22 -0400
Message-ID: <87edhpi0ft.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Damien Le Moal <dlemoal@kernel.org> writes:

> With the device links in place between port and scsi devices, we should be OK.
> But still need to check that we do not need runtime_get/put calls added.
> Ideally, we should have the chain:
>
> scsi disk -> scsi target -> scsi host -> ata port

It looks to me like there is an additional generic block device that
sits on top and that is what actually has the idle timeout.  Or maybe
that's the scsi disk, since it's name incldues the SCSI LUN, but in the
structure, its called sdev_gendev.  But then there's also sdev_dev, and
sdev_target.

> for runtime suspend, and the reverse for runtime resume. If there is a system
> suspend/resume between runtime suspend/resume, the port should not be resumed if
> it is runtime suspended.

I'm not sure about it.  The port has to be resumed so that we can
attempt to revalidate the devices on it.  For disks that have spun up on
their own, we should not leave then marked as runtime suspended, but
really they are spinning.  I suppose we could put them to sleep, though
I was leaning to just marking them as active, and leaving the runtime pm
timer to put them to sleep later, which then could allow the port to
suspend again.

