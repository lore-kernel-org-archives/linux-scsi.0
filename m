Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB2D1C5ACB3
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Nov 2023 14:23:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjKROXo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Nov 2023 09:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjKROXn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Nov 2023 09:23:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7670D126
        for <linux-scsi@vger.kernel.org>; Sat, 18 Nov 2023 06:23:39 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02AB5C433C9
        for <linux-scsi@vger.kernel.org>; Sat, 18 Nov 2023 14:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700317419;
        bh=j5MT2VDulfigmPgmxLxRdcczmS12fpbxF9q9596MrgA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=RmDmzYQ9TS7YdFvLbSDo7qi7ZNtpcUSvOZLHhNCCk7QTvpoO8u5QG+E9ZORH0kSQ5
         RURbhsuMdnFPMeAgMtPkRbtS2Ci4H2DeBw0g9zd2YOyMgWL6PdvpurPnSVCPOLZXGJ
         jIh2z+zCszkIIPOuHOzzw5WhAoT0UhwiSwDcaCSstBGGodOrAyDVI16JtZQwIHTEpS
         1Hup5zNKlKOM83ESoCJMcQcmdDJkbFxx6Egv8aOAihMJeLivSi7WKbEZGKlPmvaaVu
         Zk7ghtNkElkiV3cDb67IYFIsm3+ornVk05VWgygyrTvsVeyTCJ+8ZXYmrfI8OzZysY
         UOxaW7ggX+nYA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E5A34C53BD6; Sat, 18 Nov 2023 14:23:38 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Sat, 18 Nov 2023 14:23:38 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: leyyyyy@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217599-11613-0MLhFTvPty@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217599-11613@https.bugzilla.kernel.org/>
References: <bug-217599-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

Maxim (leyyyyy@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |leyyyyy@gmail.com

--- Comment #27 from Maxim (leyyyyy@gmail.com) ---
I have the same issue with openSUSE and Fedora new kernels.
When I installed Leap 15.5 with 5.14 kernel or COPR for Fedora with kernel =
5.15
all works fine.

First time I got the issue with kernel 5.19 on Fedora and ASR-72405 control=
ler
with connected NetApp DS.

openUSE 6.6.1 dmesg log:
```
[ 7427.739081] aacraid: Host bus reset request. SCSI hang ?
[ 7427.739101] aacraid 0000:08:00.0: outstanding cmd: midlevel-0
[ 7427.739105] aacraid 0000:08:00.0: outstanding cmd: lowlevel-0
[ 7427.739107] aacraid 0000:08:00.0: outstanding cmd: error handler-0
[ 7427.739109] aacraid 0000:08:00.0: outstanding cmd: firmware-48
[ 7427.739111] aacraid 0000:08:00.0: outstanding cmd: kernel-0
[ 7427.765640] aacraid 0000:08:00.0: Controller reset type is 3
[ 7427.765652] aacraid 0000:08:00.0: Issuing IOP reset
[ 7469.875692] aacraid 0000:08:00.0: IOP reset succeeded
[ 7469.936116] aacraid: Comm Interface type2 enabled
[ 7483.472661] aacraid 0000:08:00.0: Scheduling bus rescan
[ 7496.491585] sd 0:0:0:0: [sda] Very big device. Trying to use READ
CAPACITY(16).
[ 7496.491764] sd 0:0:1:0: [sdb] Very big device. Trying to use READ
CAPACITY(16).
[ 7553.768632] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7553.768644] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7553.768650] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7553.768655] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7553.768660] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7553.768664] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7553.768669] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7553.818630] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7553.835297] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7553.835306] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7553.835312] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7553.835317] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7553.835322] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7553.835326] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7553.835331] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7553.835335] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7553.835340] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7553.835344] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7553.835348] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7553.835353] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7553.835357] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7598.355616] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7598.355631] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7598.355637] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7598.355642] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7598.355647] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7598.355652] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7598.355657] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7598.355661] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7598.355666] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7598.382419] aacraid: Host bus reset request. SCSI hang ?
[ 7598.382439] aacraid 0000:08:00.0: outstanding cmd: midlevel-0
[ 7598.382443] aacraid 0000:08:00.0: outstanding cmd: lowlevel-0
[ 7598.382445] aacraid 0000:08:00.0: outstanding cmd: error handler-0
[ 7598.382447] aacraid 0000:08:00.0: outstanding cmd: firmware-30
[ 7598.382449] aacraid 0000:08:00.0: outstanding cmd: kernel-0
[ 7598.402360] aacraid 0000:08:00.0: Controller reset type is 3
[ 7598.402371] aacraid 0000:08:00.0: Issuing IOP reset
[ 7640.363459] aacraid 0000:08:00.0: IOP reset succeeded
[ 7640.422724] aacraid: Comm Interface type2 enabled
[ 7653.650105] aacraid 0000:08:00.0: Scheduling bus rescan
[ 7666.688374] sd 0:0:0:0: [sda] Very big device. Trying to use READ
CAPACITY(16).
[ 7666.688467] sd 0:0:1:0: [sdb] Very big device. Trying to use READ
CAPACITY(16).
[ 7814.462297] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7814.462308] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7814.462313] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7814.462318] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7814.462322] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7814.462326] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7814.462330] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7814.462334] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7814.462338] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,1,0):
[ 7814.478923] aacraid: Host bus reset request. SCSI hang ?
[ 7814.478936] aacraid 0000:08:00.0: outstanding cmd: midlevel-0
[ 7814.478938] aacraid 0000:08:00.0: outstanding cmd: lowlevel-0
[ 7814.478940] aacraid 0000:08:00.0: outstanding cmd: error handler-0
[ 7814.478942] aacraid 0000:08:00.0: outstanding cmd: firmware-9
[ 7814.478943] aacraid 0000:08:00.0: outstanding cmd: kernel-0
[ 7814.495578] aacraid 0000:08:00.0: Controller reset type is 3
[ 7814.495587] aacraid 0000:08:00.0: Issuing IOP reset
[ 7856.730598] aacraid 0000:08:00.0: IOP reset succeeded
[ 7856.779371] aacraid: Comm Interface type2 enabled
[ 7869.946607] aacraid 0000:08:00.0: Scheduling bus rescan
[ 7882.985564] sd 0:0:0:0: [sda] Very big device. Trying to use READ
CAPACITY(16).
[ 7882.985661] sd 0:0:1:0: [sdb] Very big device. Trying to use READ
CAPACITY(16).
```

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
