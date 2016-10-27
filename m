From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85751] iSCSI initiator lockup during logout
Date: Thu, 27 Oct 2016 13:21:43 +0000
Message-ID: <bug-85751-11613-y79IOJXzii@https.bugzilla.kernel.org/>
References: <bug-85751-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936606AbcJ0N73 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Oct 2016 09:59:29 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id DFD93203A1
        for <linux-scsi@vger.kernel.org>; Thu, 27 Oct 2016 13:21:46 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id E08192038E
        for <linux-scsi@vger.kernel.org>; Thu, 27 Oct 2016 13:21:44 +0000 (UTC)
In-Reply-To: <bug-85751-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85751

Jaden <jaden1q84@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jaden1q84@gmail.com

--- Comment #4 from Jaden <jaden1q84@gmail.com> ---
I also encountered the similar issue, but not in logout stage. If the links are
down could also meet this issue occasionally. Below are my reproduce steps:

1.while :; do dd if=/dev/sdc of=/dev/null bs=1K count=1 iflag=direct; done
2.kill -SIGSTOP `pidof iscsid`
3.iptables -A OUTPUT -p tcp --dport 3260 -j DROP

I think it is cause by a status conflict between the waitting for lost IO
request and iscsi device remove procedure. Any new thoughs?

-- 
You are receiving this mail because:
You are the assignee for the bug.
