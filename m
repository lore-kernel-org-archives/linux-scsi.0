Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 823E0CD37AD
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 22:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235863AbjIOWCZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 18:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237092AbjIOWB5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 18:01:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77260118
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 15:01:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 19990C433CA
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 22:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694815312;
        bh=OJ9wE0yERoS5xD76Y7/E7CfmVwh1WodSVe1C2l305gA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ERomU0P+svC1YdZ2Rvf7VI5qr04r45Urhv3zVVAF8N3AYXxPisXs/g2k51mmN3ZwN
         PkTCwxP7s9j6aj9f8XW+5WKpbj95tNEb2CzJPwogwx3vodZmkiMYYTogYinRGGBtCW
         bxsN6tncGPYQvuaSFr7cUXquW1Weh9QB7DXqLco9yB4A6+o6x5aH8d/aN+SFqzQsj0
         RXe6RXuOO13lEmaYW4bPvaqMwzctXd63IkHK7Xlj9pGjz9aF+OoiTvxJY96YMDe9zE
         d+c+VEqfI/Gzn5BTIRlyEy8uCnTH/d8KvmalhjUTu+gUXbcq+KRNm3RpJFbSJVFmRb
         Ub8ou5MribhJA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 02B4CC53BCD; Fri, 15 Sep 2023 22:01:52 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217914] scsi_eh_1 process high cpu after upgrading to 6.5
Date:   Fri, 15 Sep 2023 22:01:51 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: Niklas.Cassel@wdc.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217914-11613-L0LDEzFXB8@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217914-11613@https.bugzilla.kernel.org/>
References: <bug-217914-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217914

--- Comment #4 from Niklas.Cassel@wdc.com ---
On Fri, Sep 15, 2023 at 01:42:18PM -0700, Bart Van Assche wrote:
> On 9/15/23 12:33, bugzilla-daemon@kernel.org wrote:
> > The users loqs and leonshaw helped to narrow it down to this commit:
> >=20
> >
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D624885209f31eb9985bf51abe204ecbffe2fdeea
>=20
> Damien, can you please take a look?
>=20

Hello Bart,

It seems like:
https://lore.kernel.org/linux-scsi/20230915022034.678121-1-dlemoal@kernel.o=
rg/

Solves the problem.

From a quick look at the logs with extra log leves enabled:
https://pastebin.com/f2LQ8kQD
it appears that the MAINTENANCE_IN / MI_REPORT_SUPPORTED_OPERATION_CODES
command with a non-zero service action issued by scsi_cdl_check() fails,
and will be added to SCSI EH over and over.


Kind regards,
Niklas

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
