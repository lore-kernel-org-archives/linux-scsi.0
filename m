Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E52EB64DD
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 21:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjG0VW2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 17:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjG0VW2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 17:22:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA562D7D
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 14:22:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74AB461F43
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 21:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5D48C433C9
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 21:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690492945;
        bh=GtO8sb7isZ+53XexAK7kQ6OC/MOC7tLf4wsjvV5aJGA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=aBqRLOrSuju+Bf3Pkp8M51J6Rvr2sZNtpfnAHxGkSrhASOWLn6fOXO3w/95dRkSEJ
         n7xL8j51wI1MbougliM+UfMNWYKvrHuyV5KwkhBJrmcf2ZDPktP6MwYe4yxHU+wANP
         5Pr0DXbnSDtdW0QwGYARqrVRefBTPMIzTQ5hspuPJ77WgaBvsZ/A27YG/dtFUUWeTJ
         M1F2sJqlH1wL1T4jDfY5bK2ea7fPLB5vPqBOAdQjsWXYl3UrslInas8CYL1qVMgXCJ
         c8ft2P04gcDsobCvW0Z4vBq1OLcAtBdlXPUdwWf5GKxoDcq7QAj7cS6R5On/W71+dW
         qFfPARYRm3aXQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C22F0C53BD0; Thu, 27 Jul 2023 21:22:25 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Thu, 27 Jul 2023 21:22:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: kernel@roadkil.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217599-11613-ru6XW8MBjQ@https.bugzilla.kernel.org/>
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

Jason Hatley (kernel@roadkil.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kernel@roadkil.net

--- Comment #10 from Jason Hatley (kernel@roadkil.net) ---
I have the exact same issue after upgrading to Kernel 6.4.7 using an Adaptec
Adaptec ASR71605. Using previous kernel 6.0.0 the problem goes away.=20=20

The controller hangs approximately every 5 minutes for a period of about 2
minutes .

2023-07-28T07:11:44.380218+10:00 linux kernel: [ 1906.291075] aacraid: Host=
 bus
reset request. SCSI hang ?
2023-07-28T07:11:44.380224+10:00 linux kernel: [ 1906.291084] aacraid
0000:04:00.0: outstanding cmd: midlevel-0
2023-07-28T07:11:44.380225+10:00 linux kernel: [ 1906.291086] aacraid
0000:04:00.0: outstanding cmd: lowlevel-0
2023-07-28T07:11:44.380226+10:00 linux kernel: [ 1906.291087] aacraid
0000:04:00.0: outstanding cmd: error handler-0
2023-07-28T07:11:44.380226+10:00 linux kernel: [ 1906.291088] aacraid
0000:04:00.0: outstanding cmd: firmware-32
2023-07-28T07:11:44.380227+10:00 linux kernel: [ 1906.291089] aacraid
0000:04:00.0: outstanding cmd: kernel-0
2023-07-28T07:11:44.400215+10:00 linux kernel: [ 1906.311066] aacraid
0000:04:00.0: Controller reset type is 3
2023-07-28T07:11:44.400221+10:00 linux kernel: [ 1906.311071] aacraid
0000:04:00.0: Issuing IOP reset
2023-07-28T07:12:29.044219+10:00 linux kernel: [ 1950.957989] aacraid
0000:04:00.0: IOP reset succeeded
2023-07-28T07:12:29.108222+10:00 linux kernel: [ 1951.018606] aacraid: Comm
Interface type2 enabled
2023-07-28T07:12:38.144232+10:00 linux kernel: [ 1960.056334] aacraid
0000:04:00.0: Scheduling bus rescan
2023-07-28T07:12:48.821198+10:00 linux kernel: [ 1970.734618] sd 0:1:8:0: [=
sdi]
tag#312 timing out command, waited 120s
2023-07-28T07:15:18.872254+10:00 linux kernel: [ 2120.779775] md: md126:
reshape interrupted.
2023-07-28T07:15:52.172242+10:00 linux kernel: [ 2154.074084] aacraid: Host
adapter abort request.
2023-07-28T07:15:52.172257+10:00 linux kernel: [ 2154.074084] aacraid:
Outstanding commands on (0,1,12,0):
2023-07-28T07:15:52.172259+10:00 linux kernel: [ 2154.074109] aacraid: Host
adapter abort request.
2023-07-28T07:15:52.172260+10:00 linux kernel: [ 2154.074109] aacraid:
Outstanding commands on (0,1,3,0):
2023-07-28T07:15:52.172261+10:00 linux kernel: [ 2154.074119] aacraid: Host
adapter abort request.
2023-07-28T07:15:52.172262+10:00 linux kernel: [ 2154.074119] aacraid:
Outstanding commands on (0,1,2,0):
2023-07-28T07:15:52.292291+10:00 linux kernel: [ 2154.196250] sd 0:1:3:0: [=
sdd]
15628053168 512-byte logical blocks: (8.00 TB/7.28 TiB)
2023-07-28T07:15:52.292302+10:00 linux kernel: [ 2154.196254] sd 0:1:3:0: [=
sdd]
4096-byte physical blocks
2023-07-28T07:15:56.008234+10:00 linux kernel: [ 2157.909736] aacraid: Host
adapter abort request.
2023-07-28T07:15:56.008250+10:00 linux kernel: [ 2157.909736] aacraid:
Outstanding commands on (0,1,10,0):
2023-07-28T07:15:56.016229+10:00 linux kernel: [ 2157.917723] aacraid: Host
adapter abort request.
2023-07-28T07:15:56.016238+10:00 linux kernel: [ 2157.917723] aacraid:
Outstanding commands on (0,1,8,0):
2023-07-28T07:15:56.276248+10:00 linux kernel: [ 2158.178018] aacraid: Host
adapter abort request.
2023-07-28T07:15:56.276264+10:00 linux kernel: [ 2158.178018] aacraid:
Outstanding commands on (0,1,13,0):
2023-07-28T07:15:56.276266+10:00 linux kernel: [ 2158.178029] aacraid: Host
adapter abort request.
2023-07-28T07:15:56.276267+10:00 linux kernel: [ 2158.178029] aacraid:
Outstanding commands on (0,1,2,0):
2023-07-28T07:15:56.276268+10:00 linux kernel: [ 2158.178033] aacraid: Host
adapter abort request.
2023-07-28T07:15:56.276268+10:00 linux kernel: [ 2158.178033] aacraid:
Outstanding commands on (0,1,12,0):
2023-07-28T07:15:56.276269+10:00 linux kernel: [ 2158.178037] aacraid: Host
adapter abort request.
2023-07-28T07:15:56.276270+10:00 linux kernel: [ 2158.178037] aacraid:
Outstanding commands on (0,1,4,0):
2023-07-28T07:15:56.276271+10:00 linux kernel: [ 2158.178041] aacraid: Host
adapter abort request.
2023-07-28T07:15:56.276272+10:00 linux kernel: [ 2158.178041] aacraid:
Outstanding commands on (0,1,5,0):
2023-07-28T07:15:56.276273+10:00 linux kernel: [ 2158.178045] aacraid: Host
adapter abort request.
2023-07-28T07:15:56.276273+10:00 linux kernel: [ 2158.178045] aacraid:
Outstanding commands on (0,1,5,0):
2023-07-28T07:15:56.276274+10:00 linux kernel: [ 2158.178071] aacraid: Host
adapter abort request.
2023-07-28T07:15:56.276275+10:00 linux kernel: [ 2158.178071] aacraid:
Outstanding commands on (0,1,5,0):
2023-07-28T07:15:56.276275+10:00 linux kernel: [ 2158.178074] aacraid: Host
adapter abort request.
2023-07-28T07:15:56.276276+10:00 linux kernel: [ 2158.178074] aacraid:
Outstanding commands on (0,1,0,0):
2023-07-28T07:15:56.276277+10:00 linux kernel: [ 2158.181733] aacraid: Host
adapter abort request.
2023-07-28T07:15:56.276278+10:00 linux kernel: [ 2158.181733] aacraid:
Outstanding commands on (0,1,14,0):
2023-07-28T07:15:58.588241+10:00 linux kernel: [ 2160.489557] aacraid: Host
adapter abort request.
2023-07-28T07:15:58.588266+10:00 linux kernel: [ 2160.489557] aacraid:
Outstanding commands on (0,1,4,0):
2023-07-28T07:16:00.876228+10:00 linux kernel: [ 2162.777426] aacraid: Host
adapter abort request.
2023-07-28T07:16:00.876246+10:00 linux kernel: [ 2162.777426] aacraid:
Outstanding commands on (0,1,0,0):
2023-07-28T07:16:06.512253+10:00 linux kernel: [ 2168.413075] aacraid: Host
adapter abort request.
2023-07-28T07:16:06.512273+10:00 linux kernel: [ 2168.413075] aacraid:
Outstanding commands on (0,1,15,0):
2023-07-28T07:16:07.032219+10:00 linux kernel: [ 2168.933027] aacraid: Host
adapter abort request.
2023-07-28T07:16:07.032232+10:00 linux kernel: [ 2168.933027] aacraid:
Outstanding commands on (0,1,14,0):
2023-07-28T07:16:10.872240+10:00 linux kernel: [ 2172.772793] aacraid: Host
adapter abort request.
2023-07-28T07:16:10.872256+10:00 linux kernel: [ 2172.772793] aacraid:
Outstanding commands on (0,1,10,0):
2023-07-28T07:16:14.700245+10:00 linux kernel: [ 2176.600526] aacraid: Host
adapter abort request.
2023-07-28T07:16:14.700259+10:00 linux kernel: [ 2176.600526] aacraid:
Outstanding commands on (0,1,8,0):
2023-07-28T07:16:14.700262+10:00 linux kernel: [ 2176.604511] aacraid: Host
adapter abort request.
2023-07-28T07:16:14.700263+10:00 linux kernel: [ 2176.604511] aacraid:
Outstanding commands on (0,1,9,0):
2023-07-28T07:16:18.804238+10:00 linux kernel: [ 2180.704264] aacraid: Host
adapter abort request.
2023-07-28T07:16:18.804258+10:00 linux kernel: [ 2180.704264] aacraid:
Outstanding commands on (0,1,13,0):
2023-07-28T07:16:22.892239+10:00 linux kernel: [ 2184.791994] aacraid: Host
adapter abort request.
2023-07-28T07:16:22.892253+10:00 linux kernel: [ 2184.791994] aacraid:
Outstanding commands on (0,1,1,0):
2023-07-28T07:16:22.892256+10:00 linux kernel: [ 2184.792047] aacraid: Host=
 bus
reset request. SCSI hang ?
2023-07-28T07:16:22.892257+10:00 linux kernel: [ 2184.792056] aacraid
0000:04:00.0: outstanding cmd: midlevel-0
2023-07-28T07:16:22.892258+10:00 linux kernel: [ 2184.792059] aacraid
0000:04:00.0: outstanding cmd: lowlevel-0
2023-07-28T07:16:22.892260+10:00 linux kernel: [ 2184.792060] aacraid
0000:04:00.0: outstanding cmd: error handler-10
2023-07-28T07:16:22.892261+10:00 linux kernel: [ 2184.792061] aacraid
0000:04:00.0: outstanding cmd: firmware-0
2023-07-28T07:16:22.892262+10:00 linux kernel: [ 2184.792062] aacraid
0000:04:00.0: outstanding cmd: kernel-0
2023-07-28T07:16:22.924446+10:00 linux kernel: [ 2184.824253] aacraid
0000:04:00.0: Controller reset type is 3
2023-07-28T07:16:22.924453+10:00 linux kernel: [ 2184.824257] aacraid
0000:04:00.0: Issuing IOP reset
2023-07-28T07:17:07.708235+10:00 linux kernel: [ 2229.607605] aacraid
0000:04:00.0: IOP reset succeeded
2023-07-28T07:17:07.768229+10:00 linux kernel: [ 2229.665769] aacraid: Comm
Interface type2 enabled
2023-07-28T07:17:16.808238+10:00 linux kernel: [ 2238.704668] aacraid
0000:04:00.0: Scheduling bus rescan

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
