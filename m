Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16DC8C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 16:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3F5B61974
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 16:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhCVQXf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 12:23:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231181AbhCVQXH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Mar 2021 12:23:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1435F61974
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 16:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616430187;
        bh=ZKwB75ptbCttiwIRdgph/tLNjfcVuvaUI5k0eZFFB38=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=nys4mxaOLcU9stvTJFYMUKNXTX9iyGE+2z2aC9uSOVBnoPM9zWEQVIuYyvSadrWxl
         k5+a/ngMThDijMX6EiaxDaUnsIJnWb80ZFBYA7YZgmq44aoPxZ2sWuSVFh/PIeIeUm
         BM0KVfuV5OfMsTjyDW7lN2nr/McEtkx0p8s6GlwO2dnOgfoS+FIgpbMwRIMnBZ3B/p
         aypAOu4fe6+iDWq24Dtj//Z4v9pDEtQl23UoVlJ4bB9YzErG7Ris5kY880YnyO2vnj
         1yPr1AAmPeM9ScEZc1nIJ3MiGYe9XUUd8h4oJVsPylVEscBPW7P0YwbpkJWm/H/BON
         HAbZ5VpbsBWkw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212337] scsi_debug: race at module load and module unload
Date:   Mon, 22 Mar 2021 16:23:06 +0000
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
Message-ID: <bug-212337-11613-Db9cYci1Aw@https.bugzilla.kernel.org/>
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

--- Comment #9 from Luis Chamberlain (mcgrof@kernel.org) ---
(In reply to d gilbert from comment #8)

> >> The scsi_debug module option that is already in place is:
> >>     tur_ms_to_ready: TEST UNIT READY millisecs before initial good sta=
tus
> >> (def=3D0)
>=20
> You asked how it works, try:
>      modprobe scsi_debug tur_ms_to_ready=3D20000
>=20

That does not resolve the rmmod race against insmod:

scsi host2: scsi_debug: version 0190 [20200710]
[   42.213400]   dev_size_mb=3D8, opts=3D0x0, submit_queues=3D1, statistics=
=3D0
[   42.217527] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug       01=
90
PQ: 0 ANSI: 7
[   42.223346] scsi 2:0:0:0: Attached scsi generic sg0 type 0
[   42.282195] scsi host2: scsi_debug: version 0190 [20200710]
[   42.282195]   dev_size_mb=3D8, opts=3D0x0, submit_queues=3D1, statistics=
=3D0
[   42.288169] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug       01=
90
PQ: 0 ANSI: 7
[   42.292122] sd 2:0:0:0: Attached scsi generic sg0 type 0
[   42.292244] sd 2:0:0:0: Power-on or device reset occurred
[   42.302288] sd 2:0:0:0: [sda] Spinning up disk...

Then we wait...

[   44.308213] ...................ready
[   62.748919] sd 2:0:0:0: [sda] 16384 512-byte logical blocks: (8.39 MB/8.=
00
MiB)
[   62.754265] sd 2:0:0:0: [sda] Write Protect is off
[   62.763253] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled,
supports DPO and FUA
[   62.776965] sd 2:0:0:0: [sda] Optimal transfer size 524288 bytes
[   62.883817] sd 2:0:0:0: [sda] Attached SCSI disk

And then rmmod still fails.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
