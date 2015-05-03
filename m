From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 97641] Repeated unit attentions trigger initiator lockup
Date: Sun, 03 May 2015 09:37:23 +0000
Message-ID: <bug-97641-11613-MBu7iOqB2O@https.bugzilla.kernel.org/>
References: <bug-97641-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45366 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbbECJh2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 May 2015 05:37:28 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E617D203A4
	for <linux-scsi@vger.kernel.org>; Sun,  3 May 2015 09:37:26 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 95FC62043C
	for <linux-scsi@vger.kernel.org>; Sun,  3 May 2015 09:37:23 +0000 (UTC)
In-Reply-To: <bug-97641-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=97641

--- Comment #1 from Bart Van Assche <bvanassche@acm.org> ---
The fio job at the initiator side was started as follows:

mkfs.ext4 -O ^has_journal ${LUN0_DEV_NODE}
umount /mnt
mount ${LUN0_DEV_NODE} /mnt
fio --verify=md5 -rw=randwrite --size=10m --bs=4K --loops=10000000 \
    --iodepth=64 --group_reporting --sync=1 --direct=1 --ioengine=libaio \
    --directory=/mnt --name=test --thread --numjobs=1

-- 
You are receiving this mail because:
You are the assignee for the bug.
