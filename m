Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8823C04A95
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Oct 2022 07:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiJVH0M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 03:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiJVH0J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 03:26:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C02FE908
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 00:26:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99D9060AB1
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 07:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0FCFC433B5
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 07:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666423565;
        bh=rcY717VICBMkSvXkyIPGw0Rn/7+fAEiNbQJnoPCn6LY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=PMShMrVWobTcatWSBLv6r1a96bPIwa2qqipKM+HU4M0+8TxV72IMuJ3H57PK2eAX7
         3mTdNwWD8o1UPu3W3QiSX+Nb1DRxGulDphe90+2VI3n0NgTWr3Nt8dGhMx3FpD/G1b
         trIVjjwi4NbCx5tE1lGmYBEZ1a30fHGEvqT+tT0ReD0Wn6BIQfJqfr+CBtO/V3ilan
         5MBdJ59RPFpolvvto7c3bwV/Hr4EdEkNQOq40wI/DpxhwE/pQ6gXCZsySFSVrlMgvy
         o4GRCJ8jbLtgdcSNv0JmHRS8tRbr+MW3fEHDldp6VZbalO5IAh//zWtyrIYaFixjqx
         ntAkBY+Gs3BcA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D08C8C433E7; Sat, 22 Oct 2022 07:26:04 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216588] RTL9210(B) falsely detected as rotational disk
Date:   Sat, 22 Oct 2022 07:26:04 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: supgesu@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: drivers_usb@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216588-11613-BdhU6KWEtL@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216588-11613@https.bugzilla.kernel.org/>
References: <bug-216588-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216588

--- Comment #4 from Elias (supgesu@gmail.com) ---
(In reply to Martin K. Petersen from comment #3)
> I propose you create a udev rule to override what the device firmware
> erroneously reports.

The whole point of such an adapter is to make the disk portable, which make=
s it
possible to quickly connect it to many different machines (where some aren't
mine).

Creating a udev rule on every new machine is:
1.) annoying
2.) not possible since I don't always have root access

This is only a workaround limited to own personal machines. But it would be
much more useful if it was auto detected ootb correctly, hence this bug rep=
ort.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.=
