Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA8BECAAA2
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Aug 2022 21:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243827AbiHYVin (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Aug 2022 17:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243811AbiHYVim (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2022 17:38:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2980C2285
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 14:38:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 696B861B7C
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 21:38:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CA963C433B5
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 21:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661463520;
        bh=s32AgJHZ5LcEOWwEfJRq0x0+Y/Fc0qW9SrmHSjpawD8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=FxNF7vpbGMyHZt/iGEwjwnaHzVXgGoqByAzwl3X50jL8PBBdP52O3w1/beNd93oHF
         y+yy+OvepmdirGg9CFPMajwxzPUTwpmgeXlk2urFdzSAXCMtfBWVw9ED37VtiYL5Xv
         K6OEGhPtW9X492Iy91rUhA39jKwVH97AGL6HCbOoDwWiuN/jboC9YtSPcbw9TeYaYx
         HwUhpYg4GHH4vyC/R2onkbWnU74UScOcSkM5RUJ/uUHcsfxDbQRneffdm0LFKM5+vJ
         /MoUiq3loMA5KxK3os3bNxD0eDHhWNM9qQecvoLcvF5IeQovStOJtjvAWK3upX5oPo
         D9MtKL2qA5W1g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B48E9C433E9; Thu, 25 Aug 2022 21:38:40 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216413] [BISECT INCLUDED] scsi/sd Rework asynchronous resume
 support breaks S2idle and S3 on several systems
Date:   Thu, 25 Aug 2022 21:38:40 +0000
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
Message-ID: <bug-216413-11613-lTwsYeNwRt@https.bugzilla.kernel.org/>
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

--- Comment #5 from Todd Brandt (todd.e.brandt@intel.com) ---
Created attachment 301664
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301664&action=3Dedit
otcpl-dell-3493-icl-system-info.txt

Dell Inspiron 3493 system info

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.=
