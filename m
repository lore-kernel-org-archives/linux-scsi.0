Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE1CEB64DC
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jul 2023 01:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjGJBHh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Jul 2023 21:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjGJBHg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Jul 2023 21:07:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E91C2
        for <linux-scsi@vger.kernel.org>; Sun,  9 Jul 2023 18:07:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 449E960D2D
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2023 01:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A78AEC433B7
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2023 01:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688951254;
        bh=7sbYCabzcqk+jLEJqQ+NJ9o7weCIV05+wGW4F+9jDzM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=SpohvOBQNLJT+E+9ET5OQfZFVtLzTfCRY5xwZbLzM3mcc53pOiQCwwOHtPdhilrSN
         MjCEAjYFBX4QtTOaPbDBw7eACf/FbLcniu0kwd6YLm0VSPMRgph+HCn2vi6Z8EhwIo
         80Q8sxwvTm/TWwxSTze0c3WnidluDFx5jGjFKc9QIuovkNgXSXtmbBe89CION5Jsqw
         9hHmoY6vJOF6UzkXkIMvC3xhS37ZDO02Pl8Sr+EVe/RIGzl6NR3Pyl4pQyVvgnBwtD
         EO3i3NUfgXG0XPc4BkjuYNbWjE0MY2tPF1HltV12cfzhfsGcIx9dVc1jR4qIoPFWcj
         GdfUNXdppNQmA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 98DE8C53BD2; Mon, 10 Jul 2023 01:07:34 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Mon, 10 Jul 2023 01:07:33 +0000
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
Message-ID: <bug-215880-11613-WkSsbZOzr9@https.bugzilla.kernel.org/>
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

--- Comment #50 from Damien Le Moal (damien.lemoal@wdc.com) ---
Hmmm... PCI device scan is supposed to be asynchronous. So having to wait f=
or
the hdd to spinup should not impact the GPU/mouse (which I assume is USB ?).
The messages "pci 0000:02:00.0: BAR 15: failed to assign" are weird... What=
 is
the device on port 0000:02:00.0 ? (see lspci).

Might want to raise this issue on linux-pci list.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
