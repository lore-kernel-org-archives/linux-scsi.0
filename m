Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A6CEC433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Oct 2022 15:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiJFPh2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Oct 2022 11:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbiJFPh1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2022 11:37:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E201BD074
        for <linux-scsi@vger.kernel.org>; Thu,  6 Oct 2022 08:37:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9971B8210C
        for <linux-scsi@vger.kernel.org>; Thu,  6 Oct 2022 15:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 74DEFC43148
        for <linux-scsi@vger.kernel.org>; Thu,  6 Oct 2022 15:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665070643;
        bh=o8MMlog5d4CSBMkJhTr1kh8wSAVZaHL7zNaC7nxf1gE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=RGpabVZfInvcQi+dkmMw4zoOBeavu+pNxopQo540tcMZfHoHlpuKrV8NfZq9vEdGb
         aypV4VPao4SGf7t/IqnjSf5BupFSQEK+UPCgqKfFMTblXsdaq0atIjD+SSEgsuIh20
         bqH3nxHv4PLUFgYv/dGrwJUsEHWNiq7cGPkp3e8sVuqSU1H4n5tmMUmOcuwmItCM9D
         3JwmGLeVKRt5RGrT0ZOQpxWLXpjDN2Cdom2pZ0Eu2VAkPYpoesGr6mVUcVfJ+sBc+g
         Im9sS7FpvzBvoHA3vrfJcpbdwwtzIoS6irvngrBPloZBOaCwpTLNmMHNJQFMnWy/eC
         nFq2e0lYd6i5A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 63AF1C433E7; Thu,  6 Oct 2022 15:37:23 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Thu, 06 Oct 2022 15:37:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jason600.groome@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215880-11613-8C1CHX35ST@https.bugzilla.kernel.org/>
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

--- Comment #40 from jason600 (jason600.groome@gmail.com) ---
I have been using Damien Lemoal's patch for the last couple of days on kern=
el
5.19.8, it works fine for me, and no obvious issues.

I also tried in on kernel 6.0, again works fine and no obvious issues.

(In reply to damien.lemoal from comment #39)
> I am not sure at all this is correct though. This actually may break other
> suspend/resume flavors. If we could somehow synchronize scsi pm resume to
> run *after* ata pm resume, all problems should go away I think.

With regard to Damiens comments, and the problems with this patch last time=
 it
was submitted, I think it would be a good idea to have more people testing =
this
patch before re-submitting it.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
