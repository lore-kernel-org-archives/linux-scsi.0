From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: scsi: convert discard to REQ_TYPE_FS instead of
 REQ_TYPE_BLOCK_PC
Date: Wed, 7 Jul 2010 13:06:23 +0900
Message-ID: <20100707130545M.fujita.tomonori@lab.ntt.co.jp>
References: <20100706213136.GA21246@redhat.com>
	<4C33BEDF.7050602@interlog.com>
	<20100707004748.GA3068@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:33747 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab0GGEG5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jul 2010 00:06:57 -0400
In-Reply-To: <20100707004748.GA3068@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: snitzer@redhat.com
Cc: dgilbert@interlog.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, hch@lst.de, axboe@kernel.dk

On Tue, 6 Jul 2010 20:47:48 -0400
Mike Snitzer <snitzer@redhat.com> wrote:

> So it seems the transition away from BLOCK_PC to REQ_TYPE_FS has enabled
> us to actually know about malformed SCSI requests without special SCSI
> tracing.
>
> This appears to be a welcomed side-effect of using REQ_TYPE_FS.

scsi-ml just ignores the results for BLOCK_PC since it assumes that
the upper layers want to handle. The block layer and file systems
can't handle the results of discard so discard should be REQ_TYPE_FS.

With REQ_TYPE_FS conversion, we might see more errors of discard that
we have ignored so far. However, the errors aren't due to REQ_TYPE_FS
conversion. REQ_TYPE_FS conversion doesn't lead to any changes to
scsi_cmnd struct.
