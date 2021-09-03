Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF54C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Sep 2021 06:22:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C578D61058
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Sep 2021 06:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234650AbhICGXB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Sep 2021 02:23:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230128AbhICGXB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Sep 2021 02:23:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B7C5561057
        for <linux-scsi@vger.kernel.org>; Fri,  3 Sep 2021 06:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630650121;
        bh=qScJTEpw2aYVapKWHBwCn6kd8yew/etsr8e9Z51GltQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hyxvXqKpETVdhiTGPL69DYyxwZxuIPucBbHBB1xG07GyEn8elOK+Nq1tr1g26qIoS
         MLTGd58Hz8weIYpp/xn72RHMChCtZ+B80RHhwP8YqnI7x8kC045Pg5KoITMkkSBbXK
         IaPfyTwgLV/SA+kbaWhTrQv/rDb7OjjGKwogXlsPlpujbOUtMNBn7Z9QG+1YNNSd5f
         Bf+EpH0qyn3+v0UopnpykAk3Y0YUsfvw2JvIjoKezYk7LRlCfUtaA07xjbU9PIIEl9
         eyUv6seGMCOHGS27ljSyQ6nPoOLO/lgJLANjd7H4pGgTz7WwLxIOyRIn5P1If7QSpU
         d4VKA0KAIKhCQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214147] ISCSI broken in last release
Date:   Fri, 03 Sep 2021 06:22:01 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: slavon.net@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214147-11613-dPGnM2Cyi0@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214147-11613@https.bugzilla.kernel.org/>
References: <bug-214147-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214147

--- Comment #3 from Badalian Slava (slavon.net@gmail.com) ---
Comment on attachment 298441
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D298441
dmesg log

Ok. Send me patch, i can test it.



we use ZFS (last git(. Have 2 pools - DRAID from 6 HDD amd stripe for 10 SSD
850 EVI/

Windows Cluser connect ZFS blocked devices as Shared clustered disk on iSCS=
I in
10GB mellonox channel.  (Noo RDMA support in windows side in iSCSI).=20

Linux connect in NFS over RDMA on infiniband 40 g network.

We wont recreate SSD pool and move all VMs to HDD. Thern try move next VM. =
In
Windows host start migrate HV disk from, one clustered disk to second.. 10-=
15
min and iSCSI broke.

5.12 reconnect after some time. 5.13 system is zrease. Linux can't reboot. =
Only
ipmi power reset.



SATA is LSI3008.=20

[root@vm2 ~]# lsscsi
[0:0:0:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sdb
[0:0:1:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sdc
[0:0:2:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sdd
[0:0:3:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sde
[0:0:4:0]    disk    ATA      Samsung SSD 850  2B6Q  /dev/sdf
[0:0:5:0]    disk    ATA      Samsung SSD 850  2B6Q  /dev/sdg
[0:0:6:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sds
[0:0:7:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sdt
[4:0:0:0]    disk    ATA      KINGSTON SV300S3 BBF0  /dev/sda
[9:0:0:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sdh
[9:0:1:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sdi
[9:0:2:0]    disk    ATA      ST2000DM001-1ER1 CC26  /dev/sdj
[9:0:3:0]    disk    ATA      ST2000DM001-1ER1 CC26  /dev/sdk
[9:0:4:0]    disk    ATA      INTEL SSDSC2CW24 400i  /dev/sdl
[9:0:5:0]    disk    ATA      ST2000DM001-1CH1 CC29  /dev/sdm
[9:0:6:0]    disk    ATA      ST2000DM001-1CH1 CC29  /dev/sdn
[9:0:7:0]    disk    ATA      WDC WD20EZRZ-00Z 0A80  /dev/sdo
[9:0:8:0]    disk    ATA      INTEL SSDSC2CW24 400i  /dev/sdp
[9:0:9:0]    disk    ATA      ST3000DM001-1CH1 CC27  /dev/sdq
[9:0:10:0]   disk    ATA      ST3000DM001-1CH1 CC27  /dev/sdr
[9:0:11:0]   enclosu LSI      SAS2X28          0e12  -
[N:0:1:1]    disk    Samsung SSD 950 PRO 256GB__1               /dev/nvme0n1
[N:1:1:1]    disk    Samsung SSD 950 PRO 256GB__1               /dev/nvme1n1
[root@vm2 ~]#

[root@vm2 ~]# zfs pool -^C
[root@vm2 ~]# zpool list -v
NAME                                            SIZE  ALLOC   FREE  CKPOINT=
=20
EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
s                                              15.4T  11.5T  3.86T        -=
=20=20=20=20
    -    61%    74%  1.20x    ONLINE  -
  sdf                                          3.62T  2.08T  1.54T        -=
=20=20=20=20
    -    40%  57.5%      -    ONLINE
  sdg                                          3.62T  2.07T  1.56T        -=
=20=20=20=20
    -    41%  57.0%      -    ONLINE
  ata-Samsung_SSD_850_EVO_1TB_S3NZNF0JC02715K   928G   812G   116G        -=
=20=20=20=20
    -    77%  87.5%      -    ONLINE
  ata-Samsung_SSD_850_EVO_1TB_S3NZNF0JC02818K   928G   819G   109G        -=
=20=20=20=20
    -    77%  88.3%      -    ONLINE
  ata-Samsung_SSD_850_EVO_1TB_S3NZNF0JC02714Y   928G   815G   113G        -=
=20=20=20=20
    -    77%  87.8%      -    ONLINE
  ata-Samsung_SSD_850_EVO_1TB_S3NZNF0JC02708N   928G   827G   101G        -=
=20=20=20=20
    -    79%  89.2%      -    ONLINE
  ata-Samsung_SSD_850_EVO_1TB_S3NZNF0JC02720L   928G   821G   107G        -=
=20=20=20=20
    -    72%  88.4%      -    ONLINE
  ata-Samsung_SSD_850_EVO_1TB_S3NZNF0JC02717V   928G   834G  93.8G        -=
=20=20=20=20
    -    76%  89.9%      -    ONLINE
  ata-Samsung_SSD_850_EVO_1TB_S3NZNF0JC02707F   928G   870G  58.1G        -=
=20=20=20=20
    -    84%  93.7%      -    ONLINE
  ata-Samsung_SSD_850_EVO_1TB_S3NZNF0JC02719H   928G   907G  21.2G        -=
=20=20=20=20
    -    94%  97.7%      -    ONLINE
  nvme1n1                                       238G   211G  27.1G        -=
=20=20=20=20
    -    87%  88.6%      -    ONLINE
  nvme0n1                                       238G   210G  27.8G        -=
=20=20=20=20
    -    87%  88.3%      -    ONLINE
  ata-INTEL_SSDSC2CW240A3_CVCV316506PA240FGN    222G   219G  2.55G        -=
=20=20=20=20
    -    87%  98.8%      -    ONLINE
  ata-INTEL_SSDSC2CW240A3_CVCV316500UB240FGN    222G   220G  2.46G        -=
=20=20=20=20
    -    87%  98.9%      -    ONLINE
z                                              10.9T  4.22T  6.68T        -=
=20=20=20=20
    -    28%    38%  1.11x    ONLINE  -
  draid2:4d:7c:1s                              10.9T  4.22T  6.68T        -=
=20=20=20=20
    -    28%  38.7%      -    ONLINE
    ata-ST2000DM001-1ER164_Z5606648                -      -      -        -=
=20=20=20=20
    -      -      -      -    ONLINE
    ata-ST2000DM001-1ER164_Z4Z5X09J                -      -      -        -=
=20=20=20=20
    -      -      -      -    ONLINE
    ata-ST2000DM001-1CH164_Z340KWSB                -      -      -        -=
=20=20=20=20
    -      -      -      -    ONLINE
    ata-ST2000DM001-1CH164_Z1E668SP                -      -      -        -=
=20=20=20=20
    -      -      -      -    ONLINE
    ata-ST3000DM001-1CH166_Z1F3WA6S                -      -      -        -=
=20=20=20=20
    -      -      -      -    ONLINE
    ata-ST3000DM001-1CH166_Z1F3RQCR                -      -      -        -=
=20=20=20=20
    -      -      -      -    ONLINE
    ata-WDC_WD20EZRZ-00Z5HB0_WD-WCC4N2KHEF9K       -      -      -        -=
=20=20=20=20
    -      -      -      -    ONLINE
spare                                              -      -      -        -=
=20=20=20=20
    -      -      -      -  -
  draid2-0-0                                       -      -      -        -=
=20=20=20=20
    -      -      -      -     AVAIL

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
