Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5427EB64DC
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Jul 2023 23:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjGIXSl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Jul 2023 19:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjGIXSk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Jul 2023 19:18:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93395114
        for <linux-scsi@vger.kernel.org>; Sun,  9 Jul 2023 16:18:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D74760CA5
        for <linux-scsi@vger.kernel.org>; Sun,  9 Jul 2023 23:18:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7A320C433B7
        for <linux-scsi@vger.kernel.org>; Sun,  9 Jul 2023 23:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688944718;
        bh=rp4jufj0DwdMa89/hDl4Yh0pHRIH1iLfSz+JzJMbTuk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hAoK+Fin1voUxriO8JbLSPvcIVcdDeepFJ3tuU9OiO8UgNAdAj9jGkERi8KdkUNch
         gaH9VpJvvafNw/ecI69GrIC2/dd7UJlQyDP9n+SLsI52k/6hpUSL+RgVNRXX62yj1O
         +Lh1NsAvH5RDqSAg+gU/3jCtl4xkJS8RUgnPqdB/h2GSBotVwbZshjBtMYtFbHFZLa
         C0WfzO/XZnul0Kj1sAZ10Si3qrT1s4zVznpNLPo6XtyPW0OLsMrQXtZE2Dd+cKwq3Y
         Whv7p7XfQO1cp0d7u06rx9bGp1q+4dIy8tMxI2W8gs8dwZowriOlJlM+dLrJ3kD4jm
         rvN1xsX4gpzKA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6BC93C53BCD; Sun,  9 Jul 2023 23:18:38 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Sun, 09 Jul 2023 23:18:37 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: damien.lemoal@wdc.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215880-11613-AkdOc2TMQE@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215880-11613@https.bugzilla.kernel.org/>
References: <bug-215880-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215880

--- Comment #46 from Damien Le Moal (damien.lemoal@wdc.com) ---
(In reply to Paul Ausbeck from comment #44)
> I'd like to add that I've also noticed this regression after upgrading fr=
om
> Debian 11/5.10 to Debian 12/6.1

> I've copied the resume portion of the dmesg log below. Note that the pci =
bus
> activity and related gpu messages don't happen until after my 10 year old
> 2TB hdd spins up. Restarting of tasks is also deferred until then. I also
> note that the mouse cursor is also frozen until all those platters spin u=
p..

The GPU related messages are unrelated to ATA subsystem. Obviously, libata =
does
not attempt to use the GPU for anything :) Restarting of tasks being differ=
ed
until the hdd spins up is also normal. hdd spinning up and then starting
responding to commands is part of the normal resume process and tasks will =
be
resumed only after the kernel has finished resuming all devices. Resuming of
devices is asynchronous and devices that are unrelated can be resumed
simultaneously. So I am not sure why it seems that your GPU and mouse resum=
ing
is delaying only after the HDD spin up. Note that this change to asynchrono=
us
resume did cause some issues with ata/scsi (see below).

> To my mind, it would be a major improvement/tour de force if linux could
> defer spinning up the hdd at all until it is needed. Think of all the dri=
ve
> wear and energy savings that would ensue. I use my 2TB hdd for backing up
> smaller drives and for storing movies. It would be quite nice if the drive
> were to not spin up at all until accessed.

Having the drive sleep when unused can be achieved using power state timers
setting on the drive itself. Resume is different: the kernel must ensure th=
at
the device that was there before suspend is still here, and in the case of
storage, that the device is still the same. This is necessary to avoid issu=
es
with file system (that will resume later) and also with tasks that were doi=
ng
IOs when the system was suspended. If file systems or tasks were resumed
without the storage device ready and checked first, all sorts of bad things=
 can
happen.

Note that commit 6aa0365a3c85 ("ata: libata-scsi: Avoid deadlock on rescan
after device resume") was added to kernel 6.4 (at rc7) to fix another issue
with resume: a hard hang (not a delay). This patch synchronizes scsi and ata
resume by having scsi resume wait for ata resume to complete, which means
waiting for the device re-scan to complete. And that in turn means that the=
 HDD
must complete spin up first.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
