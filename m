Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBA6EC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 18:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239705AbiDFSCE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 14:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239924AbiDFSBu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2022 14:01:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92A2101F0B
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 09:35:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E3DD6170F
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 16:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE99DC385A1
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 16:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649262905;
        bh=+fFfN92UqYGVq15vlEFiBogiwlm1OIvtVXtQMPtgpqE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=CgAxX9FeFBt+huxjT7vQa53J5k1/wMJMa94iJ46Mt29vyC/9rSAie9xaeC27WqkX/
         k3D/yLtYEEKdYiZSYOHNNuoBnGhg6sHzNtU3az7BSGRYhZPW4+BKYEas5evyzdD6pS
         70xdDJ3O63CGZHbXPs9bjLno7d1xDf3SOF6oRtkYUpaULSvVDSkBZj3vF/J8TxwkpJ
         UQ89zSGyIwOqExaqfcC5/mzBW8nrULZWF86HI8jxlqDB21wrCkkdO8o74s5XgUldK4
         SHp2bFeU1TKD4nkUrDkqajxJLXIIgkQjZHmMXRVlVy02yBkPt8FaoLaEfc0jV5ZtaG
         D/j4nwIHpj8cg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id CF8ABC05FD5; Wed,  6 Apr 2022 16:35:04 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215788] arcmsr driver on kernel 5.16 and up fails to initialize
 ARC-1280ML RAID controller
Date:   Wed, 06 Apr 2022 16:35:04 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jernej-bugzilla.kernel@ena.si
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215788-11613-Ndredomk72@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215788-11613@https.bugzilla.kernel.org/>
References: <bug-215788-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215788

--- Comment #8 from Jernej Simon=C4=8Di=C4=8D (jernej-bugzilla.kernel@ena.s=
i) ---
Here are results for ARC-1212:

[root@sysrescue ~]# uname -a
Linux sysrescue 5.15.22-1-lts #1 SMP Tue, 08 Feb 2022 19:00:40 +0000 x86_64
GNU/Linux
[root@sysrescue ~]# sg_inq /dev/sdb
standard INQUIRY:
  PQual=3D0  PDT=3D0  RMB=3D0  LU_CONG=3D0  hot_pluggable=3D0  version=3D0x=
05  [SPC-3]
  [AERC=3D0]  [TrmTsk=3D0]  NormACA=3D0  HiSUP=3D0  Resp_data_format=3D2
  SCCS=3D0  ACC=3D0  TPGS=3D0  3PC=3D0  Protect=3D0  [BQue=3D0]
  EncServ=3D0  MultiP=3D0  [MChngr=3D0]  [ACKREQQ=3D0]  Addr16=3D1
  [RelAdr=3D0]  WBus16=3D1  Sync=3D0  [Linked=3D0]  [TranDis=3D0]  CmdQue=
=3D1
  [SPI: Clocking=3D0x3  QAS=3D0  IUS=3D0]
    length=3D96 (0x60)   Peripheral device type: disk
 Vendor identification: Areca
 Product identification: Storage
 Product revision level: R001
 Unit serial number: 42bc2c2180321188
[root@sysrescue ~]# sg_inq --vpd /dev/sdb
VPD INQUIRY, page code=3D0x00:
   Supported VPD pages:
     0x0        Supported VPD pages
     0x80       Unit serial number
     0x83       Device identification
     0xc7
[root@sysrescue ~]# sg_vpd -E /dev/sdb
Unit serial number VPD page:
  Unit serial number: 42bc2c2180321188

Device Identification VPD page:
  Addressed logical unit:
    designator type: EUI-64 based,  code set: Binary
      0x001b4d2008231188

Vendor VPD page=3D0xc0  failed to fetchVendor VPD page=3D0xc1  failed to
fetchVendor VPD page=3D0xc2  failed to fetchVendor VPD page=3D0xc3  failed =
to
fetchVendor VPD page=3D0xc4  failed to fetchVendor VPD page=3D0xc5  failed =
to fetch
00     00 c7 00 3c 00 00 00 00  00 00 00 00 00 00 00 00    ...<............
 10     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00    ................
 20     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00    ................
 30     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00    ................

Vendor VPD page=3D0xc8  failed to fetchVendor VPD page=3D0xc9  failed to
fetchVendor VPD page=3D0xca  failed to fetchVendor VPD page=3D0xd0  failed =
to
fetchVendor VPD page=3D0xd1  failed to fetchVendor VPD page=3D0xd2  failed =
to
fetch[root@sysrescue ~]# sg_logs -l -l /dev/sdb
    Areca     Storage           R001
log_sense: field in cdb illegal
sg_logs failed: Illegal request
[root@sysrescue ~]# sg_vpd --force --page=3D0xb9 /dev/sdb
VPD page=3D0xb7
fetching VPD page failed: Illegal request
sg_vpd failed: Illegal request


And for ARC-1280ML:

deepthought ~ # sg_inq /dev/sda
standard INQUIRY:
  PQual=3D0  PDT=3D0  RMB=3D0  LU_CONG=3D0  hot_pluggable=3D0  version=3D0x=
05  [SPC-3]
  [AERC=3D0]  [TrmTsk=3D0]  NormACA=3D0  HiSUP=3D0  Resp_data_format=3D2
  SCCS=3D0  ACC=3D0  TPGS=3D0  3PC=3D0  Protect=3D0  [BQue=3D0]
  EncServ=3D0  MultiP=3D0  [MChngr=3D0]  [ACKREQQ=3D0]  Addr16=3D1
  [RelAdr=3D0]  WBus16=3D1  Sync=3D0  [Linked=3D0]  [TranDis=3D0]  CmdQue=
=3D1
  [SPI: Clocking=3D0x3  QAS=3D0  IUS=3D0]
    length=3D96 (0x60)   Peripheral device type: disk
 Vendor identification: Areca
 Product identification: System
 Product revision level: R001
 Unit serial number: 0000003927378925
deepthought ~ # sg_inq /dev/sdX
sg_inq: error opening file: /dev/sdX: No such file or directory
sg_inq failed: No such file or directory
deepthought ~ # sg_inq --vpd /dev/sdX
sg_inq: error opening file: /dev/sdX: No such file or directory
sg_inq failed: No such file or directory
deepthought ~ # sg_vpd -E /dev/sdX
sg_vpd failed: No such file or directory
deepthought ~ # sg_logs -l -l /dev/sdX^C
deepthought ~ # sg_inq /dev/sda
standard INQUIRY:
  PQual=3D0  PDT=3D0  RMB=3D0  LU_CONG=3D0  hot_pluggable=3D0  version=3D0x=
05  [SPC-3]
  [AERC=3D0]  [TrmTsk=3D0]  NormACA=3D0  HiSUP=3D0  Resp_data_format=3D2
  SCCS=3D0  ACC=3D0  TPGS=3D0  3PC=3D0  Protect=3D0  [BQue=3D0]
  EncServ=3D0  MultiP=3D0  [MChngr=3D0]  [ACKREQQ=3D0]  Addr16=3D1
  [RelAdr=3D0]  WBus16=3D1  Sync=3D0  [Linked=3D0]  [TranDis=3D0]  CmdQue=
=3D1
  [SPI: Clocking=3D0x3  QAS=3D0  IUS=3D0]
    length=3D96 (0x60)   Peripheral device type: disk
 Vendor identification: Areca
 Product identification: System
 Product revision level: R001
 Unit serial number: 0000003927378925
deepthought ~ # sg_inq --vpd /dev/sda
VPD INQUIRY, page code=3D0x00:
   Supported VPD pages:
     0x0        Supported VPD pages
     0x80       Unit serial number
     0x83       Device identification
     0xc7
deepthought ~ # sg_vpd -E /dev/sda
@Unit serial number VPD page:
  Unit serial number: 0000003927378925

@Device Identification VPD page:
  Addressed logical unit:
    designator type: EUI-64 based,  code set: Binary
      0x001b4d2305766800

Vendor VPD page=3D0xc0  failed to fetchVendor VPD page=3D0xc1  failed to
fetchVendor VPD page=3D0xc2  failed to fetchVendor VPD page=3D0xc3  failed =
to
fetchVendor VPD page=3D0xc4  failed to fetchVendor VPD page=3D0xc5  failed =
to fetch
00     00 c7 00 3c 00 00 00 00  00 00 00 00 00 00 00 00    ...<............
 10     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00    ................
 20     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00    ................
 30     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00    ................

Vendor VPD page=3D0xc8  failed to fetchVendor VPD page=3D0xc9  failed to
fetchVendor VPD page=3D0xca  failed to fetchVendor VPD page=3D0xd0  failed =
to
fetchVendor VPD page=3D0xd1  failed to fetchVendor VPD page=3D0xd2  failed =
to
fetchdeepthought ~ # sg_logs -l -l /dev/sda
    Areca     System            R001
log_sense: field in cdb illegal
sg_logs failed: Illegal request
deepthought ~ # sg_vpd --force --page=3D0xb9 /dev/sda
VPD page=3D0xb7
fetching VPD page failed: Illegal request
sg_vpd failed: Illegal request


Neither controller crashed on the last command.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
