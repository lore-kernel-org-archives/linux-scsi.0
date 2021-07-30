Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA68C4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jul 2021 20:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 291DB60E09
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jul 2021 20:31:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhG3UbL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Jul 2021 16:31:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230381AbhG3UbL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jul 2021 16:31:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ECC7660EB2
        for <linux-scsi@vger.kernel.org>; Fri, 30 Jul 2021 20:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627677066;
        bh=W9Sr0s/7bMQoUgsN/LDjW/jhg5k/e6IE7Yh13Dbr6j8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=o1wU4dlgqejEdE9XUk7JVhMo709B2BN9UM75bfAs6AqyqK4xHSGCD9B+eGW1f29k3
         xuXWJPStpSz11lZ9Jyo5pd1srt9zaMPfZESRNSazVlFSB+WtP12jphekih92qQWuwy
         6ODbQF45RLjiZ7rejHg5RU88FTauo9Y6xzdR80VWz57q6Lx3A1K4qQsyrYoOSkAj7f
         VH8jVeuv6anuRn2+0WET68QGEK79Rml2SgIycfDCa9xYbyLnLXH9F29dB3HfDg1hVj
         G6l3T4MUZK30C8RJCdyhykhXBRdF01SjZB4tIVYJNS/1zy6ncffG1yWCc6l95fwtt9
         SvKS1TJIulmhA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212337] scsi_debug: race at module load and module unload
Date:   Fri, 30 Jul 2021 20:31:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mcgrof@kernel.org
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-212337-11613-MAnYvvCAes@https.bugzilla.kernel.org/>
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

--- Comment #21 from Luis Chamberlain (mcgrof@kernel.org) ---
(In reply to Luis Chamberlain from comment #20)
> one can
> eventually run into a situation where the recnt can be see in
> /sys/module/scsi_debug/refcnt as 0 and yet rmmod can fail.
>=20
> This is not possible with linux-next.

This is false, the failure rate is just lower with linux-next, I see it aro=
und
1/1642 tries. I'll work on a reproducer but that is a separate issue, a gen=
eric
module issue which I'll address.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
