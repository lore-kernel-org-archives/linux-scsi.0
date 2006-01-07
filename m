From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] always handle REQ_BLOCK_PC requests in common code
Date: Sat, 07 Jan 2006 16:26:43 +1000
Message-ID: <43BF5F23.2040804@torque.net>
References: <20060106173407.GA23658@lst.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:61586 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S932663AbWAGG0U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Jan 2006 01:26:20 -0500
In-Reply-To: <20060106173407.GA23658@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> LLDDs should never see REQ_BLOCK_PC requests, we can handle them just
> fine in the core code.  There is a small behaviour change in that some
> check in sr's rw_intr are bypassed, but I consider the old behaviour
> a bug.
> 
> Mike found this cleanup ooportunity and provdided early patches, so all
> the credit goes to him, even if I redid the patches from scratch beause
> that was easier than forward-porting the old patches.

The point of the hacks in the sd driver was to make
sure SG_IO ioctl commands issued via a sd device node
would not get caught up in the sd driver's error
processing (e.g. retries on MEDIUM ERRORs). Is there
a clean path back for such errors to the SG_IO ioctl
and hence the user space?

The same applies to most of the error processing done
in the midlayer, with TASK SET FULL being a bit of a
grey area.

Doug Gilbert
