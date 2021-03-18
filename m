Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5909AC433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 19:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AE0964F2B
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 19:20:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbhCRTUT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 15:20:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229996AbhCRTUA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Mar 2021 15:20:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4CFEE64F30
        for <linux-scsi@vger.kernel.org>; Thu, 18 Mar 2021 19:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616095200;
        bh=x9Io/SYj5QDF2B9wHzp+quflyOC1NlRhf5Wseinkvzg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Iae2ysM1CBZZ6wULSvS2CEIUr4bI/hwy7dakgIbcwBpfmsAje71ENJpuOs1waNtPj
         235a0NWgF3B9W6tlULD03NLwKCVld39bH2QH3AvKS+fx1luXEbqirK0pz1xmpufiWL
         NFmBC/t1O1YTEDlx4/VBuuEJb/xj957iqoRXaKH8CpbO8mYiZhzaUAr9BsmWhc3sw8
         9BTH/uiyf21vRIq3VlwknZa3XQbO5dYYFUeXSPoFVpYc+thKzovWwKx5UAr3vUx0uW
         jIB1G8LQ587MvsPPYJ0UIm6lIptzSwkqtYDZti76RnvL8rAMvUtk0pCq1PCnwubGmb
         NwPmY2bnJdBFQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212337] scsi_debug: race at module load and module unload
Date:   Thu, 18 Mar 2021 19:20:00 +0000
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
Message-ID: <bug-212337-11613-EPKCduzKsp@https.bugzilla.kernel.org/>
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

--- Comment #5 from Luis Chamberlain (mcgrof@kernel.org) ---
(In reply to Luis Chamberlain from comment #4)
> (In reply to d gilbert from comment #3)
> > Of course, commencing device teardown during an async scan is stress
> testing
> > that code.
>=20
> I'm afraid scsi_debug is filled with bug bombs bound to happen, because it
> was written without certain consideration of races now coming up as tangi=
ble
> with syfs / driver load. Namely, if you hold a lock at init and also use =
it
> on sysfs attributes you can easily deadlock. I discovered this issue first
> with the zram driver, and fixed the issue with try_module_get()'s on each
> driver sysfs attribute, I posted patches for that, for discussion on that
> see the post [0] [1], although discussion is mostly on the first patch, t=
he
> patch you want to look at is the second one [1].
>=20
> [0] https://lkml.kernel.org/r/20210306022035.11266-2-mcgrof@kernel.org
> [1] https://lkml.kernel.org/r/20210306022035.11266-3-mcgrof@kernel.org
>=20
> I considered fixing scsi_debug in light of this, but given that module
> initialization is *also* calling helpers used by syfs attributes, *and* t=
his
> is also true at module removal, I'm afraid much more care is needed here.=
 In
> my patch to zram for the sysfs issue I mention ways to trigger the deadlo=
ck,
> if you're up for the task to fix that, it would be wonderful. But hey, th=
ese
> are separate issues. just figured you should be aware.

That was a long winded way of saying -- yes stress testing async scan +
teardown may be good, but at this point in time *these* other issues I think
are of higher priority before one can even consider stress testing async sc=
an +
teardown.

Oh and also, someone should probably consider if this is required or not, I
have a hunch it may, but not sure:

commit 48f3c4f354ce113f45cb5adbebe0f1f06f1487f7
Author: Luis Chamberlain <mcgrof@kernel.org>
Date:   Thu Mar 18 15:22:34 2021 +0000

    scsi_lib: try module get before running queue

    Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ffe824782647..0af38f8936e4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -22,6 +22,7 @@
 #include <linux/scatterlist.h>
 #include <linux/blk-mq.h>
 #include <linux/ratelimit.h>
+#include <linux/module.h>
 #include <asm/unaligned.h>

 #include <scsi/scsi.h>
@@ -1527,6 +1528,12 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)

        }

+       if (!try_module_get(host->hostt->module)) {
+               cmd->result =3D (DID_NO_CONNECT << 16);
+               goto done;
+
+       }
+
        trace_scsi_dispatch_cmd_start(cmd);
        rtn =3D host->hostt->queuecommand(host, cmd);
        if (rtn) {
@@ -1538,6 +1545,7 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
                SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
                        "queuecommand : request rejected\n"));
        }
+       module_put(host->hostt->module);

        return rtn;
  done:

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
