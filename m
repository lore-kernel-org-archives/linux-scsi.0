From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 7644] Race: host lock is not acquired before calling ql_icmd
Date: Sat, 12 Apr 2008 19:55:40 -0700 (PDT)
Message-ID: <20080413025540.8DA36108064@picon.linux-foundation.org>
References: <bug-7644-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752556AbYDMCzm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Apr 2008 22:55:42 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m3D2tefh011282
	for <linux-scsi@vger.kernel.org>; Sat, 12 Apr 2008 19:55:41 -0700
In-Reply-To: <bug-7644-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=7644


protasnb@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |protasnb@gmail.com
             Status|NEW                         |REJECTED
         Resolution|                            |INVALID




------- Comment #1 from protasnb@gmail.com  2008-04-12 19:55 -------
We do hold the lock in generic scsi code when call queuecommand.
in scsi_dispatch_cmd:

...
        spin_lock_irqsave(host->host_lock, flags);
        scsi_cmd_get_serial(host, cmd);

        if (unlikely(host->shost_state == SHOST_DEL)) {
                cmd->result = (DID_NO_CONNECT << 16);
                scsi_done(cmd);
        } else {
                rtn = host->hostt->queuecommand(cmd, scsi_done);
        }
        spin_unlock_irqrestore(host->host_lock, flags);
...

scsi_send)eh_command:

...
        spin_lock_irqsave(shost->host_lock, flags);
        scsi_log_send(scmd);
        shost->hostt->queuecommand(scmd, scsi_eh_done);
        spin_unlock_irqrestore(shost->host_lock, flags);
...

So it looks like we are good.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
