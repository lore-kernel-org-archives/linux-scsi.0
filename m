Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6848C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 18:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A3B364E4B
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 18:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhBSSoJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Feb 2021 13:44:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229766AbhBSSoJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Feb 2021 13:44:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id EAC9464E86
        for <linux-scsi@vger.kernel.org>; Fri, 19 Feb 2021 18:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613760209;
        bh=THRDOK/YHZq6o8RLkcb9Qi0EPneMEnFFB11iysSaqrQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fWq/r8ea5UxqC62sHGMrdEIOHKtu11fYJwWB/D87otfS3EQwpsTWPI9PhcACE0tCV
         WyWZFJPaDqucrwT1edkw5RDVwoQ+Y9dGa1GM/7uDkTX/fJAEGJ6kMYc0tU2MLvxSa0
         h17BGMAIvSo56oJmLG3SnRIhJM38Kz61XIDAMwZPVBbfAzt+JWCrlbM9zioYantqp5
         pKQUeRIMhD9sREFdNMh2ZexYEs6wtwamp9OJy/cxVLrxaAenjxtD1Y9fNvmicYQz4r
         2rtWvgYwhRoWuWTGSG04H52dXpFG5Kv5IPMiGFnu9t+oIRGuA1xXRTScyKyuwT7oPB
         jI2K80W/r56Bg==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 211227] [BISECTED][REGRESSION] Linux 5.10.7 breaks s3 resume on
 opal encrypted ssd
Date:   Fri, 19 Feb 2021 18:43:28 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bvanassche@acm.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-211227-11613-AERDnSaCoD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-211227-11613@https.bugzilla.kernel.org/>
References: <bug-211227-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D211227

--- Comment #1 from Bart Van Assche (bvanassche@acm.org) ---
Thank you for having reported this. Please apply the attached patch to kern=
el
v5.11 and report which kernel warnings are reported when booting the result=
ing
patched kernel. Please note that the attached patch is not a fix but rather=
 an
attempt to extract more information about how the SED OPAL code is incompat=
ible
with the Linux power management model.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
