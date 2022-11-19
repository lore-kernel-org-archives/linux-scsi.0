Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE78C433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Nov 2022 05:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiKSFpi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Nov 2022 00:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiKSFph (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Nov 2022 00:45:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B089984807
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 21:45:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E27DB82599
        for <linux-scsi@vger.kernel.org>; Sat, 19 Nov 2022 05:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 07266C433D6
        for <linux-scsi@vger.kernel.org>; Sat, 19 Nov 2022 05:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668836734;
        bh=gT7QsNh7g9xU4v95nnkdltl5UbnWLsvWoQK8cs3kVdE=;
        h=From:To:Subject:Date:From;
        b=Bgzl9K8l0A2libEEPAh0k3yHsbZ3Dwu+y+36tOO/adSzf5eDplxaU2XWxTCbGhSeF
         2Dqxb2ImQZf6vLuBYOCdGnzWrH2JtHIeNoRSWHt4XUqqz1311S67hTt5r03VRyF0jn
         ek2SkkB8oZ5xsOBV5rjbwMOIhZafe/09JIrGmbvoUwibzBrUIo+GZNiRcSAYqSBFSa
         YTAi5hZ52aJBt0c+82k0DFOeX0hqvlb37Wm07jjwcUPJJqg/WK2QW21Yxsk434h/9B
         GFRJOC84FfU3NC1u8crfii6RVSEqLtq3QtgvMj0a8mUxwCmAc8mgyL3HTqtV8TKDQH
         QS3IUQBrSDikg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E21EBC433E7; Sat, 19 Nov 2022 05:45:33 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216707] New: mpt3sas in last kernel version reset JBOD in
 shared storage config (after reboot any host)
Date:   Sat, 19 Nov 2022 05:45:33 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: slavon.net@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-216707-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216707

            Bug ID: 216707
           Summary: mpt3sas in last kernel version reset JBOD in shared
                    storage config (after reboot any host)
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 5.19.15
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: slavon.net@gmail.com
        Regression: No

Created attachment 303230
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D303230&action=3Dedit
dmeseg of host A after reset JBOD

the mpt3sas driver in the latest kernel version resets the JBOD in the shar=
ed
storage configuration (after rebooting any host). I was on the latest versi=
on
of kernel-ml and got this error some time ago. I rolled back to the basic
centos kernel, but in recent updates this has also started to happen again.

The logic is this. Master-Slave configuration. Host A connects all the disk=
s to
itself via DM and then sends them via NFS and NVMET. Host B is waiting. The
disks are not connected, the LVM completely occupies the disks on host A. I=
f I
update host B and reboot it, it sends a RESET to the JBOD at the time of
shutdown or start, and host A loses all disks.



[root@vm1 ~]# lsscsi
[0:0:0:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sdb
[0:0:1:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sdc
[0:0:2:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sdd
[0:0:3:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sde
[0:0:4:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sdf
[0:0:5:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sdg
[0:0:6:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sdh
[0:0:7:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sdi
[0:0:8:0]    disk    SAMSUNG  MZILT3T8HBLS/007 GXA0  /dev/sdj
[0:0:9:0]    disk    ATA      Samsung SSD 850  2B6Q  /dev/sdk
[0:0:10:0]   disk    ATA      Samsung SSD 850  2B6Q  /dev/sdl
[0:0:11:0]   enclosu SMC      SC216-P          100d  -
[0:0:12:0]   disk    SAMSUNG  MZILT3T8HBLS/007 GXA0  /dev/sdm
[0:0:13:0]   enclosu SMC      SC216-S          100d  -
[2:0:0:0]    disk    ATA      KINGSTON SV300S3 BBF0  /dev/sda
[N:0:1:1]    disk    Samsung SSD 950 PRO 256GB__1               /dev/nvme0n1
[N:1:1:1]    disk    Samsung SSD 950 PRO 256GB__1               /dev/nvme1n1

dmeseg of host A after reset JBOD attached. Bug replay on fresh centos 9 st=
ream
kernels and kernels 5.19.x. Bug added some time ago. Maybe between  5.15 - =
5.17

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
