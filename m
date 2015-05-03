From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 97641] New: Repeated unit attentions trigger initiator lockup
Date: Sun, 03 May 2015 09:24:49 +0000
Message-ID: <bug-97641-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45215 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbbECJYv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 May 2015 05:24:51 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5AEFE200D4
	for <linux-scsi@vger.kernel.org>; Sun,  3 May 2015 09:24:50 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 90B5C2041B
	for <linux-scsi@vger.kernel.org>; Sun,  3 May 2015 09:24:49 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=97641

            Bug ID: 97641
           Summary: Repeated unit attentions trigger initiator lockup
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 4.1-rc1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: bvanassche@acm.org
        Regression: No

Created attachment 175651
  --> https://bugzilla.kernel.org/attachment.cgi?id=175651&action=edit
initiator-deadlock.txt

Two virtual machines were configured such that one had the role of iSCSI target
system and the other of iSCSI initiator system. After iSCSI login a fio job was
started on the initiator system against LUN 0 of the target system. When I
start 
run the following test at the target side:

# cd /sys/kernel/scst_tgt/targets/iscsi/iqn.2012-06.be.bva\:tgt1/luns/
# while true; do echo del 1 > mgmt; echo add diskf0 1 > mgmt; done

that results in the following error messages at the initiator side:

iscsid: Can not allocate memory for receive context.
kernel: [  231.226002]  connection1:0: detected conn error (1011)

and exactly 30 seconds later the initiator system locks up reporting the
following (see also the initiator-deadlock.txt attachment):

[ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
4.1.0-rc1-debug+ #2 Not tainted
------------------------------------------------------
swapper/0/0 [HC0[0]:SC1[1]:HE0:SE0] is trying to acquire:
 (&(&session->frwd_lock)->rlock){+.-...}, at: [<ffffffffc0185f42>]
iscsi_eh_cmd_timed_out+0x42/0x330 [libiscsi]

and this task is already holding:
 (&(&q->__queue_lock)->rlock){-.-...}, at: [<ffffffff81328037>]
blk_rq_timed_out_timer+0x27/0x130
which would create a new lock dependency:
 (&(&q->__queue_lock)->rlock){-.-...} ->
(&(&session->frwd_lock)->rlock){+.-...}

-- 
You are receiving this mail because:
You are the assignee for the bug.
