From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET] scsi: don't use flush_scheduled_work()
Date: Tue, 21 Dec 2010 16:01:55 +0100
Message-ID: <1292943721-4519-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:60700 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab0LUPCM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Dec 2010 10:02:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, Eric.Moore@lsi.com, dgilbert@interlog.com


Hello,

This patchset removes the use of flush_scheduled_work() from scsi
drivers and contains the following six patches.

 0001-scsi-remove-flush_scheduled_work-usages.patch
 0002-scsi-pm8001-simplify-workqueue-usage.patch
 0003-fcoe-use-dedicated-workqueue-instead-of-system_wq.patch
 0004-fusion-don-t-use-flush_scheduled_work.patch
 0005-scsi-remove-bogus-use-of-struct-execute_work-in-sg.patch
 0006-scsi-don-t-use-execute_in_process_context.patch

The patches are on top of the current scsi-misc-2.6#master +
wq#for-2.6.38[1].  The latter is necessary for commit c8efcc25
(workqueue: allow chained queueing during destruction) as 0003 and
0006 depend on destroy_workqueue() handling chained works correctly.

James, how does 0006 look to you now?  If you think it's acceptable,
please feel free to pull from wq#for-2.6.38, the branch is stable and
won't be rebased.

Thank you.

--
tejun

[1] git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-2.6.38
