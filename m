Return-Path: <SRS0=lGnU=AD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8677C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 10:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D2B3206F1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 10:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgFVKil convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Jun 2020 06:38:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbgFVKil (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Jun 2020 06:38:41 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 208045] ARM ubuntu 18.04 as the iscsi server, using initiator
 login, the kernel crashes
Date:   Mon, 22 Jun 2020 10:38:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: bstroesser@ts.fujitsu.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-208045-11613-Ry2m3lSr1T@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208045-11613@https.bugzilla.kernel.org/>
References: <bug-208045-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208045

--- Comment #11 from Bodo Stroesser (bstroesser@ts.fujitsu.com) ---
Ah, I think I know what's going wrong. I think this happens only during
commmand completion if there is a padding at the end of the tcmu command ring
which is shorter than sizeof(struct tcmu_cmd_entry).

Unfortunately I missed the problem at this place while I fixed a very similar
problem during creation of a padding entry at the end of the ring :(


I'll come up with a patch soon.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
