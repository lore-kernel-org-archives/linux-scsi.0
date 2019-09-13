Return-Path: <SRS0=Er8N=XI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E3F9C49ED7
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 16:03:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1205B2089F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 16:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbfIMQDM convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Sep 2019 12:03:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbfIMQDM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Sep 2019 12:03:12 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 204815] qla2xxx: firmware is not responding to mailbox commands
Date:   Fri, 13 Sep 2019 16:03:11 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-qla2xxx@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: QLOGIC QLA2XXX
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: r.bolshakov@yadro.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-qla2xxx@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-204815-11613-TklCnS3jym@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204815-11613@https.bugzilla.kernel.org/>
References: <bug-204815-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204815

--- Comment #3 from Roman Bolshakov (r.bolshakov@yadro.com) ---
Hi Martin,

I can't tell for sure, because f8f97b0c5b7f7 introduces a regression fixed in
1710ac17547ac8b ("scsi: qla2xxx: Fix read offset in
qla24xx_load_risc_flash()"). 

Here's the possible timeline:
1. f8f97b0c5b7f7 ("scsi: qla2xxx: Cleanups for NVRAM/Flash read/write path")
introduces a regression which prevents successful ISP firmware checksum
validation and kernel panics shortly after.
2. a28d9e4ef997 ("scsi: qla2xxx: Add support for multiple fwdump
templates/segments") introduces a regression which causes EEH and system lockup
on POWER8 or makes firmware unavailable (this bug).
3. 1710ac17547ac8 ("scsi: qla2xxx: Fix read offset in
qla24xx_load_risc_flash()") fixes  f8f97b0c5b7f7 but the fix depends both on #1
and #2.
4. edbd56472a63 ("scsi: qla2xxx: qla2x00_alloc_fw_dump: set ha->eft") fixes
a28d9e4ef997. 

It's not possible to bisect between #1 and #3 because of the panic introduced
in #1. And firmware works reliably only after #4.

And I think it's important to include your fix into 5.3, otherwise qla2xxx is
broken in the release.

Thanks,
Roman

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
