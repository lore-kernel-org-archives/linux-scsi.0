Return-Path: <SRS0=uqxd=XG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D867ECDE27
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 15:54:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5440A2089F
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 15:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbfIKPya convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Sep 2019 11:54:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728289AbfIKPy3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Sep 2019 11:54:29 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 204815] New: qla2xxx: firmware is not responding to mailbox
 commands
Date:   Wed, 11 Sep 2019 15:54:28 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
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
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-204815-11613@https.bugzilla.kernel.org/>
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

            Bug ID: 204815
           Summary: qla2xxx: firmware is not responding to mailbox
                    commands
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 5.2-rc1 up to 5.3-rc8
          Hardware: PPC-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: QLOGIC QLA2XXX
          Assignee: scsi_drivers-qla2xxx@kernel-bugs.osdl.org
          Reporter: r.bolshakov@yadro.com
        Regression: No

Created attachment 284925
  --> https://bugzilla.kernel.org/attachment.cgi?id=284925&action=edit
firmware times out on 5.3-rc8

I'm using QLogic HBAs (QLE2560 and QLE2742) inside pseries guests on
ppc64le/POWER8 hypervisor and they are not usable since commit f8f97b0c5b7f7
("scsi: qla2xxx: Cleanups for NVRAM/Flash read/write path"). 

The firmware stops responding to mailbox commands shortly after system boot is
done.
That also triggers an EEH on pseries machine and driver doesn't handle the EEH
properly because firmware is effectively not available. I disabled eeh inside
the guest as it caused a deadlock on the host kernel.

The issue is fixed in linux-next by the commit edbd56472a63 ("scsi: qla2xxx:
qla2x00_alloc_fw_dump: set ha->eft"). I think it should be included to 5.3 if
possible. It can be cherry-picked cleanly to master.

The logs of 5.3-rc8 (bad.log) and 5.3-rc8 with edbd56472a63 (good.log) are
applied.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
