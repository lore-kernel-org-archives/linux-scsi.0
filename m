Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B609ECAAA3
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Aug 2022 21:24:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbiHYVYa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Aug 2022 17:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiHYVY2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2022 17:24:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D083BB923
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 14:24:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B273EB82E96
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 21:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5BFB9C43470
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 21:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661462664;
        bh=EGiawnj8tuA1Z+w1fdCpXgqj9BTDBQOYFquyzUCG45g=;
        h=From:To:Subject:Date:From;
        b=Gmb9u03kLDqBY3ksPjwxw+ZIerFeky3VdvVRzqw5ICqi7xWU3Z9GOu2Yg8brXYaYI
         X4ntqmpYmMgKdCtV/u4iDicDEpydO4nhHoxoM2UOztd3E1LDyR4p7Yp2+U7nQvvINu
         d6cO8Xi+a32N1S7TGLTHBCD3LPKt+hZpCuMB7SKvMlr/YsEAickFo1IC3jbCX0ifDe
         zCYP8jJjS+kbDKZN+GCJ4QmvonYt4yh08uSYdr0+b2nFdiPtYavdX+r+J9X0iTAOV3
         cc6EZMNFoA7P37Bnq2Ig4b0e3tkC68MhS519JAEEOK4M3KE4vyc6Xt3c1ysH4GzqLn
         Cu+17sYrQbLAw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 38E22C433E4; Thu, 25 Aug 2022 21:24:24 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216413] New: [BISECT INCLUDED] scsi/sd Rework asynchronous
 resume support breaks S2idle and S3 on several systems
Date:   Thu, 25 Aug 2022 21:24:23 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: todd.e.brandt@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: bvanassche@acm.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cc blocked cf_regression
Message-ID: <bug-216413-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216413

            Bug ID: 216413
           Summary: [BISECT INCLUDED] scsi/sd Rework asynchronous resume
                    support breaks S2idle and S3 on several systems
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 6.0.0-rc1
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: SCSI
          Assignee: bvanassche@acm.org
          Reporter: todd.e.brandt@intel.com
                CC: bvanassche@acm.org, lenb@kernel.org,
                    linux-scsi@vger.kernel.org, martin.petersen@oracle.com
            Blocks: 178231
        Regression: No

A commit in 6.0.0-rc1 has caused S2idle and S3 (freeze & mem) to completely
hang the system on these 4 machines in our lab:

1) Clevo System76 Lemur 6
2) Lenovo Yoga 2 Pro
3) Dell Inspiron 3493
4) HP Pavillion x360

To reproduce the issue simply run kernel 6.0.0-rc1 or newer on these systems
and run "sudo sleepgraph -m freeze" or "sudo sleepgraph -m mem". The system
will hang after that.

I've bisected the problem to this specific commit:

88f1669019bd62b3009a3cebf772fbaaa21b9f38 is the first bad commit
commit 88f1669019bd62b3009a3cebf772fbaaa21b9f38
Author: Bart Van Assche <bvanassche@acm.org>
Date:   Thu Jun 30 12:57:03 2022 -0700

    scsi: sd: Rework asynchronous resume support

    For some technologies, e.g. an ATA bus, resuming can take multiple
    seconds. Waiting for resume to finish can cause a very noticeable delay.
    Hence this commit that restores the behavior from before "scsi: core: p=
m:
    Rely on the device driver core for async power management" for most SCSI
    devices.

    This commit introduces a behavior change: if the START command fails, do
    not consider this as a SCSI disk resume failure.

    Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D215880
    Link: https://lore.kernel.org/r/20220630195703.10155-3-bvanassche@acm.o=
rg
    Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for
async power management")
    Cc: Ming Lei <ming.lei@redhat.com>
    Cc: Hannes Reinecke <hare@suse.de>
    Cc: John Garry <john.garry@huawei.com>
    Cc: ericspero@icloud.com
    Cc: jason600.groome@gmail.com
    Tested-by: jason600.groome@gmail.com
    Signed-off-by: Bart Van Assche <bvanassche@acm.org>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

:040000 040000 dbd390c19cfddba2b559b06691404aee4c165384
54c7fa67e3a1605878999bdf1e39a95ca793238a M      drivers


Referenced Bugs:

https://bugzilla.kernel.org/show_bug.cgi?id=3D178231
[Bug 178231] Meta-bug: Linux suspend-to-mem and freeze performance optimiza=
tion
--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.=
