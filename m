Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E5BC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jan 2022 12:10:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbiACMKT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Jan 2022 07:10:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58402 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbiACMKS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jan 2022 07:10:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4827061028
        for <linux-scsi@vger.kernel.org>; Mon,  3 Jan 2022 12:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A5B23C36AED
        for <linux-scsi@vger.kernel.org>; Mon,  3 Jan 2022 12:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641211817;
        bh=RcKuqjhSYe2DNONaLhus7FTFW5LPdSmot8vUBi6jlOQ=;
        h=From:To:Subject:Date:From;
        b=s1p5eqtCjIJ8sdlfvZWQoZcy9ycbWKC3XROy6WnaR6OcmZQTMVjHauQQk0ajYvpDD
         Kr9uUol3buTvHJHKmcFt4vX3RQfU/uftoMHzrbCmERBgn+aN4vYDEJFzrM+QM8wkpP
         /mvhvdoNHYA/OKXTWvbbTxkH2YNN3K4vA79ULBnV14zuFFGLT1KRY77FNCW0Pf6NFf
         dpWjo3+LivFMDTeHKDprfGa8oyzC24OYwQEvuGNe726wsCPiApHtEJyTUe2CJbwHOn
         KGZObNi1Lu0gkABqO6IsHzYQ7KEyzjNnNVbgMfIlhPQjw4uoHtFg6a5SzxahuFWUBr
         K6TYNfHj0mV+A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 8EF0DC04E57; Mon,  3 Jan 2022 12:10:17 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215446] New: LSI HBA attempting task abort!scmd every 32 hours
Date:   Mon, 03 Jan 2022 12:10:17 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: qbanin@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-215446-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215446

            Bug ID: 215446
           Summary: LSI HBA attempting task abort!scmd every 32 hours
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 5.4.161 & 5.10.87
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: qbanin@gmail.com
        Regression: No

Hi,

For over a year my setup was LSI 9207-8i HBA with 8 SATA drives attached:
1st slot - 2x SSD SATA (mirrored zfs pool) & 2x 2,5" HDD SATA (STRIPE zfs p=
ool)
2nd slot - 4x 3,5" SATA HDDs (ZFS RAID10)


Recently I replaced 4x 3,5" SATA HDDs to 4x SAS HDDs and here the story
begins...

Since this replacement I'm getting this error message:

[pon sty  3 07:00:50 2022] sd 0:0:3:0: attempting task
abort!scmd(0x000000004c5af56d), outstanding for 5260 ms & timeout 5000 ms
[pon sty  3 07:00:50 2022] sd 0:0:3:0: [sdd] tag#15 CDB: Read(10) 28 00 08 =
45
7d 90 00 00 08 00
[pon sty  3 07:00:50 2022] scsi target0:0:3: handle(0x000b),
sas_address(0x4433221102000000), phy(2)
[pon sty  3 07:00:50 2022] scsi target0:0:3: enclosure logical
id(0x500605b002c52b90), slot(1)=20
[pon sty  3 07:00:50 2022] sd 0:0:3:0: task abort: SUCCESS
scmd(0x000000004c5af56d)
[pon sty  3 07:00:50 2022] sd 0:0:3:0: [sdd] tag#15 FAILED Result:
hostbyte=3DDID_TIME_OUT driverbyte=3DDRIVER_OK cmd_age=3D5s
[pon sty  3 07:00:50 2022] sd 0:0:3:0: [sdd] tag#15 CDB: Read(10) 28 00 08 =
45
7d 90 00 00 08 00
[pon sty  3 07:00:50 2022] blk_update_request: I/O error, dev sdd, sector
138771856 op 0x0:(READ) flags 0x700 phys_seg 1 prio class 0
[pon sty  3 07:00:50 2022] zio pool=3Drpool
vdev=3D/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S4X6NF0M843737B-part4 er=
ror=3D5
type=3D1 offset=3D69439528960 size=3D4096 flags=3D180880
[pon sty  3 07:00:50 2022] sd 0:0:3:0: Power-on or device reset occurred
[pon sty  3 07:00:52 2022] sd 0:0:0:0: attempting task
abort!scmd(0x0000000095ab8597), outstanding for 5120 ms & timeout 5000 ms
[pon sty  3 07:00:52 2022] sd 0:0:0:0: [sda] tag#2 CDB: Read(10) 28 00 71 5=
a fe
78 00 00 18 00
[pon sty  3 07:00:52 2022] scsi target0:0:0: handle(0x000c),
sas_address(0x4433221103000000), phy(3)
[pon sty  3 07:00:52 2022] scsi target0:0:0: enclosure logical
id(0x500605b002c52b90), slot(0)=20
[pon sty  3 07:00:52 2022] sd 0:0:0:0: [sda] tag#45 FAILED Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D0s
[pon sty  3 07:00:52 2022] sd 0:0:0:0: [sda] tag#45 CDB: Read(10) 28 00 46 =
58
48 f0 00 00 20 00
[pon sty  3 07:00:52 2022] blk_update_request: I/O error, dev sda, sector
1180190960 op 0x0:(READ) flags 0x700 phys_seg 1 prio class 0
[pon sty  3 07:00:52 2022] zio pool=3Drpool
vdev=3D/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z9NB0KC39914K-part4 er=
ror=3D5
type=3D1 offset=3D602646110208 size=3D16384 flags=3D180880
[pon sty  3 07:00:52 2022] sd 0:0:0:0: [sda] tag#44 FAILED Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D0s
[pon sty  3 07:00:52 2022] sd 0:0:0:0: [sda] tag#44 CDB: Read(10) 28 00 46 =
d1
51 f0 00 00 28 00
[pon sty  3 07:00:52 2022] blk_update_request: I/O error, dev sda, sector
1188123120 op 0x0:(READ) flags 0x700 phys_seg 2 prio class 0
[pon sty  3 07:00:52 2022] zio pool=3Drpool
vdev=3D/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z9NB0KC39914K-part4 er=
ror=3D5
type=3D1 offset=3D606707376128 size=3D20480 flags=3D180880
[pon sty  3 07:00:52 2022] sd 0:0:0:0: [sda] tag#37 FAILED Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D0s
[pon sty  3 07:00:52 2022] sd 0:0:0:0: [sda] tag#37 CDB: Read(10) 28 00 46 =
d1
6f 98 00 00 08 00
[pon sty  3 07:00:52 2022] blk_update_request: I/O error, dev sda, sector
1188130712 op 0x0:(READ) flags 0x700 phys_seg 1 prio class 0
[pon sty  3 07:00:52 2022] zio pool=3Drpool
vdev=3D/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z9NB0KC39914K-part4 er=
ror=3D5
type=3D1 offset=3D606711263232 size=3D4096 flags=3D180880
[pon sty  3 07:00:52 2022] sd 0:0:0:0: [sda] tag#17 FAILED Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D0s
[pon sty  3 07:00:52 2022] sd 0:0:0:0: [sda] tag#17 CDB: Read(10) 28 00 57 =
76
a9 c0 00 00 10 00
[pon sty  3 07:00:52 2022] blk_update_request: I/O error, dev sda, sector
1467394496 op 0x0:(READ) flags 0x700 phys_seg 1 prio class 0
[pon sty  3 07:00:52 2022] zio pool=3Drpool
vdev=3D/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z9NB0KC39914K-part4 er=
ror=3D5
type=3D1 offset=3D749694320640 size=3D8192 flags=3D180880
[pon sty  3 07:00:52 2022] sd 0:0:0:0: [sda] tag#14 FAILED Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D1s
[pon sty  3 07:00:52 2022] sd 0:0:0:0: [sda] tag#14 CDB: Read(10) 28 00 6b =
cb
7f 68 00 00 08 00
[pon sty  3 07:00:52 2022] blk_update_request: I/O error, dev sda, sector
1808498536 op 0x0:(READ) flags 0x700 phys_seg 1 prio class 0
[pon sty  3 07:00:52 2022] zio pool=3Drpool
vdev=3D/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z9NB0KC39914K-part4 er=
ror=3D5
type=3D1 offset=3D924339589120 size=3D4096 flags=3D180880
[pon sty  3 07:00:52 2022] sd 0:0:0:0: [sda] tag#13 FAILED Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D1s
[pon sty  3 07:00:52 2022] sd 0:0:0:0: [sda] tag#13 CDB: Read(10) 28 00 3f =
1d
6a e8 00 00 08 00
[pon sty  3 07:00:52 2022] blk_update_request: I/O error, dev sda, sector
1058892520 op 0x0:(READ) flags 0x700 phys_seg 1 prio class 0
[pon sty  3 07:00:52 2022] zio pool=3Drpool
vdev=3D/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z9NB0KC39914K-part4 er=
ror=3D5
type=3D1 offset=3D540541308928 size=3D4096 flags=3D180880
[pon sty  3 07:00:52 2022] sd 0:0:0:0: [sda] tag#9 FAILED Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D2s
[pon sty  3 07:00:52 2022] sd 0:0:0:0: [sda] tag#9 CDB: Read(10) 28 00 1b 3=
d a8
40 00 00 08 00
[pon sty  3 07:00:52 2022] blk_update_request: I/O error, dev sda, sector
457025600 op 0x0:(READ) flags 0x700 phys_seg 1 prio class 0
[pon sty  3 07:00:52 2022] zio pool=3Drpool
vdev=3D/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z9NB0KC39914K-part4 er=
ror=3D5
type=3D1 offset=3D232385445888 size=3D4096 flags=3D180880
[pon sty  3 07:00:52 2022] sd 0:0:0:0: task abort: SUCCESS
scmd(0x0000000095ab8597)
[pon sty  3 07:00:52 2022] sd 0:0:0:0: [sda] tag#2 FAILED Result:
hostbyte=3DDID_TIME_OUT driverbyte=3DDRIVER_OK cmd_age=3D5s
[pon sty  3 07:00:52 2022] sd 0:0:0:0: [sda] tag#2 CDB: Read(10) 28 00 71 5=
a fe
78 00 00 18 00
[pon sty  3 07:00:52 2022] blk_update_request: I/O error, dev sda, sector
1901788792 op 0x0:(READ) flags 0x700 phys_seg 2 prio class 0
[pon sty  3 07:00:52 2022] zio pool=3Drpool
vdev=3D/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z9NB0KC39914K-part4 er=
ror=3D5
type=3D1 offset=3D972104200192 size=3D12288 flags=3D180880
[pon sty  3 07:00:52 2022] sd 0:0:0:0: Power-on or device reset occurred
[pon sty  3 07:00:55 2022] sd 0:0:3:0: attempting task
abort!scmd(0x00000000279da027), outstanding for 5016 ms & timeout 5000 ms
[pon sty  3 07:00:55 2022] sd 0:0:3:0: [sdd] tag#12 CDB: Read(10) 28 00 74 =
70
6a 10 00 00 10 00
[pon sty  3 07:00:55 2022] scsi target0:0:3: handle(0x000b),
sas_address(0x4433221102000000), phy(2)
[pon sty  3 07:00:55 2022] scsi target0:0:3: enclosure logical
id(0x500605b002c52b90), slot(1)=20
[pon sty  3 07:00:55 2022] sd 0:0:3:0: task abort: SUCCESS
scmd(0x00000000279da027)
[pon sty  3 07:00:55 2022] sd 0:0:3:0: attempting task
abort!scmd(0x000000008ea05207), outstanding for 5040 ms & timeout 5000 ms
[pon sty  3 07:00:55 2022] sd 0:0:3:0: [sdd] tag#11 CDB: Read(10) 28 00 74 =
70
68 10 00 00 10 00
[pon sty  3 07:00:55 2022] scsi target0:0:3: handle(0x000b),
sas_address(0x4433221102000000), phy(2)
[pon sty  3 07:00:55 2022] scsi target0:0:3: enclosure logical
id(0x500605b002c52b90), slot(1)=20
[pon sty  3 07:00:55 2022] sd 0:0:3:0: No reference found at driver, assumi=
ng
scmd(0x000000008ea05207) might have completed
[pon sty  3 07:00:55 2022] sd 0:0:3:0: task abort: SUCCESS
scmd(0x000000008ea05207)
[pon sty  3 07:00:55 2022] sd 0:0:3:0: attempting task
abort!scmd(0x000000008734b0f9), outstanding for 5040 ms & timeout 5000 ms
[pon sty  3 07:00:55 2022] sd 0:0:3:0: [sdd] tag#10 CDB: Read(10) 28 00 00 =
30
0a 10 00 00 10 00
[pon sty  3 07:00:55 2022] scsi target0:0:3: handle(0x000b),
sas_address(0x4433221102000000), phy(2)
[pon sty  3 07:00:55 2022] scsi target0:0:3: enclosure logical
id(0x500605b002c52b90), slot(1)=20
[pon sty  3 07:00:55 2022] sd 0:0:3:0: No reference found at driver, assumi=
ng
scmd(0x000000008734b0f9) might have completed
[pon sty  3 07:00:55 2022] sd 0:0:3:0: task abort: SUCCESS
scmd(0x000000008734b0f9)
[pon sty  3 07:00:55 2022] sd 0:0:3:0: Power-on or device reset occurred
[pon sty  3 07:00:57 2022] sd 0:0:0:0: attempting task
abort!scmd(0x00000000ed5a9b35), outstanding for 5092 ms & timeout 5000 ms
[pon sty  3 07:00:57 2022] sd 0:0:0:0: [sda] tag#57 CDB: Read(10) 28 00 00 =
30
0a 10 00 00 10 00
[pon sty  3 07:00:57 2022] scsi target0:0:0: handle(0x000c),
sas_address(0x4433221103000000), phy(3)
[pon sty  3 07:00:57 2022] scsi target0:0:0: enclosure logical
id(0x500605b002c52b90), slot(0)=20
[pon sty  3 07:00:57 2022] sd 0:0:0:0: [sda] tag#18 FAILED Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D0s
[pon sty  3 07:00:57 2022] sd 0:0:0:0: [sda] tag#18 CDB: Read(10) 28 00 57 =
ac
a9 f0 00 00 28 00
[pon sty  3 07:00:57 2022] sd 0:0:0:0: task abort: SUCCESS
scmd(0x00000000ed5a9b35)
[pon sty  3 07:00:57 2022] blk_update_request: I/O error, dev sda, sector
1470933488 op 0x0:(READ) flags 0x700 phys_seg 2 prio class 0
[pon sty  3 07:00:57 2022] sd 0:0:0:0: attempting task
abort!scmd(0x00000000f0104143), outstanding for 5076 ms & timeout 5000 ms
[pon sty  3 07:00:57 2022] zio pool=3Drpool
vdev=3D/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z9NB0KC39914K-part4 er=
ror=3D5
type=3D1 offset=3D751506284544 size=3D20480 flags=3D180880
[pon sty  3 07:00:57 2022] sd 0:0:0:0: [sda] tag#38 CDB: Write(10) 2a 00 74=
 70
68 10 00 00 10 00
[pon sty  3 07:00:57 2022] sd 0:0:0:0: [sda] tag#15 FAILED Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D0s
[pon sty  3 07:00:57 2022] scsi target0:0:0: handle(0x000c),
sas_address(0x4433221103000000), phy(3)
[pon sty  3 07:00:57 2022] sd 0:0:0:0: [sda] tag#15 CDB: Read(10) 28 00 57 =
76
93 d0 00 00 10 00
[pon sty  3 07:00:57 2022] scsi target0:0:0: enclosure logical
id(0x500605b002c52b90), slot(0)=20
[pon sty  3 07:00:57 2022] blk_update_request: I/O error, dev sda, sector
1467388880 op 0x0:(READ) flags 0x700 phys_seg 1 prio class 0
[pon sty  3 07:00:57 2022] sd 0:0:0:0: No reference found at driver, assumi=
ng
scmd(0x00000000f0104143) might have completed
[pon sty  3 07:00:57 2022] zio pool=3Drpool
vdev=3D/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z9NB0KC39914K-part4 er=
ror=3D5
type=3D1 offset=3D749691445248 size=3D8192 flags=3D180880
[pon sty  3 07:00:57 2022] sd 0:0:0:0: task abort: SUCCESS
scmd(0x00000000f0104143)
[pon sty  3 07:00:57 2022] sd 0:0:0:0: [sda] tag#14 FAILED Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D0s
[pon sty  3 07:00:57 2022] sd 0:0:0:0: [sda] tag#14 CDB: Read(10) 28 00 57 =
ac
e2 90 00 00 28 00
[pon sty  3 07:00:57 2022] blk_update_request: I/O error, dev sda, sector
1470947984 op 0x0:(READ) flags 0x700 phys_seg 2 prio class 0
[pon sty  3 07:00:57 2022] zio pool=3Drpool
vdev=3D/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z9NB0KC39914K-part4 er=
ror=3D5
type=3D1 offset=3D751513706496 size=3D20480 flags=3D180880
[pon sty  3 07:00:57 2022] sd 0:0:0:0: [sda] tag#23 FAILED Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D1s
[pon sty  3 07:00:57 2022] sd 0:0:0:0: [sda] tag#23 CDB: Read(10) 28 00 57 =
ad
12 b0 00 00 08 00
[pon sty  3 07:00:57 2022] blk_update_request: I/O error, dev sda, sector
1470960304 op 0x0:(READ) flags 0x700 phys_seg 1 prio class 0
[pon sty  3 07:00:57 2022] zio pool=3Drpool
vdev=3D/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z9NB0KC39914K-part4 er=
ror=3D5
type=3D1 offset=3D751520014336 size=3D4096 flags=3D180880
[pon sty  3 07:00:57 2022] sd 0:0:0:0: [sda] tag#0 FAILED Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D2s
[pon sty  3 07:00:57 2022] sd 0:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 4a c=
9 28
f0 00 00 10 00
[pon sty  3 07:00:57 2022] blk_update_request: I/O error, dev sda, sector
1254697200 op 0x0:(READ) flags 0x700 phys_seg 1 prio class 0
[pon sty  3 07:00:57 2022] zio pool=3Drpool
vdev=3D/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z9NB0KC39914K-part4 er=
ror=3D5
type=3D1 offset=3D640793305088 size=3D8192 flags=3D180880
[pon sty  3 07:00:57 2022] sd 0:0:0:0: Power-on or device reset occurred
[pon sty  3 07:01:00 2022] sd 0:0:3:0: attempting task
abort!scmd(0x00000000df05a5b4), outstanding for 5164 ms & timeout 5000 ms
[pon sty  3 07:01:00 2022] sd 0:0:3:0: [sdd] tag#43 CDB: Read(10) 28 00 46 =
58
44 c8 00 00 20 00
[pon sty  3 07:01:00 2022] scsi target0:0:3: handle(0x000b),
sas_address(0x4433221102000000), phy(2)
[pon sty  3 07:01:00 2022] scsi target0:0:3: enclosure logical
id(0x500605b002c52b90), slot(1)=20
[pon sty  3 07:01:00 2022] sd 0:0:3:0: task abort: SUCCESS
scmd(0x00000000df05a5b4)
[pon sty  3 07:01:00 2022] sd 0:0:3:0: [sdd] tag#43 FAILED Result:
hostbyte=3DDID_TIME_OUT driverbyte=3DDRIVER_OK cmd_age=3D5s
[pon sty  3 07:01:00 2022] sd 0:0:3:0: [sdd] tag#43 CDB: Read(10) 28 00 46 =
58
44 c8 00 00 20 00
[pon sty  3 07:01:00 2022] blk_update_request: I/O error, dev sdd, sector
1180189896 op 0x0:(READ) flags 0x700 phys_seg 1 prio class 0
[pon sty  3 07:01:00 2022] zio pool=3Drpool
vdev=3D/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S4X6NF0M843737B-part4 er=
ror=3D5
type=3D1 offset=3D602645565440 size=3D16384 flags=3D180880
[pon sty  3 07:01:00 2022] sd 0:0:3:0: attempting task
abort!scmd(0x0000000030a5494c), outstanding for 5188 ms & timeout 5000 ms
[pon sty  3 07:01:00 2022] sd 0:0:3:0: [sdd] tag#42 CDB: Read(10) 28 00 46 =
d1
51 c8 00 00 28 00
[pon sty  3 07:01:00 2022] scsi target0:0:3: handle(0x000b),
sas_address(0x4433221102000000), phy(2)
[pon sty  3 07:01:00 2022] scsi target0:0:3: enclosure logical
id(0x500605b002c52b90), slot(1)=20
[pon sty  3 07:01:00 2022] sd 0:0:3:0: No reference found at driver, assumi=
ng
scmd(0x0000000030a5494c) might have completed
[pon sty  3 07:01:00 2022] sd 0:0:3:0: task abort: SUCCESS
scmd(0x0000000030a5494c)
[pon sty  3 07:01:00 2022] sd 0:0:3:0: [sdd] tag#42 FAILED Result:
hostbyte=3DDID_TIME_OUT driverbyte=3DDRIVER_OK cmd_age=3D5s
[pon sty  3 07:01:00 2022] sd 0:0:3:0: [sdd] tag#42 CDB: Read(10) 28 00 46 =
d1
51 c8 00 00 28 00
[pon sty  3 07:01:00 2022] blk_update_request: I/O error, dev sdd, sector
1188123080 op 0x0:(READ) flags 0x700 phys_seg 2 prio class 0
[pon sty  3 07:01:00 2022] zio pool=3Drpool
vdev=3D/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S4X6NF0M843737B-part4 er=
ror=3D5
type=3D1 offset=3D606707355648 size=3D20480 flags=3D180880
[pon sty  3 07:01:00 2022] sd 0:0:3:0: attempting task
abort!scmd(0x000000005680dc85), outstanding for 5192 ms & timeout 5000 ms
[pon sty  3 07:01:00 2022] sd 0:0:3:0: [sdd] tag#22 CDB: Read(10) 28 00 57 =
36
b9 f8 00 00 20 00
[pon sty  3 07:01:00 2022] scsi target0:0:3: handle(0x000b),
sas_address(0x4433221102000000), phy(2)
[pon sty  3 07:01:00 2022] scsi target0:0:3: enclosure logical
id(0x500605b002c52b90), slot(1)=20
[pon sty  3 07:01:00 2022] sd 0:0:3:0: No reference found at driver, assumi=
ng
scmd(0x000000005680dc85) might have completed
[pon sty  3 07:01:00 2022] sd 0:0:3:0: task abort: SUCCESS
scmd(0x000000005680dc85)
[pon sty  3 07:01:00 2022] sd 0:0:3:0: [sdd] tag#22 FAILED Result:
hostbyte=3DDID_TIME_OUT driverbyte=3DDRIVER_OK cmd_age=3D5s
[pon sty  3 07:01:00 2022] sd 0:0:3:0: [sdd] tag#22 CDB: Read(10) 28 00 57 =
36
b9 f8 00 00 20 00
[pon sty  3 07:01:00 2022] blk_update_request: I/O error, dev sdd, sector
1463204344 op 0x0:(READ) flags 0x700 phys_seg 1 prio class 0
[pon sty  3 07:01:00 2022] zio pool=3Drpool
vdev=3D/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S4X6NF0M843737B-part4 er=
ror=3D5
type=3D1 offset=3D747548962816 size=3D16384 flags=3D180880
[pon sty  3 07:01:02 2022] sd 0:0:0:0: attempting task
abort!scmd(0x00000000fe85a783), outstanding for 5180 ms & timeout 5000 ms
[pon sty  3 07:01:02 2022] sd 0:0:0:0: [sda] tag#59 CDB: Write(10) 2a 00 74=
 70
6a 10 00 00 10 00
[pon sty  3 07:01:02 2022] scsi target0:0:0: handle(0x000c),
sas_address(0x4433221103000000), phy(3)
[pon sty  3 07:01:02 2022] scsi target0:0:0: enclosure logical
id(0x500605b002c52b90), slot(0)=20
[pon sty  3 07:01:02 2022] sd 0:0:0:0: task abort: SUCCESS
scmd(0x00000000fe85a783)
[pon sty  3 07:01:15 2022] sd 0:0:1:0: attempting task
abort!scmd(0x00000000abb81af7), outstanding for 31752 ms & timeout 30000 ms
[pon sty  3 07:01:15 2022] sd 0:0:1:0: [sdb] tag#50 CDB: Read(10) 28 00 5c =
fa
5d f0 00 08 00 00
[pon sty  3 07:01:15 2022] scsi target0:0:1: handle(0x0009),
sas_address(0x4433221100000000), phy(0)
[pon sty  3 07:01:15 2022] scsi target0:0:1: enclosure logical
id(0x500605b002c52b90), slot(3)=20
[pon sty  3 07:01:16 2022] sd 0:0:1:0: task abort: SUCCESS
scmd(0x00000000abb81af7)
[pon sty  3 07:01:16 2022] sd 0:0:1:0: [sdb] tag#50 FAILED Result:
hostbyte=3DDID_TIME_OUT driverbyte=3DDRIVER_OK cmd_age=3D31s
[pon sty  3 07:01:16 2022] sd 0:0:1:0: [sdb] tag#50 CDB: Read(10) 28 00 5c =
fa
5d f0 00 08 00 00
[pon sty  3 07:01:16 2022] blk_update_request: I/O error, dev sdb, sector
1559911920 op 0x0:(READ) flags 0x700 phys_seg 16 prio class 0
[pon sty  3 07:01:16 2022] zio pool=3DSTRIPE
vdev=3D/dev/disk/by-id/ata-WDC_WD10JFCX-68N6GN0_WD-WXK1E846A1J1-part1 error=
=3D5
type=3D1 offset=3D798673854464 size=3D1048576 flags=3D180880
[pon sty  3 07:01:44 2022] sd 0:0:2:0: attempting task
abort!scmd(0x00000000ebfb9105), outstanding for 60452 ms & timeout 60000 ms
[pon sty  3 07:01:44 2022] sd 0:0:2:0: [sdc] tag#24 CDB: Synchronize Cache(=
10)
35 00 00 00 00 00 00 00 00 00
[pon sty  3 07:01:44 2022] scsi target0:0:2: handle(0x000a),
sas_address(0x4433221101000000), phy(1)
[pon sty  3 07:01:44 2022] scsi target0:0:2: enclosure logical
id(0x500605b002c52b90), slot(2)=20
[pon sty  3 07:01:44 2022] sd 0:0:2:0: task abort: SUCCESS
scmd(0x00000000ebfb9105)
[pon sty  3 07:01:44 2022] sd 0:0:0:0: attempting device reset!
scmd(0x00000000ed5a9b35)
[pon sty  3 07:01:44 2022] sd 0:0:0:0: [sda] tag#57 CDB: Read(10) 28 00 00 =
30
0a 10 00 00 10 00
[pon sty  3 07:01:44 2022] scsi target0:0:0: handle(0x000c),
sas_address(0x4433221103000000), phy(3)
[pon sty  3 07:01:44 2022] scsi target0:0:0: enclosure logical
id(0x500605b002c52b90), slot(0)=20
[pon sty  3 07:01:44 2022] sd 0:0:0:0: device reset: FAILED
scmd(0x00000000ed5a9b35)
[pon sty  3 07:01:44 2022] sd 0:0:3:0: attempting device reset!
scmd(0x000000008734b0f9)
[pon sty  3 07:01:44 2022] sd 0:0:3:0: [sdd] tag#10 CDB: Read(10) 28 00 00 =
30
0a 10 00 00 10 00
[pon sty  3 07:01:44 2022] scsi target0:0:3: handle(0x000b),
sas_address(0x4433221102000000), phy(2)
[pon sty  3 07:01:44 2022] scsi target0:0:3: enclosure logical
id(0x500605b002c52b90), slot(1)=20
[pon sty  3 07:01:44 2022] sd 0:0:3:0: device reset: FAILED
scmd(0x000000008734b0f9)
[pon sty  3 07:01:44 2022] scsi target0:0:3: attempting target reset!
scmd(0x000000008734b0f9)
[pon sty  3 07:01:44 2022] sd 0:0:3:0: [sdd] tag#10 CDB: Read(10) 28 00 00 =
30
0a 10 00 00 10 00
[pon sty  3 07:01:44 2022] scsi target0:0:3: handle(0x000b),
sas_address(0x4433221102000000), phy(2)
[pon sty  3 07:01:44 2022] scsi target0:0:3: enclosure logical
id(0x500605b002c52b90), slot(1)=20
[pon sty  3 07:01:44 2022] scsi target0:0:3: target reset: SUCCESS
scmd(0x000000008734b0f9)
[pon sty  3 07:01:44 2022] scsi target0:0:0: attempting target reset!
scmd(0x00000000ed5a9b35)
[pon sty  3 07:01:44 2022] sd 0:0:0:0: [sda] tag#57 CDB: Read(10) 28 00 00 =
30
0a 10 00 00 10 00
[pon sty  3 07:01:44 2022] scsi target0:0:0: handle(0x000c),
sas_address(0x4433221103000000), phy(3)
[pon sty  3 07:01:44 2022] scsi target0:0:0: enclosure logical
id(0x500605b002c52b90), slot(0)=20
[pon sty  3 07:01:44 2022] scsi target0:0:0: target reset: SUCCESS
scmd(0x00000000ed5a9b35)
[pon sty  3 07:01:45 2022] sd 0:0:3:0: Power-on or device reset occurred
[pon sty  3 07:01:55 2022] sd 0:0:3:0: attempting task
abort!scmd(0x000000008734b0f9), outstanding for 64988 ms & timeout 5000 ms
[pon sty  3 07:01:55 2022] sd 0:0:3:0: [sdd] tag#10 CDB: Test Unit Ready 00=
 00
00 00 00 00
[pon sty  3 07:01:55 2022] scsi target0:0:3: handle(0x000b),
sas_address(0x4433221102000000), phy(2)
[pon sty  3 07:01:55 2022] scsi target0:0:3: enclosure logical
id(0x500605b002c52b90), slot(1)=20
[pon sty  3 07:01:55 2022] sd 0:0:3:0: task abort: SUCCESS
scmd(0x000000008734b0f9)
[pon sty  3 07:01:55 2022] sd 0:0:0:0: Power-on or device reset occurred
[pon sty  3 07:02:05 2022] sd 0:0:0:0: attempting task
abort!scmd(0x00000000ed5a9b35), outstanding for 73176 ms & timeout 5000 ms
[pon sty  3 07:02:05 2022] sd 0:0:0:0: [sda] tag#57 CDB: Test Unit Ready 00=
 00
00 00 00 00
[pon sty  3 07:02:05 2022] scsi target0:0:0: handle(0x000c),
sas_address(0x4433221103000000), phy(3)
[pon sty  3 07:02:05 2022] scsi target0:0:0: enclosure logical
id(0x500605b002c52b90), slot(0)=20
[pon sty  3 07:02:05 2022] sd 0:0:0:0: task abort: SUCCESS
scmd(0x00000000ed5a9b35)
[pon sty  3 07:02:05 2022] mpt2sas_cm0: attempting host reset!
scmd(0x000000008734b0f9)
[pon sty  3 07:02:05 2022] sd 0:0:3:0: [sdd] tag#10 CDB: Read(10) 28 00 00 =
30
0a 10 00 00 10 00
[pon sty  3 07:02:15 2022] mpt2sas_cm0: sending diag reset !!
[pon sty  3 07:02:16 2022] mpt2sas_cm0: diag reset: SUCCESS
[pon sty  3 07:02:16 2022] mpt2sas_cm0: CurrentHostPageSize is 0: Setting
default host page size to 4k
[pon sty  3 07:02:16 2022] mpt2sas_cm0: overriding NVDATA EEDPTagMode setti=
ng
[pon sty  3 07:02:16 2022] mpt2sas_cm0: LSISAS2008: FWVersion(20.00.07.00),
ChipRevision(0x03), BiosVersion(07.39.00.00)
[pon sty  3 07:02:16 2022] mpt2sas_cm0: Protocol=3D(Initiator,Target),
Capabilities=3D(TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NC=
Q)
[pon sty  3 07:02:16 2022] mpt2sas_cm0: sending port enable !!
[pon sty  3 07:02:23 2022] mpt2sas_cm0: port enable: SUCCESS
[pon sty  3 07:02:23 2022] mpt2sas_cm0: search for end-devices: start
[pon sty  3 07:02:23 2022] scsi target0:0:1: handle(0x0009),
sas_addr(0x4433221100000000)
[pon sty  3 07:02:23 2022] scsi target0:0:1: enclosure logical
id(0x500605b002c52b90), slot(3)
[pon sty  3 07:02:23 2022] scsi target0:0:2: handle(0x000a),
sas_addr(0x4433221101000000)
[pon sty  3 07:02:23 2022] scsi target0:0:2: enclosure logical
id(0x500605b002c52b90), slot(2)
[pon sty  3 07:02:23 2022] scsi target0:0:3: handle(0x000b),
sas_addr(0x4433221102000000)
[pon sty  3 07:02:23 2022] scsi target0:0:3: enclosure logical
id(0x500605b002c52b90), slot(1)
[pon sty  3 07:02:23 2022] scsi target0:0:0: handle(0x000c),
sas_addr(0x4433221103000000)
[pon sty  3 07:02:23 2022] scsi target0:0:0: enclosure logical
id(0x500605b002c52b90), slot(0)
[pon sty  3 07:02:23 2022] scsi target0:0:4: handle(0x000d),
sas_addr(0x5000c50084fe92d9)
[pon sty  3 07:02:23 2022] scsi target0:0:4: enclosure logical
id(0x500605b002c52b90), slot(7)
[pon sty  3 07:02:23 2022] scsi target0:0:5: handle(0x000e),
sas_addr(0x5000c5008502e7a1)
[pon sty  3 07:02:23 2022] scsi target0:0:5: enclosure logical
id(0x500605b002c52b90), slot(6)
[pon sty  3 07:02:23 2022] scsi target0:0:6: handle(0x000f),
sas_addr(0x5000c50084fa5e75)
[pon sty  3 07:02:23 2022] scsi target0:0:6: enclosure logical
id(0x500605b002c52b90), slot(5)
[pon sty  3 07:02:23 2022] scsi target0:0:7: handle(0x0010),
sas_addr(0x5000c50084effbd9)
[pon sty  3 07:02:23 2022] scsi target0:0:7: enclosure logical
id(0x500605b002c52b90), slot(4)
[pon sty  3 07:02:23 2022] mpt2sas_cm0: search for end-devices: complete
[pon sty  3 07:02:23 2022] mpt2sas_cm0: search for end-devices: start
[pon sty  3 07:02:23 2022] mpt2sas_cm0: search for PCIe end-devices: comple=
te
[pon sty  3 07:02:23 2022] mpt2sas_cm0: search for expanders: start
[pon sty  3 07:02:23 2022] mpt2sas_cm0: search for expanders: complete
[pon sty  3 07:02:23 2022] mpt2sas_cm0: mpt3sas_base_hard_reset_handler:
SUCCESS
[pon sty  3 07:02:23 2022] mpt2sas_cm0: host reset: SUCCESS
scmd(0x000000008734b0f9)
[pon sty  3 07:02:33 2022] sd 0:0:3:0: Power-on or device reset occurred
[pon sty  3 07:02:33 2022] sd 0:0:0:0: Power-on or device reset occurred
[pon sty  3 07:02:34 2022] sd 0:0:1:0: Power-on or device reset occurred
[pon sty  3 07:02:34 2022] sd 0:0:2:0: Power-on or device reset occurred
[pon sty  3 07:02:34 2022] mpt2sas_cm0: removing unresponding devices: start
[pon sty  3 07:02:34 2022] mpt2sas_cm0: removing unresponding devices:
end-devices
[pon sty  3 07:02:34 2022] mpt2sas_cm0: Removing unresponding devices: pcie
end-devices
[pon sty  3 07:02:34 2022] mpt2sas_cm0: removing unresponding devices:
expanders
[pon sty  3 07:02:34 2022] mpt2sas_cm0: removing unresponding devices: comp=
lete
[pon sty  3 07:02:34 2022] mpt2sas_cm0: scan devices: start
[pon sty  3 07:02:34 2022] mpt2sas_cm0:         scan devices: expanders sta=
rt
[pon sty  3 07:02:34 2022] mpt2sas_cm0:         break from expander scan:
ioc_status(0x0022), loginfo(0x310f0400)
[pon sty  3 07:02:34 2022] mpt2sas_cm0:         scan devices: expanders
complete
[pon sty  3 07:02:34 2022] mpt2sas_cm0:         scan devices: end devices s=
tart
[pon sty  3 07:02:34 2022] mpt2sas_cm0:         break from end device scan:
ioc_status(0x0022), loginfo(0x310f0400)
[pon sty  3 07:02:34 2022] mpt2sas_cm0:         scan devices: end devices
complete
[pon sty  3 07:02:34 2022] mpt2sas_cm0:         scan devices: pcie end devi=
ces
start
[pon sty  3 07:02:34 2022] mpt2sas_cm0: log_info(0x3003011d): originator(IO=
P),
code(0x03), sub_code(0x011d)
[pon sty  3 07:02:34 2022] mpt2sas_cm0: log_info(0x3003011d): originator(IO=
P),
code(0x03), sub_code(0x011d)
[pon sty  3 07:02:34 2022] mpt2sas_cm0:         break from pcie end device
scan: ioc_status(0x0022), loginfo(0x3003011d)
[pon sty  3 07:02:34 2022] mpt2sas_cm0:         pcie devices: pcie end devi=
ces
complete
[pon sty  3 07:02:34 2022] mpt2sas_cm0: scan devices: complete

The most interesting part is that this error orrus exactly every 32 hours a=
fter
after fist boot rounded to full hours, ie: if I reboot my system before
midnight this error will trigger exactly at 8:00 (after 32h) then 4:00 (aft=
er
next 32h) etc. It's ALWAYS some hour and 00 minutes and the fist drive that
triggers this error is SSD drive (sda or sdd randomly) which lock up whole =
BUS
with SATA drives till HBA auto-recover. In the meantime SAS drives connecte=
d to
sencond bus work without any problem.

So far I...

- replaced LSI 9207-8i HBA with LSI 9211-8i HBA
- replaced SAS cable=20
- forced libata.noncq but it doesn't work for scsi attached drivers
- disabled ncq within LSI controler (using lsi_util)
- set mpt3sas.msix_disable=3D1
- tried to increase or reduce eh_timeout or drive timeout
- run smartctl -t long for all drives =3D no errors

None of above helped. At first I thought that this may be some hardware fau=
lt
but this cyclical recurrence show that this is some kind os software/driver
issue.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
