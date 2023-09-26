Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F9F4E7E649
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 15:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbjIZPVw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 11:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjIZPVv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 11:21:51 -0400
Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB4110A;
        Tue, 26 Sep 2023 08:21:44 -0700 (PDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 0B3EC13B602; Tue, 26 Sep 2023 11:21:44 -0400 (EDT)
References: <20230923002932.1082348-1-dlemoal@kernel.org>
 <20230923002932.1082348-20-dlemoal@kernel.org>
 <87msxaupig.fsf@vps.thesusis.net>
 <e3ddb272-4ff6-e5a7-7a4e-cb2acf0595d7@kernel.org>
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
Date:   Tue, 26 Sep 2023 11:01:54 -0400
In-reply-to: <e3ddb272-4ff6-e5a7-7a4e-cb2acf0595d7@kernel.org>
Message-ID: <87bkdpdkon.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien Le Moal <dlemoal@kernel.org> writes:

> I suspect you are talking about resume from hybernation here, where the drive
> may have been completely powered off... Yes, in such case, the drive will
> spinup, unless you have PUIS and enabled it.

The same thing happens in suspend / S3.

> Sure, but please do not have this delay this patch series. The problem you are
> describing above exists today already. This patch series is not making it worse,
> nor is it trying to solve it. And note that this issue is not just for ATA. SCSI
> devices locally attached to a machine that you hybernate will end up doing the
> same and spinup when power is restored...

You are saying that right now, the sd driver issues a START UNIT command
on system resume ( it looks like there's a flag you can set now to prevent
that ), then leaves the runtime pm state looking like the drive is still
suspended?  I thought it handled that correctly but I don't see any code
doing so right now.

If that's the case, then I suppose this series at least does not make
things worse...
