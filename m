Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEDF6C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 05:19:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A672A60551
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 05:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236140AbhHJFTm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 01:19:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232230AbhHJFTm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 01:19:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 93BCF60EC0
        for <linux-scsi@vger.kernel.org>; Tue, 10 Aug 2021 05:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628572760;
        bh=6SVcGUC4sOYHw+y3ZwGDNjTXkYglKso8cVGQj2opCDw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=l3tjDucc+dAuI2hCynD7wX6eWv6s+atdkwBIt1sj4XgtAZ3ChVZOry/ETjfDyV6D+
         WAdFED3qyDgIxyR1s0NYqf5mn7poz0HOGJUeweSEKLg1Lnxw2GcE7LPUcB+dFlLwRL
         3K8cNkClQHK+ZzwqVrEeDtU0dPhx0DmtPfdfktWEC0mr32KGcylGW9zgYIdVKA40tC
         Lk4B7bpK9qsQmrtDZG7MyXjLDuAFRTCfaG15BLcNwJYt772h4ivTHxIjknvrKSRcbp
         O7QfHuLatvGd03ml3njlLU30B47Fpr1NeRusMpkK6ENQVqG2qMHUM3vZYbGW3wsqFG
         biBIRidvNuT7A==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212337] scsi_debug: race at module load and module unload
Date:   Tue, 10 Aug 2021 05:19:20 +0000
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
Message-ID: <bug-212337-11613-235dSOC4jh@https.bugzilla.kernel.org/>
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

--- Comment #22 from Luis Chamberlain (mcgrof@kernel.org) ---
(In reply to Luis Chamberlain from comment #21)
> (In reply to Luis Chamberlain from comment #20)
> > one can
> > eventually run into a situation where the recnt can be see in
> > /sys/module/scsi_debug/refcnt as 0 and yet rmmod can fail.
> >=20
> > This is not possible with linux-next.
>=20
> This is false, the failure rate is just lower with linux-next, I see it
> around 1/1642 tries. I'll work on a reproducer but that is a separate iss=
ue,
> a generic module issue which I'll address.

I am tracking those failures and proposed fixes on korg#214015

[0] https://bugzilla.kernel.org/show_bug.cgi?id=3D214015

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
