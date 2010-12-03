From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: After memory pressure: can't read from tape anymore
Date: Fri, 3 Dec 2010 18:44:48 +0900
Message-ID: <20101203183122F.fujita.tomonori@lab.ntt.co.jp>
References: <4CF52A03.2000704@panasas.com>
	<alpine.LNX.2.00.1011301853300.9731@kai.makisara.local>
	<4CF53349.10509@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:60214 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932292Ab0LCJpN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Dec 2010 04:45:13 -0500
In-Reply-To: <4CF53349.10509@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: Kai.Makisara@kolumbus.fi, lkolbe@techfak.uni-bielefeld.de, linux-scsi@vger.kernel.org

On Tue, 30 Nov 2010 19:24:25 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> I looked at enlarge_buffer() and it looks fragile and broken. If you really
> need a pointer eg:
> 	STbuffer->b_data = page_address(STbuffer->reserved_pages[0]);
> 
> Than way not use vmalloc() for buffers larger then PAGE_SIZE? But better yet

As Kai said, this buffer is used for dma so you can't use vmalloc.

sg drivers keeps an array for pages. b_data is used for some commands
that do small data transfer (< PAGE_SIZE). So the driver exploits the
first page for it.

> avoid it by keeping a pages_array or sg-list and operate on an aio type
> operations.

As explained, the driver keeps a pages_array.
