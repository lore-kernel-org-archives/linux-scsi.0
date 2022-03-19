Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAC65C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Mar 2022 05:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242214AbiCSFks (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Mar 2022 01:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbiCSFkq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Mar 2022 01:40:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D8972E29
        for <linux-scsi@vger.kernel.org>; Fri, 18 Mar 2022 22:39:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFB1EB80122
        for <linux-scsi@vger.kernel.org>; Sat, 19 Mar 2022 05:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 50D34C340EC
        for <linux-scsi@vger.kernel.org>; Sat, 19 Mar 2022 05:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647668362;
        bh=m/SOqU3ZATP8hMHQLJLfGawp+v3pGGrN27R9bOyj+ZU=;
        h=From:To:Subject:Date:From;
        b=Xa8zd1OJDLUSvRLK+O1fIqlpHCsQ5xHIo/lztZePx7QP4O01287FmpqKsveXTJs1k
         +Cb7FVuXhcDRa83YjRtkXEE97RCfzfp5If3GuOxt6+Nnyfk+sbwu/cuf10y5y7060B
         b7lTxfQovjjppSXgKbebzYoxM1jp9dOYIwNaLlrZHy5eIrbaSTgzqxSeLG17aF8XxT
         kOLFg4Igm/HltPSvu3+ugRcweM0cVWNKfq8gfu9gkyFIgZbmqHMF4u6qDfolmUS51D
         fqpU3PI/YqMxyZZgMIJrn9h+tuPSHpzuVIdVLUFe3hEcPrPiekLOyhwyR+lFWQ9TCB
         MqUn37Ezeshzw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 3D306C05FD5; Sat, 19 Mar 2022 05:39:22 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215701] New: [scsi]timing out command, waited 180s
Date:   Sat, 19 Mar 2022 05:39:21 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: xqjcool@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-215701-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215701

            Bug ID: 215701
           Summary: [scsi]timing out command, waited 180s
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.10.0-514.26.2.el7.x86_64
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: xqjcool@gmail.com
        Regression: No

Created attachment 300581
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D300581&action=3Dedit
system log about scsi issue

We have encountered the following problems in the operation of our equipmen=
t.



-----------------------------
[505412.987911] sd 2:0:0:0: timing out command, waited 180s
[505412.987920] sd 2:0:0:0: [sda] FAILED Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_OK
[505412.987923] sd 2:0:0:0: [sda] CDB: Write(10) 2a 00 01 29 b4 e1 00 00 04=
 00
[505412.987926] blk_update_request: I/O error, dev sda, sector 19510497
[505412.987970] XFS (dm-0): metadata I/O error: block 0xd664e1 ("xlog_iodon=
e")
error 5 numblks 64
[505412.988952] XFS (dm-0): xfs_do_force_shutdown(0x2) called from line 120=
3 of
file fs/xfs/xfs_log.c.  Return address =3D 0xffffffffa027a590
[505412.988971] XFS (dm-0): Log I/O Error Detected.  Shutting down filesyst=
em
[505412.989365] XFS (dm-0): xfs_log_force: error -5 returned.
[505412.989428] XFS (dm-0): Please umount the filesystem and rectify the
problem(s)
[505413.038058] XFS (dm-0): xfs_log_force: error -5 returned.
--------------------------------

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
