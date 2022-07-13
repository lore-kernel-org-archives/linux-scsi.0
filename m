Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FDBDC43334
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 09:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbiGMJJR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 05:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236068AbiGMJJN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 05:09:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB89A8CC8F
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2022 02:09:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 770EECE1F19
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2022 09:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BCC48C341C8
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2022 09:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657703348;
        bh=EaoMjTvwJn/LT02lJTkrHCuHbC8X9ORj9VWfgOFiLVw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=seKb0VFXnHqO+aqacp+EoP42nVNT8dbeRSbrg7FJRnJIafJioEXHSs0J5XkdFWH9n
         h/jm+llPwnv/caBhPiIlZg/Qx4FIEXDegfy+OFSIULxX7OVsEMTRG3ZpCtp/WERf3q
         BiJHeK6DxyKqQaeJ8A3txRE7ZQR5zWZpXZ+28D6HNHtCGecuA29uWLf1LgGJCkX7ZR
         2nA6obLRRzTCKqh7b6uLh1tbFhH4r67rgV738jNObAHDZVD1U3EXaqElqfS+psUtsn
         +tFwTX2fA0vWCdPVncJrKCFgcQDRKWQedQnDQSJYxWRHBRnrF+1SYhsLZN6wpjiaqQ
         sqXAFOiP8UHmw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 8D822CC13B8; Wed, 13 Jul 2022 09:09:08 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216232] mysterious block devices are shown under /dev folder
Date:   Wed, 13 Jul 2022 09:09:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-qla2xxx@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: QLOGIC QLA2XXX
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: hare@suse.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-qla2xxx@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216232-11613-cxlmA3AD89@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216232-11613@https.bugzilla.kernel.org/>
References: <bug-216232-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216232

--- Comment #1 from Hannes Reinecke (hare@suse.de) ---
On 7/10/22 11:47, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216232
>=20
>              Bug ID: 216232
>             Summary: mysterious block devices are shown under /dev folder
>             Product: SCSI Drivers
>             Version: 2.5
>      Kernel Version: 5.4.61
>            Hardware: All
>                  OS: Linux
>                Tree: Mainline
>              Status: NEW
>            Severity: normal
>            Priority: P1
>           Component: QLOGIC QLA2XXX
>            Assignee: scsi_drivers-qla2xxx@kernel-bugs.osdl.org
>            Reporter: yshxxsjt715@gmail.com
>          Regression: No
>=20
> we are using linux kernel 5.4.61 and fibre channel card is qlogic's
> ISP2722-based 16/32Gb adapter card.
>=20
> the problem is that we are seeing some devices with lun 768 with size of =
512B
> shown under /dev folder. In the syslog we saw something like
>=20
> Jul 10 17:00:08 hci01 kernel: [21675145.568997] scsi_io_completion_action=
: 24
> callbacks suppressed
> Jul 10 17:00:08 hci01 kernel: [21675145.569005] sd 6:0:0:768: [sdau] tag#=
1298
> FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> Jul 10 17:00:08 hci01 kernel: [21675145.569011] sd 6:0:0:768: [sdau] tag#=
1298
> Sense Key : Illegal Request [current]
> Jul 10 17:00:08 hci01 kernel: [21675145.569015] sd 6:0:0:768: [sdau] tag#=
1298
> Add. Sense: Logical block address out of range
> Jul 10 17:00:08 hci01 kernel: [21675145.569019] sd 6:0:0:768: [sdau] tag#=
1298
> CDB: Read(10) 28 00 00 00 00 00 00 00 01 00
> Jul 10 17:00:08 hci01 kernel: [21675145.569021] print_req_error: 24 callb=
acks
> suppressed
> Jul 10 17:00:08 hci01 kernel: [21675145.569025] blk_update_request: criti=
cal
> target error, dev sdau, sector 0 op 0x0:(READ) flags 0x80700 phys_seg 1 p=
rio
> class 0
> Jul 10 17:00:08 hci01 kernel: [21675145.601879] sd 6:0:0:768: [sdau] tag#=
1299
> FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> Jul 10 17:00:08 hci01 kernel: [21675145.601883] sd 6:0:0:768: [sdau] tag#=
1299
> Sense Key : Illegal Request [current]
> Jul 10 17:00:08 hci01 kernel: [21675145.601886] sd 6:0:0:768: [sdau] tag#=
1299
> Add. Sense: Logical block address out of range
> Jul 10 17:00:08 hci01 kernel: [21675145.601888] sd 6:0:0:768: [sdau] tag#=
1299
> CDB: Read(10) 28 00 00 00 00 00 00 00 01 00
> Jul 10 17:00:08 hci01 kernel: [21675145.601891] blk_update_request: criti=
cal
> target error, dev sdau, sector 0 op 0x0:(READ) flags 0x0 phys_seg 1 prio
> class
> 0
> Jul 10 17:00:08 hci01 kernel: [21675145.604213] buffer_io_error: 22 callb=
acks
> suppressed
> Jul 10 17:00:08 hci01 kernel: [21675145.604215] Buffer I/O error on dev s=
dau,
> logical block 0, async page read
> Jul 10 17:00:08 hci01 kernel: [21675145.634149] sd 6:0:0:768: [sdau] tag#=
1300
> FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> Jul 10 17:00:08 hci01 kernel: [21675145.634152] sd 6:0:0:768: [sdau] tag#=
1300
> Sense Key : Illegal Request [current]
> Jul 10 17:00:08 hci01 kernel: [21675145.634155] sd 6:0:0:768: [sdau] tag#=
1300
> Add. Sense: Logical block address out of range
> Jul 10 17:00:08 hci01 kernel: [21675145.634158] sd 6:0:0:768: [sdau] tag#=
1300
> CDB: Read(10) 28 00 00 00 00 00 00 00 01 00
>=20
> here, the lun id of 768 does not exist on SAN but when I try to manually
> delete
> it, after some seconds it still appears.
>=20

This looks more like a configuration issue on the storage.
What is the output of 'lsscsi' on your system?

Cheers,

Hannes

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
