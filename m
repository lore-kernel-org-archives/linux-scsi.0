Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0737E9270F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Oct 2023 14:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbjJEOez (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Oct 2023 10:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235569AbjJEOdO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2023 10:33:14 -0400
X-Greylist: delayed 524 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 05 Oct 2023 05:47:41 PDT
Received: from vps.thesusis.net (vps.thesusis.net [IPv6:2600:1f18:60b9:2f00:6f85:14c6:952:bad3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47BEA26A5E;
        Thu,  5 Oct 2023 05:47:41 -0700 (PDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id BC7A613ED3A; Thu,  5 Oct 2023 08:38:55 -0400 (EDT)
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
In-Reply-To: <b8439234-8833-7fc5-e19f-ad8942b003ef@kernel.org>
References: <20230927141828.90288-1-dlemoal@kernel.org>
 <874jj8sia5.fsf@vps.thesusis.net> <87h6n87dac.fsf@vps.thesusis.net>
 <269e2876-58fd-b73c-0c0d-1593c17c2809@kernel.org>
 <ZRyGIE+NpmtMu7XK@thesusis.net>
 <3aae2b14-ce32-261a-46a4-cc8d5f3adab4@kernel.org>
 <875y3mumom.fsf@vps.thesusis.net>
 <b8439234-8833-7fc5-e19f-ad8942b003ef@kernel.org>
Date:   Thu, 05 Oct 2023 08:38:55 -0400
Message-ID: <87sf6pckgw.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Damien Le Moal <dlemoal@kernel.org> writes:

>> This never happens when I am normally using the debian kernel with no
>> runtime pm and just running hdparm -y to put the drives to sleep.  I can
>> check them hours later and they are still in standby.
>
> Same user space in that case ?

Yes.  I'll try to leave a blktrace running to see what causes the
spinup.  I suppose it could be another flush or other command that
doesn't require media access, but triggers runtime pm to spin up the disk.

> Given your description, that is my thinking exactly. The problem here for the
> second part (spinning up the disk for "useless" commands) is that determining if
> a command needs the drive to spinup or not is not an easy thing to do, and
> potentially dangerous if mishandled. One possible micro optimization would be to
> ignore flush commands to suspended disks. But not sure that is a high win change
> beside *may be* avoiding a spinup on system suspend witha drive already runtime
> suspended.

One of the things my patch series from a decade ago did was to use the
SLEEP flag in libata to decide to complete certain commands without
sending them to the drive so it could remain asleep.  I'm not sure if
it's even possible for the driver to evaluate the command before the pm
core orders a resume though.

I wonder if libata could leave the EH pending and return success from
the runtime resume, and then actually run the EH and wake up the drive
later, when actual IO is done.

On another note, I've been looking over your patches, and I still do not
understand why you added the VERIFY command.  The only effect it seems
to have is moving the delay while the drive spins up from the first real
IO to the resume path.  Why does that matter?

