From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 191381] LIO ignores XCOPY source and destination descriptor IDs
Date: Mon, 02 Jan 2017 01:20:35 +0000
Message-ID: <bug-191381-11613-hdW6DXl3lX@https.bugzilla.kernel.org/>
References: <bug-191381-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755167AbdABBUj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 1 Jan 2017 20:20:39 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 78E9720416
        for <linux-scsi@vger.kernel.org>; Mon,  2 Jan 2017 01:20:36 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 5474A20414
        for <linux-scsi@vger.kernel.org>; Mon,  2 Jan 2017 01:20:35 +0000 (UTC)
In-Reply-To: <bug-191381-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=191381

--- Comment #1 from David Disseldorp <ddiss.dev@gmail.com> ---
I've pushed a reproducer to:
https://github.com/ddiss/libiscsi/commit/ae159e147ddf7192ff41e2375c073a10d6c90fb6

Usage is:
examples/iscsi-dd --xcopy --src iscsi://192.168.155.101:3260/<iqn>/<src_lun>
--dst iscsi://192.168.155.101:3260/<iqn>/<dst_lun>

iscsi-dd has been modified to issue XCOPY requests with the CSCD List order
modified such that the destination (specified via segment descriptor ID)
appears before the source.

-- 
You are receiving this mail because:
You are the assignee for the bug.
