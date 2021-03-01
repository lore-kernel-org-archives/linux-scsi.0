Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 451AFC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:50:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0727664E2E
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbhCAMu3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 07:50:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:50774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233871AbhCAMu2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Mar 2021 07:50:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0FD8664E75
        for <linux-scsi@vger.kernel.org>; Mon,  1 Mar 2021 12:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614602988;
        bh=63OkT0ttVzQcDXXjagkrnHKB8+qHmDgwDl48GrUhlpc=;
        h=From:To:Subject:Date:From;
        b=t5P+WmBaJTzsTKNZqsELCziX3XdDEFFra7gUTwwN0wmSE5lkrzDRbwN9AcYudRe84
         6YVJe3crZ0UOYEoTc4fr113KPRCxzjcKAB7iN6mc4bGGfqv7wcO1+ypTvybKeVOOCr
         GAmiy31V8Jsc5BgRuL036sJ4FayxVoDDCQDQL5f9oa1EkKeOJG3mH6taiRu0JXk4Rj
         aOJIFFAahNpLNGKwGnR3BWKXZTAbuhD5BKlIEoFyl/tdqOfZvErYCYWDUn+PqBd8Pz
         4eDeFmghrm+q413rToWdyCHXk1R5vYrq3JVjdXv9mHtC/qcE5OhdhAxMDdnRnzbbfA
         Q8cMVvWui+5KA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212007] New: wrong timeout calculation in scsi device_handler
 (scsi_dh_emc.c and scsi_dh_rdac.c)
Date:   Mon, 01 Mar 2021 12:49:47 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: t.wede@kw-reneg.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-212007-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D212007

            Bug ID: 212007
           Summary: wrong timeout calculation in scsi device_handler
                    (scsi_dh_emc.c and scsi_dh_rdac.c)
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 5.11.2 (all kernels since 4.11)
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: t.wede@kw-reneg.de
        Regression: No

Created attachment 295549
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D295549&action=3Dedit
patch to correct wrong timeout calculations in scsi device handler

scsi_dh_emc.c:
--------------

In scsi_dh_emc.c (line 34) CLARIION_TIMEOUT ist defined as (60 * HZ).

In send_trespass_cmd (lines 279 - 281) the following is calculated:

err =3D scsi_execute(sdev, cdb, DMA_TO_DEVICE, csdev->buffer, len, NULL,
                        &sshdr, CLARIION_TIMEOUT * HZ, CLARIION_RETRIES,
                        req_flags, 0, NULL);

The result is "(60 * HZ) * HZ".


scsi_dh_rdac.c:
---------------

In scsi_dh_rdac.c (line 55) RDAC_TIMEOUT is defined as (60 * HZ).

In send_mode_select (lines 558 - 566) the following is calculated:

        if (scsi_execute(sdev, cdb, DMA_TO_DEVICE, &h->ctlr->mode_select,
                        data_size, NULL, &sshdr, RDAC_TIMEOUT * HZ,
                        RDAC_RETRIES, req_flags, 0, NULL)) {
                err =3D mode_select_handle_sense(sdev, &sshdr);
                if (err =3D=3D SCSI_DH_RETRY && retry_cnt--)
                        goto retry;
                if (err =3D=3D SCSI_DH_IMM_RETRY)
                        goto retry;
        }

The result is "(60 * HZ) * HZ".

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
