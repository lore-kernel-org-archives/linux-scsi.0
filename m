Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A2E5EB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 22:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbjGKWzY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 18:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbjGKWzW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 18:55:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C568E10D4
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 15:55:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 534DE6164F
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 22:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B09DFC433B7
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 22:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689116109;
        bh=5CYMYjtdTaWNO52b9pZIGd9Q1rcTrqNfHEtzDvoXV3s=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Q93JLhSOgmOCnxvSe4ZtHV11Zlu2fKrTJ8YYLpEVikYvSyYYjaL1vefGppd6i9q4G
         2EpNhdZfqlODLrjgXx6rglwMQv32V6epbK0qYh3X+KJyV8mfQIbkxxmXw7qKDfrQug
         xrk5F7hfTJruFLeJQ77ANFeYKEOV0QTTj/879bGnMwgitQEKAL8Cga6NkptPaF+rlk
         8+AZjLRBQosddpwNobynC0RVkKDkM7DCiIRvy6TwtqmXqeAvj6G5DZsGtTrIJzop1C
         Y6/wUIiLxGzz3HILfruo2m9ph//b7UAZ8NyfOnbgcG6iu+L0BO7Kl0iJItPm4f/nB/
         1dZCH7ONmEOJA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id A0E72C4332E; Tue, 11 Jul 2023 22:55:09 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Tue, 11 Jul 2023 22:55:08 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: damien.lemoal@wdc.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215880-11613-oq81py1lyh@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215880-11613@https.bugzilla.kernel.org/>
References: <bug-215880-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215880

--- Comment #56 from Damien Le Moal (damien.lemoal@wdc.com) ---
(In reply to Paul Ausbeck from comment #55)
> lspci output is relatively small and easy:
>=20
> 00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core
> processor DRAM Controller (rev 09)
> 00:02.0 VGA compatible controller: Intel Corporation IvyBridge GT2 [HD
> Graphics 4000] (rev 09)
> 00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
> Family USB xHCI Host Controller (rev 04)
> 00:16.0 Communication controller: Intel Corporation 7 Series/C216 Chipset
> Family MEI Controller #1 (rev 04)
> 00:19.0 Ethernet controller: Intel Corporation 82579V Gigabit Network
> Connection (rev 04)
> 00:1a.0 USB controller: Intel Corporation 7 Series/C216 Chipset Family USB
> Enhanced Host Controller #2 (rev 04)
> 00:1b.0 Audio device: Intel Corporation 7 Series/C216 Chipset Family High
> Definition Audio Controller (rev 04)
> 00:1c.0 PCI bridge: Intel Corporation 7 Series/C216 Chipset Family PCI
> Express Root Port 1 (rev c4)
> 00:1c.7 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family
> PCI Express Root Port 8 (rev c4)
> 00:1d.0 USB controller: Intel Corporation 7 Series/C216 Chipset Family USB
> Enhanced Host Controller #1 (rev 04)
> 00:1f.0 ISA bridge: Intel Corporation H77 Express Chipset LPC Controller
> (rev 04)
> 00:1f.2 SATA controller: Intel Corporation 7 Series/C210 Series Chipset
> Family 6-port SATA Controller [AHCI mode] (rev 04)

I think I have some servers that have the same chipset. But being servers,
suspend/resume is not well supported. Can try suspend to disk at least, but=
 not
suspend to RAM.

> 00:1f.3 SMBus: Intel Corporation 7 Series/C216 Chipset Family SMBus
> Controller (rev 04)
> 01:00.0 Multimedia video controller: Conexant Systems, Inc. CX23887/8 PCIe
> Broadcast Audio and Video Decoder with 3D Comb (rev 0f)
> 02:00.0 PCI bridge: Integrated Technology Express, Inc. IT8892E PCIe to P=
CI
> Bridge (rev 30)
> 03:01.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23 IEEE-1394a-2000
> Controller (PHY/Link)
>=20
> I'll wait a bit for full dmesg output and/or bisecting. When I initially
> read the bug report, ericspero seemed to do a pretty good job of bisecting
> the change.

You could try with the revert of 6aa0365a3c85. What I think you are seeing =
is
the X client start (Wayland ?) being delayed by the fact that with
6aa0365a3c85, resume waits for the HDD to be revalidated. Hence the delay f=
or X
& mouse to start working.

> It seems that we still don't agree that libata is responsible for the new=
ly
> introduced lack of mouse pointer interactivity following resume. Therefor=
e,

See above. It could be. But permanently reverting 6aa0365a3c85 is not a
solution as that commit fixes a real problem that some users reported and t=
hat
you could also hit yourself by reverting it. As I said, if you confirm that
this commit is indeed the cause of the delay, I can try to see how to reduce
the delay, if possible. The main issue is that the resume code is a bit of a
mess between libata and scsi, and libata resume is mostly done using EH (er=
ror
handler) context, which when running prevents using the drive for anything.=
 A
rework of the resume path may be needed but that is extremely dangerous as =
that
could introduce lots of regressions (because libata is in a sense the
accumulation of decades of "magic" code to deal with buggy adapters and dri=
ves,
and there are a lot out these out there). So extreme caution is needed when
touching such code.

> I will spend some more time characterizing the problem. I have a relative=
ly
> new Chuwi laptop with a spare m.2/sata slot. I've ordered an m.2/sata to
> sata 7 pin adapter so that I can plug a sata hard drive into this machine.
> As far as I can find, this type of adapter is only available directly from
> China so it will take a couple of weeks to get them. I'll post the results
> then. If I can muster to two machines as orthogonal as I can make them bo=
th
> exhibiting the same problem, perhaps we might come together. Or perhaps t=
he
> Chuwi machine won't exhibit the problem and I'll have to rethink.
>=20
> One other observation. It seems to me that libata maintainers should have=
 a
> machine containing a spinning disk at their disposal. I have a bunch of
> spare machines with hard drives and would be amenable to donating one for
> this purpose. Also, in case you are interested, the previously described
> m.2/sata to 7pin sata adapter is available on eBay at:

I am the libata maintainer, and if you check my email address, you will see
that it is not hard for me to get SATA HDDs and SSDs. I have 3 racks of mac=
hine
in my lab with literally hundreds of HDDs and SSDs usable, and also some PCs
with CD/DVD, old parallel ATA drives, port multiplier enclosures, etc. Many
favors of hardware.

But that does not mean that I can reproduce all issues notified by users. I
could never reproduce the issue that commit 6aa0365a3c85 fixes so my tests =
only
confirmed that I was not seeing any regression (and I did not see a bad del=
ay
with anything as I do not run any GUI on my machines).

Rather than hardware, which I have plenty, I would be happier with people
spending time testing for-next and RC trees to verify that patches do not h=
ave
unintended side effects. libata is not the sexiest of subsystems and it is =
hard
to get people to review and test patches.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
