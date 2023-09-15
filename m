Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D90C46CA1
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 20:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237573AbjIOU5e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 16:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237618AbjIOU5E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 16:57:04 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7CA3C38
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 13:55:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4EEBEC433CB
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 20:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694811328;
        bh=WgfK2SdW96rsdmNZL/vM2ymOMUUAsKY0vfcdyV6z5e8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=oPvPvBvSpt4zmD3j9Ws4/bthREwD1JlPxooXEGxtYvZtkMyeLlm+3Va01iSkd+adf
         Rug5yBQZ/1E68VZGcdA9n99TjkcTT4h9N2TDYkHhfAxBLoqW3nhL7tCGStIupBqB2E
         IDjVF+jzMJyHfMzQVTHDddWV83clMhfMKS4Eyp/8wrDhFj7lQ+uQFU9tBsWUCgoP3U
         OSS6Qgcf3Ejq9LX0b1fVJ5fPiIwQsjEZhNvq+R0p4WAapzxluAy27i+gTHGUmgBEa2
         ymrf9+cG7Edab+3Vjxqiu46jUZ874uDUMTAO9Ts3zj+bNlDCvWRiUzmJXI1phFPL5f
         MHpzTRlwv9FtQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 356AAC53BC6; Fri, 15 Sep 2023 20:55:28 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217914] scsi_eh_1 process high cpu after upgrading to 6.5
Date:   Fri, 15 Sep 2023 20:55:28 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: loberman@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217914-11613-P5bW8XGZgs@https.bugzilla.kernel.org/>
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

--- Comment #2 from loberman@redhat.com ---
On Fri, 2023-09-15 at 13:42 -0700, Bart Van Assche wrote:
> On 9/15/23 12:33, bugzilla-daemon@kernel.org=C2=A0wrote:
> > The users loqs and leonshaw helped to narrow it down to this
> > commit:
> >=20
> >
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D624885209f31eb9985bf51abe204ecbffe2fdeea
>=20
> Damien, can you please take a look?
>=20
> Thanks,
>=20
> Bart.
>=20
I had a quick look at this and its not making sense. The only calls I
see are in the scan when the devices is added and in the re-scan.
It should not be consuming the scsi_eh thread unless some type of udev
events keeps happening.

Would be good to get some
cat /proc/<PID>/stack of the scsi_eh threads if they are constantly
consuming CPUY

I will try reproduce and try figure out what is going on here.

Thanks
Laurence

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
