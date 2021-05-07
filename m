Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56DB3C433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 18:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E6E6600D1
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 18:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbhEGS0S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 May 2021 14:26:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229470AbhEGS0S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 7 May 2021 14:26:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C8C0761430
        for <linux-scsi@vger.kernel.org>; Fri,  7 May 2021 18:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620411917;
        bh=zFh6TZYcBPaJOUn0JsHWjj3jjNrhRDGYpYKl4vHRTDQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=aQjznWf4lc2lcu8hGVrnr4fglXX1J2D9jwjWxnQmUzs4yQFhWe1XLHh+37kbbmFNs
         zMcSWIIP3v2UsB1KElNI/+sPSe+NCw6Zhlr2qor1N/YglrOumArK8pNbjnp0PYWHMk
         DAt7w2DNq2uDaAXAf3Zfy95yHw9ZPuuPnujT92Ztubj6V/jDilhPg1helQOcT3xWZI
         zEfJuiqRZEN1xCDngPgnhYurGEM35N0JYgwH8BDWwGeTisNOJkTSPlt9yJsrq7vpk9
         ZymkehZbSbfX6Gn+BdFeIsigSJIB7Wp5nEazvg1G4OavxK7RzibNxNvPncnTyG96px
         1phGd5dpgih8g==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212337] scsi_debug: race at module load and module unload
Date:   Fri, 07 May 2021 18:25:17 +0000
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
Message-ID: <bug-212337-11613-mRcxDY5Y2x@https.bugzilla.kernel.org/>
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

--- Comment #16 from Luis Chamberlain (mcgrof@kernel.org) ---
(In reply to d gilbert from comment #15)
> On 2021-05-04 5:18 p.m., bugzilla-daemon@bugzilla.kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D212337
> >=20
> > Luis Chamberlain (mcgrof@kernel.org) changed:
> >=20
> >             What    |Removed                     |Added
> >
> -------------------------------------------------------------------------=
---
> >               Status|RESOLVED                    |REOPENED
> >           Resolution|WILL_NOT_FIX                |---
> >=20
> > --- Comment #13 from Luis Chamberlain (mcgrof@kernel.org) ---
> > (In reply to d gilbert from comment #12)
> >> On 2021-03-22 12:23 p.m., bugzilla-daemon@bugzilla.kernel.org wrote:
> >>> https://bugzilla.kernel.org/show_bug.cgi?id=3D212337
> >>>
> >>> --- Comment #9 from Luis Chamberlain (mcgrof@kernel.org) ---
> >>> (In reply to d gilbert from comment #8)
> >>>
> >>>>>> The scsi_debug module option that is already in place is:
> >>>>>>       tur_ms_to_ready: TEST UNIT READY millisecs before initial go=
od
> >> status
> >>>>>> (def=3D0)
> >>>>
> >>>> You asked how it works, try:
> >>>>        modprobe scsi_debug tur_ms_to_ready=3D20000
> >>>>
> >>>
> >>> That does not resolve the rmmod race against insmod:
> >>>
> >>> scsi host2: scsi_debug: version 0190 [20200710]
> >>> [   42.213400]   dev_size_mb=3D8, opts=3D0x0, submit_queues=3D1, stat=
istics=3D0
> >>> [   42.217527] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug
> >> 0190
> >>> PQ: 0 ANSI: 7
> >>> [   42.223346] scsi 2:0:0:0: Attached scsi generic sg0 type 0
> >>> [   42.282195] scsi host2: scsi_debug: version 0190 [20200710]
> >>> [   42.282195]   dev_size_mb=3D8, opts=3D0x0, submit_queues=3D1, stat=
istics=3D0
> >>> [   42.288169] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug
> >> 0190
> >>> PQ: 0 ANSI: 7
> >>> [   42.292122] sd 2:0:0:0: Attached scsi generic sg0 type 0
> >>> [   42.292244] sd 2:0:0:0: Power-on or device reset occurred
> >>> [   42.302288] sd 2:0:0:0: [sda] Spinning up disk...
> >>>
> >>> Then we wait...
> >>>
> >>> [   44.308213] ...................ready
> >>> [   62.748919] sd 2:0:0:0: [sda] 16384 512-byte logical blocks: (8.39
> >> MB/8.00
> >>> MiB)
> >>> [   62.754265] sd 2:0:0:0: [sda] Write Protect is off
> >>> [   62.763253] sd 2:0:0:0: [sda] Write cache: enabled, read cache:
> enabled,
> >>> supports DPO and FUA
> >>> [   62.776965] sd 2:0:0:0: [sda] Optimal transfer size 524288 bytes
> >>> [   62.883817] sd 2:0:0:0: [sda] Attached SCSI disk
> >>>
> >>> And then rmmod still fails.
> >>>
> >>
> >> Just to explain a bit more about tur_ms_to_ready, that does not effect
> SCSI
> >> commands like REPORT LUNS, INQUIRY and REQUEST SENSE, but does slow do=
wn
> all
> >> "media access" commands including TEST UNIT READY (TUR) and READ CAPAC=
ITY.
> >> So
> >> if you watch what is happening with 'lsscsi -s' the device (LUN) will
> appear
> >> almost immediately but its size will be "-" due to the fact that READ
> >> CAPACITY (or TUR before it) is waiting for tur_ms_to_ready to elapse.
> After
> >> that the size (for disks) will be shown by 'lsscsi -s'.
> >>
> >>
> >> When you say 'rmmod still fails' do you mean it refuses to remove the
> module
> >> because the device is busy?
> >=20
> > Yes. The refcnt must be 1 for rmmod to work. If it is not it will fail.
> >=20
> >> If is busy, where is the race?. What precisely
> >> would you like to happen? What does a real SCSI HBA do?
> >=20
> > That's the thing, the trace on comment #1 does not exactly show who to
> blame,
> > but there seems to be only two possibilities: systemd and multipath.
> > Regardless
> > what is clearer is that once the device is exposed we *cannot* block
> > userspace
> > from poking at the device. The best we can do, is udevadm settle, howev=
er
> > that
> > still does not guarantee userspace things like multipath won't try to p=
oke.
> >=20
> >> Is there any way that a driver can detect that rmmod has been called a=
nd
> >> rejected?
> >=20
> > Yes! try_module_get() would fail if rmmod was kicked off.
>=20
> I have tried this:
>      if (!try_module_get(THIS_MODULE)) {
>           pr_warn("%s: probable rmmod, stop adding\n", __func__);
>           break;
>      }
>      module_put(THIS_MODULE);
>      ....
>=20
> placed inside the loop that adds each host inside scsi_debug_init() and
> I can never get try_modules_get() to fail.

You won't race init stuff with rmmod, the issue comes up *after* the device=
 is
up, once init completes.

> There is a 'rmmod scsi_debug'
> bash script sending a rmmod every 0.3 seconds. To slow scsi_debug down
> there is a 0.5 second delay on each media access command. The overall
> modprobe takes over 10 seconds but scsi_debug_init() is only about 0.8
> seconds of that. The rest of the time is udev and friends piling on,
> sending SCSI commands to the newly appearing devices. And whenever the
> driver is processing commands then rmmod is going to get EBUSY which is
> exactly what is observed.

Right, try installing multipath too, which is a a busy nosy neighbor who ju=
st
loves too poke at devices when they pop up as well.

> The kernel try_module_get() documentation is underwhelming. Is there some
> kind of synchronization between this call and rmmod?=20

No, the piece of information you are likely missing is that rmmod does a sa=
nity
check in userspace on the refcnt before trying to call the system call to t=
ry
to remove the module. That refcnt is what userspace modprobe is bailing on.

A refcnt is always held on init, and so rmmod cannot possibly done on init.=
 The
races we are observing is not something on init and rmmod... its *after* in=
it,
and then rmmod not being able to complete. Why? Because we allow for it.

> Does a failed rmmod
> leave a persistent flag that a following try_module_get() will notice and
> return false?

No. try_module_get() is best effort, in the sense that if the module is not
being removed yet, and it succeeds in getting a reference, rmmod will be
prevented from removing the module unput we put the module later. If
try_module_get() failed, we can safely assume the module is gone out fishin=
g.

> If so, what if the user changes their mind? If not, how is
> this meant to be useful?

The idea here is to call a busy syfs file which will not return until all
devices are removed *and* it also locks the driver to not allow any new
entries, therefore making the driver useful for new additions. That requires
adding a small state machine. The reason I am thinking this would be needed=
, is
that as in the patches with zram you'll see there are possible races also w=
ith
module removal and sysfs files. So if we really want to *quiesce* this driv=
er,
for removal, we need to ensure that no new sysfs entries will busy out while
rmmod is going on.

> >> If not, we could add  a "shutdown" writable attribute in
> >> /sys/bus/pseudo/drivers/scsi_debug/ . Then if a large number of pseudo
> >> devices is being built due to the modprobe invocation, the driver can =
go
> >> into reverse by checking that attribute before it adds another host
> >> (target or LUN?). After shutdown, the driver is still active, just with
> >> no hosts, and thus no LUNs. A more accurate name would be rm_all_hosts=
 .
> >=20
> > This may work actually, and so new users who would want to avoid this r=
ace
> > would have to issue this call prior to rmmod. That would remove the
> > possibility
> > of a race. Let me know if you have a patch I can test. Putting this as
> > re-opened.
>=20
> This will depend on how quickly sysfs visibility appears (i.e.
> /sys/bus/pseudo/drivers/scsi_debug/* ) after modprobe is started.

It should appear right away if we attach sysfs stuff prior to the devices w=
hich
probe asynchronously.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
