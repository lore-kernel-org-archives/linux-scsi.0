Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F392C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 19:23:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E46DD64F40
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 19:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbhCRTW7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 15:22:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232814AbhCRTW3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Mar 2021 15:22:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E1DA064F40
        for <linux-scsi@vger.kernel.org>; Thu, 18 Mar 2021 19:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616095346;
        bh=+kmayytRLzFLqs006+MFtfC5Zv1KOCALxrnDc0k0AXQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=IkviHX1okrZhawhLo04+tHTkrFYxj7P0om01kHH7iWjgEvWnDAAv0vtV/vgqJMBqc
         7LhnrRsOAxH8pYowkHq3sc/OoQXvTsPn8u21lwx1EsopFlRg4wsrGH4KnKbs9BiMTK
         EV398f62hjg2izJzJ0yynzpUfhlj9MjPZMwDj6hDlf4+DBvNYOhwA6LuhYmTp+Hr+K
         k7M3KUMa+0VnoT5WvWkbop+rbnOJ3eqIZZYML9ffbqcxvQx5HLvd0g0hI7YAfC6O29
         yoBl8vINF0wcTwivubKaz4t3NUpocLAr2dcrVe12Vhw/b/DeywMN4IrtQMF1CGspir
         LhSZQVlZnGIrw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212337] scsi_debug: race at module load and module unload
Date:   Thu, 18 Mar 2021 19:22:26 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mcgrof@kernel.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: WILL_NOT_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-212337-11613-k8xVbNHAOY@https.bugzilla.kernel.org/>
In-Reply-To: <bug-212337-11613@https.bugzilla.kernel.org/>
References: <bug-212337-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D212337

--- Comment #6 from Luis Chamberlain (mcgrof@kernel.org) ---
(In reply to Luis Chamberlain from comment #5)
> (In reply to Luis Chamberlain from comment #4)
> > (In reply to d gilbert from comment #3)
> > > Of course, commencing device teardown during an async scan is stress
> > testing
> > > that code.
> >=20
> > I'm afraid scsi_debug is filled with bug bombs bound to happen, because=
 it
> > was written without certain consideration of races now coming up as
> tangible
> > with syfs / driver load. Namely, if you hold a lock at init and also us=
e it
> > on sysfs attributes you can easily deadlock. I discovered this issue fi=
rst
> > with the zram driver, and fixed the issue with try_module_get()'s on ea=
ch
> > driver sysfs attribute, I posted patches for that, for discussion on th=
at
> > see the post [0] [1], although discussion is mostly on the first patch,=
 the
> > patch you want to look at is the second one [1].
> >=20
> > [0] https://lkml.kernel.org/r/20210306022035.11266-2-mcgrof@kernel.org
> > [1] https://lkml.kernel.org/r/20210306022035.11266-3-mcgrof@kernel.org
> >=20
> > I considered fixing scsi_debug in light of this, but given that module
> > initialization is *also* calling helpers used by syfs attributes, *and*
> this
> > is also true at module removal, I'm afraid much more care is needed her=
e.
> In
> > my patch to zram for the sysfs issue I mention ways to trigger the
> deadlock,
> > if you're up for the task to fix that, it would be wonderful. But hey,
> these
> > are separate issues. just figured you should be aware.
>=20
> That was a long winded way of saying -- yes stress testing async scan +
> teardown may be good, but at this point in time *these* other issues I th=
ink
> are of higher priority before one can even consider stress testing async
> scan + teardown.
>=20
> Oh and also, someone should probably consider if this is required or not,=
 I
> have a hunch it may, but not sure:
>=20
> commit 48f3c4f354ce113f45cb5adbebe0f1f06f1487f7
> Author: Luis Chamberlain <mcgrof@kernel.org>
> Date:   Thu Mar 18 15:22:34 2021 +0000
>=20
>     scsi_lib: try module get before running queue
>=20=20=20=20=20
>     Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index ffe824782647..0af38f8936e4 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -22,6 +22,7 @@
>  #include <linux/scatterlist.h>
>  #include <linux/blk-mq.h>
>  #include <linux/ratelimit.h>
> +#include <linux/module.h>
>  #include <asm/unaligned.h>
>=20=20
>  #include <scsi/scsi.h>
> @@ -1527,6 +1528,12 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>=20=20
>       }
>=20=20
> +     if (!try_module_get(host->hostt->module)) {
> +             cmd->result =3D (DID_NO_CONNECT << 16);
> +             goto done;
> +
> +     }
> +
>       trace_scsi_dispatch_cmd_start(cmd);
>       rtn =3D host->hostt->queuecommand(host, cmd);
>       if (rtn) {
> @@ -1538,6 +1545,7 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>               SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
>                       "queuecommand : request rejected\n"));
>       }
> +     module_put(host->hostt->module);
>=20=20
>       return rtn;
>   done:

I should explain a bit more here. Refcounting on the driver's queuecommand(=
) is
possible for sure, *but* in scsi_debug's case its quite complex given we ha=
ve 3
ways to queue commands:

  * right away
  * work queue
  * hrtimer

Yes, you can refcount at the top, but the code is easier to manage / if the
library does it. And if its indeed correct, better it goes there.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
