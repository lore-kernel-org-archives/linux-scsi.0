Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7641BC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 01:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453552AbiDFBJg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573705AbiDETqb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 15:46:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2231214087
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 12:44:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3A44B81D70
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 19:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57406C385A5
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 19:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649187869;
        bh=IJ/2d+uptvjbtjK+OAT3T7uVg726Fjx0wo3MOOHaZJE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=X5pHqvEtvHDUTlQrT28PCEcphGQJcdMY9QhHytaGdzxopum8b3CK5PJH2rmXOL6N/
         lnYZdx7JdEFAIMKOVTPbLc92asqlbtVTvWXsDzLxMAkvQlP4s75vpXrAShKVpV9ptA
         BWFztfB7TfUpgMGcBiW7AW5mM3FyZ/R20OptriWxjdDmsX/eRRLJPLTjUVbpZQPL17
         PjsnVqZYsoONM6aeUrsjt8R3F0n4AyKPnnwNU0SHn5/sfOiQy6oBKxUYO/JvQloC3V
         Y4hxGcug0fOF5TvqO2hRfY0Kga1Z8dhbNTgiHmq834pyXj09P7R3N1eHVjxlinZfhg
         lZr5hocWCq3fw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 31877CAC6E2; Tue,  5 Apr 2022 19:44:29 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215788] arcmsr driver on kernel 5.16 and up fails to initialize
 ARC-1280ML RAID controller
Date:   Tue, 05 Apr 2022 19:44:28 +0000
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
Message-ID: <bug-215788-11613-7AgoF2qW7L@https.bugzilla.kernel.org/>
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

--- Comment #3 from Jernej Simon=C4=8Di=C4=8D (jernej-bugzilla.kernel@ena.s=
i) ---
Done, it points at this commit:

e815d36548f01797ce381be8f0b74f4ba9befd15 is the first bad commit
commit e815d36548f01797ce381be8f0b74f4ba9befd15
Author: Damien Le Moal <damien.lemoal@wdc.com>
Date:   Wed Oct 27 11:22:20 2021 +0900

    scsi: sd: add concurrent positioning ranges support

    Add the sd_read_cpr() function to the sd scsi disk driver to discover
    if a device has multiple concurrent positioning ranges (i.e. multiple
    actuators on an HDD). The existence of VPD page B9h indicates if a
    device has multiple concurrent positioning ranges. The page content
    describes each range supported by the device.

    sd_read_cpr() is called from sd_revalidate_disk() and uses the block
    layer functions disk_alloc_independent_access_ranges() and
    disk_set_independent_access_ranges() to represent the set of actuators
    of the device as independent access ranges.

    The format of the Concurrent Positioning Ranges VPD page B9h is defined
    in section 6.6.6 of SBC-5.

    Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
    Reviewed-by: Hannes Reinecke <hare@suse.de>
    Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
    Reviewed-by: Keith Busch <kbusch@kernel.org>
    Link:
https://lore.kernel.org/r/20211027022223.183838-3-damien.lemoal@wdc.com
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

 drivers/scsi/sd.c | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++=
++++
 drivers/scsi/sd.h |  1 +
 2 files changed, 82 insertions(+)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
