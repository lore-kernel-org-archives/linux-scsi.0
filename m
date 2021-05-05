Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7566AC433ED
	for <linux-scsi@archiver.kernel.org>; Wed,  5 May 2021 16:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B0F66109E
	for <linux-scsi@archiver.kernel.org>; Wed,  5 May 2021 16:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbhEEQHi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 May 2021 12:07:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233484AbhEEQHh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 5 May 2021 12:07:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 301CA6121F
        for <linux-scsi@vger.kernel.org>; Wed,  5 May 2021 16:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620230801;
        bh=WKx5URrYHFk0mtmdkB42l16KaLYRRCrdS+5BuonKjK4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=CdDzbyLFIheztOF9Adg4TfZ9u7if6yUYtwjW4G/3YntOoLuUhCIhFXfLIniZBWO6h
         KHAA+tYMHzcA3Q45GvTo3lJmHzfaZwBoA2pgOcFBjXG6RzhbAGym1EK3qi2OCCIiak
         3xINAjmam3zWWk8z3HOZWbRh8+GvorQdHbMe6aMFLDK7NyHxGcTtRFkxUvk8eSApiN
         kpRY5zbBddiRxURWKE2IoxU13Fyu/6yqtD8y26a3GrllYg1Q0BN+oXb+h159ivWEG9
         syoBCSt5UFxgEa0onyls00tvDzlTkGIWZnoZrGY2cdoSE9H90YkrnJNZMHGYDyRZXl
         3h7U8X9mUQovA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212337] scsi_debug: race at module load and module unload
Date:   Wed, 05 May 2021 16:06:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dgilbert@interlog.com
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-212337-11613-zp9Lw6AfDr@https.bugzilla.kernel.org/>
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

--- Comment #15 from d gilbert (dgilbert@interlog.com) ---
On 2021-05-04 5:18 p.m., bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D212337
>=20
> Luis Chamberlain (mcgrof@kernel.org) changed:
>=20
>             What    |Removed                     |Added
> -------------------------------------------------------------------------=
---
>               Status|RESOLVED                    |REOPENED
>           Resolution|WILL_NOT_FIX                |---
>=20
> --- Comment #13 from Luis Chamberlain (mcgrof@kernel.org) ---
> (In reply to d gilbert from comment #12)
>> On 2021-03-22 12:23 p.m., bugzilla-daemon@bugzilla.kernel.org wrote:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D212337
>>>
>>> --- Comment #9 from Luis Chamberlain (mcgrof@kernel.org) ---
>>> (In reply to d gilbert from comment #8)
>>>
>>>>>> The scsi_debug module option that is already in place is:
>>>>>>       tur_ms_to_ready: TEST UNIT READY millisecs before initial good
>> status
>>>>>> (def=3D0)
>>>>
>>>> You asked how it works, try:
>>>>        modprobe scsi_debug tur_ms_to_ready=3D20000
>>>>
>>>
>>> That does not resolve the rmmod race against insmod:
>>>
>>> scsi host2: scsi_debug: version 0190 [20200710]
>>> [   42.213400]   dev_size_mb=3D8, opts=3D0x0, submit_queues=3D1, statis=
tics=3D0
>>> [   42.217527] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug
>> 0190
>>> PQ: 0 ANSI: 7
>>> [   42.223346] scsi 2:0:0:0: Attached scsi generic sg0 type 0
>>> [   42.282195] scsi host2: scsi_debug: version 0190 [20200710]
>>> [   42.282195]   dev_size_mb=3D8, opts=3D0x0, submit_queues=3D1, statis=
tics=3D0
>>> [   42.288169] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug
>> 0190
>>> PQ: 0 ANSI: 7
>>> [   42.292122] sd 2:0:0:0: Attached scsi generic sg0 type 0
>>> [   42.292244] sd 2:0:0:0: Power-on or device reset occurred
>>> [   42.302288] sd 2:0:0:0: [sda] Spinning up disk...
>>>
>>> Then we wait...
>>>
>>> [   44.308213] ...................ready
>>> [   62.748919] sd 2:0:0:0: [sda] 16384 512-byte logical blocks: (8.39
>> MB/8.00
>>> MiB)
>>> [   62.754265] sd 2:0:0:0: [sda] Write Protect is off
>>> [   62.763253] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enab=
led,
>>> supports DPO and FUA
>>> [   62.776965] sd 2:0:0:0: [sda] Optimal transfer size 524288 bytes
>>> [   62.883817] sd 2:0:0:0: [sda] Attached SCSI disk
>>>
>>> And then rmmod still fails.
>>>
>>
>> Just to explain a bit more about tur_ms_to_ready, that does not effect S=
CSI
>> commands like REPORT LUNS, INQUIRY and REQUEST SENSE, but does slow down=
 all
>> "media access" commands including TEST UNIT READY (TUR) and READ CAPACIT=
Y.
>> So
>> if you watch what is happening with 'lsscsi -s' the device (LUN) will ap=
pear
>> almost immediately but its size will be "-" due to the fact that READ
>> CAPACITY (or TUR before it) is waiting for tur_ms_to_ready to elapse. Af=
ter
>> that the size (for disks) will be shown by 'lsscsi -s'.
>>
>>
>> When you say 'rmmod still fails' do you mean it refuses to remove the mo=
dule
>> because the device is busy?
>=20
> Yes. The refcnt must be 1 for rmmod to work. If it is not it will fail.
>=20
>> If is busy, where is the race?. What precisely
>> would you like to happen? What does a real SCSI HBA do?
>=20
> That's the thing, the trace on comment #1 does not exactly show who to bl=
ame,
> but there seems to be only two possibilities: systemd and multipath.
> Regardless
> what is clearer is that once the device is exposed we *cannot* block
> userspace
> from poking at the device. The best we can do, is udevadm settle, however
> that
> still does not guarantee userspace things like multipath won't try to pok=
e.
>=20
>> Is there any way that a driver can detect that rmmod has been called and
>> rejected?
>=20
> Yes! try_module_get() would fail if rmmod was kicked off.

I have tried this:
     if (!try_module_get(THIS_MODULE)) {
          pr_warn("%s: probable rmmod, stop adding\n", __func__);
          break;
     }
     module_put(THIS_MODULE);
     ....

placed inside the loop that adds each host inside scsi_debug_init() and
I can never get try_modules_get() to fail. There is a 'rmmod scsi_debug'
bash script sending a rmmod every 0.3 seconds. To slow scsi_debug down
there is a 0.5 second delay on each media access command. The overall
modprobe takes over 10 seconds but scsi_debug_init() is only about 0.8
seconds of that. The rest of the time is udev and friends piling on,
sending SCSI commands to the newly appearing devices. And whenever the
driver is processing commands then rmmod is going to get EBUSY which is
exactly what is observed.

The kernel try_module_get() documentation is underwhelming. Is there some
kind of synchronization between this call and rmmod? Does a failed rmmod
leave a persistent flag that a following try_module_get() will notice and
return false? If so, what if the user changes their mind? If not, how is
this meant to be useful?

>> If not, we could add  a "shutdown" writable attribute in
>> /sys/bus/pseudo/drivers/scsi_debug/ . Then if a large number of pseudo
>> devices is being built due to the modprobe invocation, the driver can go
>> into reverse by checking that attribute before it adds another host
>> (target or LUN?). After shutdown, the driver is still active, just with
>> no hosts, and thus no LUNs. A more accurate name would be rm_all_hosts .
>=20
> This may work actually, and so new users who would want to avoid this race
> would have to issue this call prior to rmmod. That would remove the
> possibility
> of a race. Let me know if you have a patch I can test. Putting this as
> re-opened.

This will depend on how quickly sysfs visibility appears (i.e.
/sys/bus/pseudo/drivers/scsi_debug/* ) after modprobe is started.

Doug Gilbert

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
