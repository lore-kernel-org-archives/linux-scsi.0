Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 819E2EB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbjGKVj2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjGKVjZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:39:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA14FE69
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:39:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 430F761635
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 21:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97F69C4163D
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 21:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689111563;
        bh=+Vn89n1KsmDahIUrosPnT+74XmMjI7qcQUH46Ta8vpk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ElDVQmY2y6fhWVnfOQHsYMwntILt1kewJWw92Y/eUjNLZL7Jja2mTS5kblyS1CfFh
         XIlFigJ0ekXDl4KqPZZqYINYH2SY8/2uuAjPTKVu9/ONPGWZLqV5kiBpXelwwQxMr4
         4c6Mc373YSK7EWMeecPCFWmfZ/fB+Jq4LNoxTmM7CauE1pAoDlvUeexmFfW7Wkdc5E
         VspMcqYEKApZmrU4P/A0o6iMipf3Fr2OIzeuvGIwk2wg3aKgaQRAlMYlzSwrb2mbqi
         8KUnxxX7FNuIUD8/yVWeJwtOUMcfQhiTT7JF7J4garEiDLGJuVD0dMeitVxK2jFH9e
         aSTUq5LRjCpvg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 77957C53BD4; Tue, 11 Jul 2023 21:39:23 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Tue, 11 Jul 2023 21:39:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: paula@alumni.cse.ucsc.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215880-11613-yRb1Wra5fc@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215880-11613@https.bugzilla.kernel.org/>
References: <bug-215880-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215880

--- Comment #55 from Paul Ausbeck (paula@alumni.cse.ucsc.edu) ---
lspci output is relatively small and easy:

00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core process=
or
DRAM Controller (rev 09)
00:02.0 VGA compatible controller: Intel Corporation IvyBridge GT2 [HD Grap=
hics
4000] (rev 09)
00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Fami=
ly
USB xHCI Host Controller (rev 04)
00:16.0 Communication controller: Intel Corporation 7 Series/C216 Chipset
Family MEI Controller #1 (rev 04)
00:19.0 Ethernet controller: Intel Corporation 82579V Gigabit Network
Connection (rev 04)
00:1a.0 USB controller: Intel Corporation 7 Series/C216 Chipset Family USB
Enhanced Host Controller #2 (rev 04)
00:1b.0 Audio device: Intel Corporation 7 Series/C216 Chipset Family High
Definition Audio Controller (rev 04)
00:1c.0 PCI bridge: Intel Corporation 7 Series/C216 Chipset Family PCI Expr=
ess
Root Port 1 (rev c4)
00:1c.7 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family P=
CI
Express Root Port 8 (rev c4)
00:1d.0 USB controller: Intel Corporation 7 Series/C216 Chipset Family USB
Enhanced Host Controller #1 (rev 04)
00:1f.0 ISA bridge: Intel Corporation H77 Express Chipset LPC Controller (r=
ev
04)
00:1f.2 SATA controller: Intel Corporation 7 Series/C210 Series Chipset Fam=
ily
6-port SATA Controller [AHCI mode] (rev 04)
00:1f.3 SMBus: Intel Corporation 7 Series/C216 Chipset Family SMBus Control=
ler
(rev 04)
01:00.0 Multimedia video controller: Conexant Systems, Inc. CX23887/8 PCIe
Broadcast Audio and Video Decoder with 3D Comb (rev 0f)
02:00.0 PCI bridge: Integrated Technology Express, Inc. IT8892E PCIe to PCI
Bridge (rev 30)
03:01.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23 IEEE-1394a-2000
Controller (PHY/Link)

I'll wait a bit for full dmesg output and/or bisecting. When I initially re=
ad
the bug report, ericspero seemed to do a pretty good job of bisecting the
change.

It seems that we still don't agree that libata is responsible for the newly
introduced lack of mouse pointer interactivity following resume. Therefore,=
 I
will spend some more time characterizing the problem. I have a relatively n=
ew
Chuwi laptop with a spare m.2/sata slot. I've ordered an m.2/sata to sata 7=
 pin
adapter so that I can plug a sata hard drive into this machine. As far as I=
 can
find, this type of adapter is only available directly from China so it will
take a couple of weeks to get them. I'll post the results then. If I can mu=
ster
to two machines as orthogonal as I can make them both exhibiting the same
problem, perhaps we might come together. Or perhaps the Chuwi machine won't
exhibit the problem and I'll have to rethink.

One other observation. It seems to me that libata maintainers should have a
machine containing a spinning disk at their disposal. I have a bunch of spa=
re
machines with hard drives and would be amenable to donating one for this
purpose. Also, in case you are interested, the previously described m.2/sat=
a to
7pin sata adapter is available on eBay at:

https://www.ebay.com/itm/394315621714?hash=3Ditem5bcf0ae552:g:YGYAAOSwAjRjY=
cUd&amdata=3Denc%3AAQAIAAAA8BpM7jdIQ4JS2IAPozAs7uLQETGPFQcybkuhO3nBfjImXm%2=
BMSA5oCG2CcetiX4fOY579FQd0JR8Pj81mS%2FW8k9MyCtUCg1hGuVhX4aMzkBQrzfXXjZcz%2F=
%2BldcLdwbLHcyTpN%2BjrSKmKiyGprAr1aZEH27ur%2FTJReKBBziJpJAz8qlG9j6GCGEYsA5R=
2kLpW0bSX4s8it5oZ1xTHDNhiidRnGvgTi16IvgMCZiLuGnOgTeSJuVA4kQdpsli2lYjmMwuU4i=
3USWppY5mh54l0AGV3Nf%2Ff4%2FCwhCoEogLghu62kFYpd7h3fofI8mCPTFLjh%2FA%3D%3D%7=
Ctkp%3ABk9SR7LBpuuoYg

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
