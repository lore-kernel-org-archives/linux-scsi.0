From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] convert sg dio to use blk functions
Date: Tue, 2 Jan 2007 11:28:03 +0000
Message-ID: <20070102112803.GA24951@infradead.org>
References: <20061205080034T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43841 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932849AbXABL2I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jan 2007 06:28:08 -0500
Content-Disposition: inline
In-Reply-To: <20061205080034T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

On Tue, Dec 05, 2006 at 08:00:34AM +0900, FUJITA Tomonori wrote:
> This patch makes sg dio use the block layer functions (calls
> blk_rq_map_user and blk_execute_rq_nowait).
> 
> It doesn't break any existing features. So sg dio uses the block layer
> functions and sg mmap and indirectio use scsi_execute_async.
> 
> This isn't for merging. I would like to discuss how to convert sg mmap
> and indirectio to use the block layer functions.
> 
> sg dio doesn't use preallocated pages and scatterlist buffer so it can
> use nicely the block layer functions. But mmap and indirectio
> can't. We need to kill the preallocated buffer in sg or modify the
> block layer functions to use preallocated buffer.

This looks nice and gets rid of two different codepathes for the same
thing so I'm all in favour of it. 

But please send sg patches to Douglas as he maintains the driver and knows
it best.

