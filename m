Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 645ECC6FA86
	for <linux-scsi@archiver.kernel.org>; Sat, 17 Sep 2022 20:50:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiIQUuw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 17 Sep 2022 16:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiIQUuv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Sep 2022 16:50:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F952B243
        for <linux-scsi@vger.kernel.org>; Sat, 17 Sep 2022 13:50:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CD09611E6
        for <linux-scsi@vger.kernel.org>; Sat, 17 Sep 2022 20:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2F50C433D7
        for <linux-scsi@vger.kernel.org>; Sat, 17 Sep 2022 20:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663447846;
        bh=nhKeki83RPOXTC5+/w3Cnwy2yfuK54LMi6gm+EUgPpk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=VWrJNBX4csnMroWxNsgID+/khavHQtMVJ4P3yKBmaWVt7tQCiWDqICt6geUf4jfrC
         x4A0BCgiXKNoXwcolJdmRKZ63kRsB7HzKRvDr/IaUBVHvVZuWRZbJP8NAZ2evQTgpG
         HL6jVN1QmQzuE4ytP07xs5S8rl6ca+E/qKVq0Yl7k8vv3XSoqiMKaz5BymBmc+/8gf
         sGNxIX7+16e3YOV2ilRanBnyHo8O4ClrsVV7mF2KksHnNBkVY361W8Sq3XkPOzmO95
         8/vGFJWNdAnY8iWHmgOhCljgMoBhKd18zq4oucosViAGOj+YmtTU7hR/uuK3LeNcAS
         vUbZcPIlBWXoQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B8272C433E7; Sat, 17 Sep 2022 20:50:46 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 199887] Fibre login failure on older adapters
Date:   Sat, 17 Sep 2022 20:50:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-qla2xxx@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: QLOGIC QLA2XXX
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: peak@argo.troja.mff.cuni.cz
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-qla2xxx@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-199887-11613-vymC70BFaN@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199887-11613@https.bugzilla.kernel.org/>
References: <bug-199887-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D199887

--- Comment #5 from Pavel Kankovsky (peak@argo.troja.mff.cuni.cz) ---
Some additional findings:

1. It turns out qla2x00_get_node_name_list() was introduced in 3.5 and it w=
as
called from qla_target.c until 3.11 when the call was removed and the funct=
ion
remained unused until its own removal in 4.11.

I have not tested whether it would work on an old HBA but it is far from
certain (its result was an array of "struct qla_port_24xx_data", correspond=
ing
to "struct get_name_list" in recent versions), and even if it would, it wou=
ld
not help much (there seem to be two variants of MBC_PORT_NODE_NAME_LIST, the
old function invoked the variant providing less data while the current code
needs the variant providing more data, "struct get_name_list_extended").

2. The driver is sometimes unable to relogin when an old HBA reconnects to =
the
fabric because "Async-login" keeps failing with 4007 ie. MBS_PORT_ID_USED. =
It
turns out qla24xx_handle_plogi_done_event expects an offending loopid in
ea->iop[1] but qla2x00_mbx_iocb_entry stores the value in ea->data[1].

(A similar problem occurs during the handling 4008 ie. MBS_LOOP_ID_USED when
qla24xx_handle_plogi_done_event expects an offending portid in ea->iop[1] b=
ut
it is not stored anywhere. But the driver seems to be able to recover in th=
is
case.)

3. Newer HBAs seem to use the same command (MBC_LOGIN_FABRIC_PORT) for both
fabric and private loop port login but old HBAs need a different command
(MBC_LOGIN_LOOP_PORT) in the latter case. See qla2x00_local_device_login.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
