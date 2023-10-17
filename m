Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 636EECDB484
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 18:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbjJQSDt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 14:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233170AbjJQSDs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 14:03:48 -0400
Received: from vps.thesusis.net (vps.thesusis.net [IPv6:2600:1f18:60b9:2f00:6f85:14c6:952:bad3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A23C83;
        Tue, 17 Oct 2023 11:03:44 -0700 (PDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 7B60F14517D; Tue, 17 Oct 2023 14:03:43 -0400 (EDT)
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
In-Reply-To: <1a6f1768-fd48-42df-9f1a-4b203baf6ddf@kernel.org>
References: <20230927141828.90288-1-dlemoal@kernel.org>
 <20230927141828.90288-5-dlemoal@kernel.org>
 <87v8b73lsh.fsf@vps.thesusis.net>
 <0177ab41-6a7b-42ff-bf84-97d173efb838@kernel.org>
 <87r0luspvx.fsf@vps.thesusis.net>
 <1a6f1768-fd48-42df-9f1a-4b203baf6ddf@kernel.org>
Date:   Tue, 17 Oct 2023 14:03:43 -0400
Message-ID: <87y1g1unwg.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Damien Le Moal <dlemoal@kernel.org> writes:

> That one should be fixable, though it I do not see an elegant method to do it.
> It would be easy with ugly code, e.g. tweaking the scsi device runtime pm state
> from libata... Not great.

What would be not great about it?  libata already takes over the system
suspend/resume from sd.  I'm currently testing having libata do just
this right now.  I just got ahold of some jumpers today to put the
drives back into PuiS and do some further testing tonight.

> Never saw that in my tests when enabling runtime pm on the scsi disk only. Which
> is the important point here: there is no propagation of the suspend state down
> to the device parent it seems.

Last night I again saw the port auto suspend when the scsi disk was
runtime suspended.  Tonight I'll test with PuiS, as well as with system
resume while runtime suspended.  Maybe I'll even try to get the whole
AHCI controller to auto suspend.  It seems like it should once all of
the ports do.

> I am not sure of that, especially with cases of ATA ports with multiple disks
> (e.g. pmp or IDE).

Good point.  I have an eSATA dock with PMP.  I'll check tonight if the
children are counted properly.
