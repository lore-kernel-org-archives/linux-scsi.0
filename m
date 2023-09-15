Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E753C46CA1
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 21:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbjIOVGo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 17:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237341AbjIOVGM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 17:06:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF683A1
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 14:06:07 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94D3FC433C7
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 21:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694811967;
        bh=InrQr2Ztk2lUzAhJQpHCer2kvlIAqAAb1zqdlepdfY8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=azTiPl0AizVj+lW43dNeS0Npr1uQJiX3X9zIA3u3fdSmYs6NSSdlvuY3/gyebdRpK
         34upXSKvl0d7ysE35AQnb+soGrcnkvrCE0e1OqjNOkTJXstIJgcuXczR1EKu5rNHDT
         MNpgF/rtJ01Hg8/x6vEEh7NsMJQGTCV5sCBoiA0GZtjdh0+FT9KNTUSle5snbuENR/
         DP/8FIjy6WhkNxw/KsDzSBE1rCQGZ/w8++dcb2cKimtZapcvEni8MEcXEwnTiwzysg
         80bupqaqD5gqM/VkQxme/QECrxHhwkQzQIVPBcpJuSsNoLtj0nRHvlSfKR8LfwxMrs
         tbJ1ovIX6pb6g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 81D95C53BCD; Fri, 15 Sep 2023 21:06:07 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217914] scsi_eh_1 process high cpu after upgrading to 6.5
Date:   Fri, 15 Sep 2023 21:06:07 +0000
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
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217914-11613-bOnMBR6Gu3@https.bugzilla.kernel.org/>
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

loberman@redhat.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |loberman@redhat.com

--- Comment #3 from loberman@redhat.com ---
Not reproducible generically for me

[root@penguin8 ~]# uname -a
Linux penguin8 6.5.0+ #2 SMP PREEMPT_DYNAMIC=20

[root@penguin8 ~]# lsscsi
[0:0:0:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sdb=20
[1:0:0:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sda=20


USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root        1649  0.0  0.0      0     0 ?        S    16:58   0:00 [scsi_eh=
_0]
root        1651  0.0  0.0      0     0 ?        S    16:58   0:00 [scsi_eh=
_1]
root        1653  0.0  0.0      0     0 ?        S    16:58   0:00 [scsi_eh=
_2]
root        1655  0.0  0.0      0     0 ?        S    16:58   0:00 [scsi_eh=
_3]
root        1668  0.0  0.0      0     0 ?        S    16:58   0:00 [scsi_eh=
_4]
root        1670  0.0  0.0      0     0 ?        S    16:58   0:00 [scsi_eh=
_5]
root        1672  0.0  0.0      0     0 ?        S    16:58   0:00 [scsi_eh=
_6]
root        1674  0.0  0.0      0     0 ?        S    16:58   0:00 [scsi_eh=
_7]
root        1866  0.0  0.0      0     0 ?        S    16:58   0:00 [scsi_eh=
_8]
root        1887  0.0  0.0      0     0 ?        S    16:58   0:00 [scsi_eh=
_9]

root        1649  0.0  0.0      0     0 ?        S    16:58   0:00 [scsi_eh=
_0]
root        1651  0.0  0.0      0     0 ?        S    16:58   0:00 [scsi_eh=
_1]
root        1653  0.0  0.0      0     0 ?        S    16:58   0:00 [scsi_eh=
_2]
root        1655  0.0  0.0      0     0 ?        S    16:58   0:00 [scsi_eh=
_3]
root        1668  0.0  0.0      0     0 ?        S    16:58   0:00 [scsi_eh=
_4]
root        1670  0.0  0.0      0     0 ?        S    16:58   0:00 [scsi_eh=
_5]
root        1672  0.0  0.0      0     0 ?        S    16:58   0:00 [scsi_eh=
_6]
root        1674  0.0  0.0      0     0 ?        S    16:58   0:00 [scsi_eh=
_7]
root        1866  0.0  0.0      0     0 ?        S    16:58   0:00 [scsi_eh=
_8]
root        1887  0.0  0.0      0     0 ?        S    16:58   0:00 [scsi_eh=
_9]

I Have no CDROm so I think its the virtual cdrom.
In VMware the CDROM will continuously get probed and log errors due to no m=
edia
and every time that happens it will call the cdl stuff.

I will bring up a Virtual guest now, will take time as I will have to build
upstream kernels.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
