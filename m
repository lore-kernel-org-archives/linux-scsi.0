Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3101ECAAA2
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Aug 2022 19:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiH1Tyk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Aug 2022 15:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiH1Tyj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Aug 2022 15:54:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8818531ECD
        for <linux-scsi@vger.kernel.org>; Sun, 28 Aug 2022 12:54:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26349B80B95
        for <linux-scsi@vger.kernel.org>; Sun, 28 Aug 2022 19:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5478C433D7
        for <linux-scsi@vger.kernel.org>; Sun, 28 Aug 2022 19:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661716474;
        bh=Y0jKIbaHml36dbuULqChxnm2qAqSQG1EzAEqYNipRsE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=tZKaVL/iXxPnxlPVriM5TAGHZn+P2lYPfYAbUfB5q/t9NEBxqp5mdFRfNYmqywx/Z
         qWQZOH4Ad/O89zFigHp7PBCup2nxGJ7zsmZKIXkPxA/ewzmfU/1QmFOgI/QmSvhtSf
         N4LHNSGYgD2XAY0BfsNNJuY7a7jdLqoIfwkXwucGSEEeLDY/nakJly6ONc/Zj5Q5ti
         mAEot5C6M08PYSkeyip5yfbYnvoVtiEkQi6+PztzievHhYg9NBdzAj+8JFZ524K69K
         v3a02sZd1OG0AY+JujQtl8Qd7nnmCaSsSdzp8xiUJbkJHAF2HJjEdxGKbaT8LD305f
         ZPt9Xj1epQeAg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id BFA1EC433E4; Sun, 28 Aug 2022 19:54:34 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 199887] Fibre login failure on older adapters
Date:   Sun, 28 Aug 2022 19:54:34 +0000
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
X-Bugzilla-Changed-Fields: cc attachments.created
Message-ID: <bug-199887-11613-KCUChxQpmA@https.bugzilla.kernel.org/>
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

Pavel Kankovsky (peak@argo.troja.mff.cuni.cz) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |peak@argo.troja.mff.cuni.cz

--- Comment #4 from Pavel Kankovsky (peak@argo.troja.mff.cuni.cz) ---
Created attachment 301697
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301697&action=3Dedit
kinda fix

I did some experiments with my old QLA2340 (ISP2312, fw 3.03.28) and the mo=
st
recent stable kernel, ie. 5.19.4.

"Async-gnlist" failures seem to be survivable and I decided to ignore them =
for
the time being. In fact, the old driver in 4.9.325 was able to work without
MBC_PORT_NODE_NAME_LIST. There was a function issuing that command, namely
qla2x00_get_node_name_list(), but AFAICT it was never called.

"Async-gpdb" failures are a real problem because they trigger session delet=
ion
(qla24xx_handle_gpdb_event() gets an invalid zero login state).

As far as I can tell, the new asynchronous implementation provides correct
parameters to MBC_GET_PORT_DATABASE (compare qla24xx_async_gpdb() with
qla2x00_get_port_database(), HAS_EXTENDED_IDS is true for ISP2312) but
1. the adapter cannot handle the request when it receives it via the IOCB
interface, and
2. the driver would not be able to handle returned data anyway because their
format is completely different on old non-IS_FWI2_CAPABLE adapters (compare
qla24xx_handle_gpdb_event() with the final part of
qla2x00_get_port_database()).

I tried replacing the new code with a small wrapper around a call to the old
qla2x00_get_port_database() sending the request synchronously via the mbox
interface... and it worked! The driver was able to finish logins and access
available FC targets. See the attached patch.

That said, it is a horrible hack done by someone almost totally ignorant of=
 the
inner workings of the driver. There is absolutely no guarantee. It might cr=
ash
your kernel. It might fail to handle some (newly connected?) remote ports. =
It
might brick your adapter. It might wipe all your disk arrays. It might summ=
on
the Elder Gods. You have been warned.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
