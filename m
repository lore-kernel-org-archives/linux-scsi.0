Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B98C2C4332F
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Nov 2023 06:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjKKGnz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Nov 2023 01:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjKKGnz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Nov 2023 01:43:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571D93C07
        for <linux-scsi@vger.kernel.org>; Fri, 10 Nov 2023 22:43:52 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABDDEC433CC
        for <linux-scsi@vger.kernel.org>; Sat, 11 Nov 2023 06:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699685031;
        bh=4H0iN8mFUjuGKpXQvs+bBD0og+tnFkgwwqfjSTgWiBQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ClPhInPNEijM46VWFXwHzqHzQW8NcLsPLy3PowHtH0aru1g8PPE4DByj3WLLBI3Fn
         nCibKbZ92W8aMK5xTpLLHgo4793ESd41QCt73xl93ks8AO1p0s9H3mu6DAX9VHd2GW
         2qZv58CkxrS0zKqFvmJtHLnQNNOHV5SxWMm+WXVRXgjlmRkVYLKVQKbeKCh46SSCQa
         xsFKhpPiO1Cboi4sM/wsCTuxlGOk24OTKpoT1cGE47xuQ07ldfoubRAWY25lKpi+wP
         gXYOTrABvN3A2dNs7OJDX5biU1T3Biq/GSj734Tsn1Q9p4GYFnXVAIlNUWNnvm/q+v
         aWHPbQcqtNW5A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 97F17C53BD5; Sat, 11 Nov 2023 06:43:51 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Sat, 11 Nov 2023 06:43:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: bobinium@thoughtsfactory.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-217599-11613-jCcHNjtbZX@https.bugzilla.kernel.org/>
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

--- Comment #25 from Robert Langlois (bobinium@thoughtsfactory.net) ---
Created attachment 305397
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D305397&action=3Dedit
Patch for aacraid FC38 6.3.12-200 vs 6.4.4-200

I have the same issue on two servers running Fedora 38 with different Adapt=
ec
coontrollers.

=3D=3D=3D Server 1:

# arcconf getconfig 1 AD | grep 'Model'
   Controller Model                         : Adaptec ASR72405

# arcconf getversion 1
Controllers found: 1
Controller #1
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Firmware                               : 7.5-0 (32118)
Staged Firmware                        : 7.5-0 (32118)
BIOS                                   : 7.5-0 (32118)
Driver                                 : 1.2-1 (50983)
Boot Flash                             : 7.5-0 (32118)
CPLD (Load version/ Flash version)     : 8/ 10
SEEPROM (Load version/ Flash version)  : 1/ 1

=3D=3D=3D Server 2:

# arcconf getconfig 1 AD | grep 'Model'
   Controller Model                           : Adaptec ASR71685

# arcconf getversion 1
Controllers found: 1
Controller #1
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Firmware                               : 7.5-0 (32118)
Staged Firmware                        : 7.5-0 (32118)
BIOS                                   : 7.5-0 (32118)
Driver                                 : 1.2-1 (50983)
Boot Flash                             : 7.5-0 (32118)
CPLD (Load version/ Flash version)     : 7/ 10
SEEPROM (Load version/ Flash version)  : 0/ 1

Both controllers have latest firmware.

Last known working kernel: 6.3.12-200<br>
First known non-working kernel: 6.4.4-200

Patch from Comment #22 did not work for me, still getting errors.

Submitted patch was done between two kernels above on 'drivers/scsi/aacraid=
'.
Applied and working on the folling Fedora kernels:

6.5.9-200.fc38
6.5.10-200.fc38
6.5.10-300.fc39
6.5.11-300.fc39

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
