Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B17E7E649
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 15:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbjIZPgN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 11:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjIZPgM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 11:36:12 -0400
Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77308116;
        Tue, 26 Sep 2023 08:36:05 -0700 (PDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id B6E5D13B615; Tue, 26 Sep 2023 11:36:04 -0400 (EDT)
References: <20230923002932.1082348-1-dlemoal@kernel.org>
 <20230923002932.1082348-6-dlemoal@kernel.org>
 <87r0mmux6s.fsf@vps.thesusis.net>
 <613610e3-5eaf-f3f9-005c-f9a3903b6e3c@kernel.org>
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
Subject: Re: [PATCH v6 05/23] ata: libata-scsi: Disable scsi device
 manage_system_start_stop
Date:   Tue, 26 Sep 2023 11:25:53 -0400
In-reply-to: <613610e3-5eaf-f3f9-005c-f9a3903b6e3c@kernel.org>
Message-ID: <877coddk0r.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien Le Moal <dlemoal@kernel.org> writes:

> However, regarding the SET FEATURES command to spin up the drive, you are
> confusing the basic power management (STANDBY IMMEDIATE command support), which
> is a mandatory feature of ATA disks, with the Extended Power Conditions (EPC)
> feature set, which is optional. The latter one defines the behavior of the SET
> FEATURES command with the Extended Power Conditions subcommand to control the
> disk power state and power state transitions timers. The former, basic power
> management, does NOT have this. So trying what you suggest would only work for
> drives that support and enable EPC. Given that EPC is optional, and that we are
> not probing/supporting it currently in libata, we cannot rely on that.

I'm talking about PuiS.  At least with my 10 year old WD 1 TB blue
drives, if I enable PuiS, the drive will not spin up if you give it a
READ or VERIFY command, you have to give it the SET FEATURES command.
The kernel currently does this when it sees the drive requires it.

> That already is all taken care of. That is the basics for even the initial scan
> on boot where we send commands to the disk while it is still spinning up. The
> timeout I am mentioning is the drive not responding at all because it is spun
> down, no matter how many times one retries. And given that the ATA specs clearly
> define that a drive should not change its power state with a reset, even the
> reset after the command timeout does not change anything with some drives (I do
> have some drives that actually spin up on reset, but many that don't, as per spec).

I believe the idea of "reset" here within the context of the ATA spec is
the reset bit in the ATA TaskFile, not a hardware reset, or even an SATA
link reset.  Those genereally DO spin up the disk unless it has PuiS enabled.

> Exactly. As you said yourself, there are some drives that will not report
> everything unless they are spun up. And I have some old drives that really do
> not like receiving that command at all while spun down. So the safer approach
> taken is to spinup the drive upfront, before doing anything else.

I'd prefer to be able to avoid spinning up disks on system resume, but
my point was that if you want it to spin up, a VERIFY command might not
work.  For some drives with PuiS enabled, you have to use the SET
FEATURES command to spin it up.

> PUIS is another optional feature that we do not directly support in the kernel.
> If you want/need that, patches are welcome. With detection of that feature
> added, we could improve resume and avoid useless drive spinup. That is currently
> outside the scope of this series since we are not supporting PUIS currently.

The kernel at least currently issues the SET FEATURE command to wake a
drive with PuiS enabled, if it says that it needs that.  I hope this
patch series does not break that.
