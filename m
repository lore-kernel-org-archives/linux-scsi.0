Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85BE0C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 18 May 2022 01:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiERBKK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 May 2022 21:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233253AbiERBKE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2022 21:10:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315973D1E1
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2022 18:10:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F37C614DB
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2022 01:10:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E1148C34118
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2022 01:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652836201;
        bh=7PvMfh0QTy38bmJyeuYC+iEMsSVs1u7pjqiJQUga3MA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ulKG4pmFvDdZ1br/Uf8fO664k4SespXB2moYBfd2aJotvI44G7WJVzn4RXO06mkrp
         SOG7L9YmaFBH9WN5qgW9Gxg/GKKOqsOFnXZvNpk16/GyPVw6O40ekpD/9eI8VpV4Ib
         L8EnUy710PS+fMy14/eJEB9ldoSEaPxqj0PgDsyTeWMYd1ESxSXSs8PbExYympMzQ5
         uTy9axDJF6wLhiefd06uExfAv4+7GWiqcpi9GqLunWz+/AmeWsgGYHHZTmrKEE0elV
         hISCi6cQ17TnVIKFTwUEAEIe5JTqcXkvrnIu3JhTGjf1H67qeDyIIUoYlaTiL25v8V
         ZpbnMF2+gNyAw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C463ECC13AF; Wed, 18 May 2022 01:10:01 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215943] UBSAN: array-index-out-of-bounds in
 drivers/scsi/megaraid/megaraid_sas_fp.c:103:32
Date:   Wed, 18 May 2022 01:10:01 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: darren.armstrong85@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc attachments.created
Message-ID: <bug-215943-11613-pV7v1iPMPg@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215943-11613@https.bugzilla.kernel.org/>
References: <bug-215943-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215943

darren.armstrong85@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |darren.armstrong85@gmail.co
                   |                            |m

--- Comment #1 from darren.armstrong85@gmail.com ---
Created attachment 300986
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D300986&action=3Dedit
drivers: scsi: megaraid: fix ldSpanMap array declarations

It looks like ldSpanMap arrays are being declared with a length of 1 whilst=
 the
accompanying ldTgtIdToLd lookup is set up using max limits.

This looks to be quite old code (2010) which makes me a bit suspicious that
I've missed something about how this works.  But I couldn't find anything in
the current source or commit logs to explain why it was this way.  So it lo=
oks
like an honest oversight from what I can tell.

I've attached a patch that matches lengths between ldSpanMap and ldTgtIdToL=
d in
the two cases I was able to identify.  Is it possible to test with this pat=
ch
applied?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
