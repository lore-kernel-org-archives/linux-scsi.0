From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [Bug 14563] SCSI tape driver: Spurious EIO and kernel BUG
Date: Thu, 19 Nov 2009 22:03:44 +0200 (EET)
Message-ID: <alpine.LNX.2.00.0911192156460.14560@kai.makisara.local>
References: <4B028253.1040407@jmbreuer.net> <alpine.LNX.2.00.0911172231040.20752@kai.makisara.local> <alpine.LNX.2.00.0911182338070.13484@kai.makisara.local> <20091119164558H.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:56653 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbZKSUD5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2009 15:03:57 -0500
In-Reply-To: <20091119164558H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@jmbreuer.net, linux-scsi@vger.kernel.org

On Thu, 19 Nov 2009, FUJITA Tomonori wrote:

...
> As you suggested earlier, looks like normalize_buffer() doesn't free
> all the buffers. I think that I found one bug that causes to this.
> 
> When enlarge_buffer() allocates 524288 from 0, st uses six-order page
> allocation. So mdata->page_order is 6 and frp_seg is 2.
> 
> After that, if st uses dio, sgl_map_user_pages() sets
> mdata->page_order to 0 for st_do_scsi(). After that, when we call
> normalize_buffer(), it frees only free frp_seg * PAGE_SIZE (2 * 4096)
> though we should free frp_seg * PAGE_SIZE << 6 (2 * 4096 << 6). So we
> see buffer_size is set to 516096 (524288 - 8192).
> 
This surely can cause problems later.

> Here's a fix for this.
> 

I have tested the patch. Amanda did make the backup without problems. 
However, looking at dmesg revealed that this time it did not use dio with 
any write. Then I made a small program that writes both with and without 
dio (when the write buffer is not aligned at page boundary, it needs 129 
s/g segments and dio is not used). Dmesg showed that dio was used in half 
of the writes and the buffer was shrunk properly.

Thanks,
Kai

