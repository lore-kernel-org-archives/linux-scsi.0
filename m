Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D50F8ECAAA2
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Aug 2022 21:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243811AbiHYVgA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Aug 2022 17:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243864AbiHYVfy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2022 17:35:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF80EC12D3
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 14:35:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24A8A61B69
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 21:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8716BC43141
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 21:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661463352;
        bh=gvyWh4w3h6aW0TweE1P+NWxaKO9F6bZiOskPQ/xzVr4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=eeiZ+PfCx6n08mmjPHacm41qZxchT5ZdO33aBYxD+W6vL8d/wZf5sQJjlCeKkJDiS
         Uj6er1JuY8QsO3PniMBWoTa8x37MektCxY0QDGTzqFfJO9BSDDlkqfdatazlcv/wLB
         cMKBlnnDLGNGBehEyN4qcHWuVJ6jip+lEa8hj02ItKwE+jfXzJQ+TAcBIwcuz0xEM8
         fDzr68t+R1D2vGEFnnLHUezq6gxcV6EPJRPxsba7pMuTwXbvSkWEiAJFYNrC9PO2Qw
         qHxazQAITDf+56PMWBD3JNMlNsZcZeCyVzFBK2FAxxkU6+FdajQgO7EMYNvQm/VtOd
         u47Nz2vMN6PhA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 730FCC433E9; Thu, 25 Aug 2022 21:35:52 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216413] [BISECT INCLUDED] scsi/sd Rework asynchronous resume
 support breaks S2idle and S3 on several systems
Date:   Thu, 25 Aug 2022 21:35:52 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: todd.e.brandt@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: bvanassche@acm.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-216413-11613-f4vYM6BP3V@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216413-11613@https.bugzilla.kernel.org/>
References: <bug-216413-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216413

--- Comment #4 from Todd Brandt (todd.e.brandt@intel.com) ---
Created attachment 301663
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301663&action=3Dedit
otcpl-hp-x360-system-info.txt

System info for the HP Pavillion x360

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.=
