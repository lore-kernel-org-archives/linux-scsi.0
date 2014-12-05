From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] SCSI: SD: set max_ws_blocks as max_unmap_blocks if it isn't provided
Date: Fri, 05 Dec 2014 07:56:15 -0500
Message-ID: <yq1r3wefe6o.fsf@sermon.lab.mkp.net>
References: <1417782952-19908-1-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40222 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaLEM4e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2014 07:56:34 -0500
In-Reply-To: <1417782952-19908-1-git-send-email-ming.lei@canonical.com> (Ming
	Lei's message of "Fri, 5 Dec 2014 20:35:51 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: James Bottomley <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>

>>>>> "Ming" == Ming Lei <ming.lei@canonical.com> writes:

Ming,

Ming> QEMU SCSI device claims to support UNMAP, WRITE SAME and WRITE
Ming> SAME 16 in LBP VPD page, but only provides "Maximum unmap LBA
Ming> count" in block limits VPD page, and "Maximum write same length"
Ming> isn't set.

That really sounds like a problem that should be fixed in QEMU SCSI.

Ming> The default max_discard_sectors(SD_MAX_WS16_BLOCKS) can't work at
Ming> all since it is much bigger than the actual Maximum unmap LBA
Ming> count.

There is absolutely no correlation between max write same blocks and max
unmap blocks. They are two entirely different commands. If QEMU SCSI
advertises support for WRITE SAME(16) and does not report a cap in the
block limits VPD then we must expect that it supports the maximum number
of blocks that can be expressed by the command.

-- 
Martin K. Petersen	Oracle Linux Engineering
