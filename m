Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF787ECAAA1
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Sep 2022 07:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbiIFHny (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Sep 2022 03:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiIFHnx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2022 03:43:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600A326AE7
        for <linux-scsi@vger.kernel.org>; Tue,  6 Sep 2022 00:43:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CA9DB815A0
        for <linux-scsi@vger.kernel.org>; Tue,  6 Sep 2022 07:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4AECC433B5
        for <linux-scsi@vger.kernel.org>; Tue,  6 Sep 2022 07:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662450229;
        bh=jSigw2SxWWoL+4P/fVyaPZq8tl2ygvYvQW+RzFGLZ4Q=;
        h=From:To:Subject:Date:From;
        b=XECdZUk0mmqi517DIUSYe4DVm7usksg1JnG3RUTsOwBttDyCrh3Y6iHZeo3gcevYp
         6RgFyGqha7TjbJdWW1IImVQvNyf++0jcSIfTsnqfMJ8WsMFjDV+P1ka/HQ3IVLJYyL
         c4NndRemjQov7uTY5UNpyNOYIIcAIrD1bBEs3bP4lLcdRExtjXp3Kj/5H3kP+dLArw
         RSVh4WFZDK8KIrQuKgI+5Sdti6ITvm0XDq5VEzx3kspJRP+rXyg66b5/wH6FIiP7Y3
         YpPHt4KsiU142ZTtvxC7ZrGozIbp6bVtqeTjxGzOXaeiSGotVujJ6M6Gdu+fJdwy2R
         5Ncvz4bFPxpdQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id CDF06C433E6; Tue,  6 Sep 2022 07:43:49 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216454] New: scsi: megaraid_sas: possible use-after-free caused
 by bad error handling in megasas_probe_one()
Date:   Tue, 06 Sep 2022 07:43:49 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: r33s3n6@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-216454-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216454

            Bug ID: 216454
           Summary: scsi: megaraid_sas: possible use-after-free caused by
                    bad error handling in megasas_probe_one()
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 5.10.0
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: r33s3n6@gmail.com
        Regression: No

Hello,

Our fault injection tool finds a possible use-after-free in the=20
megaraid_sas driver in Linux 5.10.0:

In the file drivers/scsi/megaraid/megaraid_sas_base.c:
In megasas_io_attach(), the call to scsi_add_host() may fail:=20
6814:   if (scsi_add_host(host, &instance->pdev->dev)) {
            ...
6818:           return -ENODEV;
6819:   }

This error is then propagated to its caller megasas_probe_one().
7414:   if (megasas_io_attach(instance))
7415:           goto fail_io_attach;

In error handling code of megasas_probe_one(), it calls scsi_host_put():
7457:   scsi_host_put(host);

The function scsi_host_put() calls scsi_host_dev_release() to free `host`,
which contains a variable `instance`.

But megasas_probe_one() calls megasas_init_fw() before:
7372:   if (megasas_init_fw(instance))

In megasas_init_fw(), it starts a timer:
6369:   megasas_start_timer(instance);

And megasas_probe_one() does nothing about it in error handling code. When
the timer expires, it accesses `instance`, causing a use-after-free bug.

I am not quite sure how to fix this possible bug. Any feedback would be
appreciated, thanks!

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>

Best wishes,
Zixuan Fu

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
