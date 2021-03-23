Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3679CC433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 00:38:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBBC4619A8
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 00:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhCWAiP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 20:38:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230166AbhCWAiB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Mar 2021 20:38:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DC5D5619AC
        for <linux-scsi@vger.kernel.org>; Tue, 23 Mar 2021 00:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616459880;
        bh=yAFd+yZ9D8T/tv7KtWlhcEdsIdD+FEIwxeJWNja90Kk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=NwGfj13m5+0W0+GGCExeN6GqMlgm2GeFqFQBmlrUIw7eNvkd/iKZe3wqtnLVJFr1j
         9DkOf2DTLMYEVY/RVdj0eLaGfuhefzOJ0Y4fpuhymOA5YSjpGKukZJl2LLRF1DBL5k
         A3cjF5dLAcwNmKR90xT4b7StCATCStAOltVVxdYd2R4dZQGJxQfXNvy39nf2vClrKf
         20YjXtRRczKpFIahBLmM0eni0KjG3WG6nIyxUv3qrCA3A1wT3sWEJbpS9e1XU2uYV4
         OtxRlAsTVht2uRASqIx+/lWh48l+s3RwATh3w9QWcpPCDBPxOSfgL312+Ykh0nUBLP
         oLPdj9gQGVwmQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212337] scsi_debug: race at module load and module unload
Date:   Tue, 23 Mar 2021 00:38:00 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dgilbert@interlog.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: WILL_NOT_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-212337-11613-U59h1KhdjV@https.bugzilla.kernel.org/>
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

--- Comment #12 from d gilbert (dgilbert@interlog.com) ---
On 2021-03-22 12:23 p.m., bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D212337
>=20
> --- Comment #9 from Luis Chamberlain (mcgrof@kernel.org) ---
> (In reply to d gilbert from comment #8)
>=20
>>>> The scsi_debug module option that is already in place is:
>>>>      tur_ms_to_ready: TEST UNIT READY millisecs before initial good st=
atus
>>>> (def=3D0)
>>
>> You asked how it works, try:
>>       modprobe scsi_debug tur_ms_to_ready=3D20000
>>
>=20
> That does not resolve the rmmod race against insmod:
>=20
> scsi host2: scsi_debug: version 0190 [20200710]
> [   42.213400]   dev_size_mb=3D8, opts=3D0x0, submit_queues=3D1, statisti=
cs=3D0
> [   42.217527] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug       =
0190
> PQ: 0 ANSI: 7
> [   42.223346] scsi 2:0:0:0: Attached scsi generic sg0 type 0
> [   42.282195] scsi host2: scsi_debug: version 0190 [20200710]
> [   42.282195]   dev_size_mb=3D8, opts=3D0x0, submit_queues=3D1, statisti=
cs=3D0
> [   42.288169] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug       =
0190
> PQ: 0 ANSI: 7
> [   42.292122] sd 2:0:0:0: Attached scsi generic sg0 type 0
> [   42.292244] sd 2:0:0:0: Power-on or device reset occurred
> [   42.302288] sd 2:0:0:0: [sda] Spinning up disk...
>=20
> Then we wait...
>=20
> [   44.308213] ...................ready
> [   62.748919] sd 2:0:0:0: [sda] 16384 512-byte logical blocks: (8.39 MB/=
8.00
> MiB)
> [   62.754265] sd 2:0:0:0: [sda] Write Protect is off
> [   62.763253] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enable=
d,
> supports DPO and FUA
> [   62.776965] sd 2:0:0:0: [sda] Optimal transfer size 524288 bytes
> [   62.883817] sd 2:0:0:0: [sda] Attached SCSI disk
>=20
> And then rmmod still fails.
>=20

Just to explain a bit more about tur_ms_to_ready, that does not effect SCSI
commands like REPORT LUNS, INQUIRY and REQUEST SENSE, but does slow down all
"media access" commands including TEST UNIT READY (TUR) and READ CAPACITY. =
So
if you watch what is happening with 'lsscsi -s' the device (LUN) will appear
almost immediately but its size will be "-" due to the fact that READ
CAPACITY (or TUR before it) is waiting for tur_ms_to_ready to elapse. After
that the size (for disks) will be shown by 'lsscsi -s'.


When you say 'rmmod still fails' do you mean it refuses to remove the module
because the device is busy? It is busy, where is the race?. What precisely
would you like to happen? What does a real SCSI HBA do?

Is there any way that a driver can detect that rmmod has been called and
rejected? If not, we could add  a "shutdown" writable attribute in
/sys/bus/pseudo/drivers/scsi_debug/ . Then if a large number of pseudo
devices is being built due to the modprobe invocation, the driver can go
into reverse by checking that attribute before it adds another host
(target or LUN?). After shutdown, the driver is still active, just with
no hosts, and thus no LUNs. A more accurate name would be rm_all_hosts .

Doug Gilbert

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
