Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E60FEEB64D7
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jun 2023 22:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjFZWgR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jun 2023 18:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjFZWgQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2023 18:36:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E889E53
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2023 15:36:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9519C60F8A
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2023 22:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E77C1C433C8
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2023 22:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687818973;
        bh=R9i31fO7AWxc1kr1r0MrhMuChUms/6ItL8T2PrWU/9k=;
        h=From:To:Subject:Date:From;
        b=g8TkRsdNiaZPyoOuR49TsnSRW414oNHn96bX53V126vUi2Dh4G+HnGm4nAQOlMRrZ
         vmTSIn1XQW5zWMaoi05jRR5fbmki/YFMbKJxfL+Mp2wr6U1Zu23EERF57ebi6K3JKk
         RGghSfdkUotQrPLJ2FZpdPXFlplZ+4xPEj7ywYXSPnEd44la0nGCtsyp3gR/QdOwAZ
         mqLqQdr4cVe3pZ7NjSvSQrv7aQB7hFBCPdYz/7z6juuKBDY/gLUyoqJSEZVXCswAzH
         ll08yds9rZ+a5qlvpRyupu1qhyvty4BtFf8Q21izQwsxjK9OcUhJDNCtDiWLptLDOV
         dxNw/vNhQCB+Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id CC207C53BD2; Mon, 26 Jun 2023 22:36:13 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] New: Adaptec 71605z hangs with aacraid: Host adapter
 abort request after update to linux 6.4.0
Date:   Mon, 26 Jun 2023 22:36:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: pheidologeton@protonmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-217599-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

            Bug ID: 217599
           Summary: Adaptec 71605z hangs with aacraid: Host adapter abort
                    request after update to linux 6.4.0
           Product: SCSI Drivers
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: high
          Priority: P3
         Component: AACRAID
          Assignee: scsi_drivers-aacraid@kernel-bugs.osdl.org
          Reporter: pheidologeton@protonmail.com
        Regression: No

The controller works fine for a few minutes. Then it hangs for a few tens of
seconds to a few minutes, then also works normally for a while. This bug is
present in the 6.4.0 kernel release (6.3.9 works without hanging)
The messages in dmesg are as follows

[  287.137901] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137909] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137912] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137914] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137916] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137919] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137921] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137924] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137926] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137928] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137930] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137933] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137934] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137937] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137939] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137941] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137943] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137945] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137947] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137949] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137951] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137952] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137954] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137956] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137958] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137960] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137962] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137964] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137966] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137967] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137969] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.137971] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  287.157697] aacraid: Host bus reset request. SCSI hang ?
[  287.157706] aacraid 0000:02:00.0: outstanding cmd: midlevel-0
[  287.157708] aacraid 0000:02:00.0: outstanding cmd: lowlevel-0
[  287.157709] aacraid 0000:02:00.0: outstanding cmd: error handler-0
[  287.157711] aacraid 0000:02:00.0: outstanding cmd: firmware-32
[  287.157712] aacraid 0000:02:00.0: outstanding cmd: kernel-0
[  287.167040] aacraid 0000:02:00.0: Controller reset type is 3
[  287.167042] aacraid 0000:02:00.0: Issuing IOP reset
[  321.029712] aacraid 0000:02:00.0: IOP reset succeeded
[  321.066201] numacb=3D512 ignored
[  321.066843] aacraid: Comm Interface type2 enabled
[  344.845370] aacraid 0000:02:00.0: Scheduling bus rescan
[  358.294342] sd 10:0:0:0: [sda] Very big device. Trying to use READ
CAPACITY(16).
[  442.109147] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109155] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109158] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109160] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109162] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109164] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109166] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109168] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109170] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109172] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109174] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109176] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109178] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109179] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109181] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109183] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109185] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109187] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109189] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109191] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109193] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109194] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109196] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109198] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109200] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109201] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109203] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109205] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109207] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109208] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.109210] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.137144] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (10,0,0,0):
[  442.154292] aacraid: Host bus reset request. SCSI hang ?
[  442.154302] aacraid 0000:02:00.0: outstanding cmd: midlevel-0
[  442.154305] aacraid 0000:02:00.0: outstanding cmd: lowlevel-0
[  442.154307] aacraid 0000:02:00.0: outstanding cmd: error handler-0
[  442.154308] aacraid 0000:02:00.0: outstanding cmd: firmware-32
[  442.154310] aacraid 0000:02:00.0: outstanding cmd: kernel-0
[  442.171131] aacraid 0000:02:00.0: Controller reset type is 3
[  442.171133] aacraid 0000:02:00.0: Issuing IOP reset
[  476.040983] aacraid 0000:02:00.0: IOP reset succeeded
[  476.078055] numacb=3D512 ignored
[  476.078606] aacraid: Comm Interface type2 enabled
[  494.747632] aacraid 0000:02:00.0: Scheduling bus rescan
[  507.896453] sd 10:0:0:0: [sda] Very big device. Trying to use READ
CAPACITY(16).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
