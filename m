From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fixes compile errors in cpqfcTS driver
Date: 22 Apr 2003 08:54:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051019692.1768.7.camel@mulgrave>
References: <3EA48555.8020600@us.ibm.com>
	<20030422074414.A26090@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:25350 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263169AbTDVNna (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2003 09:43:30 -0400
In-Reply-To: <20030422074414.A26090@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Christie <mikenc@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-04-22 at 01:44, Christoph Hellwig wrote:
> I don't think the onstack command/device will work anymore.
> You'll have to use scsi_get_command/scsi_put_command I guess

Actually on stack command allocation never was legal, although we seem
to have quite a few drivers that do it.  The reason (aside from the fact
that the stack is a precious resource in the kernel) is that struct
scsi_cmnds can be used by the driver to DMA to the device and DMAable
memory should never be allocated on the stack (mainly because of
alignment and flushing issues that can cause memory corruption).

Unfortunately, the bugs stack allocation causes don't show up on the x86
architecture giving a driver that seems to work for the majority of
users but which can cause weird hangs and crashes on non-x86 platforms.

James


