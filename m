Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B19C43217
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 05:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241974AbiDFFna (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 01:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1845834AbiDFCBW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 22:01:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCAC3258FF5
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 16:29:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C4CD60AC0
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 23:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82F91C385A0
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 23:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649201385;
        bh=NEWncxU3RMWEbBPuVnOQnu4+2dh1CqVI3xodyHY6Ijk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=R1C3fgbpM8pOt4TQRat/Emy5Z08buJMfeni9ybat8Gs5GM1n4w+5BDghA0Tn+OSrf
         CtTLEchwZY0Niu2tSqE4EG7HYmex4axIi7Jz8jGjwiI8MRI8mxNryvuYKSZn9INSk2
         Bb/XbWln+1xqP281rLiNRPzJVO6BD9snqZmloXqVHQPzTX7ONsswRzwmPNx0DSZJqE
         eGbWygM+q4y8DS/gcWrTiXu2qQpjcZwdO4Q70EPrWorNXJ7K/6+/gU3btZeFX7BF0M
         VAUVGnelv51UuAi5tIilQSqJpRggsSjSVvMS7v5wXwMb13okfBuZCBD5ZpQLaKRQD/
         E8OKUkqJkhM5g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6AA4ECAC6E2; Tue,  5 Apr 2022 23:29:45 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215788] arcmsr driver on kernel 5.16 and up fails to initialize
 ARC-1280ML RAID controller
Date:   Tue, 05 Apr 2022 23:29:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: damien.lemoal@wdc.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215788-11613-dn8na9sStn@https.bugzilla.kernel.org/>
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

--- Comment #5 from Damien Le Moal (damien.lemoal@wdc.com) ---
Can you try this patch:

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a390679cf458..cecba3fcbc61 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3216,6 +3216,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
                        sd_read_block_limits(sdkp);
                        sd_read_block_characteristics(sdkp);
                        sd_zbc_read_zones(sdkp, buffer);
+                       sd_read_cpr(sdkp);
                }

                sd_print_capacity(sdkp, old_capacity);
@@ -3225,7 +3226,6 @@ static int sd_revalidate_disk(struct gendisk *disk)
                sd_read_app_tag_own(sdkp, buffer);
                sd_read_write_same(sdkp, buffer);
                sd_read_security(sdkp, buffer);
-               sd_read_cpr(sdkp);
        }

        /*

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
