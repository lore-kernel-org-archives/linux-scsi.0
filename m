From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] support for bidirectional transfers and variable length CDBs
Date: Sun, 29 Oct 2006 12:30:04 -0700
Message-ID: <20061029193004.GV5591@parisc-linux.org>
References: <4541F822.70700@panasas.com> <20061028163609.GA17317@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:25311 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S965353AbWJ2TaH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Oct 2006 14:30:07 -0500
Content-Disposition: inline
In-Reply-To: <20061028163609.GA17317@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Benny Halevy <bhalevy@panasas.com>, linux-scsi@vger.kernel.org, Mike Christie <mchristi@redhat.com>, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Dalit Naor <DALIT@il.ibm.com>, Liran Schour <LIRANS@il.ibm.com>, Sami.Iren@seagate.com, Daniel.E.Messinger@seagate.com, stuart.brodsky@seagate.com, open-iscsi@googlegroups.com, Boaz Harrosh <bharrosh@panasas.com>

On Sat, Oct 28, 2006 at 05:36:09PM +0100, Christoph Hellwig wrote:
> This should be an entirely separate patch.  (As should your updates to
> the list of scsi device types and the typo fix in a comment in your
> patch)

Actually, the update to the list of device types is already in Linus' tree
http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=4ff36718ede26ee2da73f2dae94d71e2b06845fc

> I haven't looked at this code in detail but it looks rather
> messy already ;-)  I'd prefer if we could postponed implementing this
> properly until we've landed bidi support.

I think we should encapsulate:

-	int write = (data_direction == DMA_TO_DEVICE);
+	int write = ((data_direction == DMA_TO_DEVICE) || (data_direction == DMA_BIDIRECTIONAL));

into something like:

-	int write = (data_direction == DMA_TO_DEVICE);
+	int write = is_dma_write(data_direction);

