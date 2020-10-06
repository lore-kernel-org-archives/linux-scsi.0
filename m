Return-Path: <SRS0=xWhZ=DN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B4DC47095
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Oct 2020 09:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC2932080A
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Oct 2020 09:42:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="U6BeqY82"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbgJFJms (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 05:42:48 -0400
Received: from mout.gmx.net ([212.227.17.22]:34109 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgJFJmr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Oct 2020 05:42:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1601977353;
        bh=Skf/L3Dyq1CuPIqkY4gR71mNxfblatWdGsd2D/rEIvI=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=U6BeqY82WfX+zL9Ufdvd0GtUvgPLtG0mPmyiJQ/ipHPbflv55VqOPoOL5JSn3+MgM
         UD4gxwG5134wHepiCjTem9aT3zIdd444LqRv3rbXt/5AOWZRih+RrKg3xJLSt66ayQ
         zhsAtarm/BiHRkt/wr0jUOXLaOUT/EkgRxL4ScFg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from ts7.local ([91.8.173.95]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M1HZi-1kO4nL1Xy6-002keK; Tue, 06
 Oct 2020 11:42:33 +0200
From:   Thomas Schmitt <scdbackup@gmx.net>
To:     linux-scsi@vger.kernel.org
Cc:     axboe@kernel.dk, linux-kernel@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Thomas Schmitt <scdbackup@gmx.net>
Subject: [PATCH v2 0/2] Fix automatic CD tray loading for data reading via sr
Date:   Tue,  6 Oct 2020 11:40:24 +0200
Message-Id: <20201006094026.1730-1-scdbackup@gmx.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Jw9p0x4mXfBUonFFRPgNiCbvLCXoVf082glZYflxlbdJo7kLUQ/
 4eF2ZPyqrjp8JlXseOmJ9Av9jN6H1vqCvid7+59bS8lcq/JvvYjwh4FrjuDhpsA6S6FJ8Kc
 AYsXkePaqg0v7yOw3ZNugpNcWGfqAlH0T0VGn6NzeGEd7oXGXXW8UpTnvyENf7e4r6b6eBm
 P+SVAMO8wc00U3p5VgZWQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:K01hy6Gc8O4=:jKOeHpjm8UA03QxybED49d
 vr4mZ/tDH8mSJfJldFGoo0Whdegdajhk4qdWMV5E9pR0b/7Qw971r8PnrVua9as906HX5a+Cz
 YyWVq19vVdE+IrUtbEk2LrUqpm5k6fEJKW1Kb2M41dXrNxGxErJQEF3hOTAgf6z35z0pm/a2R
 LsHnWgs4eNx7xCaWdr4+XGw8hSoPfuZHB70Fwv1wJyiKSEwwpoeWoo4rtxxOyDx2ISP6YoUxC
 EQ7yotMY9wV50vdFqGg569nuJb73+yftTv7Ne7Mo7wwvAKKscCpXev2u9cJ6MziNplNN4RQKZ
 XjqZb0jdjXVbXWe+H4yCwJQtsb5mngMOSxyDvghvL5zP4bPa8Iaspkibyhn5L2ernCzxl8uqZ
 o5McbkGvlDX5flBLzRISXHeJAKkUaIgKSUc0vcLTEpaunmW63iwjhxqkugg2QUdX86OXM2Q9a
 XFXtqvE4od3t3eOqn4BPDpCFfVeOrxWs8zwiUZJ11BiO0gPK6EphhpQlIzcMl1gWFon9nZqAj
 SJTVTxLZKOo7HthnHWgk9iFlr+M8bOo4+ZkMJtayAor0Nuc+4ZvYVmRtyaZ/17HOQjQ0SXaEc
 lwQCzFAv8+t4cWiCW0bCHXcAhhgrI/hgQxQDtTiyz+xykMrGZH7Tt2fuTrBfvjtdv0iavG9V9
 FoN03MsBR0UNjBCn0RVIGEAHS/jT71C61x+wsnKBMILTsOqiWQXG6iltEuTHGam0d0048OONB
 5x86ByNhW9Tq0WB7qSbPVRUjbXyRUfC8kuJR4zj/NF0NGwjRNWO1phe76g2QhR0tzQy2KLeqo
 aomiV+x26MGEWunwyWjsyvpWXf/vnhK4E0wpg7tgp9r+VPvAnym23Y/NetJVT2IonDa2CLvzn
 DPVZtyPbiIoFXpBOWU0sD840ZXWLIcvFCAUP1YZfEDyZER5nyghqcBeHvAD1IYOQUEOlbLFQp
 Z9HiLdcYgvdedFW7zfVBolyX6nWxCf7jUajNTBM4cgNHIQHVAAPwVTZ4kdYGevtbWJOyonRNA
 OaQhIHJRvPWtHtvukC99CfyXfLfuHKsajZOeB3I04Ty6jwz3Pn2jzwTechlMzoIQ9w+gsFozc
 mL8W+NEIGXRQTeyIBTHHegDzHIRzRiVOTjz4xdzeh4cjd0KYnEuHCRkV+rWIpBRpgDA3r7WUR
 JeswpeiQmZbog+otaHSrOFtAshpxwrTeIC/1V0qSgbQfrFLxJwO3DIljNRgEJfuXPjI62y/so
 1FiNCFKDPMldk6r3kdoSG1+7smhcWjgreDKweLw==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

if
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

To make sure that no unwanted tray loading happens, i tested with open
tray by a program which prevents loading by O_NONBLOCK:
  fd =3D open(path, O_RDONLY | O_NONBLOCK);
  ret =3D ioctl(fd, CDROMREADTOCHDR, &hdr);
The open() call succeeds, whereas the ioctl() fails with ENOMEDIUM.
The tray does not move.

The patches were checked on Debian 10 by
  ./scripts/checkpatch.pl --strict --codespell --codespellfile \
       /usr/lib/python3/dist-packages/codespell_lib/data/dictionary.txt

=2D--------------------------------------------------------------------
Patch version:

v2 is based on git://git.kernel.dk/linux-block branch for-next to take
into respect commit afd35c4f573d ("sr: use bdev_check_media_change") and
commit 38a2b557e238 ("sr: simplify sr_block_revalidate_disk").

Newest in the branch was commit 73f2e37b498a ("Merge branch
'for-5.10/drivers' into for-next").

v2 improves the concurrency behavior of its tray loader with competing
tray loading by the human user. v1 reported "no medium" when encountering
a drive which is already in the process of decision. v2 waits for this
decision.

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

The automatic tray loading happened under the mutex for cdrom_open().
My proposal upholds this locking by acquiring cd->lock before calling
cdrom_handle_open_tray() and giving it up before medium assessment.

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

 drivers/cdrom/cdrom.c | 173 +++++++++++++++++++++++++++++++-----------
 drivers/scsi/sr.c     |  12 ++-
 include/linux/cdrom.h |   3 +
 3 files changed, 141 insertions(+), 47 deletions(-)

=2D-
2.20.1

