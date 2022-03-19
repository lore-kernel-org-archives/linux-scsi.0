Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0023C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Mar 2022 09:46:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242627AbiCSJrl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Mar 2022 05:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbiCSJrj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Mar 2022 05:47:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B915212612
        for <linux-scsi@vger.kernel.org>; Sat, 19 Mar 2022 02:46:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9821B8013A
        for <linux-scsi@vger.kernel.org>; Sat, 19 Mar 2022 09:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7CD8FC340F0
        for <linux-scsi@vger.kernel.org>; Sat, 19 Mar 2022 09:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647683175;
        bh=UHgNHUZp1tWcFY6e/z4vmYaRhnN5mFY9saG8joog6EE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OuvhAQCvxX/QpTlDS3t3VYQzdxsegKoe3YRMhU7gOM/ffYB0pwdIEFHMGno075eOg
         l6lCVQAYKVYA3e/si3AsBTEFoNQVli/gZEa8F8itaxDb3SX43v67jvyHZD3miVnEjI
         6Ap6WUL+043PHhi33Z8sau6bXf1pNxp6Q3oaxoFJurKs6BkWp7hC/qtzRO6vY/jDqs
         XsLJhcxtRv3k4vTW1/gk3ysCgSyJHk36kWwgR5X/vyVyHxuKfN/u3k+WefOLI9Tx+z
         8tSjBOqL81YAVA/2zTnPhxgktIFP9/TWSZG7S6GBS9vPaQdqdudFUd8et49PDTKL3N
         g3h23oKILmN+g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 651F9C05FD6; Sat, 19 Mar 2022 09:46:15 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215701] [scsi]timing out command, waited 180s
Date:   Sat, 19 Mar 2022 09:46:15 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: xqjcool@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215701-11613-dh3YM5IiXn@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215701-11613@https.bugzilla.kernel.org/>
References: <bug-215701-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215701

--- Comment #1 from Jack Xing (xqjcool@gmail.com) ---
[root@cpe ~]# lspci -vv -k -x -xxx -xxxx -b -D -nn -qq -Q -d 8086:0f23
0000:00:13.0 SATA controller [0106]: Intel Corporation Atom Processor E3800
Series SATA AHCI Controller [8086:0f23] (rev 0e) (prog-if 01 [AHCI 1.0])
        Subsystem: Intel Corporation Atom Processor E3800 Series SATA AHCI
Controller [8086:0f23]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 10
        Region 0: I/O ports at e070
        Region 1: I/O ports at e060
        Region 2: I/O ports at e050
        Region 3: I/O ports at e040
        Region 4: I/O ports at e020
        Region 5: Memory at d9602000 (32-bit, non-prefetchable)
        Capabilities: [80] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
                Address: fee0400c  Data: 4142
        Capabilities: [70] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=3D00000004
        Kernel driver in use: ahci
        Kernel modules: ahci
00: 86 80 23 0f 07 04 b0 02 0e 01 06 01 00 00 00 00
10: 71 e0 00 00 61 e0 00 00 51 e0 00 00 41 e0 00 00
20: 21 e0 00 00 00 20 60 d9 00 00 00 00 86 80 23 0f
30: 00 00 00 00 80 00 00 00 00 00 00 00 0a 01 00 00
40: 00 80 00 80 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 01 a8 03 40 08 00 00 00 00 00 00 00 00 00 00 00
80: 05 70 01 00 0c 40 e0 fe 42 41 00 00 00 00 00 00
90: 60 0d 02 82 83 01 00 3d 20 02 dc 22 00 70 00 80
a0: f4 00 00 00 00 00 00 00 12 00 10 00 48 00 00 00
b0: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 05 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 1a 0f 0e 01 00 00 00 00

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
