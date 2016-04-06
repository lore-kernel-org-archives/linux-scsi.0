From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 114401] crash dump aic94xx
Date: Wed, 06 Apr 2016 19:26:43 +0000
Message-ID: <bug-114401-11613-vbdgtkUucG@https.bugzilla.kernel.org/>
References: <bug-114401-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41376 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701AbcDFT1G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Apr 2016 15:27:06 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 83DC82020F
	for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2016 19:26:45 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 9EE67201F2
	for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2016 19:26:44 +0000 (UTC)
In-Reply-To: <bug-114401-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=114401

bastienphilbert@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bastienphilbert@gmail.com

--- Comment #1 from bastienphilbert@gmail.com ---
out_done:
         tascb->completion = NULL;
         if (res == TMF_RESP_FUNC_COMPLETE) {
                 task->lldd_task = NULL;
add these line:
                 list_del_init(&ascb->list);
                 mb();
                 asd_ascb_free(tascb);
         }
         ASD_DPRINTK("task 0x%p aborted, res: 0x%x\n", task, res);
         return res;

  out_free:
same here:
         list_del_init(&ascb->list);
         asd_ascb_free(ascb);
         ASD_DPRINTK("task 0x%p aborted, res: 0x%x\n", task, res);
         return res;
}
Tell me if this fixes your issue.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
