Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0966C43461
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 18:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5690C2080A
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 18:36:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="FK9dKPCI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731621AbgIHScJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 14:32:09 -0400
Received: from mout.gmx.net ([212.227.15.18]:42701 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731362AbgIHQJ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Sep 2020 12:09:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1599581363;
        bh=3rPErxsobiM2Nx402ZHly3ReD4PHag8PvdQVYoKtzkk=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=FK9dKPCIzV66zX5BBdoSO7RmkKl/+DgB1CWwBfuIHoNMXCDOslF7x4A1n4qPECnU2
         d94z03WCQwq/qSSOCxoadQVDhuvpiD2Ot6GBAlh8BWchalGT1yif15OeB7Af+8PYl2
         cx1ozdT9BVXwLMRciirooB8iREQpJF85aJdIRy0Y=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from ts7.local ([84.179.245.142]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MxUnz-1kUnlP2bHt-00xrSJ; Tue, 08
 Sep 2020 14:02:30 +0200
From:   Thomas Schmitt <scdbackup@gmx.net>
To:     linux-scsi@vger.kernel.org
Cc:     axboe@kernel.dk, linux-kernel@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Thomas Schmitt <scdbackup@gmx.net>
Subject: [PATCH 0/2] Fix automatic CD tray loading for data reading via sr
Date:   Tue,  8 Sep 2020 14:02:05 +0200
Message-Id: <20200908120207.5014-1-scdbackup@gmx.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:5nyH4+bxE2qnjrIl+MWxnoPVzz/IrW+WP23SLrCeOKb+BtiDEGQ
 dCTaVpa++4/ItLe+s2BqJbTUTomW0NANuXuNZ0S/4e6nGzJrWKRh4edeJCUdQdjXeNLWDpf
 C/HR2jCdV9g2tgnOKHXMUCCm/EBhqohUV6/timwE+8AhpHChA0SdFzlfLEQXnFOfwH2dC+Y
 nEMW8s7briQopvbPdS6cA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:bEWSGX0SmkQ=:PB7hy06IZjKsc4nQwMl0Eu
 owkqWBXDV8YPDCsqL9fl79G2dv3G8DuB1U5HfW3vgQlv4BSIqRAqlLRFIQqyk20BaixEIrs0z
 Ok0/ANTIukGfzCuf+BD1FY8odBqcBiJJTfXOuK6mw8IlPZ4ABFCSEjPJdn4dU6o47iCzfWHJL
 I/50UGzwNtay3O4jsolc2bbdJzTTjueWEcfYQMyKm/tfZ5+2HuYAph5LkI1Ng0SmVqn3NfJwh
 Pbc764XmTAef2q4Eu4hZytoB+iEYVNWuptiXOOtSLKgQ+QE/cOjPQqBn+PFY9Y15QI6hjJ2zA
 t/UxOUf/0hKI8mhUZSqBzUrBqR8v7Fk9gY/GBpjgCYSfFwxkmX1K2eLWNjnoN2I0swRCSJnxW
 MB1Bd0vIVYU2xIWuR2WU1s66z9yu/2J/1xX+IVGzS/GR8AXv+56OW9YmKgKOgr2btEOX4e4Ps
 Ax6/vSeMxHaHBzRCE0KI7XPsbSfMziUvtINY4nfajeGa4vVpHcZyGg9vGkRo4vB0e0/GVNFeZ
 1aGtcJz9KJ6mPzfy0z5UzCIUnma9YjQk97UvUTojmPgD3I3uekKQ1TMpVg9DemSJUJszUlRK0
 qvRYY8Zi7NW7aICXQ/nt4Hb+PPZ2BQeLJuz5Q49csFR12JVqX+d72x6Tva2cxp4kFXX3mL7P/
 8aQ3MuFbJtbIFlzyVIe7uenXcTC8MMO1rvtjd7mVIQL1E1HDW+j/dwIWewQ4GfzE+sNaxErAk
 SiyN+QcV3Aby8Ow+3NYaTUsC0QzLs7G7fN3pS0p1yZZzFF0z9tP6mxFvhUmFFTFhrBVglMCkZ
 YSnja88FebP0bVs3xcfp5QUp3x16LErCNpuiL5AR0RHgp21Y3yXxw/nrmCYgjTWsvoBqGIT+c
 LyuZNKrinILUOBfPQgFlCpQqvgus8Vb6KYrLftMNspP6jSAy4zExcQoP1fqx0ESJUsrid0uTh
 bo8v6YcOyFa3LyLArFAhTHguBEoRXpNVVTBeWsaQvbwT+cFopG5ufnOagtmnDMB+MCxK7P2Nu
 lGqjhWVreG8+q+imxtPBIQD73eObmMxR9zXU2kIKC7zLuZisNVNLpaR3/GOxdlkUAF6DJLhFq
 rOEC8UmfpmMfqhmXs0aGO55pWk97f7vAJ0Of7orVDkQiuSnaLLTnv0TfOGMoJye3h8tAx4jdC
 96dAOHGyPxXoJ4XaYJKwmXLpk1xMT5lw8Bak+wTlmo+WW0/P8zLOzd0Do6wySq6XoQ1pwj6hJ
 Sj2i29bH2mYGmbWQs01jMQevu0pxs10az8OlPWg==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

i am aware that a solution proposal for this problem was not accepted
in november 2019. Mine is independent of this and also my first attempt to
submit a kernel patch.

If
  open("/dev/sr0", O_RDONLY);
pulls in the tray of an optical drive, it immediately returns -1 with
errno ENOMEDIUM, or the first read(2) fails with EIO. Later, when the
drive has stopped blinking, another open() yields success and read()
works.
This affects not only userland reading of the device file but also
mounting the device.

The fundamental problem of the current implementation is that function
sr_block_open() does medium assessment before calling cdrom_open(), under
which open_for_data() performs the tray loading too late.
A minor problem is that there is currently no waiting loop for the drive's
decision about the medium.

Please regard my proposal as follow-up to commit 2bbea6e11735 ("cdrom: do
not call check_disk_change() inside cdrom_open()") of march 2008. It moved
medium assessment out ouf cdrom_open() but left behind tray loading.

=2D-----------------------------------------------------------------------=
--
For now my proposal fixes only data reading via sr, because that's what i
am able to test:

Factor out from open_for_data() a new function cdrom_handle_open_tray()
and export it.
It decides whether it can and should load the tray. If so, it emits the
tray loading command and waits for up to 40 seconds for the drive to make
its decision. Plus 1 second of waiting in case of a usable medium, in
order to avoid hard-to-test narrow race conditions.

Let cdrom_open() not attempt to load the tray any more, but rather just
return -ENOMEDIUM if it detects an open tray.

Let sr_block_open() call cdrom_handle_open_tray() under mutex cd->lock
which it gives up immediately thereafter.
Then it calls the same sequence of medium assessment, mutex cd->lock and
cdrom_open() as it does currently.

Thanks to commit 51a858817dcd ("scsi: sr: get rid of sr global mutex") of
february 2020, the blocking of at most 41 seconds only affects the
particular drive and not all other sr devices.

=2D----------------------------------------------------------------------
Successful tests:

I tested with 3 different drives at SATA and USB (ASUS DRW-24D5MT,
Pioneer BDR-S09, LG BH16NS40 in USB box) simultaneously by
  time dd if=3D/dev/sr"$N" bs=3D2048 count=3D1 of=3D/dev/null
with CD, DVD, and BD media. Waiting times ranged from 9 to 23 seconds.

The same times were measured when each drive was the only busy one.

Simultaneous full reads succeeded starting from open tray by
  time dd if=3D/dev/sr"$N" bs=3D2048 status=3Dprogress of=3D/dev/null

I tested mounting CD, DVD and BD with ISO 9660 from open tray by
  mount /dev/sr"$N" /mnt/iso

The patches were checked on Debian 10 by
  ./scripts/checkpatch.pl --strict --codespell --codespellfile \
       /usr/lib/python3/dist-packages/codespell_lib/data/dictionary.txt
This yielded some small corrections in the moved code.

=2D--------------------------------------------------------------------
Patch base:

My patches still talk of check_disk_change() because i do not know how
to get a git branch which already shows the effect of the recent patch set
"rework check_disk_change()" by Christoph Hellwig.

For now my patches are based on next-20200827 because the then recent
v5.9-rc2 did not boot unchanged on my machine due to a nvme problem.

Please instruct me about the proper base and how to get it, if it is not
by a simple git checkout -B from a clone of
  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

=2D-------------------------------------------------------------------
The rest of this mail is about these aspects:
- What about CD audio and non-sr CD drivers.
- Why not (yet) waiting without mutex after tray loading.
- Why i can only test data reading via sr.
- Why the current code not always yields ENOMEDIUM at open() but sometimes
  EIO at the first read(2).

=2D-------------------------------------------------------------------
What about CD audio and non-sr CD drivers:

Because i lack of testing opportunities (see below), i omit:

- Calling cdrom_handle_open_tray() in the bdops.open() functions of
  cdrom/gdrom.c, block/paride/pcd.c, ide/ide-cd.c.

- Calling cdrom_handle_open_tray() in the callers of
  check_for_audio_disc(): cdrom_ioctl_audioctl() and
  cdrom_ioctl_play_trkind() which control audio playback by the drive to
  some (traditionally analog) audio outlet.

- Replacing the tray loading code of check_for_audio_disc() in cdrom.c
  by a mere status checker like by my proposal in open_for_data().
  (It could stay in place but would be of no use any more.)

My changes in sr_block_open() and open_for_data() could serve as
templates for these omitted tasks.

I would prepare patches if there is acceptance for untested code.

=2D-------------------------------------------------------------------
Why not (yet) waiting without mutex after tray loading:

It seems to me that it should be safe to run the new function
cdrom_handle_open_tray() without cd->lock, as it mainly emits drive
commands START/STOP UNIT and TEST UNIT READY. It does not manipulate
members of device structs.
Without lock it would enable access to the drive by other threads during
the waiting for a drive decision.

But i have no idea how to prove that it is safe.

=2D--------------------------------------------------------------------
Why i can only test data reading via sr:

None of my DVD and BD drives has a socket for plugging loudspeakers or
earphones. So i cannot test the consequences of my proposal to the ability
of playing audio tracks.

sr is the only driver i can test, because of the extinction status of the
devices of the other drivers which call cdrom_open():
- gdrom seems to be for ancient gaming consoles. It is unclear to me
  whether they could load a tray by own motor power.
- paride is described as ATAPI via an old printer cable.
- ide-cd ... was not that the CD part of hd swallowed by sr, as the HDD
  part of hd was swallowed by sd ?

sr is well alive. BD drives cost ~80 EUR, 25 GB BD-RE media <1 EUR.
Not a competitor to HDD, but to USB sticks.

=2D--------------------------------------------------------------------
Why the current code not always yields ENOMEDIUM at open() but sometimes
EIO at the first read(2):

A newly bought Pioneer BDR-S09 shows this behavior with the current code.
dd reports I/O error rather than no medium.

Inspection by libburn shows that it waits with its reply to START/STOP
UNIT until it has decided over the medium. The first following TEST UNIT
READY yields key=3D6, asc=3D28h, ascq=3D00h "Not Ready to Ready change, me=
dium
may have changed" and the second TEST UNIT READY yields success.

This substitutes for the missing waiting loop, but not for the lack of
medium assessment after loading. So open(2) succeeds, but read(2) faces
the medium assessment which was made when the tray was out. The result was
in my experiments always EIO on the first read().

This behavior is peculiar among my drives. Seven others reply to
START/STOP UNIT as soon as the tray has moved in. Then for several seconds
they reply to TEST UNIT READY by key=3D2, asc=3D04h, ascq=3D01h "Logical u=
nit is
in process of becoming ready".

Have a nice day :)

Thomas

Thomas Schmitt (2):
  cdrom: delegate automatic CD tray loading to callers of cdrom_open()
  sr: fix automatic tray loading for data reading

 drivers/cdrom/cdrom.c | 165 +++++++++++++++++++++++++++++++-----------
 drivers/scsi/sr.c     |   9 ++-
 include/linux/cdrom.h |   3 +
 3 files changed, 131 insertions(+), 46 deletions(-)

=2D-
2.20.1

