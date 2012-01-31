From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Write same support
Date: Mon, 30 Jan 2012 19:31:27 -0500
Message-ID: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:53194 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab2AaAbt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2012 19:31:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@hansenpartnership.com, snitzer@redhat.com, jaxboe@fusionio.com


Here's my stab at write same support.

I have mainly tested using blkdev_issue_zeroout which I have modified to
use write same if available. It will fall back to writing zeroes the
old-fashioned way if write same fails. I also wired up an ioctl so I
could trigger zeroout from userland.

I have gone back and forth over whether blkdev_issue_write_same() should
take a struct page or a virtual address. It's not such a big deal for
devices with a 512-byte logical block size. But for devices with 4K it's
more of an issue. Comments welcome.

The discovery heuristics is what stopped this patchkit in its tracks
last year. So I've spent the last few days testing with every exotic
(i.e. ancient) SCSI device I could find. I'm pretty happy with how it
works now but it would be great if more people would put it to the test.

I have a 'writesame' branch available at:

	git://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git

for those that want to try it out...

-- 
Martin K. Petersen	Oracle Linux Engineering
