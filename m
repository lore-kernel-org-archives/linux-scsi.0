From: Christoph Hellwig <hch@lst.de>
Subject: fusion problems on 64bit hosts
Date: Sat, 25 Sep 2004 15:57:14 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040925135714.GA19990@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:51686 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S269341AbUIYN5V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Sep 2004 09:57:21 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Emoore@lsil.com
Cc: linux-scsi@vger.kernel.org

compiling fusion on ppc64 gives:

drivers/message/fusion/mptbase.c: In function `mpt_interrupt':
drivers/message/fusion/mptbase.c:360: warning: cast to pointer from integer of different size
drivers/message/fusion/mptbase.c:384: warning: cast to pointer from integer of different size
drivers/message/fusion/mptlan.c: In function `lan_reply':
drivers/message/fusion/mptlan.c:214: warning: cast from pointer to integer of different size

This is because of:

#if defined(__alpha__) || defined(__sparc_v9__) || defined(__ia64__) || defined(__x86_64__)
#define CAST_U32_TO_PTR(x)      ((void *)(u64)x)
#define CAST_PTR_TO_U32(x)      ((u32)(u64)x)
#else
#define CAST_U32_TO_PTR(x)      ((void *)x)
#define CAST_PTR_TO_U32(x)      ((u32)x)
#endif

which shuts the warning up on some 64bit architectures but doesn't solve
the problem.  You're trying to keep a 64bit pointer in a 32bit hardware
register which can't work on 64bit architectures (the code if for the
networking and target modules that few people use)

The right fix is to only store a 32bit lookup key for some datastructure
in the register and use it as lookup key in the intr handler.
