Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6175C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 11:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiDFLiA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 07:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbiDFLhA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2022 07:37:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205FF26AE11
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 01:26:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B28BEB8217E
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 08:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 798AAC385B8
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 08:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649233593;
        bh=ORkarmYzI6EEG1uh+1UGHbjGlq0FbnchYNr2x6cZQtg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ehEsvYCGWPYHuqyO0+eusCTyiqH9z73vOk67+i17YJ//jZkckDN2jl4GfDcMEilEs
         GQR+mZ2qe4YdZH1KgOdsmoQh2QeztpnnyEd3vvLauiIbYWBMFzxyuC0OpCp1ZcCOqc
         vpYWs+zm+cBnKovN8AQE9XK//uK4qrsdFPaAnMyjS89d8XpPIe48OGsB8k9QRDdT+v
         xnWVCiTrIgUNpTW9D1dEWOZBxoDjS1QAPfXsnSfaSygRZTWBR/uGsoOxjaqU8QYmgb
         8Wiby5n4KNJYpLmxlkRsyHqlgyB1aVq/K9yHWU0jmaeevawa8u5K4l0oOq0bNaOi+1
         R79vbTy5U9/Uw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5E630C05FD4; Wed,  6 Apr 2022 08:26:33 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215788] arcmsr driver on kernel 5.16 and up fails to initialize
 ARC-1280ML RAID controller
Date:   Wed, 06 Apr 2022 08:26:33 +0000
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
Message-ID: <bug-215788-11613-nd5G5m1pF9@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215788-11613@https.bugzilla.kernel.org/>
References: <bug-215788-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215788

--- Comment #7 from Damien Le Moal (damien.lemoal@wdc.com) ---
On Wed, 2022-04-06 at 06:59 +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D215788
>=20
> --- Comment #6 from Jernej Simon=C4=8Di=C4=8D (jernej-bugzilla.kernel@ena=
.si) ---
> Doesn't help unfortunately.

Hmm... And everything is OK if you comment out that function call ?

Can you post the output of these commands for the RAID disk ?

sg_inq /dev/sdX
sg_inq --vpd /dev/sdX
sg_vpd -E /dev/sdX
sg_logs -l -l /dev/sdX

And then last:

sg_vpd --force --page=3D0xb9 /dev/sdX

This last command could be the one crashing the HBA/drive so beware.
Your drive clearly should not be supporting vpd page 0xb9, so
sd_read_cpr() should be a nop, doing nothing. It does not seem to be
the case. Maybe this adapter uses page 0xb9 as a vendor specific one,
causing problems. The above commands will allow checking that.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
