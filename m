Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A86F5C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Mar 2022 17:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350686AbiCORp2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Mar 2022 13:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239523AbiCORp2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2022 13:45:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD88B4EA11
        for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2022 10:44:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DD4BB81804
        for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2022 17:44:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7B93C340F4
        for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2022 17:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647366251;
        bh=gR6zOICvrC2XxBUpde4jjOqNfbAf9iDIgWGRLaUJZSI=;
        h=From:To:Subject:Date:From;
        b=n8QdnqUOKSN4yDEGRB9iGtk+MMYo/4JKMMguR1Y+iPjg+KnSrJ9kihGJYJ4U9v98w
         HfU2Jogs3TWgiKu2kgCBHTQhWruPJWwAJtzNB+RYjQPi1Pjgxv8ksASV2qekie9w6d
         MgHLcoCvr1zf4END4Mk/aiaX9B9YB74bSe3Cx29e55LV1IeQwUzSbua4rAY8DJlFa2
         GYWhwYEYOKAoAZjXVO0UWRj2mM3/NucaJ/01+n0j1JjlkqEMpiiyq4chEWFuEVrNow
         CNivJXp5isv3T2c0WdHKIcVN8ENXZnLayf45MvEYx7rCoOm1FOj1PcU4WxgSwdecWS
         /eCxsXuxS7+9A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D4CFFC05FCE; Tue, 15 Mar 2022 17:44:11 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215691] New: mpt3sas "SMP command sent to the expander has
 timed out" cause halt
Date:   Tue, 15 Mar 2022 17:44:11 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: new
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
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-215691-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215691

            Bug ID: 215691
           Summary: mpt3sas "SMP command sent to the expander has timed
                    out" cause halt
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 5.16.14
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: slavon.net@gmail.com
        Regression: No

Created attachment 300574
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D300574&action=3Dedit
DMESG

All info in dmsg. Aditional ingo:

[root@vm2 ~]# lsscsi
[2:0:0:0]    disk    ATA      KINGSTON SV300S3 BBF0  /dev/sda
[9:0:0:0]    enclosu LSI      SAS2X28          0e12  -
[9:0:1:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sdb
[9:0:2:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sdc
[9:0:3:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sdd
[9:0:4:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sde
[9:0:5:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sdf
[9:0:6:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sdg
[9:0:7:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sdh
[9:0:8:0]    disk    ATA      Samsung SSD 850  3B6Q  /dev/sdi
[9:0:9:0]    disk    ATA      Samsung SSD 850  2B6Q  /dev/sdj
[9:0:10:0]   disk    ATA      Samsung SSD 850  2B6Q  /dev/sdk
[9:0:11:0]   enclosu SMC      SC216-P          100d  -
[9:0:12:0]   disk    ATA      ST2000DM001-1ER1 CC26  /dev/sdl
[9:0:13:0]   disk    ATA      ST2000DM001-1ER1 CC26  /dev/sdm
[9:0:14:0]   disk    ATA      ST2000DM001-1CH1 CC29  /dev/sdn
[9:0:15:0]   disk    ATA      ST2000DM001-1CH1 CC29  /dev/sdo
[9:0:16:0]   disk    ATA      WDC WD20EZRZ-00Z 0A80  /dev/sdp
[9:0:17:0]   disk    ATA      ST3000DM001-1CH1 CC27  /dev/sdq
[9:0:18:0]   disk    ATA      ST3000DM001-1CH1 CC27  /dev/sdr
[N:0:1:1]    disk    Samsung SSD 950 PRO 256GB__1               /dev/nvme0n1
[N:1:1:1]    disk    Samsung SSD 950 PRO 256GB__1               /dev/nvme1n1



NAME                               MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda                                  8:0    0  55,9G  0 disk
=E2=94=9C=E2=94=80sda1                               8:1    0   600M  0 par=
t /boot/efi
=E2=94=9C=E2=94=80sda2                               8:2    0     1G  0 par=
t /boot
=E2=94=94=E2=94=80sda3                               8:3    0    50G  0 par=
t /
sdb                                  8:16   0 931,5G  0 disk
=E2=94=94=E2=94=80sdb1                               8:17   0 931,5G  0 part
  =E2=94=94=E2=94=80SSDvg-thin_pool_tdata          253:10   0  14,9T  0 lvm
    =E2=94=94=E2=94=80SSDvg-thin_pool-tpool        253:11   0  14,9T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-thin_pool            253:12   0  14,9T  1 lvm
      =E2=94=9C=E2=94=80SSDvg-1C                   253:13   0     5T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-XT                   253:14   0     3T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-VDI                  253:15   0    20T  0 lvm
      =E2=94=94=E2=94=80SSDvg-LINUX                253:16   0     5T  0 lvm=
  /s
sdc                                  8:32   0 931,5G  0 disk
=E2=94=94=E2=94=80sdc1                               8:33   0 931,5G  0 part
  =E2=94=94=E2=94=80SSDvg-thin_pool_tdata          253:10   0  14,9T  0 lvm
    =E2=94=94=E2=94=80SSDvg-thin_pool-tpool        253:11   0  14,9T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-thin_pool            253:12   0  14,9T  1 lvm
      =E2=94=9C=E2=94=80SSDvg-1C                   253:13   0     5T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-XT                   253:14   0     3T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-VDI                  253:15   0    20T  0 lvm
      =E2=94=94=E2=94=80SSDvg-LINUX                253:16   0     5T  0 lvm=
  /s
sdd                                  8:48   0 931,5G  0 disk
=E2=94=94=E2=94=80sdd1                               8:49   0 931,5G  0 part
  =E2=94=94=E2=94=80SSDvg-thin_pool_tdata          253:10   0  14,9T  0 lvm
    =E2=94=94=E2=94=80SSDvg-thin_pool-tpool        253:11   0  14,9T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-thin_pool            253:12   0  14,9T  1 lvm
      =E2=94=9C=E2=94=80SSDvg-1C                   253:13   0     5T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-XT                   253:14   0     3T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-VDI                  253:15   0    20T  0 lvm
      =E2=94=94=E2=94=80SSDvg-LINUX                253:16   0     5T  0 lvm=
  /s
sde                                  8:64   0 931,5G  0 disk
=E2=94=94=E2=94=80sde1                               8:65   0 931,5G  0 part
  =E2=94=94=E2=94=80SSDvg-thin_pool_tdata          253:10   0  14,9T  0 lvm
    =E2=94=94=E2=94=80SSDvg-thin_pool-tpool        253:11   0  14,9T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-thin_pool            253:12   0  14,9T  1 lvm
      =E2=94=9C=E2=94=80SSDvg-1C                   253:13   0     5T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-XT                   253:14   0     3T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-VDI                  253:15   0    20T  0 lvm
      =E2=94=94=E2=94=80SSDvg-LINUX                253:16   0     5T  0 lvm=
  /s
sdf                                  8:80   0 931,5G  0 disk
=E2=94=94=E2=94=80sdf1                               8:81   0 931,5G  0 part
  =E2=94=94=E2=94=80SSDvg-thin_pool_tdata          253:10   0  14,9T  0 lvm
    =E2=94=94=E2=94=80SSDvg-thin_pool-tpool        253:11   0  14,9T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-thin_pool            253:12   0  14,9T  1 lvm
      =E2=94=9C=E2=94=80SSDvg-1C                   253:13   0     5T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-XT                   253:14   0     3T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-VDI                  253:15   0    20T  0 lvm
      =E2=94=94=E2=94=80SSDvg-LINUX                253:16   0     5T  0 lvm=
  /s
sdg                                  8:96   0 931,5G  0 disk
=E2=94=94=E2=94=80sdg1                               8:97   0 931,5G  0 part
  =E2=94=94=E2=94=80SSDvg-thin_pool_tdata          253:10   0  14,9T  0 lvm
    =E2=94=94=E2=94=80SSDvg-thin_pool-tpool        253:11   0  14,9T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-thin_pool            253:12   0  14,9T  1 lvm
      =E2=94=9C=E2=94=80SSDvg-1C                   253:13   0     5T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-XT                   253:14   0     3T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-VDI                  253:15   0    20T  0 lvm
      =E2=94=94=E2=94=80SSDvg-LINUX                253:16   0     5T  0 lvm=
  /s
sdh                                  8:112  0 931,5G  0 disk
=E2=94=94=E2=94=80sdh1                               8:113  0 931,5G  0 part
  =E2=94=94=E2=94=80SSDvg-thin_pool_tdata          253:10   0  14,9T  0 lvm
    =E2=94=94=E2=94=80SSDvg-thin_pool-tpool        253:11   0  14,9T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-thin_pool            253:12   0  14,9T  1 lvm
      =E2=94=9C=E2=94=80SSDvg-1C                   253:13   0     5T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-XT                   253:14   0     3T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-VDI                  253:15   0    20T  0 lvm
      =E2=94=94=E2=94=80SSDvg-LINUX                253:16   0     5T  0 lvm=
  /s
sdi                                  8:128  0 931,5G  0 disk
=E2=94=94=E2=94=80sdi1                               8:129  0 931,5G  0 part
  =E2=94=94=E2=94=80SSDvg-thin_pool_tdata          253:10   0  14,9T  0 lvm
    =E2=94=94=E2=94=80SSDvg-thin_pool-tpool        253:11   0  14,9T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-thin_pool            253:12   0  14,9T  1 lvm
      =E2=94=9C=E2=94=80SSDvg-1C                   253:13   0     5T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-XT                   253:14   0     3T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-VDI                  253:15   0    20T  0 lvm
      =E2=94=94=E2=94=80SSDvg-LINUX                253:16   0     5T  0 lvm=
  /s
sdj                                  8:144  0   3,7T  0 disk
=E2=94=94=E2=94=80sdj1                               8:145  0   3,7T  0 part
  =E2=94=94=E2=94=80SSDvg-thin_pool_tdata          253:10   0  14,9T  0 lvm
    =E2=94=94=E2=94=80SSDvg-thin_pool-tpool        253:11   0  14,9T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-thin_pool            253:12   0  14,9T  1 lvm
      =E2=94=9C=E2=94=80SSDvg-1C                   253:13   0     5T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-XT                   253:14   0     3T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-VDI                  253:15   0    20T  0 lvm
      =E2=94=94=E2=94=80SSDvg-LINUX                253:16   0     5T  0 lvm=
  /s
sdk                                  8:160  0   3,7T  0 disk
=E2=94=94=E2=94=80sdk1                               8:161  0   3,7T  0 part
  =E2=94=94=E2=94=80SSDvg-thin_pool_tdata          253:10   0  14,9T  0 lvm
    =E2=94=94=E2=94=80SSDvg-thin_pool-tpool        253:11   0  14,9T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-thin_pool            253:12   0  14,9T  1 lvm
      =E2=94=9C=E2=94=80SSDvg-1C                   253:13   0     5T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-XT                   253:14   0     3T  0 lvm
      =E2=94=9C=E2=94=80SSDvg-VDI                  253:15   0    20T  0 lvm
      =E2=94=94=E2=94=80SSDvg-LINUX                253:16   0     5T  0 lvm=
  /s
sdl                                  8:176  0   1,8T  0 disk
=E2=94=94=E2=94=80sdl1                               8:177  0   1,8T  0 part
  =E2=94=9C=E2=94=80HDDvg-vdopool_rmeta_1          253:7    0     4M  0 lvm
  =E2=94=82 =E2=94=94=E2=94=80HDDvg-vdopool                253:9    0   5,5=
T  0 lvm  /mnt/hdd
  =E2=94=94=E2=94=80HDDvg-vdopool_rimage_1         253:8    0   5,5T  0 lvm
    =E2=94=94=E2=94=80HDDvg-vdopool                253:9    0   5,5T  0 lvm=
  /mnt/hdd
sdm                                  8:192  0   1,8T  0 disk
=E2=94=94=E2=94=80sdm1                               8:193  0   1,8T  0 part
  =E2=94=94=E2=94=80HDDvg-vdopool_rimage_0         253:5    0   5,5T  0 lvm
    =E2=94=94=E2=94=80HDDvg-vdopool                253:9    0   5,5T  0 lvm=
  /mnt/hdd
sdn                                  8:208  0   1,8T  0 disk
=E2=94=94=E2=94=80sdn1                               8:209  0   1,8T  0 part
  =E2=94=94=E2=94=80HDDvg-vdopool_rimage_1         253:8    0   5,5T  0 lvm
    =E2=94=94=E2=94=80HDDvg-vdopool                253:9    0   5,5T  0 lvm=
  /mnt/hdd
sdo                                  8:224  0   1,8T  0 disk
=E2=94=94=E2=94=80sdo1                               8:225  0   1,8T  0 part
  =E2=94=94=E2=94=80HDDvg-vdopool_rimage_0         253:5    0   5,5T  0 lvm
    =E2=94=94=E2=94=80HDDvg-vdopool                253:9    0   5,5T  0 lvm=
  /mnt/hdd
sdp                                  8:240  0   1,8T  0 disk
=E2=94=94=E2=94=80sdp1                               8:241  0   1,8T  0 part
  =E2=94=94=E2=94=80HDDvg-vdopool_rimage_1         253:8    0   5,5T  0 lvm
    =E2=94=94=E2=94=80HDDvg-vdopool                253:9    0   5,5T  0 lvm=
  /mnt/hdd
sdq                                 65:0    0   2,7T  0 disk
=E2=94=94=E2=94=80sdq1                              65:1    0   2,7T  0 part
  =E2=94=9C=E2=94=80HDDvg-vdopool_rmeta_0          253:3    0     4M  0 lvm
  =E2=94=82 =E2=94=94=E2=94=80HDDvg-vdopool                253:9    0   5,5=
T  0 lvm  /mnt/hdd
  =E2=94=94=E2=94=80HDDvg-vdopool_rimage_0         253:5    0   5,5T  0 lvm
    =E2=94=94=E2=94=80HDDvg-vdopool                253:9    0   5,5T  0 lvm=
  /mnt/hdd
sdr                                 65:16   0   2,7T  0 disk
nvme0n1                            259:0    0 238,5G  0 disk
=E2=94=9C=E2=94=80nvme0n1p1                        259:1    0   100G  0 part
=E2=94=82 =E2=94=94=E2=94=80SSDvg-thin_pool_tdata          253:10   0  14,9=
T  0 lvm
=E2=94=82   =E2=94=94=E2=94=80SSDvg-thin_pool-tpool        253:11   0  14,9=
T  0 lvm
=E2=94=82     =E2=94=9C=E2=94=80SSDvg-thin_pool            253:12   0  14,9=
T  1 lvm
=E2=94=82     =E2=94=9C=E2=94=80SSDvg-1C                   253:13   0     5=
T  0 lvm
=E2=94=82     =E2=94=9C=E2=94=80SSDvg-XT                   253:14   0     3=
T  0 lvm
=E2=94=82     =E2=94=9C=E2=94=80SSDvg-VDI                  253:15   0    20=
T  0 lvm
=E2=94=82     =E2=94=94=E2=94=80SSDvg-LINUX                253:16   0     5=
T  0 lvm  /s
=E2=94=9C=E2=94=80nvme0n1p2                        259:2    0   100G  0 part
=E2=94=82 =E2=94=94=E2=94=80SSDvg-thin_pool_tdata          253:10   0  14,9=
T  0 lvm
=E2=94=82   =E2=94=94=E2=94=80SSDvg-thin_pool-tpool        253:11   0  14,9=
T  0 lvm
=E2=94=82     =E2=94=9C=E2=94=80SSDvg-thin_pool            253:12   0  14,9=
T  1 lvm
=E2=94=82     =E2=94=9C=E2=94=80SSDvg-1C                   253:13   0     5=
T  0 lvm
=E2=94=82     =E2=94=9C=E2=94=80SSDvg-XT                   253:14   0     3=
T  0 lvm
=E2=94=82     =E2=94=9C=E2=94=80SSDvg-VDI                  253:15   0    20=
T  0 lvm
=E2=94=82     =E2=94=94=E2=94=80SSDvg-LINUX                253:16   0     5=
T  0 lvm  /s
=E2=94=94=E2=94=80nvme0n1p3                        259:3    0  38,5G  0 part
  =E2=94=9C=E2=94=80SSDvg-thin_pool_tmeta_rmeta_1  253:2    0     4M  0 lvm
  =E2=94=82 =E2=94=94=E2=94=80SSDvg-thin_pool_tmeta        253:6    0  38,5=
G  0 lvm
  =E2=94=82   =E2=94=94=E2=94=80SSDvg-thin_pool-tpool      253:11   0  14,9=
T  0 lvm
  =E2=94=82     =E2=94=9C=E2=94=80SSDvg-thin_pool          253:12   0  14,9=
T  1 lvm
  =E2=94=82     =E2=94=9C=E2=94=80SSDvg-1C                 253:13   0     5=
T  0 lvm
  =E2=94=82     =E2=94=9C=E2=94=80SSDvg-XT                 253:14   0     3=
T  0 lvm
  =E2=94=82     =E2=94=9C=E2=94=80SSDvg-VDI                253:15   0    20=
T  0 lvm
  =E2=94=82     =E2=94=94=E2=94=80SSDvg-LINUX              253:16   0     5=
T  0 lvm  /s
  =E2=94=94=E2=94=80SSDvg-thin_pool_tmeta_rimage_1 253:4    0  38,5G  0 lvm
    =E2=94=94=E2=94=80SSDvg-thin_pool_tmeta        253:6    0  38,5G  0 lvm
      =E2=94=94=E2=94=80SSDvg-thin_pool-tpool      253:11   0  14,9T  0 lvm
        =E2=94=9C=E2=94=80SSDvg-thin_pool          253:12   0  14,9T  1 lvm
        =E2=94=9C=E2=94=80SSDvg-1C                 253:13   0     5T  0 lvm
        =E2=94=9C=E2=94=80SSDvg-XT                 253:14   0     3T  0 lvm
        =E2=94=9C=E2=94=80SSDvg-VDI                253:15   0    20T  0 lvm
        =E2=94=94=E2=94=80SSDvg-LINUX              253:16   0     5T  0 lvm=
  /s
nvme1n1                            259:4    0 238,5G  0 disk
=E2=94=9C=E2=94=80nvme1n1p1                        259:5    0   100G  0 part
=E2=94=82 =E2=94=94=E2=94=80SSDvg-thin_pool_tdata          253:10   0  14,9=
T  0 lvm
=E2=94=82   =E2=94=94=E2=94=80SSDvg-thin_pool-tpool        253:11   0  14,9=
T  0 lvm
=E2=94=82     =E2=94=9C=E2=94=80SSDvg-thin_pool            253:12   0  14,9=
T  1 lvm
=E2=94=82     =E2=94=9C=E2=94=80SSDvg-1C                   253:13   0     5=
T  0 lvm
=E2=94=82     =E2=94=9C=E2=94=80SSDvg-XT                   253:14   0     3=
T  0 lvm
=E2=94=82     =E2=94=9C=E2=94=80SSDvg-VDI                  253:15   0    20=
T  0 lvm
=E2=94=82     =E2=94=94=E2=94=80SSDvg-LINUX                253:16   0     5=
T  0 lvm  /s
=E2=94=9C=E2=94=80nvme1n1p2                        259:6    0   100G  0 part
=E2=94=82 =E2=94=94=E2=94=80SSDvg-thin_pool_tdata          253:10   0  14,9=
T  0 lvm
=E2=94=82   =E2=94=94=E2=94=80SSDvg-thin_pool-tpool        253:11   0  14,9=
T  0 lvm
=E2=94=82     =E2=94=9C=E2=94=80SSDvg-thin_pool            253:12   0  14,9=
T  1 lvm
=E2=94=82     =E2=94=9C=E2=94=80SSDvg-1C                   253:13   0     5=
T  0 lvm
=E2=94=82     =E2=94=9C=E2=94=80SSDvg-XT                   253:14   0     3=
T  0 lvm
=E2=94=82     =E2=94=9C=E2=94=80SSDvg-VDI                  253:15   0    20=
T  0 lvm
=E2=94=82     =E2=94=94=E2=94=80SSDvg-LINUX                253:16   0     5=
T  0 lvm  /s
=E2=94=94=E2=94=80nvme1n1p3                        259:7    0  38,5G  0 part
  =E2=94=9C=E2=94=80SSDvg-thin_pool_tmeta_rmeta_0  253:0    0     4M  0 lvm
  =E2=94=82 =E2=94=94=E2=94=80SSDvg-thin_pool_tmeta        253:6    0  38,5=
G  0 lvm
  =E2=94=82   =E2=94=94=E2=94=80SSDvg-thin_pool-tpool      253:11   0  14,9=
T  0 lvm
  =E2=94=82     =E2=94=9C=E2=94=80SSDvg-thin_pool          253:12   0  14,9=
T  1 lvm
  =E2=94=82     =E2=94=9C=E2=94=80SSDvg-1C                 253:13   0     5=
T  0 lvm
  =E2=94=82     =E2=94=9C=E2=94=80SSDvg-XT                 253:14   0     3=
T  0 lvm
  =E2=94=82     =E2=94=9C=E2=94=80SSDvg-VDI                253:15   0    20=
T  0 lvm
  =E2=94=82     =E2=94=94=E2=94=80SSDvg-LINUX              253:16   0     5=
T  0 lvm  /s
  =E2=94=94=E2=94=80SSDvg-thin_pool_tmeta_rimage_0 253:1    0  38,5G  0 lvm
    =E2=94=94=E2=94=80SSDvg-thin_pool_tmeta        253:6    0  38,5G  0 lvm
      =E2=94=94=E2=94=80SSDvg-thin_pool-tpool      253:11   0  14,9T  0 lvm
        =E2=94=9C=E2=94=80SSDvg-thin_pool          253:12   0  14,9T  1 lvm
        =E2=94=9C=E2=94=80SSDvg-1C                 253:13   0     5T  0 lvm
        =E2=94=9C=E2=94=80SSDvg-XT                 253:14   0     3T  0 lvm
        =E2=94=9C=E2=94=80SSDvg-VDI                253:15   0    20T  0 lvm
        =E2=94=94=E2=94=80SSDvg-LINUX              253:16   0     5T  0 lvm=
  /s


[root@vm2 sas3ircu_linux_x64_rel]# ./sas3ircu 1 DISPLAY
Avago Technologies SAS3 IR Configuration Utility.
Version 17.00.00.00 (2018.04.02)
Copyright (c) 2009-2018 Avago Technologies. All rights reserved.

Read configuration has been initiated for controller 1
------------------------------------------------------------------------
Controller information
------------------------------------------------------------------------
  Controller type                         : SAS3008
  BIOS version                            : 8.37.00.00
  Firmware version                        : 16.00.10.00
  Channel description                     : 1 Serial Attached SCSI
  Initiator ID                            : 0
  Maximum physical devices                : 1023
  Concurrent commands supported           : 9664
  Slot                                    : 33
  Segment                                 : 0
  Bus                                     : 131
  Device                                  : 0
  Function                                : 0
  RAID Support                            : No
------------------------------------------------------------------------
IR Volume information
------------------------------------------------------------------------
------------------------------------------------------------------------
Physical device information
------------------------------------------------------------------------
Initiator at ID #0

Device is a Hard disk
  Enclosure #                             : 2
  Slot #                                  : 0
  SAS Address                             : 5003048-0-29c4-e100
  State                                   : Ready (RDY)
  Size (in MB)/(in sectors)               : 953869/1953525167
  Manufacturer                            : ATA
  Model Number                            : Samsung SSD 850
  Firmware Revision                       : 3B6Q
  Serial No                               : S3NZNF0JC02719H
  Unit Serial No(VPD)                     : S3NZNF0JC02719H
  GUID                                    : 5002538d428a46b5
  Protocol                                : SATA
  Drive Type                              : SATA_SSD

Device is a Hard disk
  Enclosure #                             : 2
  Slot #                                  : 1
  SAS Address                             : 5003048-0-29c4-e101
  State                                   : Ready (RDY)
  Size (in MB)/(in sectors)               : 953869/1953525167
  Manufacturer                            : ATA
  Model Number                            : Samsung SSD 850
  Firmware Revision                       : 3B6Q
  Serial No                               : S3NZNF0JC02715K
  Unit Serial No(VPD)                     : S3NZNF0JC02715K
  GUID                                    : 5002538d428a46b1
  Protocol                                : SATA
  Drive Type                              : SATA_SSD

Device is a Hard disk
  Enclosure #                             : 2
  Slot #                                  : 2
  SAS Address                             : 5003048-0-29c4-e102
  State                                   : Ready (RDY)
  Size (in MB)/(in sectors)               : 953869/1953525167
  Manufacturer                            : ATA
  Model Number                            : Samsung SSD 850
  Firmware Revision                       : 3B6Q
  Serial No                               : S3NZNF0JC02714Y
  Unit Serial No(VPD)                     : S3NZNF0JC02714Y
  GUID                                    : 5002538d428a46b0
  Protocol                                : SATA
  Drive Type                              : SATA_SSD

Device is a Hard disk
  Enclosure #                             : 2
  Slot #                                  : 3
  SAS Address                             : 5003048-0-29c4-e103
  State                                   : Ready (RDY)
  Size (in MB)/(in sectors)               : 953869/1953525167
  Manufacturer                            : ATA
  Model Number                            : Samsung SSD 850
  Firmware Revision                       : 3B6Q
  Serial No                               : S3NZNF0JC02720L
  Unit Serial No(VPD)                     : S3NZNF0JC02720L
  GUID                                    : 5002538d428a46b6
  Protocol                                : SATA
  Drive Type                              : SATA_SSD

Device is a Hard disk
  Enclosure #                             : 2
  Slot #                                  : 4
  SAS Address                             : 5003048-0-29c4-e104
  State                                   : Ready (RDY)
  Size (in MB)/(in sectors)               : 953869/1953525167
  Manufacturer                            : ATA
  Model Number                            : Samsung SSD 850
  Firmware Revision                       : 3B6Q
  Serial No                               : S3NZNF0JC02717V
  Unit Serial No(VPD)                     : S3NZNF0JC02717V
  GUID                                    : 5002538d428a46b3
  Protocol                                : SATA
  Drive Type                              : SATA_SSD

Device is a Hard disk
  Enclosure #                             : 2
  Slot #                                  : 5
  SAS Address                             : 5003048-0-29c4-e105
  State                                   : Ready (RDY)
  Size (in MB)/(in sectors)               : 953869/1953525167
  Manufacturer                            : ATA
  Model Number                            : Samsung SSD 850
  Firmware Revision                       : 3B6Q
  Serial No                               : S3NZNF0JC02708N
  Unit Serial No(VPD)                     : S3NZNF0JC02708N
  GUID                                    : 5002538d428a46aa
  Protocol                                : SATA
  Drive Type                              : SATA_SSD

Device is a Hard disk
  Enclosure #                             : 2
  Slot #                                  : 6
  SAS Address                             : 5003048-0-29c4-e106
  State                                   : Ready (RDY)
  Size (in MB)/(in sectors)               : 953869/1953525167
  Manufacturer                            : ATA
  Model Number                            : Samsung SSD 850
  Firmware Revision                       : 3B6Q
  Serial No                               : S3NZNF0JC02818K
  Unit Serial No(VPD)                     : S3NZNF0JC02818K
  GUID                                    : 5002538d428a475e
  Protocol                                : SATA
  Drive Type                              : SATA_SSD

Device is a Hard disk
  Enclosure #                             : 2
  Slot #                                  : 7
  SAS Address                             : 5003048-0-29c4-e107
  State                                   : Ready (RDY)
  Size (in MB)/(in sectors)               : 953869/1953525167
  Manufacturer                            : ATA
  Model Number                            : Samsung SSD 850
  Firmware Revision                       : 3B6Q
  Serial No                               : S3NZNF0JC02707F
  Unit Serial No(VPD)                     : S3NZNF0JC02707F
  GUID                                    : 5002538d428a46a9
  Protocol                                : SATA
  Drive Type                              : SATA_SSD

Device is a Hard disk
  Enclosure #                             : 2
  Slot #                                  : 22
  SAS Address                             : 5003048-0-29c4-e126
  State                                   : Ready (RDY)
  Size (in MB)/(in sectors)               : 3815447/7814037167
  Manufacturer                            : ATA
  Model Number                            : Samsung SSD 850
  Firmware Revision                       : 2B6Q
  Serial No                               : S2RRNX0J800385N
  Unit Serial No(VPD)                     : S2RRNX0J800385N
  GUID                                    : 5002538c407a35e4
  Protocol                                : SATA
  Drive Type                              : SATA_SSD

Device is a Hard disk
  Enclosure #                             : 2
  Slot #                                  : 23
  SAS Address                             : 5003048-0-29c4-e127
  State                                   : Ready (RDY)
  Size (in MB)/(in sectors)               : 3815447/7814037167
  Manufacturer                            : ATA
  Model Number                            : Samsung SSD 850
  Firmware Revision                       : 2B6Q
  Serial No                               : S2RRNX0J800093E
  Unit Serial No(VPD)                     : S2RRNX0J800093E
  GUID                                    : 5002538c407a33f8
  Protocol                                : SATA
  Drive Type                              : SATA_SSD

Device is a Enclosure services device
  Enclosure #                             : 2
  Slot #                                  : 24
  SAS Address                             : 5003048-0-29c4-e13d
  State                                   : Standby (SBY)
  Manufacturer                            : SMC
  Model Number                            : SC216-P
  Firmware Revision                       : 100d
  Serial No                               : x406616130
  Unit Serial No(VPD)                     : Enclosure Serial Number
  GUID                                    : N/A
  Protocol                                : SAS
  Device Type                             : Enclosure services device

Device is a Enclosure services device
  Enclosure #                             : 3
  Slot #                                  : 0
  SAS Address                             : 5003048-0-0000-007d
  State                                   : Standby (SBY)
  Manufacturer                            : LSI
  Model Number                            : SAS2X28
  Firmware Revision                       : 0e12
  Serial No                               : x365514180
  Unit Serial No(VPD)                     : N/A
  GUID                                    : N/A
  Protocol                                : SAS
  Device Type                             : Enclosure services device

Device is a Hard disk
  Enclosure #                             : 3
  Slot #                                  : 2
  SAS Address                             : 5003048-0-0000-006e
  State                                   : Ready (RDY)
  Size (in MB)/(in sectors)               : 1907729/3907029167
  Manufacturer                            : ATA
  Model Number                            : ST2000DM001-1ER1
  Firmware Revision                       : CC26
  Serial No                               : Z5606648
  Unit Serial No(VPD)                     : Z5606648
  GUID                                    : 5000c50091e6af7c
  Protocol                                : SATA
  Drive Type                              : SATA_HDD

Device is a Hard disk
  Enclosure #                             : 3
  Slot #                                  : 3
  SAS Address                             : 5003048-0-0000-006f
  State                                   : Ready (RDY)
  Size (in MB)/(in sectors)               : 1907729/3907029167
  Manufacturer                            : ATA
  Model Number                            : ST2000DM001-1ER1
  Firmware Revision                       : CC26
  Serial No                               : Z4Z5X09J
  Unit Serial No(VPD)                     : Z4Z5X09J
  GUID                                    : 5000c50091e6874b
  Protocol                                : SATA
  Drive Type                              : SATA_HDD

Device is a Hard disk
  Enclosure #                             : 3
  Slot #                                  : 5
  SAS Address                             : 5003048-0-0000-0071
  State                                   : Ready (RDY)
  Size (in MB)/(in sectors)               : 1907729/3907029167
  Manufacturer                            : ATA
  Model Number                            : ST2000DM001-1CH1
  Firmware Revision                       : CC29
  Serial No                               : Z340KWSB
  Unit Serial No(VPD)                     : Z340KWSB
  GUID                                    : 5000c50065546546
  Protocol                                : SATA
  Drive Type                              : SATA_HDD

Device is a Hard disk
  Enclosure #                             : 3
  Slot #                                  : 6
  SAS Address                             : 5003048-0-0000-0072
  State                                   : Ready (RDY)
  Size (in MB)/(in sectors)               : 1907729/3907029167
  Manufacturer                            : ATA
  Model Number                            : ST2000DM001-1CH1
  Firmware Revision                       : CC29
  Serial No                               : Z1E668SP
  Unit Serial No(VPD)                     : Z1E668SP
  GUID                                    : 5000c500655589a0
  Protocol                                : SATA
  Drive Type                              : SATA_HDD

Device is a Hard disk
  Enclosure #                             : 3
  Slot #                                  : 7
  SAS Address                             : 5003048-0-0000-0073
  State                                   : Ready (RDY)
  Size (in MB)/(in sectors)               : 1907729/3907029167
  Manufacturer                            : ATA
  Model Number                            : WDC WD20EZRZ-00Z
  Firmware Revision                       : 0A80
  Serial No                               : WDWCC4N2KHEF9K
  Unit Serial No(VPD)                     : WD-WCC4N2KHEF9K
  GUID                                    : 50014ee2b923d72d
  Protocol                                : SATA
  Drive Type                              : SATA_HDD

Device is a Hard disk
  Enclosure #                             : 3
  Slot #                                  : 10
  SAS Address                             : 5003048-0-0000-0076
  State                                   : Ready (RDY)
  Size (in MB)/(in sectors)               : 2861588/5860533167
  Manufacturer                            : ATA
  Model Number                            : ST3000DM001-1CH1
  Firmware Revision                       : CC27
  Serial No                               : Z1F3WA6S
  Unit Serial No(VPD)                     : Z1F3WA6S
  GUID                                    : 5000c50064f8d7a4
  Protocol                                : SATA
  Drive Type                              : SATA_HDD

Device is a Hard disk
  Enclosure #                             : 3
  Slot #                                  : 11
  SAS Address                             : 5003048-0-0000-0077
  State                                   : Ready (RDY)
  Size (in MB)/(in sectors)               : 2861588/5860533167
  Manufacturer                            : ATA
  Model Number                            : ST3000DM001-1CH1
  Firmware Revision                       : CC27
  Serial No                               : Z1F3RQCR
  Unit Serial No(VPD)                     : Z1F3RQCR
  GUID                                    : 5000c50064cb0d57
  Protocol                                : SATA
  Drive Type                              : SATA_HDD
------------------------------------------------------------------------
Enclosure information
------------------------------------------------------------------------
  Enclosure#                              : 1
  Logical ID                              : 500605b0:0db3ce40
  Numslots                                : 8
  StartSlot                               : 0
  Enclosure#                              : 2
  Logical ID                              : 50030480:29c4e13f
  Numslots                                : 43
  StartSlot                               : 0
  Enclosure#                              : 3
  Logical ID                              : 50030480:0000007f
  Numslots                                : 17
  StartSlot                               : 0
  Primary Boot Slot                       : 0
------------------------------------------------------------------------
SAS3IRCU: Command DISPLAY Completed Successfully.
SAS3IRCU: Utility Completed Successfully.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
