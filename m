Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55CFDCD13B1
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 19:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236999AbjIOTdX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 15:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237001AbjIOTdH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 15:33:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D6719A9
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 12:33:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E71FC433C9
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 19:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694806382;
        bh=VT1V4cENLhcEh9aQTufxnnY22ZQzaaNuWaEC9amFqtQ=;
        h=From:To:Subject:Date:From;
        b=iqyqGKGgozxjQcBPtAi7UrY5a8YfOjm1Fzm63mkG/zP4WBqDwjStOhftUUpgKxvWp
         mlPZUN5w3TzXk4TyOlYC7U6cWp6f8AnHgVEgibJWYz/K+UZrChuCBUmlo4oAJ4x9s8
         epc82WdHl5rt9FfUVqAkU89zxgh2MmXQ3oEQhergCmOX+rwFAhNSEWReqlMaDydDth
         eo73ImNnd1wkouFzNu0VfVqhKyoN1TYwPAWqhAaWltkYys5dCd9lhKdm9mpFRd+S8X
         h8Pp/9b/eWUab6Ut73xOnwR0z1gt2MT701Qz4lnavjIBm2yJypILwWSIrmfTfqKRih
         LF+8NOulZCYfQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id EDE85C53BC6; Fri, 15 Sep 2023 19:33:01 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217914] New: scsi_eh_1 process high cpu after upgrading to 6.5
Date:   Fri, 15 Sep 2023 19:33:01 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: laktak@cdak.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression cf_bisect_commit
Message-ID: <bug-217914-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217914

            Bug ID: 217914
           Summary: scsi_eh_1 process high cpu after upgrading to 6.5
           Product: IO/Storage
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: high
          Priority: P3
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: laktak@cdak.net
        Regression: Yes
           Bisected 624885209f31eb9985bf51abe204ecbffe2fdeea
         commit-id:

Overview:

Several users report that after upgrading from 6.4.12 to 6.5 the process
scsi_eh_1 will constantly consume >10% CPU resources. This happens most oft=
en
in VMs.

Steps to Reproduce:

- Create a VM (e.g. VMware Fusion)
- Create an SCSI disk
- Connect a virtual CD ROM (IDE)
- Boot a 6.4.12 kernel
- Boot a 6.5 kernel

Actual Results:

- no issues for the 6.4.12 kernel
- scsi_eh consumes too much CPU with the 6.5 kernel

Expected Results:

scsi_eh should not consume significant resources.

Build Date & Hardware:

Linux arch 6.5.2-arch1-1 #1 SMP PREEMPT_DYNAMIC Wed, 06 Sep 2023 21:01:01 +=
0000
x86_64 GNU/Linux
inside a VMware Fusion VM

Additional Builds and Platforms:

Other users were able to reproduce the error on bare metal hardware.

Additional Information:

More details can be found in this thread:
https://bbs.archlinux.org/viewtopic.php?id=3D288723

The users loqs and leonshaw helped to narrow it down to this commit:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D624885209f31eb9985bf51abe204ecbffe2fdeea

good: 6.4.0-rc1-1-00007-g152e52fb6ff1
bad: 6.4.0-rc1-1-00008-g624885209f31

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
